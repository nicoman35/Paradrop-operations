// #include "BIS_AddonInfo.hpp"
class CfgPatches {
	class NIC_GRP_01 {
		version 			= 1;
		units[] 			= {
			"NIC_Bergen_dgtl_Para"
		};
		weapons[] 			= {};
		requiredVersion		= 0.1;
		requiredAddons[]	= {};
	};
};
class CfgFunctions {
	class NIC_GRP {
		class Functions {
			file = "GRParadrop\functions";
			class GRPInit {
				preInit = 1;
			};
			class ActionCheckAttach {};
			class ActionCheckDetach {};
			class ActionCheckGRP {};
			class ActionCheckSetMarker {};
			class AddActionAttachParachute {};
			class AddActionDetachParachute {};
			class AddActionGRP {};
			class AddActionSetMarker {};
			class AttachVehicleParachute {};
			class CheckAddActionGRP {};
			class DelParadropLocation {};
			class DetachVehicleParachute {};
			class GetReadyParadrop {};
			class GetSafePositionGRP {};
			class HaloGRP {};
			class HandleFallDamage {};
			class IsUnitAuthorized {};
			class IsUnitCopilot {};	
			class ParachuteGlideGRP {};
			class RemoveAbackpack {};
			class RemoveAction {};
			class SetParadropLocation {};	
			class VehParaDeployControl {};
		};
	};
};
class CfgVehicles {
	class B_Bergen_dgtl_F;
	class NIC_Bergen_dgtl_Para: B_Bergen_dgtl_F	{
		author						= "$STR_A3_Bohemia_Interactive";
		_generalMacro				= "B_Bergen_dgtl_F";
		scope						= 2;
		displayName					= "$STR_NIC_GRP_VEH_PARA";
		picture						= "\A3\Supplies_F_Exp\Bags\Data\UI\Icon_B_Bergen_digi_CA.paa";
		hiddenSelectionsTextures[]	= {
			"\A3\Supplies_F_Exp\Bags\Data\Bergen_digi_CO.paa"
		};
		maximumLoad					= 0;
		DLC							= "Expansion";
		mass						= 300;
	};
};
class Extended_PreInit_EventHandlers {
	class NIC_GRP_02 {
		init = "call compile preprocessFileLineNumbers '\GRParadrop\scripts\XEH_preInit.sqf'"; // CBA_a3 integration
	};
};
