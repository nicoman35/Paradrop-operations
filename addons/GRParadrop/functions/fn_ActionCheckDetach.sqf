/*
	Author: 		Nicoman
	Function: 		NIC_GRP_fnc_ActionCheckDetach
	Version: 		1.0
	Edited Date: 	24.05.2022
	
	Description:
		Check, if 'Detach Vehicle Parachute' action is available 
	
	Parameters:
		_vehicle:	Object - vehicle to be checked, defauts to objNull
		_unit:		Object - unit having the vehicle as cursorObject, defauts to objNull
		
	Returns:
		Bool
*/

// NIC_GRP_fnc_ActionCheckDetach = {
// diag_log formatText ["%1%2%3%4%5", time, "s  (NIC_GRP_fnc_ActionCheckDetach) _this: ", _this];
// params [["_vehicle", objNull], ["_unit", objNull]];
params [["_unit", objNull], ["_vehicle", objNull]];
if (isNull _vehicle || isNull _unit) exitWith {false};
if !(local _vehicle) exitWith {
	_this remoteExecCall [NIC_GRP_fnc_ActionCheckDetach, _vehicle];
	false
};
if (!alive _vehicle) exitWith {
	[_vehicle, "NIC_AddActionDetachParachute"] call NIC_GRP_fnc_RemoveAction; 
	false
};
// hintSilent format ["%1 dist: %2", _vehicle, _vehicle distance _unit];
if (_vehicle distance _unit > NIC_GRP_attachDistance) exitWith {false};

// diag_log formatText ["%1%2%3%4%5%6%7", time, "s  (NIC_GRP_fnc_ActionCheckDetach) _vehicle: ", _vehicle, " _unit: ",  _unit, " check: ",  _unit != vehicle _unit];
if (_unit != vehicle _unit) exitWith {false};
// hintSilent format ["NIC_GRP_fnc_ActionCheckDetach is true"];

true
// };
