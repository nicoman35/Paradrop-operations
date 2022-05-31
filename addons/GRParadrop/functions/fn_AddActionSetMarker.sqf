/*
	Author: 		Nicoman
	Function: 		NIC_GRP_fnc_AddActionSetMarker
	Version: 		1.0
	Edited Date: 	30.05.2022
	
	Description:
		Add 'Set Paradrop Location' action to a vehicle
	
	Parameters:
		_vehicle:		Object - vehicle to be checked, defauts to objNull
	
	Returns:
		None
*/

// NIC_GRP_fnc_AddActionSetMarker = {
params [["_vehicle", objNull]];
if (isNull _vehicle) exitWith {false};
if !(local _vehicle) exitWith {_this remoteExecCall [NIC_GRP_fnc_AddActionSetMarker, _vehicle]};
if !(isNil{_vehicle getVariable "NIC_actionID_GRP_SetMarker"}) exitWith {};	// exit, if vehicle was already added the action
private _actionID = _vehicle addAction [									// Add 'Get Ready For Paradropping' action to authorized units
	localize "STR_NIC_GRP_SET_LOCATION",									// Title
	{[] call NIC_GRP_fnc_SetParadropLocation},							// Script to be executed on clicking on action
	nil,																	// Arguments
	0,																		// Priority
	false,																	// showWindow
	true,																	// hideOnUse
	"",																		// Shortcut
	"[_target, _this] call NIC_GRP_fnc_ActionCheckSetMarker"				// Condition; script checking, if action is available to vehicle
];
_vehicle setVariable ["NIC_actionID_GRP_SetMarker", _actionID];				// save action id on vehicle
// diag_log formatText ["%1%2%3%4%5", time, "s  (NIC_GRP_fnc_AddActionSetMarker) _this: ", _this, ", _unit: ", _unit];
// };
