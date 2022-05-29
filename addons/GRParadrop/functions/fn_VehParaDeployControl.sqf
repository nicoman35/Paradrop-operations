/*
	Author: 		Nicoman
	Function: 		NIC_GRP_fnc_VehParaDeployControl
	Version: 		1.0
	Edited Date: 	29.05.2022
	
	Description:
		Control and deploy vehicle parachute
	
	Parameters:
		_vehicle:		Object - vehicle deploying from airborne vehilce, defaults to objNull
	
	Returns:
		None
*/

// NIC_GRP_fnc_VehParaDeployControl = {
params [["_vehicle", objNull]];
if (isNull _vehicle) exitWith {};
if !(local _vehicle) exitWith {_this remoteExec [NIC_GRP_fnc_VehParaDeployControl, _vehicle]};
if (!alive _vehicle) exitWith {};

// Vehicle parachute is attached to vehicle, wait for vehicle free fall
private _hint = 0;
while {
	alive _vehicle &&
	!(isNil {_vehicle getVariable "NIC_GRP_parachuteHolder"}) &&
	(isTouchingGround _vehicle ||
	vehicle _vehicle != _vehicle ||
	getPos _vehicle #2 < 5 ||
	!(isNull attachedTo _vehicle) ||
	velocity _vehicle #2 > -10 ||
	!(isNull ropeAttachedTo _vehicle))} 
do {
	if (!(isNull ropeAttachedTo _vehicle) && _hint < 2) then {
		hint composeText [localize "STR_NIC_GRP_ATTENTION", lineBreak, localize "STR_NIC_GRP_ATTENTION2"];
		_hint = _hint + 1;
	};
	sleep 1;
};
// diag_log formatText ["%1%2%3%4%5%6", time, "s (NIC_GRP_fnc_VehParaDeployControl)	 FALL DETECTED"];

if (isNil {_vehicle getVariable "NIC_GRP_parachuteHolder"}) exitWith {};		// Exit, if no attached vehicle parachute found

_vehicle spawn NIC_GRP_fnc_HandleFallDamage;									// Iniciate damage control

private ["_velocity", "_t"];

// Vehicle is now free falling, let's calculate parachute deployment height
private _deployHeight = 0;
if (NIC_GRP_deployOverride) then {	_deployHeight = NIC_GRP_vehicleParachuteDeployHeight};

// Control fall speed and height until vehicle is lower then deploy height
private _inflatingTime = 1.5;
private _massFactor = (getMass _vehicle)^(1/6);
// diag_log formatText ["%1%2%3%4%5%6%7", time, "s (NIC_GRP_fnc_VehParaDeployControl)  NIC_GRP_securityFactor: ", NIC_GRP_securityFactor];
while {alive _vehicle && getPos _vehicle #2 > _deployHeight} do {
	_velocity = velocity _vehicle;
	if (_velocity #2 < -NIC_GRP_maxFallSpeed) then {
		_velocity set [2, -NIC_GRP_maxFallSpeed];
		_vehicle setVelocity _velocity;
	};
	if (!NIC_GRP_deployOverride) then {
		// hintSilent formatText ["%1%2%3%4%5%6%7", " speed: ", abs(_velocity #2)];		
		_t = -(10 - abs(_velocity #2)) / (18 - _massFactor);  																// t = (v - v0) / a; time vehicle would need to reduce current fall speed to 10 m/s
		_deployHeight = (0.5 * (18 - _massFactor) * _t^2 + abs(_velocity #2) * _inflatingTime) * NIC_GRP_securityFactor;	// s = 0,5 · a · t^2 + v · tInf; height parachute would need to sucessfully break vehicle's fall
		if (abs(_velocity #2) < NIC_GRP_maxFallSpeed - 3) then {
			_deployHeight = _deployHeight * NIC_GRP_securityFactor;
			if (getPos _vehicle #2 < 300) then {_deployHeight = _deployHeight * (NIC_GRP_securityFactor + (20 / getPos _vehicle #2))};
		};
	};
	sleep 0.01;
};
// diag_log formatText ["%1%2%3%4%5%6%7", time, "s (NIC_GRP_fnc_VehParaDeployControl)  _deployHeight: ", _deployHeight]; 

if (!alive _vehicle || getPos _vehicle #2 < 10) exitWith {};																// Exit, if vehicle no longer alive or near ground
if !(_vehicle call NIC_GRP_fnc_DetachVehicleParachute) exitWith {};														// Detach vehicle parachute; exit, if parachute has been somehow removed from vehicle during fall

// Create parachute and attach vehicle to it
private _class = format [
	"%1_parachute_02_F", 
	toString [(toArray faction _vehicle) #0]
];
private _parachute = createVehicle [_class, [0, 0, 0], [], 0, "CAN_COLLIDE"];
if (isNull _parachute) then {_parachute = createVehicle ["B_parachute_02_F", [0, 0, 0], [], 0, "CAN_COLLIDE"]};

_velocity = velocity _vehicle;
_parachute setDir getDir _vehicle;
_parachute setPos getPos _vehicle;
_parachute setVelocity _velocity;
_vehicle attachTo [_parachute, [0, 0, 1]];
private _height = getPos _vehicle #2;
// diag_log formatText ["%1%2%3%4%5%6%7%8%9", time, "s (NIC_GRP_fnc_VehParaDeployControl)  parachute deploy initiated.  _velocity at deploy: ", _velocity, ", height at deploy: ", _height, " m, mass: ", getMass _vehicle];

// Simulate fall braking after parachute opening
sleep _inflatingTime; 																										// parachute inflating phase
private _sleep = 0.05;
while {_velocity #2 < -10} do {
	if (abs(_velocity #0) > 5) then {
		if (_velocity #0 > 0) exitWith {_velocity set [0, -(18 - _massFactor) * _sleep + _velocity #0]};
		_velocity set [0, (18 - _massFactor) * _sleep + _velocity #0];
	};																														// horrizontal brake x axis (v = a · t + Xv0)									// horrizontal brake x axis (v = a · t + Xv0)
	if (abs(_velocity #1) > 5) then {
		if (_velocity #1 > 0) exitWith {_velocity set [1, -(18 - _massFactor) * _sleep + _velocity #1]};
		_velocity set [1, (18 - _massFactor) * _sleep + _velocity #1];
	};																														// horrizontal brake y axis (v = a · t + Yv0)
	_velocity set [2, (18 - _massFactor) * _sleep + _velocity #2]; 															// vertical brake z axis (v = a · t + Zv0)
	_parachute setVelocity _velocity;
	if (getPos _vehicle #2 < 4 || !alive _vehicle) exitWith {};
	sleep _sleep;
};
// diag_log formatText ["%1%2%3%4%5%6%7%8", time, "s (NIC_GRP_fnc_VehParaDeployControl)  parachute break completed.  speed parachute: ", abs(velocity _parachute #2), " m/s , brake distance: ", _height - getPos _vehicle #2, " m"];

waitUntil {getPos _vehicle #2 < 4 || !alive _vehicle};																		// Wait for vehicle to glide near ground
_velocity = velocity _parachute;
detach _vehicle;																											// Detach vehicle from parachute
_vehicle setVelocity _velocity;
_vehicle disableCollisionWith _parachute;

// Failsafe for not ending up with vehicles beneath terrain level
if (getPosATL _vehicle #2 < 0) then {
	private _pos = getpos _vehicle; 
	_pos set [2, 0];
	_vehicle setPos _pos;
};
// };
