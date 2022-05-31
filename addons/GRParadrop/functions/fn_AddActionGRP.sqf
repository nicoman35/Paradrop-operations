/*
	Author: 		Nicoman
	Function: 		NIC_GRP_fnc_AddActionGRP
	Version: 		1.0
	Edited Date: 	30.05.2022
	
	Description:
		Add 'Get Ready For Paradropping' action to a unit
	
	Parameters:
		_unit:		Object - unit to be checked, defauts to objNull
	
	Returns:
		None
*/

// NIC_GRP_fnc_AddActionGRP = {
params [["_vehicle", objNull]];
// diag_log formatText ["%1%2%3%4%5", time, "s  (NIC_GRP_fnc_AddActionGRP)  _vehicle: ", _vehicle, " called ActionGRP"];
if (isNull _vehicle) exitWith {};
if !(local _vehicle) exitWith {_this remoteExec [NIC_GRP_fnc_AddActionGRP, _vehicle]};
if (!alive _vehicle) exitWith {};
if !([_vehicle] call NIC_GRP_fnc_CheckAddActionGRP) exitWith {};
if !(isNil{_vehicle getVariable "NIC_actionID_GRP"}) exitWith {};		// exit, if unit was already added the action
private _actionID = _vehicle addAction [								// Add 'Get Ready For Paradropping' action to authorized units
	localize "STR_NIC_GRP_GET_READY",									// Title
	{_this call NIC_GRP_fnc_GetReadyParadrop},							// Script to be executed on clicking on action
	nil,																// Arguments
	0,																	// Priority
	false,																// showWindow
	true,																// hideOnUse
	"",																	// Shortcut
	"[_target, _this] call NIC_GRP_fnc_ActionCheckGRP"					// Condition; script checking, if action is available to unit
];
_vehicle setVariable ["NIC_actionID_GRP", _actionID];						// save action id on unit
// diag_log formatText ["%1%2%3%4%5", time, "s  (NIC_GRP_fnc_AddActionGRP)  _vehicle: ", _vehicle, " was added ActionGRP"];
// };
