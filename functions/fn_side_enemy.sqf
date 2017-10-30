/*
Author: 

	Quiksilver
	Modified by christian2526
	
Last modified:

	18/10/2017

Description:

	Spawn OPFOR enemy around side objectives.
	Enemy should have backbone AA/AT + random composition.
	
___________________________________________*/

//---------- CONFIG
#define CGR_SIDE_INF_GROUPS "rhsgref_group_chdkz_infantry_patrol","rhsgref_group_chdkz_ins_gurgents_squad"
#define CGR_SIDE_INF_GROUPS_SMALL "rhsgref_group_chdkz_infantry_mg","rhsgref_group_chdkz_infantry_at","rhsgref_group_chdkz_infantry_aa"
#define CGR_SIDE_VEHICLES "rhsgref_ins_g_BM21","rhsgref_ins_g_btr60","rhsgref_ins_g_btr70","rhsgref_ins_g_uaz_ags","rhsgref_ins_g_uaz_dshkm_chdkz","rhsgref_ins_g_bmd1","rhsgref_ins_g_bmp2d","rhsgref_ins_g_bmp2k","rhsgref_ins_g_bmp2","rhsgref_ins_g_t72ba","rhsgref_BRDM2_ins_g"
#define CGR_SIDE_VEHICLES_AA "rhsgref_ins_g_zsu234","rhsgref_ins_g_gaz66_zu23","rhsgref_ins_g_ZU23","rhsgref_ins_g_ural_Zu23"
private ["_x","_pos","_flatPos","_randomPos","_enemiesArray","_infteamPatrol","_SMvehPatrol","_SMveh1","_SMveh2","_SMaaPatrol","_SMaa","_smSniperTeam"];
_enemiesArray = [grpNull];
_x = 0;

//---------- GROUPS
	
_infteamPatrol = createGroup independent;
_smSniperTeam = createGroup independent;
_SMvehPatrol = createGroup independent;
_SMaaPatrol = createGroup independent;

//---------- INFANTRY GROUP RANDOM
	
for "_x" from 0 to 3 do {
	_randomPos = [[[getPos cgr_side_target, 300],[]],["water","out"]] call BIS_fnc_randomPos;
	_infteamPatrol = [_randomPos, independent, (configfile >> "CfgGroups" >> "Indep" >> "rhsgref_faction_chdkz_g" >> "rhsgref_group_chdkz_ins_gurgents_infantry" >> [CGR_SIDE_INF_GROUPS] call BIS_fnc_selectRandom)] call BIS_fnc_spawnGroup;
	[_infteamPatrol, getPos cgr_side_target, 100] call BIS_fnc_taskPatrol;
				
	_enemiesArray = _enemiesArray + [_infteamPatrol];


};

//---------- SMALL GROUP

for "_x" from 0 to 2 do {
	_randomPos = [getPos cgr_side_target, 500, 100, 20] call BIS_fnc_findOverwatch;
	_smSniperTeam = [_randomPos, independent, (configfile >> "CfgGroups" >> "Indep" >> "rhsgref_faction_chdkz_g" >> "rhsgref_group_chdkz_ins_gurgents_infantry" >> [CGR_SIDE_INF_GROUPS_SMALL] call BIS_fnc_selectRandom)] call BIS_fnc_spawnGroup;
	_smSniperTeam setBehaviour "COMBAT";
	_smSniperTeam setCombatMode "RED";
		
	_enemiesArray = _enemiesArray + [_smSniperTeam];

};
	
//---------- VEHICLE RANDOM
	
_randomPos = [[[getPos cgr_side_target, 300],[]],["water","out"]] call BIS_fnc_randomPos;
_SMveh1 = [CGR_SIDE_VEHICLES] call BIS_fnc_selectRandom createVehicle _randomPos;
waitUntil {sleep 0.5; !isNull _SMveh1};
[_SMveh1, _SMvehPatrol] call BIS_fnc_spawnCrew;
[_SMvehPatrol, getPos cgr_side_target, 75] call BIS_fnc_taskPatrol;
_SMveh1 lock 3;
if (random 1 >= 0.5) then {
	_SMveh1 allowCrewInImmobile true;
};
sleep 0.1;
	
_enemiesArray = _enemiesArray + [_SMveh1];

	
//---------- VEHICLE RANDOM	
	
_randomPos = [[[getPos cgr_side_target, 300],[]],["water","out"]] call BIS_fnc_randomPos;
_SMveh2 = [CGR_SIDE_VEHICLES] call BIS_fnc_selectRandom createVehicle _randomPos;
waitUntil {sleep 0.5; !isNull _SMveh2};
[_SMveh2, _SMvehPatrol] call BIS_fnc_spawnCrew;
[_SMvehPatrol, getPos cgr_side_target, 150] call BIS_fnc_taskPatrol;
_SMveh2 lock 3;
if (random 1 >= 0.5) then {
	_SMveh2 allowCrewInImmobile true;
};
sleep 0.1;
	
_enemiesArray = _enemiesArray + [_SMveh2];
sleep 0.1;
_enemiesArray = _enemiesArray + [_SMvehPatrol];


//---------- VEHICLE AA
	
_randomPos = [[[getPos cgr_side_target, 300],[]],["water","out"]] call BIS_fnc_randomPos;
_SMaa = [CGR_SIDE_VEHICLES_AA] call BIS_fnc_selectRandom createVehicle _randomPos;
waitUntil {sleep 0.5; !isNull _SMaa};
[_SMaa, _SMaaPatrol] call BIS_fnc_spawnCrew;
_SMaa lock 3;
if (random 1 >= 0.5) then {
	_SMaa allowCrewInImmobile true;
};
[_SMaaPatrol, getPos cgr_side_target, 150] call BIS_fnc_taskPatrol;
	
_enemiesArray = _enemiesArray + [_SMaaPatrol];
sleep 0.1;
_enemiesArray = _enemiesArray + [_SMaa];


//---------- COMMON

// [(units _infteamPatrol)] call QS_fnc_setSkill2;
// [(units _smSniperTeam)] call QS_fnc_setSkill3;
// [(units _SMaaPatrol)] call QS_fnc_setSkill4;
// [(units _SMvehPatrol)] call QS_fnc_setSkill2;
/*
//---------- GARRISON FORTIFICATIONS
	
	{
		_newGrp = [_x] call QS_fnc_garrisonFortEAST;
		if (!isNull _newGrp) then { 
		_enemiesArray = _enemiesArray + [_newGrp]; };

	} forEach (getPos cgr_side_target nearObjects ["House", 150]);
*/
_enemiesArray