/*
Written by christian2526 aka. [TF47] Chris [REBEL] for Task Force 47 Community

Spawns a reasonable force to counter a side mission team.

[time,number,number] call cgr_fnc_side_reinforcements;

Time: Time when they are called.
Number 1: 

	1: Small Force 4xCar
	2: Medium Force 2xCar 1xTank
	3: Large Force 3xCar 2xTank
	4: No Ground Reinforcements
	
Number 2:
	
	1: Jet
	2: No Jet

*/

private ["_time","_force","_jet","_blacklist","_reinforcementArray","_x","_infReinforcement","_carReinforcement","_tankReinforcement","_airReinforcement","_jetReinforcement","_position","_reinforcementSpawnRandom","_reinforcementSpawn","_randomPos","_car","_tank","_jet","_waypoint","_jettype"];

_time = _this select 0;
_force = _this select 1;
_jet = _this select 2;
_blacklist = ["cgr_mkr_base","cgr_mkr_fob"];
#define CGR_SIDE_RE_INF_GROUPS "rhsgref_group_chdkz_infantry_patrol"
#define CGR_SIDE_RE_INF_GROUPS_SMALL "rhsgref_group_chdkz_infantry_mg","rhsgref_group_chdkz_infantry_at","rhsgref_group_chdkz_infantry_aa"
#define CGR_SIDE_RE_VEHICLES_TANK "rhsgref_ins_g_bmd1","rhsgref_ins_g_bmp2d","rhsgref_ins_g_bmp2k","rhsgref_ins_g_bmp2","rhsgref_ins_g_t72ba"
#define CGR_SIDE_RE_VEHICLES_CAR "rhsgref_ins_g_btr60","rhsgref_ins_g_btr70","rhsgref_ins_g_uaz_ags","rhsgref_ins_g_uaz_dshkm_chdkz","rhsgref_BRDM2_ins_g"
#define CGR_SIDE_RE_VEHICLES_AA "rhsgref_ins_g_zsu234","rhsgref_ins_g_gaz66_zu23","rhsgref_ins_g_ural_Zu23"
#define CGR_SIDE_RE_JET "rhs_l39_cdf","rhs_l159_CDF"

_reinforcementArray = [grpNull];
_x = 0;

_infReinforcement = createGroup independent;
_carReinforcement = createGroup independent;
_tankReinforcement = createGroup independent;
_airReinforcement = createGroup independent;
_jetReinforcement = createGroup independent;

/*Wait until time is up*/
sleep _time;

/*SetUp a Task to inform*/
cgr_task_reinforcements = [west,["cgr_task_reinforcements","tsk_side_1"],["Enemy reinforcements are on the move! Stop them before they reach the Side Mission!","Reinforcements"],cgr_side_target,"Created",0,true,"danger"] call BIS_fnc_taskCreate;
//Random Spawn Position for Side Vehicles
_position = (getPos cgr_side_Target);
_reinforcementSpawnRandom = [_position, 800, 1200, 10, 0, 0.4, 0, ["cgr_mkr_base","cgr_mkr_fob"]] call BIS_fnc_findSafePos;
_reinforcementSpawn = [_reinforcementSpawnRandom select 0,_reinforcementSpawnRandom select 1, 0];	
switch (_force) do {
    
	case 1: {
	hint "Small Counter Force in Action";
	for "_x" from 1 to 4 do {

		/*Car Reinforcement*/
		_randomPos = [[[_reinforcementSpawn, 15],[]],["water","out"]] call BIS_fnc_randomPos;
		_car = [CGR_SIDE_RE_VEHICLES_CAR] call BIS_fnc_selectRandom createVehicle _randomPos;
		waitUntil {sleep 0.5; !isNull _car};
		[_car, _carReinforcement] call BIS_fnc_spawnCrew;
		_car lock 3;
		if (random 1 >= 0.5) then {
			_car allowCrewInImmobile true;
		};
		sleep 0.1;
										
			//Create a waypoint
			_waypoint = _carReinforcement addWaypoint [cgr_side_target, 10];
			_waypoint setWaypointFormation "COLUMN";
			_waypoint setWaypointCombatMode "RED";
			_waypoint waypointAttachVehicle cgr_side_target;
			_waypoint setWaypointType "SAD";
		
		_reinforcementArray = _reinforcementArray + [_car];
		sleep 0.1;
		_reinforcementArray = _reinforcementArray + [_carReinforcement];
		};
	};
    
	case 2: { hint "Medium Counter Force in Action";
		for "_x" from 1 to 2 do {
		/*Car Reinforcement*/
		_randomPos = [[[_reinforcementSpawn, 15],[]],["water","out"]] call BIS_fnc_randomPos;
		_car = [CGR_SIDE_RE_VEHICLES_CAR] call BIS_fnc_selectRandom createVehicle _randomPos;
		
		waitUntil {sleep 0.5; !isNull _car};
		[_car, _carReinforcement] call BIS_fnc_spawnCrew;
		[_carReinforcement, getPos cgr_side_target, 150] call BIS_fnc_taskPatrol;
		_car lock 3;
		if (random 1 >= 0.5) then {
			_car allowCrewInImmobile true;
		};
		sleep 0.1;
		
								
			//Create a waypoint
			_waypoint = _carReinforcement addWaypoint [cgr_side_target, 10];
			_waypoint setWaypointFormation "COLUMN";
			_waypoint setWaypointCombatMode "RED";
			_waypoint waypointAttachVehicle cgr_side_target;
			_waypoint setWaypointType "SAD";
		
		
		_reinforcementArray = _reinforcementArray + [_car];
		sleep 0.1;
		_reinforcementArray = _reinforcementArray + [_carReinforcement];
		};
	
		/*Tank Reinforcement*/
		_randomPos = [[[_reinforcementSpawn, 15],[]],["water","out"]] call BIS_fnc_randomPos;
		_tank = [CGR_SIDE_RE_VEHICLES_TANK] call BIS_fnc_selectRandom createVehicle _randomPos;
		waitUntil {sleep 0.5; !isNull _tank};
		[_tank, _tankReinforcement] call BIS_fnc_spawnCrew;
		[_tankReinforcement, getPos cgr_side_target, 150] call BIS_fnc_taskPatrol;
		_tank lock 3;
		if (random 1 >= 0.5) then {
			_tank allowCrewInImmobile true;
		};
		sleep 0.1;
				
								
			//Create a waypoint
			_waypoint = _tankReinforcement addWaypoint [cgr_side_target, 10];
			_waypoint setWaypointFormation "COLUMN";
			_waypoint setWaypointCombatMode "RED";
			_waypoint waypointAttachVehicle cgr_side_target;
			_waypoint setWaypointType "SAD";
		
		
		_reinforcementArray = _reinforcementArray + [_tank];
		sleep 0.1;
		_reinforcementArray = _reinforcementArray + [_tankReinforcement];
		
	};
	
	case 3: { hint "Big Counter Force in Action";
	
		for "_x" from 1 to 3 do {
		/*Car Reinforcement*/
		_randomPos = [[[_reinforcementSpawn, 15],[]],["water","out"]] call BIS_fnc_randomPos;
		_car = [CGR_SIDE_RE_VEHICLES_CAR] call BIS_fnc_selectRandom createVehicle _randomPos;
		waitUntil {sleep 0.5; !isNull _car};
		[_car, _carReinforcement] call BIS_fnc_spawnCrew;
		[_carReinforcement, getPos cgr_side_target, 150] call BIS_fnc_taskPatrol;
		_car lock 3;
		if (random 1 >= 0.5) then {
			_car allowCrewInImmobile true;
		};
		sleep 0.1;
								
			//Create a waypoint
			_waypoint = _carReinforcement addWaypoint [cgr_side_target, 10];
			_waypoint setWaypointFormation "COLUMN";
			_waypoint setWaypointCombatMode "RED";
			_waypoint waypointAttachVehicle cgr_side_target;
			_waypoint setWaypointType "SAD";
		
		
		_reinforcementArray = _reinforcementArray + [_car];
		sleep 0.1;
		_reinforcementArray = _reinforcementArray + [_carReinforcement];
		};
		
		for "_x" from 1 to 2 do {
	
		/*Tank Reinforcement*/
		_randomPos = [[[_reinforcementSpawn, 15],[]],["water","out"]] call BIS_fnc_randomPos;
		_tank = [CGR_SIDE_RE_VEHICLES_TANK] call BIS_fnc_selectRandom createVehicle _randomPos;
		waitUntil {sleep 0.5; !isNull _tank};
		[_tank, _tankReinforcement] call BIS_fnc_spawnCrew;
		[_tankReinforcement, getPos cgr_side_target, 150] call BIS_fnc_taskPatrol;
		_tank lock 3;
		if (random 1 >= 0.5) then {
			_tank allowCrewInImmobile true;
		};
		sleep 0.1;
								
			//Create a waypoint
			_waypoint = _tankReinforcement addWaypoint [cgr_side_target, 10];
			_waypoint setWaypointFormation "COLUMN";
			_waypoint setWaypointCombatMode "RED";
			_waypoint waypointAttachVehicle cgr_side_target;
			_waypoint setWaypointType "SAD";
		
		
		_reinforcementArray = _reinforcementArray + [_tank];
		sleep 0.1;
		_reinforcementArray = _reinforcementArray + [_tankReinforcement];
		};
	
	};
	case 4: { hint "no reinforcements"};
};
switch (_jet) do {
	case 1: {
		
			_randomPos = [[[(getMarkerPos "cgr_mkr_side_spawn"), 300],[]],["water","out"]] call BIS_fnc_randomPos;
			_jettype = [CGR_SIDE_RE_JET] call BIS_fnc_selectRandom; 
			_jet = createVehicle [_jettype, [(_randomPos select 0),(_randomPos select 1),2000], [], 0, "FLY"];
			waitUntil {sleep 0.5; !isNull _jet};
			[_jet, _jetReinforcement] call BIS_fnc_spawnCrew;
			[_jetReinforcement, getPos cgr_side_target, 2000,_blacklist] call BIS_fnc_taskPatrol;
			_jet lock 3;
			if (random 1 >= 0.5) then {
			_jet allowCrewInImmobile true;
			};
			sleep 0.1;
								
			//Create a waypoint
			_waypoint = _jetReinforcement addWaypoint [cgr_side_target, 10];
			_waypoint setWaypointFormation "COLUMN";
			_waypoint setWaypointCombatMode "RED";
			_waypoint waypointAttachVehicle cgr_side_target;
			_waypoint setWaypointType "SAD";
		
			_reinforcementArray = _reinforcementArray + [_jet];
			sleep 0.1;
			_reinforcementArray = _reinforcementArray + [_jetReinforcement];
	};
	case 2: {
	hint "no jet imbound";
	};
	default {hint "Defaul no jet"};
};

_reinforcementArray