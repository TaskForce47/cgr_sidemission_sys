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
private ["_position","_safeposition","_side_trigger","_side_target_list","_side_text","_side_task_text","_side_task_detail","_side_target_type","_side_target","_enemiesArray","_sideMarker"];

_position = (getMarkerPos "cgr_mkr_center");
_safeposition = [_position, 1, cgr_center_distance, 10, 0, 0.25, 0, ["cgr_mkr_base","cgr_mkr_fob"]] call BIS_fnc_findSafePos;


waitUntil {!(isNil "_safeposition");};

_side_trigger = createTrigger ["EmptyDetector", _safeposition];
_side_trigger setTriggerArea [500, 500, 0, false];
_side_trigger setTriggerActivation ["independent", "PRESENT", false];
_side_trigger setTriggerStatements ["this","",""];

/*Position and Trigger created*/
/*List of Targets for this Side Mission*/
_side_target_list = [

		"rhs_2s3_tv",
		"rhs_2s3_tv",
		"rhs_t90atv",
		"rhs_t90atv",
		"rhs_zsu234_aa"

];

/*Prepare the Side Vehicle (Target)*/
_side_target_type = _side_target_list call BIS_fnc_selectRandom;
cgr_side_target = createVehicle [_side_target_type, _safeposition,[], (random 360), "none"];
waitUntil {sleep 1; alive cgr_side_target};

cgr_side_target lock 3;
cgr_side_target setFuel 0;
/*Place enemy protection forces*/
waitUntil {!isNull cgr_side_target};
_enemiesArray =[cgr_side_target] call cgr_fnc_side_enemy;

/*Prepare the Task*/
_side_task_text = "Side: Destroy the enemy armor!";
_side_task_detail = "Side Mission: Destroy the enemy vehicle near the marked position.";
_side_task_marker = createMarker ["cgr_mkr_side",(getPos cgr_side_target)];
_sideTask = [west,["tsk_side_1"], [_side_task_detail,_side_task_text,"cgr_mkr_side"],cgr_side_target,true,1,true,"destroy"] call BIS_fnc_taskCreate;
sleep 5;



//Wait for completiton
waitUntil {sleep 5; (not alive cgr_side_target)};

waitUntil {sleep 5; count list _side_trigger < 3};

_sideTask = ["tsk_side_1","Succeeded",true] call bis_fnc_taskSetState;

//TF47 TICKET ID SUCCES 15
//TF$/ TICKET ID FAILURE 16
[objNull, 15, 5, true, "Side Mission Completed!"] call tf47_core_ticketsystem_fnc_changeTickets;
//Clean-up
["tsk_side_1"] call Bis_fnc_deleteTask;
deleteMarker _side_task_marker;
deleteVehicle _side_trigger;
sleep 120;
deleteVehicle cgr_side_target;
[_enemiesArray] spawn cgr_fnc_side_cleanUp;

waitUntil {cgr_cleanup_finished};

//Call next
sleep cgr_timebetweenmissions; 
[true] call cgr_fnc_side_init;