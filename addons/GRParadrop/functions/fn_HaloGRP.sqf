/*
	Author: 		Nicoman
	Function: 		NIC_GRP_fnc_HaloGRP
	Version: 		1.1
	Edited Date: 	07.06.2022
	
	Description:
		Perform and control paradrop of one unit from an airborne vehicle
	
	Parameters:
		_unit:		Object - unit deploying from airborne vehilce, defaults to objNull
		_vehicle:	Object - vehicle unit is jumping out of, defauts to objNull
		
	Returns:
		None
*/

// NIC_GRP_fnc_HaloGRP = {
params [["_unit", objNull], ["_vehicle", objNull]];
if (isNull _unit) exitWith {};
if !(local _unit) exitWith {_this remoteExec [NIC_GRP_fnc_HaloGRP, _unit]};
if (!alive _unit) exitWith {};
removeBackpackGlobal _unit;

private ["_distance2D"];

// diag_log formatText ["%1%2%3%4%5%6", time, "s  NIC_GRP_fnc_HealMeHalo waiting for ", _unit, " to be airborne"];
waitUntil {sleep 0.05; vehicle _unit == _unit};

if (getPos _unit #2 > 20) then {
	_unit setDir round(random 360);
	sleep 1;
	private _velocity = velocity _unit;
	private _direction = direction _unit;
	private _speed = random 10; 
	_unit setVelocity [
		(_velocity select 0) + (sin _direction * _speed),
		(_velocity select 1) + (cos _direction * _speed),
		(_velocity select 2)
	];

	private _safePos = [_unit] call NIC_GRP_fnc_GetSafePositionGRP;
	if (isNil "_safePos") then {_safePos = getpos _unit};
	_unit doMove _safePos;

	private _atan	= 100;
	private _targetAngle = 30;																// target elevation angle from safe position to unit. lower values -> later parachute deployment, flatter glide trajectory
	private _height	= getPos _unit select 2;
	while {(_atan > _targetAngle && _height > NIC_GRP_parachuteHeight) || _unit distance _vehicle < 20} do {
		_distance2D	= _unit distance2D _safePos;
		_height		= getPos _unit select 2;
		_atan		= atan (_height / _distance2D);											// elevation angle from safe position to unit
		sleep 0.1;
	};

	// diag_log formatText ["%1%2%3%4%5", time, "s   NIC_GRP_fnc_HealMeHalo attachedObjects _unit: ",  attachedObjects _unit];
	if (isNull _unit || !alive _unit) exitWith {};
	
	_velocity = velocity _unit;
	_unit addBackpack "B_Parachute";
	_unit action ["openParachute", _unit];
	private _para = vehicle _unit;
	
	// simulate speed decrease
	private _decrease = _velocity #2 / 45;	
	for "_i" from 1 to 70 do { 
		if (_i < 30) then {
			_velocity set [2, _velocity #2];
		} else {
			_velocity set [2, (_velocity #2) - _decrease];
		};
		_para setVelocity _velocity;
		sleep 0.02;
	};
	sleep 0.1;

	[_unit, _safePos] call NIC_GRP_fnc_ParachuteGlideGRP;									// perform a parachute glide to found safe position
	if (isNull _unit || !alive _unit) exitWith {};
};
waitUntil {sleep 1; getPos _unit #2 < 1};
sleep 1;
if (isNull _unit || !alive _unit) exitWith {};
_unit allowDamage true;

if (_unit getVariable "NIC_hasBackpackOnChest") then {
	removeBackpackGlobal _unit;
	sleep 1;
	if (isNull _unit || !alive _unit) exitWith {};
	// diag_log formatText ["%1%2%3%4%5%6%7%8%9", time, "s  ", name _unit, " switches back backpack"];
	[_unit] call bocr_main_fnc_actionOnBack;
	_unit setVariable ["NIC_hasBackpackOnChest", nil];
};

waitUntil {sleep 1; moveToCompleted _unit};
doStop _unit;
// };
