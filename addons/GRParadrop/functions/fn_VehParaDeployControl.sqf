/*
	Author: 		Nicoman
	Function: 		NIC_GRP_fnc_VehParaDeployControl
	Version: 		1.0
	Edited Date: 	07.06.2022
	
	Description:
		Control and deploy vehicle parachute
	
	Parameters:
		_cargo:		Object - cargo being deployed from airborne vehilce, defaults to objNull
	
	Returns:
		None
*/

// NIC_GRP_fnc_VehParaDeployControl = {
params [["_cargo", objNull]];
if (isNull _cargo) exitWith {};
if !(local _cargo) exitWith {_this remoteExec [NIC_GRP_fnc_VehParaDeployControl, _cargo]};
if (!alive _cargo) exitWith {};

// Vehicle parachute is attached to vehicle, wait for vehicle free fall
private _hint = 0;
while {
	alive _cargo &&
	!(isNil {_cargo getVariable "NIC_GRP_parachuteHolder"}) &&
	(isTouchingGround _cargo ||
	vehicle _cargo != _cargo ||
	getPos _cargo #2 < 5 ||
	!(isNull attachedTo _cargo) ||
	velocity _cargo #2 > -10 ||
	!(isNull ropeAttachedTo _cargo))} 
do {
	if (!(isNull ropeAttachedTo _cargo) && _hint < 2) then {
		private _length = 35;
		{
			if ((ropeAttachedTo _cargo) isKindOf _x #0) exitWith {_length = _x #1};
		} forEach NIC_GRP_ropeLength;
		// hint composeText [localize "STR_NIC_GRP_ATTENTION", lineBreak, localize "STR_NIC_GRP_ATTENTION2"];
		hint composeText [localize "STR_NIC_GRP_ATTENTION", lineBreak, format[localize "STR_NIC_GRP_ATTENTION2", _length]];
		_hint = _hint + 1;
	};
	sleep 1;
};
// diag_log formatText ["%1%2%3%4%5%6", time, "s (NIC_GRP_fnc_VehParaDeployControl)	 FALL DETECTED"];

if (isNil {_cargo getVariable "NIC_GRP_parachuteHolder"}) exitWith {};														// Exit, if no attached vehicle parachute found

_cargo spawn NIC_GRP_fnc_HandleFallDamage;																					// Iniciate damage control

private ["_velocity", "_v", "_t", "_fpsInfluence"];

// Vehicle is now free falling, let's calculate parachute deployment height
private _deployHeight = 0;
if (NIC_GRP_deployOverride) then {	_deployHeight = NIC_GRP_cargoParachuteDeployHeight};

// Control fall speed and height until vehicle is lower then deploy height
private _inflatingTime = 1;																										// time parachute needs to inflate (s)
private _massFactor = (getMass _cargo)^(1/6);																					// x^1/y = y root x
private _a = 18 - _massFactor;																									// acceleration (m/s^2)
private _v0 = 10;																												// end velocity (m/s)
// diag_log formatText ["%1%2%3%4%5%6%7%8%9", time, "s (NIC_GRP_fnc_VehParaDeployControl)  NIC_GRP_securityFactor: ", NIC_GRP_securityFactor, ", _a: ", _a, ", _mass: ", getMass _cargo, ", _massFactor: ", _massFactor];
while {alive _cargo && getPos _cargo #2 > _deployHeight} do {
	_velocity = velocity _cargo;
	if (_velocity #2 < -NIC_GRP_maxFallSpeed) then {
		_velocity set [2, -NIC_GRP_maxFallSpeed];
		_cargo setVelocity _velocity;
	};																															// falling vehicles accelerate to ridiculous speeds; cap that speed at about 470 km/h 
	if (!NIC_GRP_deployOverride) then {
		_v = abs(_velocity #2);
		_t = (_v0 - _v) / -_a;  																								// t = (v - v0) / a; time vehicle would need to reduce current fall speed to 10 m/s
		_fpsInfluence = (90 / diag_fps * 1.2) max 1;	
		if (isMultiplayer) then {_fpsInfluence = _fpsInfluence * 1.4};
		_deployHeight = (0.5 * _a * _t^2 + _v0 * _t + _v * _inflatingTime) * NIC_GRP_securityFactor^_fpsInfluence;				// height = braking distance (0,5 · a · t^2 + _v0 * _t) + inflating distance (v · tInf)
	};
	// sleep 0.01;
	// if (isMultiplayer) then	{
	uiSleep 0.01;
	// } else {
		// sleep 0.01;
	// };
};
// diag_log formatText ["%1%2%3%4%5%6%7%8", "_v: ", _v, ", _t: ", _t];
// diag_log formatText ["%1%2%3%4%5%6%7%8", "fps: ", diag_fps, ", braking distance: ", 0.5 * _a * _t^2 + _v0 * _t, ", infating distance: ", _v * _inflatingTime, ", securityF: ", NIC_GRP_securityFactor^_fpsInfluence];
// diag_log formatText ["%1%2%3%4%5%6%7", time, "s (NIC_GRP_fnc_VehParaDeployControl)  _deployHeight: ", _deployHeight]; 

if (!alive _cargo || getPos _cargo #2 < 10) exitWith {};																	// Exit, if vehicle no longer alive or near ground
if !(_cargo call NIC_GRP_fnc_DetachVehicleParachute) exitWith {};															// Detach vehicle parachute; exit, if parachute has been somehow removed from vehicle during fall

// Create parachute and attach vehicle to it
private _class = format [
	"%1_parachute_02_F", 
	toString [(toArray faction _cargo) #0]
];
private _parachute = createVehicle [_class, [0, 0, 0], [], 0, "CAN_COLLIDE"];
if (isNull _parachute) then {_parachute = createVehicle ["B_parachute_02_F", [0, 0, 0], [], 0, "CAN_COLLIDE"]};

_velocity = velocity _cargo;
_parachute setDir getDir _cargo;
_parachute setPos getPos _cargo;
_parachute setVelocity _velocity;
_cargo attachTo [_parachute, [0, 0, 1]];
private _height = getPos _cargo #2;
// diag_log formatText ["%1%2%3%4%5%6%7%8%9", time, "s (NIC_GRP_fnc_VehParaDeployControl)  parachute deploy initiated.  _velocity at deploy: ", _velocity, ", height at deploy: ", _height, " m, mass: ", getMass _cargo];

private _sleep = 0.05;
private _fullyOpen = time + _inflatingTime;																						// parachute inflating phase
while {_velocity #2 < -_v0} do {
	if (time > _fullyOpen) then {
		if (abs(_velocity #0) > 5) then {
			if (_velocity #0 > 0) exitWith {_velocity set [0, -_a * _sleep + _velocity #0]};
			_velocity set [0, _a * _sleep + _velocity #0];
		};																														// horrizontal brake x axis (v = a · t + Xv0)	
		if (abs(_velocity #1) > 5) then {
			if (_velocity #1 > 0) exitWith {_velocity set [1, -_a * _sleep + _velocity #1]};
			_velocity set [1, _a * _sleep + _velocity #1];
		};																														// horrizontal brake y axis (v = a · t + Yv0)
		_velocity set [2, _a * _sleep + _velocity #2]; 																			// vertical brake z axis (v = a · t + Zv0)
	};
	_parachute setVelocity _velocity;
	if (getPos _cargo #2 < 4 || !alive _cargo) exitWith {};
	uiSleep _sleep;
	// sleep _sleep;
};
diag_log formatText ["%1%2%3%4%5%6%7%8", time, "s (NIC_GRP_fnc_VehParaDeployControl)  parachute break completed.  speed parachute: ", abs(velocity _parachute #2), " m/s , brake distance: ", _height - getPos _cargo #2, " m"];

waitUntil {getPos _cargo #2 < 4 || !alive _cargo};																			// Wait for vehicle to glide near ground
_velocity = velocity _parachute;
detach _cargo;																												// Detach vehicle from parachute
_cargo setVelocity _velocity;
_cargo disableCollisionWith _parachute;

// Failsafe for not ending up with vehicles beneath terrain level
if (getPosATL _cargo #2 < 0) then {
	private _pos = getpos _cargo; 
	_pos set [2, 0];
	_cargo setPos _pos;
};
// };
