/*
	Author: 		Nicoman
	Function: 		NIC_GRP_fnc_GRPInit
	Version: 		1.0
	Edited Date: 	07.06.2022
	
	Description:
		Initiate addon, define CBA variables, add init event handler to all infantry units
	
	Parameters:
		None
	
	Returns:
		None
*/

if (format[localize "STR_BOCR_Main_ModuleAdd_Displayname"] == "") exitWith {};															// check for 'Backpack On Chest - Redux' mod

if (isNil "NIC_GRP_pilotsReady") then {NIC_GRP_pilotsReady 									= false};								// should pilots also get ready for paradropping?
if (isNil "NIC_GRP_copilotsReady") then {NIC_GRP_copilotsReady 								= false};								// should copilots also get ready for paradropping?
if (isNil "NIC_GRP_parachuteHeight") then {NIC_GRP_parachuteHeight 							= 120};									// minimal height at which halo jumping units will be given a parachute (m)
if (isNil "NIC_GRP_attachDistance") then {NIC_GRP_attachDistance 								= 7};									// distance in, below which attaching vehicle parachute is possible (m)
if (isNil "NIC_GRP_attachMinMass") then {NIC_GRP_attachMinMass 								= 250};									// minimum mass a vehicle has to have for being able to attach the vehicle parachute (kg)
if (isNil "NIC_GRP_attachMaxMass") then {NIC_GRP_attachMaxMass 								= 80000};								// maximum mass a vehicle has to have for being able to attach the vehicle parachute (kg)
if (isNil "NIC_GRP_vehicleParachuteDeployHeight") then {NIC_GRP_vehicleParachuteDeployHeight 	= 200};									// height at which vehicle parachute is to be deployed (m)
if (isNil "NIC_GRP_maxFallSpeed") then {NIC_GRP_maxFallSpeed 									= 130};									// max fall speed of vehicles (m/s)
if (isNil "NIC_GRP_deployOverride") then {NIC_GRP_deployOverride 								= false};								// override automatic calculation of parachute deployment height
if (isNil "NIC_GRP_securityFactor") then {NIC_GRP_securityFactor 								= 1.05};								// factor times (calculation of needed distance for vehicle parachute to break a load)
if (isNil "NIC_GRP_vehicleParachuteClasses") then {NIC_GRP_vehicleParachuteClasses			= [
	"Car", 
	"Tank", 
	"Air", 
	"Boat_F",
	"ReammoBox_F"
]};																																		// object classes vehicle parachute is allowed being attached to

// Vehicle list for vehicle parachute attachment offsets in format [vehicle type, [x, y, z]]
NIC_GRP_cargos = [
	["UGV_01_base_F", [0.7, 0.7, -0.2]],
	["B_Truck_01_medical_F", [-0.25, 1.8, 1.1]]
];

// Vehicle kind list for notice on how long ropes are to be when vehicle parachute is attached to load [vehicle kind, rope length]
NIC_GRP_ropeLength = [
	["Heli_Transport_03_base_F", 35],
	["VTOL_01_base_F", 60],
	["VTOL_02_base_F", 30]
];

["CAManBase", "init", {
	params ["_unit"];
	[_unit] spawn NIC_GRP_fnc_AddActionAttachParachute;
}, true] call CBA_fnc_addClassEventHandler;

["Air", "init", {_this spawn NIC_GRP_fnc_AddActionGRP}, true] call CBA_fnc_addClassEventHandler; 										// adds init event to all air vehicles; has to be run preinit!

["CAManBase", "Take", {
	params ["_unit"];
	[_unit] spawn NIC_GRP_fnc_AddActionAttachParachute;
}, true] call CBA_fnc_addClassEventHandler;

// player addEventHandler ["Take", {																									// does not work somehow -> find out why
	// params ["_unit"];
	// diag_log formatText ["%1%2%3%4%5%6%7", time, "s  EH fired"];
	// [_unit] spawn NIC_GRP_fnc_AddActionAttachParachute;
// }];

[missionNamespace, "arsenalClosed", {
	{[_x] spawn NIC_GRP_fnc_AddActionAttachParachute;} forEach allPlayers;
}] call BIS_fnc_addScriptedEventHandler;

// diag_log formatText ["%1%2%3%4%5%6%7", time, "s  NIC_GRP_fnc_GRPInit performed"];