/*
	Author: 		Nicoman
	Function: 		NIC_GRP_fnc_DetachVehicleParachute
	Version: 		1.0
	Edited Date: 	26.05.2022
	
	Description:
		Dettach vehicle parachute from vehicle
	
	Parameters:
		_vehicle:	Object - vehicle vehicle parachute is attached to, defauts to objNull
		_caller:	Object - unit performing detach action, defauts to objNull
		
	Returns:
		Bool:		Returns true on success
*/

// NIC_GRP_fnc_DetachVehicleParachute = {
params [["_vehicle", objNull], ["_caller", objNull]];
if (isNull _vehicle) exitWith {false};
// diag_log formatText ["%1%2%3%4%5", time, "s  (NIC_GRP_fnc_DetachVehicleParachute) _vehicle: ", _vehicle, ", _caller: ", _caller];
if !(local _vehicle) exitWith {_this remoteExecCall [NIC_GRP_fnc_DetachVehicleParachute, _vehicle]};
private _holder = _vehicle getVariable ["NIC_GRP_parachuteHolder", objNull];
if (isNull _holder) exitWith {
	[_vehicle, "NIC_AddActionDetachParachute"] call NIC_GRP_fnc_RemoveAction;
	_vehicle setVariable ["NIC_GRP_parachuteHolder", nil];
	false
};
detach _holder;
deleteVehicle _holder;
_vehicle setVariable ["NIC_GRP_parachuteHolder", nil];
[_vehicle, "NIC_AddActionDetachParachute"] call NIC_GRP_fnc_RemoveAction;
if (isNull _caller) exitWith {true};
if (backpack _caller == "") exitWith {
	_caller addBackpack "NIC_Bergen_dgtl_Para";
	[_caller] call NIC_GRP_fnc_AddActionAttachParachute;
	true
};
_holder = "groundweaponholder" createVehicle position _vehicle; 
_holder addBackpackCargoGlobal ["NIC_Bergen_dgtl_Para", 1];
true
// };