/*
	Author: 		Nicoman
	Function: 		NIC_GRP_fnc_HandleFallDamage
	Version: 		1.0
	Edited Date: 	26.05.2022
	
	Description:
		Handle vehicle damage due to impact with high velocity
	
	Parameters:
		_vehicle:		Object - unit performing fall, defauts to objNull
	
	Returns:
		None
*/

// NIC_GRP_fnc_HandleFallDamage = {
params [["_vehicle", objNull]];
// diag_log formatText ["%1%2%3%4%5", time, "s (NIC_GRP_fnc_HandleFallDamage)	_vehicle: ", _vehicle];
if (isNull _vehicle || !alive _vehicle) exitWith {};
private ["_velocity"];

// _vehicle setPos (getPos _vehicle vectorAdd [0 ,0, 500]);
// _velocity = velocity _vehicle;
// private _vx = 35 - random 70;
// private _vy = 35 - random 70;
// _velocity = _velocity vectorAdd  [_vx, _vy, 0];
// _vehicle setVelocity _velocity;

private _sleep = 1;
private _finalHeight = 0.5;
private _originalVehicle = _vehicle;
while {getPos _vehicle #2 > _finalHeight} do {
	_velocity = velocity _vehicle;
	// diag_log formatText ["%1%2%3%4%5", time, "s (NIC_GRP_fnc_HandleFallDamage)  _velocity: ", _velocity];
	if !(isNull attachedTo _vehicle) then {
		private _para = attachedTo _vehicle;
		_velocity = velocity _para;
		// diag_log formatText ["%1%2%3%4%5", time, "s (NIC_GRP_fnc_HandleFallDamage)  velocity _para: ", _velocity];
	};
	private _finalHeight = 0.5 + abs(_velocity #2) / 50;
	// hintsilent formatText ["%1%2%3%4%5", "hVel: ", round(_velocity #2), ", 	_fHei: ", _finalHeight];
	if (getPos _vehicle #2 < abs(_velocity #2 * 3)) then {_sleep = 0.01};
	sleep _sleep;
};

waitUntil {isTouchingGround _vehicle || getPosASL _vehicle #2 <= 0};
sleep 0.1;
private _horizontalSpeed = sqrt ((_velocity #0) ^ 2 + (_velocity #1) ^ 2);
private _verticalSpeed = _velocity #2;
// diag_log formatText ["%1%2%3%4%5", time, "s (NIC_GRP_fnc_HandleFallDamage)  _horizontalSpeed: ", _horizontalSpeed, ", _verticalSpeed: ", _verticalSpeed];

_horizontalSpeed = _horizontalSpeed - 10;
if (_horizontalSpeed < 0) then {_horizontalSpeed = 0};
private _damage = _horizontalSpeed / 50;
// diag_log formatText ["%1%2%3%4%5", time, "s (NIC_GRP_fnc_HandleFallDamage)  _horizontal speed damage: ", _damage];
_verticalSpeed = _verticalSpeed + 8;
if (_verticalSpeed > 0) then {_verticalSpeed = 0};
_damage = _damage + abs(_verticalSpeed / 30);
if (surfaceIsWater position _vehicle) then {
	private _waterPos = +(getpos _vehicle); 
	_waterPos set [2, getTerrainHeightASL _waterPos];
	private _depth = abs(ASLtoAGL _waterPos select 2);
	// diag_log formatText ["%1%2%3%4%5", time, "s (NIC_GRP_fnc_HandleFallDamage) _depth: ", _depth];
	if (_depth > 4) then {_damage = _damage / 2};
};
if (_damage > 1) then {_damage = 1};
// diag_log formatText ["%1%2%3%4%5", time, "s (NIC_GRP_fnc_HandleFallDamage)  total damage: ", _damage];
_vehicle setDamage (getDammage _vehicle + _damage);
// }; 
// [cursorObject] spawn NIC_GRP_fnc_HandleFallDamage;