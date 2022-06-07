/*
	Author: 		Nicoman
	Function: 		NIC_GRP_fnc_AddActionDetachParachute
	Version: 		1.0
	Edited Date: 	07.06.2022
	
	Description:
		Add 'Dettach Vehicle Parachute' action to a vehicle
	
	Parameters:
		_cargo:	Object - cargo to which action will be added, defauts to objNull
	
	Returns:
		None
*/

// NIC_GRP_fnc_AddActionDetachParachute = {
params [["_cargo", objNull]];
// diag_log formatText ["%1%2%3%4%5", time, "s  (NIC_GRP_fnc_AddActionDetachParachute) _cargo: ", _cargo];
if (isNull _cargo) exitWith {};
if !(local _cargo) exitWith {_this remoteExecCall [NIC_GRP_fnc_AddActionDetachParachute, _cargo]};
if (!alive _cargo) exitWith {[_cargo, "NIC_AddActionDetachParachute"] call NIC_GRP_fnc_RemoveAction};
if !(isNil{_cargo getVariable "NIC_AddActionDetachParachute"}) exitWith {};
private _actionID = _cargo addAction [																						// Add 'Dettach Vehicle Parachute' action to vehicle
	localize "STR_NIC_GRP_DETACH_VEH_PARA",																					// Title
	{_this call NIC_GRP_fnc_DetachVehicleParachute},																		// Script
	nil,																													// Arguments
	0,																														// Priority
	false,																													// showWindow
	true,																													// hideOnUse
	"",																														// Shortcut
	"[_this, _target] call NIC_GRP_fnc_ActionCheckDetach"																	// Condition, action menu only available when all conditions met
];
_cargo setVariable ["NIC_AddActionDetachParachute", _actionID];
// diag_log formatText ["%1%2%3%4%5", time, "s  (NIC_GRP_fnc_AddActionDetachParachute) _cargo: ", _cargo];
_cargo spawn NIC_GRP_fnc_VehParaDeployControl;
	
// diag_log formatText ["%1%2%3%4%5", time, "s  (NIC_GRP_fnc_AddActionDetachParachute) _this: ", _this, ", _cargo: ", _cargo];
// };
