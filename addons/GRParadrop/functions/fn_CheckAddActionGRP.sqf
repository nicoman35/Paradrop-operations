/*
	Author: 		Nicoman
	Function: 		NIC_GRP_fnc_CheckAddActionGRP
	Version: 		1.0
	Edited Date: 	22.05.2022
	
	Description:
		Check, if unit is autorized to obtain the 'Get Ready For Paradropping' action
	
	Parameters:
		_unit:		Object - unit to be checked for autorization
	
	Returns:
		Bool
*/

// NIC_GRP_fnc_CheckAddActionGRP = {
params [["_unit", objNull]];

// if (isNull _unit || !alive _unit) exitWith {diag_log formatText ["%1%2%3%4%5", time, "s  (NIC_GRP_fnc_CheckAddActionGRP) exit1"];false};
// if (isNull _unit || !alive _unit) exitWith {false};
if (isNull _unit) exitWith {false};
if !(local _unit) exitWith {_this remoteExecCall [NIC_GRP_fnc_CheckAddActionGRP, _unit]};
if (!alive _unit) exitWith {false};
private _vehicle = vehicle _unit;
// if (_vehicle == _unit) exitWith {diag_log formatText ["%1%2%3%4%5", time, "s  (NIC_GRP_fnc_CheckAddActionGRP) exit2"];false};
if (_vehicle == _unit) exitWith {false};
// if !(_vehicle isKindOf "Air") exitWith {diag_log formatText ["%1%2%3%4%5", time, "s  (NIC_GRP_fnc_CheckAddActionGRP) exit3"];false};
if !(_vehicle isKindOf "Air") exitWith {false};
// if (unitIsUAV _vehicle) exitWith {diag_log formatText ["%1%2%3%4%5", time, "s  (NIC_GRP_fnc_CheckAddActionGRP) exit4"];false};
if (unitIsUAV _vehicle) exitWith {false};
private _crew = fullCrew [_vehicle, "", true];
// if (count _crew < 2) exitWith {diag_log formatText ["%1%2%3%4%5", time, "s  (NIC_GRP_fnc_CheckAddActionGRP) exit5"];false};
if (count _crew < 2) exitWith {false};
// if (isPlayer _unit) exitWith {diag_log formatText ["%1%2%3%4%5", time, "s  (NIC_GRP_fnc_CheckAddActionGRP) exit6, AUTORIZED"];true};
if (isPlayer _unit) exitWith {true};
// if (_unit == driver _vehicle) exitWith {diag_log formatText ["%1%2%3%4%5", time, "s  (NIC_GRP_fnc_CheckAddActionGRP) exit7, AUTORIZED"];true};
if (_unit == driver _vehicle) exitWith {true};
// if ([_unit, _vehicle] call NIC_GRP_fnc_IsUnitCopilot) exitWith {diag_log formatText ["%1%2%3%4%5", time, "s  (NIC_GRP_fnc_CheckAddActionGRP) exit8, AUTORIZED"];true};
if ([_unit, _vehicle] call NIC_GRP_fnc_IsUnitCopilot) exitWith {true};

// diag_log formatText ["%1%2%3%4%5", time, "s (NIC_GRP_fnc_CheckAddActionGRP)  ", name _unit, " NOT autorized"];
false
// };
