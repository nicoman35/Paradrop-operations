/*
	Author: 		Nicoman
	Function: 		NIC_GRP_fnc_AddActionAttachParachute
	Version: 		1.0
	Edited Date: 	26.05.2022
	
	Description:
		Add 'Attach Vehicle Parachute' action to a unit
	
	Parameters:
		_unit:		Object - unit to which action will be added, defauts to objNull
	
	Returns:
		None
*/

// diag_log formatText ["%1%2%3%4%5", time, "s  (NIC_GRP_fnc_AddActionAttachParachute) _this: ", _this];

// NIC_GRP_fnc_AddActionAttachParachute = {
params [["_unit", objNull]];
// diag_log formatText ["%1%2%3%4%5", time, "s  (NIC_GRP_fnc_AddActionAttachParachute) _unit: ", name _unit];
if (isNull _unit) exitWith {};
if (!isPlayer _unit) exitWith {};
if !(local _unit) exitWith {_this remoteExec [NIC_GRP_fnc_AddActionAttachParachute, _unit]};
if (backpack _unit!= "NIC_Bergen_dgtl_Para") exitWith {
	[_unit, "NIC_AddActionAttachParachute"] call NIC_GRP_fnc_RemoveAction;
	// diag_log formatText ["%1%2%3%4%5", time, "s  (NIC_GRP_fnc_AddActionAttachParachute) Exit2"];
};
if !(isNil{_unit getVariable "NIC_AddActionAttachParachute"}) exitWith {};
private _actionID = _unit addAction [																						// Add 'Attach Vehicle Parachute' action to unit
	localize "STR_NIC_GRP_ATTACH_VEH_PARA",																					// Title
	{_this call NIC_GRP_fnc_AttachVehicleParachute},																		// Script
	nil,																													// Arguments
	0,																														// Priority
	false,																													// showWindow
	true,																													// hideOnUse
	"",																														// Shortcut
	"[_this] call NIC_GRP_fnc_ActionCheckAttach"																			// Condition, action menu only available when all conditions met
];
_unit setVariable ["NIC_AddActionAttachParachute", _actionID];
// diag_log formatText ["%1%2%3%4%5", time, "s  (NIC_GRP_fnc_AddActionAttachParachute) _this: ", _this, ", _unit: ", _unit];
// };
