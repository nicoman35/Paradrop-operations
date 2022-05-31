/*
	Author: 		Nicoman
	Function: 		NIC_GRP_fnc_ActionCheckGRP
	Version: 		1.0
	Edited Date: 	30.05.2022
	
	Description:
		Check, if 'Get Ready For Paradropping' action is available 
	
	Parameters:
		_vehicle:	Object - vehicle unit is in, defauts to objNull
		_unit:		Object - unit to be checked, defauts to objNull
	
	Returns:
		Bool
*/

// NIC_GRP_fnc_ActionCheckGRP = {
// diag_log formatText ["%1%2%3%4%5", time, "s  (NIC_GRP_fnc_ActionCheckGRP)  _this: ", _this];
params [["_vehicle", objNull], ["_unit", objNull]];
if (isNull _vehicle || isNull _unit) exitWith {
	// diag_log formatText ["%1%2%3%4%5", time, "s  (NIC_GRP_fnc_ActionCheckGRP) exit 0"];
	false
};
if !(local _vehicle) exitWith {_this remoteExecCall [NIC_GRP_fnc_ActionCheckGRP, _vehicle]};
if (!alive _vehicle || !alive _unit) exitWith {
	// diag_log formatText ["%1%2%3%4%5", time, "s  (NIC_GRP_fnc_ActionCheckGRP) exit 1"];
	false
};
if (_unit != driver _vehicle && !([_unit, _vehicle] call NIC_GRP_fnc_IsUnitCopilot)) exitWith {
	// diag_log formatText ["%1%2%3%4%5", time, "s  (NIC_GRP_fnc_ActionCheckGRP) exit 2"];
	false
};							// unit must be pilot or copilot
private _crew = crew _vehicle;
private _crew = _crew select {alive _x && !isPlayer _x && isNil {_x getVariable "NIC_grpEventGetOut"}};		// get crew of unit's vehicle, excluding players and dead units
if (!NIC_GRP_pilotsReady) then {_crew deleteAt (_crew find driver _vehicle)};								// if pilots are not allowed, remove vehicles driver from crew
if (!NIC_GRP_copilotsReady) then {																			// if copilots are not allowed, remove copilot from crew
	{
		if ([_x, _vehicle] call NIC_GRP_fnc_IsUnitCopilot) exitWith {
			_crew deleteAt _foreachindex;
		};
	} forEach _crew;
};
if (count _crew == 0) exitWith {
	// diag_log formatText ["%1%2%3%4%5", time, "s  (NIC_GRP_fnc_ActionCheckGRP) exit 3"];
	false
};
// diag_log formatText ["%1%2%3%4%5", time, "s  (NIC_GRP_fnc_ActionCheckGRP) PASSED"];
true
// };
