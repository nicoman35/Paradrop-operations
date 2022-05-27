/*
	Author: 		Nicoman
	Function: 		NIC_GRP_fnc_DelParadropLocation
	Version: 		1.0
	Edited Date: 	22.05.2022
	
	Description:
		Add mission event handler 'Map Single Click'. 
		When clicking on map near paradrop marker, delete the marker.
		Doing so removes event handler.
		
	Parameters:
		None
	
	Returns:
		None
*/

// NIC_GRP_fnc_DelParadropLocation  = {
addMissionEventHandler ["MapSingleClick", {
	params ["", "_pos", "", ""];
	private _mPos1 = getMarkerPos "NIC_GRP_Objective";
	// diag_log formatText ["%1%2%3%4%5%6%7%8%9", time, "s  _mPos1: ", _mPos1, ", _pos: ", _pos];
	if (_mPos1 distance2D _pos < 100) then {
		deleteMarker "NIC_GRP_Objective";
		removeMissionEventHandler ["MapSingleClick", _thisEventHandler];
	};
}];
// };
