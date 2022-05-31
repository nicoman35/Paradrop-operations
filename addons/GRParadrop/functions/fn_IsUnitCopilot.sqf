/*
	Author: 		Nicoman
	Function: 		NIC_GRP_fnc_IsUnitCopilot
	Version: 		1.0
	Edited Date: 	30.05.2022
	
	Description:
		Check, if unit is copilot of vehicle
	
	Parameters:
		_unit:		Object - unit to be checked, defauts to objNull
		_vehicle:	Object - vehicle unit is in, defaults to objNull
	
	Returns:
		Bool
*/

// NIC_GRP_fnc_IsUnitCopilot = {
params [["_unit", objNull], ["_vehicle", objNull]];
if (isNull _unit || isNull _vehicle) exitWith {false};
if !(local _unit) exitWith {_this remoteExecCall [NIC_GRP_fnc_IsUnitCopilot, _unit]};
if (!alive _unit) exitWith {false};
// if (isNull _unit || !alive _unit || isNull _vehicle) exitWith {false};
private ["_trt"];
private _cfg = configFile >> "CfgVehicles" >> typeOf (_vehicle);
private _trts = _cfg >> "turrets";
private _isCopilot = false;
for "_i" from 0 to (count _trts - 1) do {
	_trt = _trts select _i;
	if (getNumber(_trt >> "iscopilot") == 1) exitWith {
		_isCopilot = (_vehicle turretUnit [_i] == _unit);
	};
};
_isCopilot
// };
