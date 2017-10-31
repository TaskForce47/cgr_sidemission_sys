hint "Its working as it should!";
/*
Written by christian2526 aka. [TF47] Chris [REBEL]
Every Feature is subject to change.
For questions send me an Email at Christian.Grandjean@web.de

==================================================================
This is a test file for editing. Executed by side_init and side_start

	Parameters:
			-No Parameters are passed-

==================================================================
*/
private ["_position","_safeposition","_side_target_list","_side_text","_side_task_text","_side_task_detail","_side_target_type","_side_target","_enemiesArray","_reinforcementArray"];

_position = (getMarkerPos "cgr_mkr_center");
_safeposition = [_position, 1, cgr_center_distance, 10, 0, 0.25, 0, ["cgr_mkr_base","cgr_mkr_fob"]] call BIS_fnc_findSafePos;


waitUntil {!(isNil "_safeposition");};

 
/*Position and Trigger created*/
/*List of Targets for this Side Mission*/
_side_target_list = [

		"Land_Cargo10_red_F",
		"Land_Cargo10_blue_F"

];

/*Prepare the Side Vehicle (Target)*/
_side_target_type = _side_target_list call BIS_fnc_selectRandom;
cgr_side_target = createVehicle [_side_target_type, _safeposition,[], (random 360), "none"];
waitUntil {sleep 1; alive cgr_side_target};

cgr_side_target allowDamage false;
/*Place enemy protection forces*/
waitUntil {!isNull cgr_side_target};
_enemiesArray =[cgr_side_target] call cgr_fnc_side_enemy;

/*Prepare the Task*/
_side_task_text = "Side: Recover Material!";
_side_task_detail = "Side Mission: Recover the downed material container. The container may not be damaged otherwise its lost. And hurry up! You only have 20 minutes until reinforcements arrive!";
_side_task_marker = createMarker ["cgr_mkr_side",(getPos cgr_side_target)];
_sideTask = [west,["tsk_side_1"], [_side_task_detail,_side_task_text,"cgr_mkr_side"],cgr_side_target,true,1,true,"container"] call BIS_fnc_taskCreate;
sleep 5;

/*Place for extra code*/
_reinforcementArray = "";
_containerinbase = false;
private _count = 2;
while {!_containerinbase} do {
	if !(cgr_side_target distance2D cgr_return_point < 10) then {
		_containeratbase = false;
		

		if (_count == 200) then {
			_reinforcementArray = [200,1,1] call cgr_fnc_side_reinforcements;
		} else {
			_count = _count + 2;
		};
	} else {
		_containerinbase = true;
	};
	sleep 10;
};


//Wait for completiton
waitUntil {sleep 5;_containerinbase};

_sideTask = ["tsk_side_1","Succeeded",true] call bis_fnc_taskSetState;

//TF47 TICKET ID SUCCES 15
//TF$/ TICKET ID FAILURE 16
[objNull, 15, 5, true, "Side Mission Completed!"] call tf47_core_ticketsystem_fnc_changeTickets;
//Clean-up
["tsk_side_1"] call Bis_fnc_deleteTask;
sleep 120;
deleteVehicle cgr_side_target;
[_enemiesArray] spawn cgr_fnc_side_cleanUp;
if (_reinforcementArray == "") then {
	cgr_cleanup_finished = true;
} else {
	[_reinforcementArray] spawn cgr_fnc_side_cleanUp;
};
waitUntil {cgr_cleanup_finished};

//Call next
sleep timebetweenmissions;
[true] call cgr_fnc_side_init;