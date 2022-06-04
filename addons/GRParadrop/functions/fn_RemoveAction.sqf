/*
	Author: 		Nicoman
	Function: 		NIC_GRP_fnc_RemoveAction
	Version: 		1.0
	Edited Date: 	26.05.2022
	
	Description:
		Remove an action from an object
	
	Parameters:
		_object:		Object - object action is to be removed from, defauts to objNull
		_savedAction:	String - variable name actionID was stored to, defauts to ""

	Returns:
		None
*/

// NIC_GRP_fnc_RemoveAction = {
params [["_object", objNull], ["_savedAction", ""]];
if (isNull _object || _savedAction == "") exitWith {};
if !(local _object) exitWith {_this remoteExec [NIC_GRP_fnc_RemoveAction, _object]};
if (!alive _object) exitWith {};
if (isNil{_object getVariable _savedAction}) exitWith {};
private _actionID = _object getVariable _savedAction;
_object removeAction _actionID;
_object setVariable [_savedAction, nil];
// };

// diag_log formatText ["%1%2%3%4%5%6%7%8%9", time, "s (NIC_GRP_fnc_RemoveAction)		unit: ", name _object, " _savedAction: ", _savedAction];