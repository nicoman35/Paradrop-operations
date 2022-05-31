/*
	Author: 		Nicoman
	Function: 		NIC_GRP_fnc_CheckAddActionGRP
	Version: 		1.0
	Edited Date: 	30.05.2022
	
	Description:
		Check, if unit is autorized to obtain the 'Get Ready For Paradropping' action
	
	Parameters:
		_unit:		Object - unit to be checked for autorization
	
	Returns:
		Bool
*/

// NIC_GRP_fnc_CheckAddActionGRP = {
// params [["_unit", objNull]];
// if (isNull _unit) exitWith {
	// diag_log formatText ["%1%2%3%4%5", time, "s  (NIC_GRP_fnc_CheckAddActionGRP) exit 0"];
	// false
// };
// if !(local _unit) exitWith {_this remoteExecCall [NIC_GRP_fnc_CheckAddActionGRP, _unit]};
// if (!alive _unit) exitWith {
	// diag_log formatText ["%1%2%3%4%5", time, "s  (NIC_GRP_fnc_CheckAddActionGRP) exit 1"];
	// false
// };
// private _vehicle = vehicle _unit;
// if (_vehicle == _unit) exitWith {
	// diag_log formatText ["%1%2%3%4%5", time, "s  (NIC_GRP_fnc_CheckAddActionGRP) exit 2"];
	// false
// };
// if !(_vehicle isKindOf "Air") exitWith {
	// diag_log formatText ["%1%2%3%4%5", time, "s  (NIC_GRP_fnc_CheckAddActionGRP) exit 3"];
	// false
// };
// if (unitIsUAV _vehicle) exitWith {
	// diag_log formatText ["%1%2%3%4%5", time, "s  (NIC_GRP_fnc_CheckAddActionGRP) exit 4"];
	// false
// };
// private _crew = fullCrew [_vehicle, "", true];
// if (count _crew < 2) exitWith {
	// diag_log formatText ["%1%2%3%4%5", time, "s  (NIC_GRP_fnc_CheckAddActionGRP) exit 5"];
	// false
// };
// if (isPlayer _unit) exitWith {
	// diag_log formatText ["%1%2%3%4%5", time, "s  (NIC_GRP_fnc_CheckAddActionGRP) exit 6, AUTORIZED"];
	// true
// };
// if (_unit == driver _vehicle) exitWith {
	// diag_log formatText ["%1%2%3%4%5", time, "s  (NIC_GRP_fnc_CheckAddActionGRP) exit 7, AUTORIZED"];
	// true
// };
// if ([_unit, _vehicle] call NIC_GRP_fnc_IsUnitCopilot) exitWith {
	// diag_log formatText ["%1%2%3%4%5", time, "s  (NIC_GRP_fnc_CheckAddActionGRP) exit 8, AUTORIZED"];
	// true
// };
// diag_log formatText ["%1%2%3%4%5", time, "s (NIC_GRP_fnc_CheckAddActionGRP)  ", name _unit, " exit 9"];
// false




















params [["_vehicle", objNull]];
if (isNull _vehicle) exitWith {
	// diag_log formatText ["%1%2%3%4%5", time, "s  (NIC_GRP_fnc_CheckAddActionGRP) exit 0"];
	false
};
if !(local _vehicle) exitWith {_this remoteExecCall [NIC_GRP_fnc_CheckAddActionGRP, _vehicle]};
if (!alive _vehicle) exitWith {
	// diag_log formatText ["%1%2%3%4%5", time, "s  (NIC_GRP_fnc_CheckAddActionGRP) exit 1"];
	false
};
// private _vehicle = vehicle _unit;
// if (_vehicle == _unit) exitWith {
	// diag_log formatText ["%1%2%3%4%5", time, "s  (NIC_GRP_fnc_CheckAddActionGRP) exit 2"];
	// false
// };
if !(_vehicle isKindOf "Air") exitWith {
	// diag_log formatText ["%1%2%3%4%5", time, "s  (NIC_GRP_fnc_CheckAddActionGRP) exit 2"];
	false
};
if (_vehicle isKindOf "ParachuteBase") exitWith {
	// diag_log formatText ["%1%2%3%4%5", time, "s  (NIC_GRP_fnc_CheckAddActionGRP) exit 3"];
	false
};									// exclude parachutes from action
if (unitIsUAV _vehicle) exitWith {
	// diag_log formatText ["%1%2%3%4%5", time, "s  (NIC_GRP_fnc_CheckAddActionGRP) exit 4"];
	false
};
private _crew = fullCrew [_vehicle, "", true];
if (count _crew < 2) exitWith {
	// diag_log formatText ["%1%2%3%4%5", time, "s  (NIC_GRP_fnc_CheckAddActionGRP) exit 5"];
	false
};
// if (isPlayer _unit) exitWith {
	// diag_log formatText ["%1%2%3%4%5", time, "s  (NIC_GRP_fnc_CheckAddActionGRP) exit 6, AUTORIZED"];
	// true
// };
// if (_unit == driver _vehicle) exitWith {
	// diag_log formatText ["%1%2%3%4%5", time, "s  (NIC_GRP_fnc_CheckAddActionGRP) exit 7, AUTORIZED"];
	// true
// };
// if ([_unit, _vehicle] call NIC_GRP_fnc_IsUnitCopilot) exitWith {
	// diag_log formatText ["%1%2%3%4%5", time, "s  (NIC_GRP_fnc_CheckAddActionGRP) exit 8, AUTORIZED"];
	// true
// };
// diag_log formatText ["%1%2%3%4%5", time, "s (NIC_GRP_fnc_CheckAddActionGRP)  ", _vehicle, " Add action autorized"];
true
// };
