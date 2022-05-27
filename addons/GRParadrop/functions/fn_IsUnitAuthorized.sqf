/*
	Author: 		Nicoman
	Function: 		NIC_GRP_fnc_IsUnitAuthorized
	Version: 		1.0
	Edited Date: 	22.05.2022
	
	Description:
		Check a unit, if it is authorized to pick a parachute from vehicle inventory
	
	Parameters:
		_unit:		Object - unit to be checked, defaults to objNull
		_vehicle:	Object - vehicle unit just boarded, defaults to objNull
	
	Returns:
		Bool
*/

// NIC_GRP_fnc_IsUnitAuthorized = {
params [["_unit", objNull], ["_vehicle", objNull]];
if (isNull _unit || isNull _vehicle) exitWith {false};														// unit or vehicle is null
if !(local _unit) exitWith {_this remoteExecCall [NIC_GRP_fnc_IsUnitAuthorized, _unit]};
if (!alive _unit) exitWith {false};																			// unit is not alive
if (vehicle _unit != _vehicle) exitWith {false};															// unit is not aboard the given vehicle
if (isPlayer _unit) exitWith {false};																		// unit is player, players are to be left alone
if (!NIC_GRP_pilotsReady && _unit == driver _vehicle) exitWith {false};									// unit is pilot, and pilots are not allowed for paradroping
if (!NIC_GRP_copilotsReady && [_unit, _vehicle] call NIC_GRP_fnc_IsUnitCopilot) exitWith {false};		// unit is copilot, and copilots are not allowed for paradroping
private _vehicleBackpacks = getBackpackCargo _vehicle;													
if !(["B_Parachute"] in _vehicleBackpacks) exitWith {false};												// given vehicle has no parachute in inventory
if !(isNil{_unit getVariable "NIC_grpEventGetOut"}) exitWith {false};										// unit already has been ordered to get ready

true
// };
