/*
Author: 

	Quiksilver
	Modified by christian2526
	
Last modified:

	18/10/2017

Description:

	Delete enemies.
	
___________________________________________*/
{
sleep 1;
    if (typeName _x == "GROUP") then {
        {
            if (vehicle _x != _x) then {
                deleteVehicle (vehicle _x);
            };
            deleteVehicle _x;
        } forEach (units _x);
    } else {
        if (vehicle _x != _x) then {
            deleteVehicle (vehicle _x);
        };
        if !(_x isKindOf "Man") then {
            {
                deleteVehicle _x;
            } forEach (crew _x)
        };
        deleteVehicle _x;
    };
} forEach (_this select 0);

cgr_cleanup_finished = true;