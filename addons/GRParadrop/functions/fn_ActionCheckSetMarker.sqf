/*
	Author: 		Nicoman
	Function: 		NIC_GRP_fnc_ActionCheckSetMarker
	Version: 		1.0
	Edited Date: 	24.05.2022
	
	Description:
		Check, if 'Set Paradrop Location' action is available 
	
	Parameters:
		_unit:		Object - unit to be checked, defauts to objNull
	
	Returns:
		Bool
*/

// NIC_GRP_fnc_ActionCheckSetMarker = {
params [["_unit", objNull]];
if (isNull _unit) exitWith {false};
if !(local _unit) exitWith {_this remoteExecCall [NIC_GRP_fnc_ActionCheckSetMarker, _unit]};
private _vehicle = vehicle _unit;
if (_unit == _vehicle) exitWith {false};
private _crew = crew _vehicle;
private _crew = _crew select {!(isNil{_x getVariable "NIC_grpEventGetOut"})};		// get all crew members of unit's vehicle, which were assigned for paradropping
if (count _crew > 0) exitWith {true};
[_unit, "NIC_actionID_GRP_SetMarker"] call NIC_GRP_fnc_RemoveAction;				// imediately remove action, once condition gets false
false
// };
