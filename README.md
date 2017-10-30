# cgr_sidemission_sys




Side Mission Framework by christian2526 aka. [TF47] Chris [REBEL] based on Invade & Annex Side Mission Script
==================================================
Einfügen in die Init.sqf: 

[true] call cgr_fnc_side_init;

_cgr_side_mission = execVM "cgr_sidemission_sys\cgr_sidemission_config.sqf";

cgr_fnc_side_get = compileFinal preprocessFileLineNumbers "cgr_sidemission_sys\functions\fn_side_get.sqf";
cgr_fnc_side_finish = compileFinal preprocessFileLineNumbers "cgr_sidemission_sys\functions\fn_side_finish.sqf";
cgr_fnc_side_cleanup = compileFinal preprocessFileLineNumbers "cgr_sidemission_sys\functions\fn_side_cleanup.sqf";


Einfügen in die Description.ext:

class cfgFunctions
{
#include "cgr_sidemission_sys\cgr_config.hpp"
};


Sollte class cfgFunctions schon vorhanden sein:

#include "cgr_sidemission_sys\cgr_config.hpp"


Funktionierende Missionen: 

side_armor (Feindliche stationäre Panzer vernichten)

side_container (Container bergen und in die Base bringen mit Heli)


Bei Fragen:

PN im Forum der Task Force 47 an Chris

Oder via Mail:
Christian.Grandjean@web.de