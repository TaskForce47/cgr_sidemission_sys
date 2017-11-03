hint "Its working as it should!";
/*
Written by christian2526 aka. [TF47] Chris [REBEL]
Every Feature is subject to change.
For questions send me an Email at Christian.Grandjean@web.de

==================================================================
Creates a FAC and a jet spam, during a 30 minute period jets are called in and attack random blufor units. If the fac dies the mission is completed. 

	Parameters:
			-No Parameters are passed-

==================================================================
*/
cgr_fnc_fac_indep = {

	private ["_position"];
	_position = _this select 0;
	_fac = "rhsgref_ins_g_grenadier" createUnit [_position, "this addBackpack 'tf_anprc155_coyote'", 1, "corporal"];
	_fac;
};

cgr_fnc_airraid_jet = {
	
	private ["_randomPos","_jetType","_jet","_jetCrew","_waypoint","_x"];

	_JetArray = [grpNull];
	_jetCrew = createGroup independent;
	_blacklist = ["cgr_mkr_base","cgr_mkr_fob"];
	{
	_jetCrew = createGroup independent;
	_randomPos = [[[(getMarkerPos "cgr_mkr_side_spawn"), 300],[]],["water","out"]] call BIS_fnc_randomPos;
	_jettype = "rhs_l39_cdf";
	_jet = createVehicle [_jettype, [(_randomPos select 0),(_randomPos select 1),2000], [], 0, "FLY"];
	waitUntil {sleep 0.5; !isNull _jet};
	[_jet, _jetCrew] call BIS_fnc_spawnCrew;
	[_jetCrew, getPos cgr_side_target, 2000,_blacklist] call BIS_fnc_taskPatrol;
	_jet lock 3;
	if (random 1 >= 0.5) then {
		_jet allowCrewInImmobile true;
	};
	sleep 0.1;
						
	//Create a waypoint
	_waypoint = _jetCrew addWaypoint [cgr_side_target, 10];
	_waypoint setWaypointFormation "COLUMN";
	_waypoint setWaypointCombatMode "RED";
	_waypoint waypointAttachVehicle cgr_side_target;
	_waypoint setWaypointType "SAD";
		
	_JetArray = _JetArray + [_jet];
	sleep 0.1;
	_JetArray = _JetArray + [_jetCrew];
	} forEach [_this select 0,_this select 1];
	
	_JetArray;
	

};

private ["_side_task_text","_side_task_detail","_side_task_marker","_sideTask","_position","_safeposition","_enemiesArray"];
_JetArray = [grpNull];
_enemyArray = [grpNull];
_blacklist = ["cgr_mkr_base","cgr_mkr_fob"];
/*Prepare the Task*/
_side_task_text = "Side: FAC in the area!";
_side_task_detail = "Side Mission: Two enemy Forward Air Controllers have moved into the area near our base and are currently</br>preparing an air raid on our base. Find them and neutralize them as fast as possible.</br>In roughly 15 minutes they will send the jets in!";
_sideTask = [west,["tsk_side_1"], [_side_task_detail,_side_task_text,"cgr_mkr_base"],getmarkerPos "cgr_mkr_base",true,1,true,"defend"] call BIS_fnc_taskCreate;
sleep 1;
//Spawn the fac and let him move around
_position = (getMarkerPos "cgr_mkr_base");
_safeposition = [_position, 200, 400, 5, 0, 0.5, 0, ["cgr_mkr_base","cgr_mkr_fob"]] call BIS_fnc_findSafePos;
_facGroup1 = createGroup independent;
_facGroup2 = createGroup independent;
cgr_side_target_1 = _facGroup1 createUnit ["rhsgref_ins_g_grenadier",_safeposition, [], 0, "FORM"];
cgr_side_target_1 addBackpack 'tf_anprc155_coyote';
[cgr_side_target_1, _safeposition, 600,_blacklist] call BIS_fnc_taskPatrol;
_position = (getMarkerPos "cgr_mkr_base");
_safeposition = [_position, 200, 400, 5, 0, 0.5, 0, ["cgr_mkr_base","cgr_mkr_fob"]] call BIS_fnc_findSafePos;
cgr_side_target_2 = _facGroup2 createUnit ["rhsgref_ins_g_grenadier",_safeposition, [], 0, "FORM"];
cgr_side_target_2 addBackpack 'tf_anprc155_coyote';
[cgr_side_target_2, _safeposition, 600,_blacklist] call BIS_fnc_taskPatrol;

//Wait for completiton
_fac_1_dead = false;
_fac_2_dead = false;
_fac_dead_both = false;
_jetsup = false;
_jet_1_down = false;
_jet_2_down = false;
_jetsdown = false;
_time = 0;
_time5minutes = 30;
_time15minutes = 90;

while {!_fac_dead_both || {_time < _time15minutes}} do {
	
	if (!_fac_dead_both) then {
		if (alive cgr_side_target_1) then {_fac_1_dead = false} else {_fac_1_dead = true};
		if (alive cgr_side_target_2) then {_fac_2_dead = false} else {_fac_2_dead = true};
		
		if (_fac_1_dead && _fac_2_dead) then {_fac_dead_both = true;};
		
		_time = _time + 10;
	} else {
		if (_fac_dead_both && (_time < _time15minutes)) exitWith {
			_sideTask = ["tsk_side_1","Succeeded",true] call bis_fnc_taskSetState;
			[objNull, 15, 5, true, "Side Mission Completed!"] call tf47_core_ticketsystem_fnc_changeTickets;
			
			//Clean-up
			["tsk_side_1"] call Bis_fnc_deleteTask;
			["tsk_side_2"] call Bis_fnc_deleteTask;
			sleep 120;
			deleteVehicle cgr_side_target_1;
			deleteVehicle cgr_side_target_2;
			[_JetArray] spawn cgr_fnc_side_cleanUp;

			waitUntil {cgr_cleanup_finished};

			//Call next
			sleep cgr_timebetweenmissions; 
			[true] call cgr_fnc_side_init;
		} else {
			_time = _time +10;
		};
	};
	sleep 10;
};
while {!_jetsUP} do {
	if (_time == _time15minutes) then {
		_jetArray = [cgr_side_target_1,cgr_side_target_2] call cgr_fnc_airraid_jet;
		_side_task_text = "Side: BANDITS IMBOUND!!!";
		_side_task_detail = "Side Mission: BANDITS reportedly went up into the skies and are making their way towards our base, from now you have 10 minutes to either kill the FAC or you neutralize those jets.";
		_sideTask = [west,["tsk_side_2","tsk_side_1"], [_side_task_detail,_side_task_text,""],getmarkerPos "cgr_mkr_base",true,1,true,"defend"] call BIS_fnc_taskCreate;
		_jetsUP = true;
	} else {
		_time = _time + 10;
	};
};
		
while {_jetsUp && {!_jetsdown}} do {
	
	_cnt = count _jetArray == 0;
	if (_cnt) then {_jetsdown = true;_jetsUp = false;};

	if (!_fac_dead_both) then {
		if (alive cgr_side_target_1) then {_fac_1_dead = false} else {_fac_1_dead = true};
		if (alive cgr_side_target_2) then {_fac_2_dead = false} else {_fac_2_dead = true};
		
		if (_fac_1_dead && _fac_2_dead) then {_fac_dead_both = true;};
	} else {
		if (_fac_dead_both) then {
			_sideTask = ["tsk_side_1","Succeeded",true] call bis_fnc_taskSetState;
			[objNull, 15, 5, true, "Side Mission Completed!"] call tf47_core_ticketsystem_fnc_changeTickets;
			sleep 2;
			//Clean-up
			["tsk_side_1"] call Bis_fnc_deleteTask;
			["tsk_side_2"] call Bis_fnc_deleteTask;
			sleep 120;
			deleteVehicle cgr_side_target_1;
			deleteVehicle cgr_side_target_2;
			[_JetArray] spawn cgr_fnc_side_cleanUp;
	
			waitUntil {cgr_cleanup_finished};
			//Call next
			sleep cgr_timebetweenmissions; 
			[true] call cgr_fnc_side_init;
		};
	};
	sleep 10;
};
waitUntil {_jetsdown && {_fac_dead_both};sleep 5;};
if (_jetsdown && _fac_dead_both) then {
	_sideTask = ["tsk_side_1","Succeeded",true] call bis_fnc_taskSetState;
	[objNull, 15, 5, true, "Side Mission Completed!"] call tf47_core_ticketsystem_fnc_changeTickets;
				
	//Clean-up
	["tsk_side_1"] call Bis_fnc_deleteTask;
	["tsk_side_2"] call Bis_fnc_deleteTask;
	sleep 120;
	deleteVehicle cgr_side_target_1;
	deleteVehicle cgr_side_target_2;
	[_JetArray] spawn cgr_fnc_side_cleanUp;
	
	waitUntil {cgr_cleanup_finished};
	//Call next
	sleep cgr_timebetweenmissions; 
	[true] call cgr_fnc_side_init;
};