/*
	Author: 		Nicoman
	Function: 		NIC_GRP_fnc_RemoveAbackpack
	Version: 		1.0
	Edited Date: 	22.05.2022
	
	Description:
		Remove one parachute from vehicles inventory
	
	Parameters:
		_vehicle:			Object - air vehicle, defaults to objNull
		_parachuteType:		Config type - parachute type, defaults to ""
	
	Returns:
		None
*/

// NIC_GRP_fnc_RemoveAbackpack = {
params [["_vehicle", objNull], ["_parachuteType", ""]];
if (isNull _vehicle || _parachuteType == "") exitWith {};
if !(local _vehicle) exitWith {_this remoteExecCall [NIC_GRP_fnc_RemoveAbackpack, _vehicle]};
private _vehicleBackpacks = getBackpackCargo _vehicle;
// diag_log formatText ["%1%2%3%4%5%6%7", time, "s  _vehicleBackpacks: ", _vehicleBackpacks];
private _idx = _vehicleBackpacks #0 find _parachuteType;
private _number = _vehicleBackpacks #1 #_idx; 
// diag_log formatText ["%1%2%3%4%5%6%7", time, "s  _idx: ", _idx, ", _number B_Parachute: ", _number];
_number = _number - 1;
_vehicleBackpacks #1 set [_idx, _number];
clearBackpackCargo _vehicle;
// diag_log formatText ["%1%2%3%4%5%6%7", time, "s  _vehicleBackpacks: ", _vehicleBackpacks];
{
	_vehicle addBackpackCargo [_x, _vehicleBackpacks #1 #_foreachindex];
} forEach _vehicleBackpacks #0; 
// };

