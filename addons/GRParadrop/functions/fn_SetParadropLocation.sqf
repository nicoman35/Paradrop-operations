/*
	Author: 		Nicoman
	Function: 		NIC_GRP_fnc_SetParadropLocation
	Version: 		1.0
	Edited Date: 	22.05.2022
	
	Description:
		Add mission event handler 'Map Single Click'. Opens map. 
		When clicking on map set paradrop marker. Multiple clicking
		will update marker's position.
		Closing map removes event handler.
	
	Parameters:
		None
	
	Returns:
		None
*/

// NIC_GRP_fnc_SetParadropLocation  = {
private _setParadropLocation = addMissionEventHandler ["MapSingleClick", {
	params ["", "_pos", "", ""];
	
	deleteMarker "NIC_GRP_Objective";
	_markerstr = createMarkerLocal ["NIC_GRP_Objective", _pos];
	"NIC_GRP_Objective" setMarkerTypeLocal "hd_objective";
	"NIC_GRP_Objective" setMarkerText "PARADROP";
}];
openMap [true, false];

waitUntil {sleep 1; !visibleMap};
removeMissionEventHandler ["MapSingleClick", _setParadropLocation];

[] call NIC_GRP_fnc_DelParadropLocation;

// };

