/*
	Author: 		Nicoman
	Function: 		NIC_GRP_fnc_AddActionDetachParachute
	Version: 		1.0
	Edited Date: 	27.05.2022
	
	Description:
		Add 'Dettach Vehicle Parachute' action to a vehicle
	
	Parameters:
		_vehicle:	Object - vehicle to which action will be added, defauts to objNull
	
	Returns:
		None
*/

// NIC_GRP_fnc_AddActionDetachParachute = {
params [["_vehicle", objNull]];
// diag_log formatText ["%1%2%3%4%5", time, "s  (NIC_GRP_fnc_AddActionDetachParachute) _vehicle: ", _vehicle];
if (isNull _vehicle) exitWith {};
if !(local _vehicle) exitWith {_this remoteExecCall [NIC_GRP_fnc_AddActionDetachParachute, _vehicle]};
if (!alive _vehicle) exitWith {[_vehicle, "NIC_AddActionDetachParachute"] call NIC_GRP_fnc_RemoveAction};
if !(isNil{_vehicle getVariable "NIC_AddActionDetachParachute"}) exitWith {};
private _actionID = _vehicle addAction [																					// Add 'Dettach Vehicle Parachute' action to vehicle
	localize "STR_NIC_GRP_DETACH_VEH_PARA",																					// Title
	{_this call NIC_GRP_fnc_DetachVehicleParachute},																		// Script
	nil,																													// Arguments
	0,																														// Priority
	false,																													// showWindow
	true,																													// hideOnUse
	"",																														// Shortcut
	"[_this, _target] call NIC_GRP_fnc_ActionCheckDetach"																	// Condition, action menu only available when all conditions met
];
_vehicle setVariable ["NIC_AddActionDetachParachute", _actionID];
// diag_log formatText ["%1%2%3%4%5", time, "s  (NIC_GRP_fnc_AddActionDetachParachute) _vehicle: ", _vehicle];
_vehicle spawn NIC_GRP_fnc_VehParaDeployControl;
	
// diag_log formatText ["%1%2%3%4%5", time, "s  (NIC_GRP_fnc_AddActionDetachParachute) _this: ", _this, ", _vehicle: ", _vehicle];
// };
