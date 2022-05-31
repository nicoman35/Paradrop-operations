/*
	Author: 		Nicoman
	Function: 		NIC_GRP_fnc_GRPInit
	Version: 		1.0
	Edited Date: 	30.05.2022
	
	Description:
		Initiate addon, define CBA variables, add init event handler to all infantry units
	
	Parameters:
		None
	
	Returns:
		None
*/

if (format[localize "STR_BOCR_Main_ModuleAdd_Displayname"] == "") exitWith {};											// check for 'Backpack On Chest - Redux' mod

if (isNil "NIC_GRP_pilotsReady") then {NIC_GRP_pilotsReady 									= false};				// should pilots also get ready for paradropping?
if (isNil "NIC_GRP_copilotsReady") then {NIC_GRP_copilotsReady 								= false};				// should copilots also get ready for paradropping?
if (isNil "NIC_GRP_parachuteHeight") then {NIC_GRP_parachuteHeight 							= 120};					// minimal height at which halo jumping units will be given a parachute (m)
if (isNil "NIC_GRP_attachDistance") then {NIC_GRP_attachDistance 								= 7};					// distance in, below which attaching vehicle parachute is possible (m)
if (isNil "NIC_GRP_attachMinMass") then {NIC_GRP_attachMinMass 								= 250};					// minimum mass a vehicle has to have for being able to attach the vehicle parachute (kg)
if (isNil "NIC_GRP_attachMaxMass") then {NIC_GRP_attachMaxMass 								= 80000};				// maximum mass a vehicle has to have for being able to attach the vehicle parachute (kg)
if (isNil "NIC_GRP_vehicleParachuteDeployHeight") then {NIC_GRP_vehicleParachuteDeployHeight 	= 200};					// height at which vehicle parachute is to be deployed (m)
if (isNil "NIC_GRP_maxFallSpeed") then {NIC_GRP_maxFallSpeed 									= 130};					// max fall speed of vehicles (m/s)
if (isNil "NIC_GRP_deployOverride") then {NIC_GRP_deployOverride 								= false};				// override automatic calculation of parachute deployment height
if (isNil "NIC_GRP_securityFactor") then {NIC_GRP_securityFactor 								= 1.05};				// factor times (calculation of needed distance for vehicle parachute to break a load)

// Parachutes to be used
// NIC_GRP_parachutes = [
	// "B_Parachute"
// ];

// Vehicle list for vehicle parachute attachment offsets in format [vehicle type, [x, y, z]]
NIC_GRP_vehicles = [
	["UGV_01_base_F", [0.7, 0.7, -0.2]],
	["B_Truck_01_medical_F", [-0.25, 1.8, 1.1]]
];

["CAManBase", "init", {
	params ["_unit"];
	// [_unit] spawn NIC_GRP_fnc_AddActionGRP;
	[_unit] spawn NIC_GRP_fnc_AddActionAttachParachute;
}, true] call CBA_fnc_addClassEventHandler;

["Air", "init", {_this spawn NIC_GRP_fnc_AddActionGRP}, true] call CBA_fnc_addClassEventHandler;


// ["Air", "init", {_this spawn NIC_GRP_fnc_AddActionGRP}, true] call CBA_fnc_addClassEventHandler; // adds init event to all air vehicles; has to be run preinit!

// ["CAManBase", "GetInMan", {
	// params ["_unit"];
	// [_unit] spawn NIC_GRP_fnc_AddActionGRP;
// }, true] call CBA_fnc_addClassEventHandler;

// ["CAManBase", "GetOutMan", {
	// params ["_unit"];
	// [_unit, "NIC_actionID_GRP"] spawn NIC_GRP_fnc_RemoveAction;
// }, true] call CBA_fnc_addClassEventHandler;

["CAManBase", "Take", {
	params ["_unit"];
	[_unit] spawn NIC_GRP_fnc_AddActionAttachParachute;
}, true] call CBA_fnc_addClassEventHandler;

// player addEventHandler ["Take", {					// does not work somehow -> find out why
	// params ["_unit"];
	// diag_log formatText ["%1%2%3%4%5%6%7", time, "s  EH fired"];
	// [_unit] spawn NIC_GRP_fnc_AddActionAttachParachute;
// }];

[missionNamespace, "arsenalClosed", {
	{[_x] spawn NIC_GRP_fnc_AddActionAttachParachute;} forEach allPlayers;
}] call BIS_fnc_addScriptedEventHandler;

// ["Air", "init", {_this call NIC_GRP_fnc_AddActionGRP}, true] call CBA_fnc_addClassEventHandler; // adds init event to all air vehicles; has to be run preinit!



// diag_log formatText ["%1%2%3%4%5%6%7", time, "s  NIC_GRP_fnc_GRPInit performed"];