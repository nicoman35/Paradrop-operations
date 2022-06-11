/*
	Author: 		Nicoman
	Function: 		NIC_GRP_fnc_HaloGRP
	Version: 		1.1
	Edited Date: 	10.06.2022
	
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

waitUntil {sleep 0.05; vehicle _unit == _unit};

if (getPos _unit #2 > 20) then {
	_unit setDir round(random 360);
	sleep 1;
	private _velocity = velocity _unit;
	private _direction = direction _unit;
	private _speed = random 10; 
	_unit setVelocity [
		(_velocity #0) + (sin _direction * _speed),
		(_velocity #1) + (cos _direction * _speed),
		(_velocity #2)
	];
	
	private _safePos = [_unit] call NIC_GRP_fnc_GetSafePositionGRP;
	if (isNil "_safePos") then {_safePos = getpos _unit};
	_unit doMove _safePos;
	private _atan = 100;
	private _targetAngle = 30;																										// target elevation angle from safe position to unit. lower values -> later parachute deployment, flatter glide trajectory
	private _height	= getPos _unit #2;
	private _deployHeight = 0;																										// height at which parachute will be opened (m)
	if (NIC_GRP_deployOverride) then {	_deployHeight = NIC_GRP_parachuteDeployHeight};
	private _a = 30;																												// acceleration (m/s^2)
	private _v0 = 6;																												// velocity at end of parachute brake sequence (m/s)
	private _inflatingTime = 2;	
	private ["_distance2D", "_v", "_t", "_fpsInfluence"];
	while {(_atan > _targetAngle && _height > _deployHeight && alive _unit) || _unit distance _vehicle < 20} do {
		_distance2D	= _unit distance2D _safePos;
		_height		= getPos _unit #2;
		_atan		= atan ((_height - _deployHeight + 30) / _distance2D);															// elevation angle from safe position to unit
		_velocity	= velocity _unit;	
		if (!NIC_GRP_deployOverride) then {
			_v = abs(_velocity #2);
			_t = (_v0 - _v) / -_a;  																								// t = (v - v0) / a; time vehicle would need to reduce current fall speed to v0 m/s
			_fpsInfluence = (90 / diag_fps * 1.2) max 1;	
			if (isMultiplayer) then {_fpsInfluence = _fpsInfluence * 1.3};
			_deployHeight = (0.5 * _a * _t^2 + _v0 * _t + _v * _inflatingTime) * NIC_GRP_securityFactor^_fpsInfluence + 20;		// height = braking distance (0,5 · a · t^2 + _v0 * _t) + inflating distance (v · tInf)
		};
	
		sleep 0.01;
	};
	if (isNull _unit || !alive _unit) exitWith {};
	
	_velocity = velocity _unit;
	// diag_log formatText ["%1%2%3%4%5%6%7%8%9%10%11%12%13", time, "s (NIC_GRP_fnc_HealMeHalo)  parachute deployHeight: ", _deployHeight, ", fall speed: ", abs(_velocity #2), ", _distance2D: ", _distance2D, ", NIC_GRP_securityFactor: ", NIC_GRP_securityFactor, ", _fpsInfluence: ", _fpsInfluence]; 
	_unit addBackpack "B_Parachute";
	_unit action ["openParachute", _unit];
	private _parachute = vehicle _unit;
	
	// simulate speed decrease
	private _sleep = 0.03;
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
		if (getPos _unit #2 < 4 || !alive _unit) exitWith {};
		uiSleep _sleep;
	};
	sleep 0.1;
	// diag_log formatText ["%1%2%3%4%5%6%7%8%9", time, "s (NIC_GRP_fnc_HealMeHalo)  brake completed; height: ", getPos _unit #2, ", brake distance: ", _height - getPos _unit #2, ", fall speed: ", abs(velocity _unit #2)]; 
	
	_unit doMove _safePos;
	[_unit, _safePos] call NIC_GRP_fnc_ParachuteGlideGRP;																			// perform a parachute glide to found safe position
	if (isNull _unit || !alive _unit) exitWith {};
	_unit doMove _safePos;
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
