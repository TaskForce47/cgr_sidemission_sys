/*
Written by christian2526 aka. [TF47] Chris [REBEL]
Based on Quicksilvers Side Mission Script in his Invade & Annex. Thanks therefore.
Every Feature is subject to change.
For questions send me an Email at Christian.Grandjean@web.de

==================================================================
This is requierd to be called through the init.sqf:

	[true] call cgr_fnc_side_init;
	_cgr_side_mission = execVM "cgr_sidemission_sys\cgr_sidemission_config.sqf";

	Parameters:
		1. True/False : Put True for Sidemissions on/False for Sidemissions off

==================================================================
*/

private ["_pathToSideMission","_listOfSideMission","_sideMissionselected","_sideMissionStart"];
cgr_center_distance = 6000;
cgr_sideStart = true;
cgr_cleanup_finished = false;
cgr_timebetweenmissions = 300 + (random 600);
if (cgr_sideStart) then {

_pathToSideMission = "cgr_sidemission_sys\scripts\missions\";
//List of SideMissions
_listOfSideMission = [

					"side_container.sqf"
					"side_rescue_pilot.sqf",
					"side_armor.sqf"
					//"side_airraid.sqf"
					];
					

	_sideMissionselected = _listOfSideMission call BIS_fnc_selectRandom;
	_sideMissionStart = execVM format ["%1%2",_pathToSideMission,_sideMissionselected];
	
} else {hint "cgr_sidemission_sys not activated! Exiting!";};