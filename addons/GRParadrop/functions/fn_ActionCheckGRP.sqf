/*
	Author: 		Nicoman
	Function: 		NIC_GRP_fnc_ActionCheckGRP
	Version: 		1.0
	Edited Date: 	27.05.2022
	
	Description:
		Check, if 'Get Ready For Paradropping' action is available 
	
	Parameters:
		_unit:		Object - unit to be checked, defauts to objNull
	
	Returns:
		Bool
*/

// NIC_GRP_fnc_ActionCheckGRP = {
params [["_unit", objNull]];
if (isNull _unit) exitWith {false};
if !(local _unit) exitWith {_this remoteExecCall [NIC_GRP_fnc_ActionCheckGRP, _unit]};
private _vehicle = vehicle _unit;
if (_unit == _vehicle) exitWith {false};
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
if (count _crew > 0) exitWith {true};
false
// };
