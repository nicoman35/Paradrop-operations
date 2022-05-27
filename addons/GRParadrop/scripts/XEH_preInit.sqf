[
	"NIC_GRP_pilotsReady",																		// internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
	"CHECKBOX",																					// setting type
	[localize "STR_NIC_GRP_PILOTS", localize "STR_NIC_GRP_PILOTS_TIP"],							// [setting name, tooltip]
	[localize "STR_NIC_GRP_TITLE", localize "STR_NIC_GRP_DEPLOY_INF"],							// [name of the category the setting can be found, subcategory entry]
	false,																						// default value of setting
    true																						// "_isGlobal" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
] call CBA_fnc_addSetting;
[
	"NIC_GRP_copilotsReady",
	"CHECKBOX",
	[localize "STR_NIC_GRP_COPILOTS", localize "STR_NIC_GRP_COPILOTS_TIP"],
	localize "STR_NIC_GRP_TITLE",
	false,
    true
] call CBA_fnc_addSetting;
[
	"NIC_GRP_deployOverride",
	"CHECKBOX",
	[localize "STR_NIC_GRP_OVERIDE", localize "STR_NIC_GRP_OVERIDE_TIP"],
	[localize "STR_NIC_GRP_TITLE", localize "STR_NIC_GRP_DEPLOY_SUB"],
	false,
    true
] call CBA_fnc_addSetting;
[
	"NIC_GRP_vehicleParachuteDeployheight",
	"SLIDER",
	[localize "STR_NIC_GRP_DEPLOY_HEIGHT", localize "STR_NIC_GRP_DEPLOY_HEIGHT_TIP"],
	localize "STR_NIC_GRP_TITLE", 
	[80, 800, 200, 0],																			// data for this setting: [_min, _max, _default, _trailingDecimals]
    true,
	{NIC_GRP_vehicleParachuteDeployheight = round(NIC_GRP_vehicleParachuteDeployheight)}	// code executed on option changed AND on init
] call CBA_fnc_addSetting;
