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
private ["_position","_safeposition","_side_trigger","_side_text","_side_task_text","_side_task_detail","_side_target","_enemiesArray","_reinforcementArray","_side_1_killed","_side_2_killed","_sideTask1","_sideTask2","_randomPos","_pilots_at_base"];


//get the location
_position = (getMarkerPos "cgr_mkr_center");
_safeposition = [_position, 1, 1000, 10, 0, 0.5, 0, ["cgr_mkr_base","cgr_mkr_fob"]] call BIS_fnc_findSafePos;
waitUntil {!(isNil "_safeposition");};


//Different in recover missions
_side_trigger = createTrigger ["EmptyDetector", getMarkerPos "cgr_mkr_droppoint"];
_side_trigger setTriggerArea [10, 10, 0, false];
_side_trigger setTriggerActivation ["WEST", "PRESENT", true];
_side_trigger setTriggerStatements ["this","",""];



/*Prepare the Side Group (Target)*/
cgr_side_target = "BlackHawkWreck" createVehicle _safeposition;
cgr_side_target allowDamage false;
waitUntil {!isNull cgr_side_target};
cgr_side_target_grp = createGroup [west,false];
sleep 0.021;
_randomPos = [[[position cgr_side_target, 15]],[]] call BIS_fnc_randomPos;
cgr_side_target_1 = cgr_side_target_grp createUnit ["rhsusf_army_ocp_helipilot", _randomPos, [], 1, "FORM"];
sleep 0.2;
_randomPos = [[[position cgr_side_target, 20]],[]] call BIS_fnc_randomPos;
cgr_side_target_2 = cgr_side_target_grp createUnit ["rhsusf_army_ocp_helipilot", _randomPos, [], 1, "FORM"];
sleep 0.2;
waitUntil {sleep 1; (alive cgr_side_target_1 && alive cgr_side_target_2)};
[cgr_side_target_1,true,9999, false] call ace_medical_fnc_setUnconscious;
[cgr_side_target_2,true,9999, false] call ace_medical_fnc_setUnconscious;

/*Place enemy protection forces*/


/*Prepare the Task*/
_side_task_text = "Side: Recover downed pilots!";
_side_task_detail = "Side Mission: Recover the downed pilots. If they die the mission is a complete failure. Hurry the fuck up! You only have 30 minutes until a huge enemy force arrives!";
_side_task_marker = createMarker ["cgr_mkr_side",(getPos cgr_side_target)];
_sideTask = [west,["tsk_side_1"], [_side_task_detail,_side_task_text,"cgr_mkr_side"],cgr_side_target,true,1,true,"defend"] call BIS_fnc_taskCreate;
_sideTask1 = [west,["tsk_side_2","tsk_side_1"], ["Keep the Cpt. Jack alive at all costs! Return him to base.","Save Cpt. Jack","cgr_mkr_side"],cgr_side_target_1,false,0,false,"defend"] call BIS_fnc_taskCreate;
_sideTask2 = [west,["tsk_side_3","tsk_side_1"], ["Keep the Lt. Bauer alive at all costs! Return him to base.","Save Lt. Bauer","cgr_mkr_side"],cgr_side_target_2,false,0,false,"defend"] call BIS_fnc_taskCreate;
sleep 5;

_pilots_at_base = false;
_pilots_dead = false;
while {!_pilots_at_base && {!_pilots_dead}} do {
	if (!alive cgr_side_target_1 && {!alive cgr_side_target_2}) then {
		_pilots_dead = true;
		_sideTask = ["tsk_side_1","FAILED",true] call bis_fnc_taskSetState;
		deleteVehicle _side_trigger;
		sleep 120;
		deleteVehicle cgr_side_target;
		deleteVehicle cgr_side_target_1;
		deleteVehicle cgr_side_target_2;
		[_reinforcementArray] spawn cgr_fnc_side_cleanUp;
		waitUntil {cgr_cleanup_finished};
		_sleep = 300 + (random 600);
		sleep _sleep;
		[true] call cgr_fnc_side_init;
	} else {
		if (_pilots_at_base) then {
		
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
		
		} else {
			if (cgr_side_target_1 distance2D cgr_return_point < 10 || {cgr_side_target_2 distance2D cgr_return_point < 10}) then {_pilots_at_base = true} else {_pilots_at_base = false;};
		};
	};
};

//Wait for completiton
waitUntil {_pilots_at_base};
_sideTask = ["tsk_side_1","Succeeded",true] call bis_fnc_taskSetState;

//TF47 TICKET ID SUCCES 15
//TF$/ TICKET ID FAILURE 16
[objNull, 15, 5, true, "Side Mission Completed!"] call tf47_core_ticketsystem_fnc_changeTickets;
//Clean-up
deleteVehicle cgr_side_target_1;
deleteVehicle cgr_side_target_2;
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
