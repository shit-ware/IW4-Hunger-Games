#include common_scripts\utility;
#include maps\mp\_utility;


//Gun Arrays
//Because "missing case statement" is too fucking vague and makes me want to drink bleach


//UPDATE: this file will NO LONGER contain coordinates, they are now static and are no longer dynamic
//instead of returning coordinates, we return the firearms
//this change happened because weapons were spawning inside of each other
//any remaining cooridnates left in this file will be removed and will be replaced with internal weapon names

basicGuns(map)
{
	gun = undefined;
	if(map == "mp_derail")
	{
		switch(randomInt(10))
		{
			case 0:
				gun = "beretta_mp";
				break;
			case 1:
				gun = "tmp_mp";
				break;
			case 2:
				gun = "model1887_mp";
				break;
			case 3:
				gun = "tavor_acog_mp";
				break;
			case 4:
				gun = "scar_thermal_mp";
				break;
			case 5:
				gun = "uzi_acog_mp";
				break;
			case 6:
				gun = "wa2000_acog_mp";
				break;
			case 7:
				gun = "mp5k_mp";
				break;
			case 8:
				gun = "usp_mp";
				break;
			case 9:
				gun = "ak47_mp";
				break;
			default:
				break;
		}
		return gun;
	}
	else
	{
		self iPrintln(map+" ^1is not supported.");
	}
}

powerGuns(map)
{
	power = undefined;
	if(map == "mp_derail")
	{
		switch(randomInt(7))
		{
			case 0:
				power = "cheytac_mp";
				break;
			case 1:
				power = "riotshield_mp";
				break;
			case 2:
				power = "javelin_mp";
				break;
			case 3:
				power = "fal_heartbeat_shotgun_mp";
				break;
			case 4:
				power = "p90_akimbo_rof_mp";
				break;
			case 5:
				power = "glock_akimbo_mp";
				break;
			case 6:
				power = "sa80_grip_reflex_mp";
				break;
			default:
				break;
		}
		return power;
	}
	else
	{
		self iPrintln(map+"^1is no supported.");
	}
}