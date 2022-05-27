/*
	Author: 		Nicoman
	Function: 		NIC_GRP_fnc_VehParaDeployControl
	Version: 		1.0
	Edited Date: 	27.05.2022
	
	Description:
		Control and deploy vehicle parachute
	
	Parameters:
		_vehicle:		Object - vehicle deploying from airborne vehilce, defaults to objNull
	
	Returns:
		None
*/

// diag_log formatText ["%1%2%3%4%5%6", time, "s  _this: ", _this];
params [["_vehicle", objNull]];
if (isNull _vehicle) exitWith {};
if !(local _vehicle) exitWith {_this remoteExec [NIC_GRP_fnc_VehParaDeployControl, _vehicle]};
if (!alive _vehicle) exitWith {};

// Vehicle parachute is attached to vehicle, wait for vehicle free fall
while {
	alive _vehicle &&
	!(isNil {_vehicle getVariable "NIC_GRP_parachuteHolder"}) &&
	isTouchingGround _vehicle &&
	(vehicle _vehicle != _vehicle ||
	getPos _vehicle #2 < 5 ||
	!(isNull attachedTo _vehicle) ||
	velocity _vehicle #2 > -10 ||
	!(isNull ropeAttachedTo _vehicle))} 
do {
	sleep 1;
};

if (isNil {_vehicle getVariable "NIC_GRP_parachuteHolder"}) exitWith {};		// Exit, if no attached vehicle parachute found

_vehicle spawn NIC_GRP_fnc_HandleFallDamage;									// Iniciate damage control






// Vehicle is now free falling, let's calculate parachute deployment height
private _vehicleMass = getMass _vehicle;
private _deployHeight = round(((_vehicleMass / 1000) max 1) * 120) min 900;  									// 120 - 900
_deployHeight = (((((getPos _vehicle #2 - _deployHeight) min 1200) / 1200) min 1) max 0.3) * _deployHeight;		// fail






if (NIC_GRP_deployOverride) then {	_deployHeight = NIC_GRP_vehicleParachuteDeployheight};
// diag_log formatText ["%1%2%3%4%5%6%7", time, "s (NIC_GRP_fnc_VehParaDeployControl)  _deployHeight: ", _deployHeight];

// Control fall speed and height until vehicle is lower then deploy height
private _sleep = 1;
private ["_velocity"];
while {alive _vehicle && getPos _vehicle #2 > _deployHeight} do {
	_velocity = velocity _vehicle;
	if (getPos _vehicle #2 - _deployHeight < abs(_velocity #2 * 2)) then {_sleep = 0.01};
	if (_velocity #2 < -NIC_GRP_maxFallSpeed) then {
		_velocity set [2, -NIC_GRP_maxFallSpeed];
		_vehicle setVelocity _velocity;
	};
	sleep _sleep;
};
if (!alive _vehicle || getPos _vehicle #2 < 10) exitWith {};					// Exit, if vehicle no longer alive or near ground

if !(_vehicle call NIC_GRP_fnc_DetachVehicleParachute) exitWith {};			// Detach vehicle parachute; exit, if parachute has been somehow removed from vehicle during fall

// Create parachute and attach vehicle to it
private _class = format [
	"%1_parachute_02_F", 
	toString [(toArray faction _vehicle) #0]
];
private _parachute = createVehicle [_class, [0, 0, 0], [], 0, "FLY"];
_parachute setDir getDir _vehicle;
_parachute setPos getPos _vehicle;
_velocity = velocity _vehicle;
_parachute setVelocity _velocity;
_vehicle attachTo [_parachute, [0, 0, 1]];

// Simulate fall breaking after parachute opening
_sleep = ((round(_vehicleMass / 200) / 1000) max 0.01) min 0.05;				// The more mass vehicle has, the longer parachute needs to break fall
private _count = 100;															// velocity decrease iteration count
if (_sleep == 0.05) then {
	_count = _count + (((_vehicleMass - 10000) / 500) min 100);					// Increase iteration count for heavyer vehicles
};
private _decrease = _velocity #2 / (_count * 1.1);								// velocity decrease rate
 
// diag_log formatText ["%1%2%3%4%5%6%7", time, "s (NIC_GRP_fnc_VehParaDeployControl)  _sleep: ", _sleep, ", _count: ", _count, ", _decrease: ", _decrease];
for "_i" from 1 to _count do { 
	_velocity set [2, (_velocity #2) - _decrease];
	_parachute setVelocity _velocity;
	if (getPos _vehicle #2 < 4 || !alive _vehicle) exitWith {};
	sleep _sleep;
};
// diag_log formatText ["%1%2%3%4%5", time, "s (NIC_GRP_fnc_VehParaDeployControl)  vehicle height after decrease: ", getPos _vehicle #2];

waitUntil {getPos _vehicle #2 < 4 || !alive _vehicle};							// Wait for vehicle to glide near ground
_velocity = velocity _parachute;
detach _vehicle;																// Detach vehicle from parachute
_vehicle setVelocity _velocity;
_vehicle disableCollisionWith _parachute;

// Failsafe for not ending up with vehicles beneath terrain level
// if (!(surfaceIsWater position _vehicle) && getpos _vehicle #2 < 0) then {
if (getPosATL _vehicle #2 < 0) then {
	private _pos = getpos _vehicle; 
	_pos set [2, 0];
	_vehicle setPos _pos;
};
