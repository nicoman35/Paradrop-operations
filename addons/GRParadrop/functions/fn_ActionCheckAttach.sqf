/*
	Author: 		Nicoman
	Function: 		NIC_GRP_fnc_ActionCheckAttach
	Version: 		1.0
	Edited Date: 	04.06.2022
	
	Description:
		Check, if 'Attach Vehicle Parachute' action is available 
	
	Parameters:
		_unit:		Object - unit trying to attach vehicle parachute, defauts to objNull
	
	Returns:
		Bool
*/

// NIC_GRP_fnc_ActionCheckAttach = {
params [["_unit", objNull]];
if (isNull _unit) exitWith {false};
if !(local _unit) exitWith {_this remoteExecCall [NIC_GRP_fnc_ActionCheckAttach, _unit]};
if (!alive _unit) exitWith {false};
private _vehicle = cursorObject;
if (_unit distance _vehicle > NIC_GRP_attachDistance) exitWith {false};
if !(isNil {_vehicle getVariable "NIC_GRP_parachuteHolder"}) exitWith {false};		// Exit, if another parachute is already attached
private _allowed = false;
{
	if (_vehicle isKindOf _x) exitWith {
		// hint formatText ["%1%2%3%4%5", time, "s object is kind of: ", _x];
		_allowed = true;
	};
} forEach NIC_GRP_vehicleParachuteClasses;
_allowed
// };
