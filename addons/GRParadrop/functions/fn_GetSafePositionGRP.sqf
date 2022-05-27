/*
	Author: 		Nicoman
	Function: 		NIC_GRP_fnc_GetSafePositionGRP
	Version: 		1.0
	Edited Date: 	22.05.2022
	
	Description:
		Search a safe position. Center position either given special paradrop marker, or unit itself, if no marker was set
	
	Parameters:
		_vehicle:			Object - air vehicle, defaults to objNull
		_parachuteType:		Config type - parachute type, defaults to ""
	
	Returns:
		_safePos:			Position array [x, y, z]
*/

// NIC_GRP_fnc_GetSafePositionGRP = {
params [["_unit", objNull], ["_maxDist", 25]];
if (isNull _unit) exitWith {};
if !(local _unit) exitWith {_this remoteExecCall [NIC_GRP_fnc_GetSafePositionGRP, _unit]};

private _center 	= [getpos _unit select 0, getpos _unit select 1];							// center position to search from
if (getMarkerType "NIC_GRP_Objective" != "") then {
	// diag_log formatText ["%1%2%3%4%5%6%7%8%9", time, "s  NIC_GRP_fnc_GetSafePositionGRP 	we got a par marker: ", getMarkerType "NIC_GRP_Objective"];
	_center 	= getMarkerPos "NIC_GRP_Objective";	
};

private _minDist 	= 0;																		// minimum distance from the center position
private _minDistWater 	= 3;		
if (_maxDist == 0) then {
	_maxDist 		= getpos _unit select 2;													// maximum distance from the center position
	_minDistWater 	= 20;
};
private _objDist 	= 2; 																		// minimum distance from the resulting position to the center of nearest object
private _waterMode 	= 0; 																		// 0: cannot be in water, 1: can either be in water or not, 2: must be in water
private _maxGrad	= 30; 																		// maximum terrain gradient (hill steepness)

private _safePos = [_center, _minDist, _maxDist, _objDist, _waterMode, _maxGrad] call BIS_fnc_findSafePos;
while {_center distance _safePos > _maxDist && _maxDist < 2000} do {
	_maxDist = _maxDist + 100;
	// diag_log formatText ["%1%2%3%4%5%6%7%8", time, "s  NIC_GRP_fnc_GetSafePositionGRP	raising search distance to: ", _maxDist];
	_safePos = [_center, _minDist, _maxDist, _objDist, _waterMode, _maxGrad] call BIS_fnc_findSafePos;
};

private _waterPos = [_safePos, 0, _minDistWater, 0, 2, 80] call BIS_fnc_findSafePos;			// check, if found position is near water
if (_safePos distance _waterPos <= _minDistWater) then {
	private _arrowG = createVehicle ["Sign_Arrow_Green_F", _safePos, [], 0, "CAN_COLLIDE"];
	private _posDistance = (_waterPos distance _safePos) max _minDistWater;						// get distance from safe position to water position, at least 20 m
	private _azimuth = _waterPos getDir _safePos;
	_safePos = _arrowG getRelPos [_posDistance, _azimuth];										// define safe position in the oppositie direction of the water position
	// diag_log formatText ["%1%2%3%4%5%6%7%8", time, "s  NIC_GRP_fnc_GetSafePositionGRP	safe pos was too near water, new safe pos: ", _safePos];
	deleteVehicle _arrowG;
};

// private _marker1 = createMarker [name _unit, _safePos];
// _marker1 setMarkerType "hd_dot";
// _marker1 setMarkerText name _unit;
// private _flag = createVehicle ["Flag_Blue_F", _safePos, [], 0, "CAN_COLLIDE"];
// diag_log formatText ["%1%2%3%4%5%6%7%8", time, "s  NIC_GRP_fnc_GetSafePositionGRP	safe position found: ", _safePos, ", search range: ", _maxDist, " distance to safe position: ", _unit distance _safePos];

_safePos
// };
