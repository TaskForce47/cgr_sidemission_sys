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
private ["_position","_safeposition","_side_trigger","_side_target_list","_side_text","_side_task_text","_side_task_detail","_side_target_type","_side_target","_enemiesArray","_reinforcementArray"];

_position = (getMarkerPos "cgr_mkr_center");
_safeposition = [_position, 1, 2000, 10, 0, 0.25, 0, ["cgr_mkr_base","cgr_mkr_fob"]] call BIS_fnc_findSafePos;


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

//Different in recover missions
_side_trigger = createTrigger ["EmptyDetector", getPos cgr_return_point];
_side_trigger setTriggerArea [10, 10, 0, false];
_side_trigger setTriggerActivation ["ANY", "PRESENT", true];
_side_trigger setTriggerStatements ["this","",""];

//Time until Reinforcements start moving e.g. 20 minutes
_reinforcementArray = [1200,1,1] call cgr_fnc_side_reinforcements;

//Wait for completiton
waitUntil {sleep 5; cgr_side_target in (list _side_trigger);};

_sideTask = ["tsk_side_1","Succeeded",true] call bis_fnc_taskSetState;

//TF47 TICKET ID SUCCES 15
//TF$/ TICKET ID FAILURE 16
[objNull, 15, 5, true, "Side Mission Completed!"] call tf47_core_ticketsystem_fnc_changeTickets;
//Clean-up

deleteVehicle _side_trigger;
sleep 120;
deleteVehicle cgr_side_target;
[_enemiesArray] spawn cgr_fnc_side_cleanUp;
[_reinforcementArray] spawn cgr_fnc_side_cleanUp;

waitUntil {cgr_cleanup_finished};

//Call next
_sleep = 300 + (random 600);
sleep _sleep; 
[true] call cgr_fnc_side_init;