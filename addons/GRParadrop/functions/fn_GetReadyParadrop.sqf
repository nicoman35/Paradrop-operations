/*
	Author: 		Nicoman
	Function: 		NIC_GRP_fnc_GetReadyParadrop
	Version: 		1.0
	Edited Date: 	30.05.2022
	
	Description:
		Advice crew of a vehilce to get ready for paradropping. Requires the addon 'Backpack On Chest - Redux'.
		Unit will, if all conditions are met, move original backpack to chest, pick a parachute from vehicle inventory, 
		and fit it out as backpack.
	
	Parameters:
		_vehicle:	Object - vehicle unit is in, defauts to objNull
		_unit:		Object - unit giving order to get ready for paradropping, defauts to objNull
		
		
	Returns:
		None
*/

// NIC_GRP_fnc_GetReadyParadrop  = {
params [["_vehicle", objNull], ["_unit", objNull]];
if (isNull _vehicle || isNull _unit) exitWith {
	// diag_log formatText ["%1%2%3%4%5", time, "s  (NIC_GRP_fnc_GetReadyParadrop) exit 0"];
	false
};
if !(local _vehicle) exitWith {_this remoteExecCall [NIC_GRP_fnc_GetReadyParadrop, _vehicle]};
if (!alive _vehicle || !alive _unit) exitWith {
	// diag_log formatText ["%1%2%3%4%5", time, "s  (NIC_GRP_fnc_GetReadyParadrop) exit 1"];
	false
};

// diag_log formatText ["%1%2%3%4%5%6%7%8%9", time, "s (NIC_GRP_fnc_GetReadyParadrop) 		_unit: ", name _unit];
private ["_index"];
private _units = [];
if (isPlayer _unit) then {_units = groupSelectedUnits player};
if (count _units == 0) then {_units = crew _vehicle};
// diag_log formatText ["%1%2%3%4%5%6%7%8%9", time, "s (NIC_GRP_fnc_GetReadyParadrop) 		_units: ", _units];
private _count = 0;
{
	if ([_x, _vehicle] call NIC_GRP_fnc_IsUnitAuthorized) then {
		// diag_log formatText ["%1%2%3%4%5%6%7%8%9", time, "s (NIC_GRP_fnc_GetReadyParadrop) 		member: ", name _x];
		if (backpack _x != "B_Parachute") then {
			if (backpack _x != "") then {
				[_x] call bocr_main_fnc_actionOnChest;
				_x setVariable ["NIC_hasBackpackOnChest", true];
			};
			[_vehicle, "B_Parachute"] call NIC_GRP_fnc_RemoveAbackpack;		
			_x addBackpack "B_Parachute";
		};
		_index = _x addEventHandler ["GetOutMan", {
			params ["_unit"];
			_unit removeEventHandler ["GetOutMan", _thisEventHandler];
			_unit setVariable ["NIC_grpEventGetOut", nil];
			[_unit, _vehicle] spawn NIC_GRP_fnc_HaloGRP;
		}];
		_x setVariable ["NIC_grpEventGetOut", _index]; 
		_count = _count + 1;
	};
} forEach _units; 

if (_count > 0) then {[_vehicle] spawn NIC_GRP_fnc_AddActionSetMarker};		// if any units are ready for paradropping, add 'Set Paradrop Location' action to vehicle

sleep 5;																		// sleep timer to emulate units getting ready takes time - might be replaced with something more fancy
// };
