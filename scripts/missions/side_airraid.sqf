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
	