/*
	Author: 		Nicoman
	Function: 		NIC_GRP_fnc_AddActionSetMarker
	Version: 		1.0
	Edited Date: 	22.05.2022
	
	Description:
		Add 'Set Paradrop Location' action to a unit
	
	Parameters:
		_unit:		Object - unit to be checked, defauts to objNull
	
	Returns:
		None
*/

// NIC_GRP_fnc_AddActionSetMarker = {
params [["_unit", objNull]];
if (isNull _unit) exitWith {false};
if !(local _unit) exitWith {_this remoteExecCall [NIC_GRP_fnc_AddActionSetMarker, _unit]};
if !(isNil{_unit getVariable "NIC_actionID_GRP_SetMarker"}) exitWith {};	// exit, if unit was already added the action
private _actionID = _unit addAction [										// Add 'Get Ready For Paradropping' action to authorized units
	localize "STR_NIC_GRP_SET_LOCATION",									// Title
	{[] call NIC_GRP_fnc_SetParadropLocation},							// Script to be executed on clicking on action
	nil,																	// Arguments
	0,																		// Priority
	false,																	// showWindow
	true,																	// hideOnUse
	"",																		// Shortcut
	"[_this] call NIC_GRP_fnc_ActionCheckSetMarker"							// Condition; script checking, if action is available to unit
];
_unit setVariable ["NIC_actionID_GRP_SetMarker", _actionID];				// save action id on unit
// diag_log formatText ["%1%2%3%4%5", time, "s  (NIC_GRP_fnc_AddActionSetMarker) _this: ", _this, ", _unit: ", _unit];
// };

