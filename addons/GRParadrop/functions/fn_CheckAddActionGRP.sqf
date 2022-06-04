/*
	Author: 		Nicoman
	Function: 		NIC_GRP_fnc_CheckAddActionGRP
	Version: 		1.0
	Edited Date: 	02.06.2022
	
	Description:
		Check, if unit is autorized to obtain the 'Get Ready For Paradropping' action
	
	Parameters:
		_unit:		Object - unit to be checked for autorization
	
	Returns:
		Bool
*/

// NIC_GRP_fnc_CheckAddActionGRP = {
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
true
// };
