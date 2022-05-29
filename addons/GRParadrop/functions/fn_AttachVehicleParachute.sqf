/*
	Author: 		Nicoman
	Function: 		NIC_GRP_fnc_AttachVehicleParachute
	Version: 		1.0
	Edited Date: 	27.05.2022
	
	Description:
		Attach vehicle parachute to vehicle
	
	Parameters:
		_unit:		Object - unit holding vehicle parachute, defauts to objNull
	
	Returns:
		None
*/

// NIC_GRP_fnc_AttachVehicleParachute = {
params [["_unit", objNull]];
if (isNull _unit) exitWith {};
if !(local _unit) exitWith {_this remoteExecCall [NIC_GRP_fnc_AttachVehicleParachute, _unit]};
private _vehicle = cursorObject;
private _mass = getMass _vehicle;
private _strg = format ["%1 kg", round _mass];
if (_mass > 1000) then {_strg = format ["%1 t", _mass / 1000 toFixed 1]};
if (_mass < NIC_GRP_attachMinMass) exitWith {hint format[localize "STR_NIC_GRP_TOO_LIGHT", _strg, format ["%1 kg", NIC_GRP_attachMinMass]]};
if (_mass > NIC_GRP_attachMaxMass) exitWith {hint format[localize "STR_NIC_GRP_TOO_HEAVY", _strg, format ["%1 t", NIC_GRP_attachMaxMass / 1000 toFixed 1]]};
private _vehicleOffsets = [_vehicle, [0, 0, 0]];
{
	if (_vehicle isKindOf _x #0) exitWith {_vehicleOffsets = [_vehicle, _x #1]};
} forEach NIC_GRP_vehicles;
removeBackpackGlobal _unit;
private _holder = "groundweaponholder" createVehicle position _unit;
_holder addBackpackCargoGlobal ["NIC_Bergen_dgtl_Para", 1];
_holder attachTo _vehicleOffsets;
_vehicle setVariable ["NIC_GRP_parachuteHolder", _holder];
[_unit, "NIC_AddActionAttachParachute"] call NIC_GRP_fnc_RemoveAction;
// diag_log formatText ["%1%2%3%4%5", time, "s  (NIC_GRP_fnc_AttachVehicleParachute) _vehicle: ", _vehicle];
[_vehicle] call NIC_GRP_fnc_AddActionDetachParachute;
// };
