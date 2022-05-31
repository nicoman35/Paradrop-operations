/*
	Author: 		Nicoman
	Function: 		NIC_GRP_fnc_ActionCheckSetMarker
	Version: 		1.0
	Edited Date: 	30.05.2022
	
	Description:
		Check, if 'Set Paradrop Location' action is available 
	
	Parameters:
		_vehicle:	Object - vehicle unit is in, defauts to objNull
		_unit:		Object - unit to be checked, defauts to objNull
	
	Returns:
		Bool
*/

// NIC_GRP_fnc_ActionCheckSetMarker = {
// diag_log formatText ["%1%2%3%4%5", time, "s  (NIC_GRP_fnc_ActionCheckSetMarker) _this: ", _this];
params [["_vehicle", objNull], ["_unit", objNull]];
if (isNull _vehicle || isNull _unit) exitWith {
	// diag_log formatText ["%1%2%3%4%5", time, "s  (NIC_GRP_fnc_GetReadyParadrop) exit 0"];
	false
};
if !(local _vehicle) exitWith {_this remoteExecCall [NIC_GRP_fnc_ActionCheckSetMarker, _vehicle]};
if (!alive _vehicle || !alive _unit) exitWith {
	// diag_log formatText ["%1%2%3%4%5", time, "s  (NIC_GRP_fnc_GetReadyParadrop) exit 1"];
	false
};
private _crew = crew _vehicle;
private _crew = _crew select {!(isNil{_x getVariable "NIC_grpEventGetOut"})};				// get all crew members of unit's vehicle, which were assigned for paradropping
if (count _crew == 0) exitWith {false};
if (_unit != driver _vehicle && !([_unit, _vehicle] call NIC_GRP_fnc_IsUnitCopilot)) exitWith {
	// diag_log formatText ["%1%2%3%4%5", time, "s  (NIC_GRP_fnc_ActionCheckSetMarker) exit 2"];
	false
};
// [_vehicle, "NIC_actionID_GRP_SetMarker"] call NIC_GRP_fnc_RemoveAction;				// imediately remove action, once condition gets false
true
// };
