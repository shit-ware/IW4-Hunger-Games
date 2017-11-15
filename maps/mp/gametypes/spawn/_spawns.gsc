#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\spawn\_gunArrays;

//TODO:Make code like hgSpawns but for drops. Make it load coordinates based off of map


//Part of Hunger Games project

//This file dictates player, weapon, and drop spawns

hgSpawns(num, map)
{
	if(map == "mp_derail")
	{
		switch(num)
		{
			case 0:
				self setOrigin((-13.1251, 1231.13, 117.174));
				break;
			case 1:
				self setOrigin((-249.925, 1512.87, 102.548));
				break;
			case 2:
				self setOrigin((-468.608, 1721.73, 79.6812));
				break;
			case 3:
				self setOrigin((-932.285, 1900.63, 26.8286));
				break;
			case 4:
				self setOrigin((-1361.16, 1797.81, 30.3052));
				break;
			case 5:
				self setOrigin((-1513.85, 1452.87, 63.3228));
				break;
			case 6:
				self setOrigin((-1745.47, 1297.54, 67.9404));
				break;
			case 7:
				self setOrigin((-1876.47, 1024.43, 57.811));
				break;
			case 8:
				self setOrigin((-1872.92, 800.484, 83.1167));
				break;
			case 9:
				self setOrigin((-1633.56, 511.972, 100.153));
				break;
			case 10:
				self setOrigin((-1356.2, 255.818, 17.2883));
				break;
			case 11:
				self setOrigin((-959.201, 39.7774, -12.4562));
				break;
			case 12:
				self setOrigin((-550.08, 186.828, -12.935));
				break;
			case 13:
				self setOrigin((-364.725, 618.268, 61.9338));
				break;
			case 14:
				self setOrigin((-272.458, 1111.64, 115.47));
				break;
			default:
				break;
		}
	}
	else
	{
		self iPrintln(map+" ^1is not supported.");//No map support (yet!)
	}
}

mapGuns(map)
{
	if(map=="mp_derail")
	{
		//regular weapons, 10 of these
		level thread SpawnWeapons(undefined, basicGuns(map), "a gun", (-1015.66, 961.908, 0.254103), 1);
		level thread SpawnWeapons(undefined, basicGuns(map), "some hardware",(-1014.2, 997.052, 12.0514), 1);
		level thread SpawnWeapons(undefined, basicGuns(map), "this piece", (-1124.92, 1158.77, 7.25911), 1);
		level thread SpawnWeapons(undefined, basicGuns(map), "an equalizer", (-1096.45, 920.957, 96.45), 1);
		level thread SpawnWeapons(undefined, basicGuns(map), "a persuader", (-1237.21, 949.416, 33.3706), 1);
		level thread SpawnWeapons(undefined, basicGuns(map), "a peashooter", (-1197.14, 857.372, 30.0319), 1);
		level thread SpawnWeapons(undefined, basicGuns(map), "the Saturday-night special", (-1164.76, 771.549, 26.2658), 1);
		level thread SpawnWeapons(undefined, basicGuns(map), "this rod", (-1133.21, 681.88, 5.74691), 1);
		level thread SpawnWeapons(undefined, basicGuns(map), "a blaster", (-1196.1, 791.607, 36.4873), 1);
		level thread SpawnWeapons(undefined, basicGuns(map), "a maker meeter", (-1015.66, 961.908, 0.254103), 1);
		
		//power weapons, 8 of these, 7 to be used because gold deagle is static
		level thread SpawnWeapons(undefined, powerGuns(map), "extra muscle", (-2009.47, 4339.86, 157.539), 1);
		level thread SpawnWeapons(undefined, powerGuns(map), "a defender", (-1956.13, -1435.4, 37.963), 1);
		level thread SpawnWeapons(undefined, powerGuns(map), "an equalizer", (142.048, -2618.53, 334.427), 1);
		level thread SpawnWeapons(undefined, powerGuns(map), "some expensive shit", (2195.9, -1873.46, 84.0185), 1);
		level thread SpawnWeapons(undefined, powerGuns(map), "more power", (1926.63, 1200.88, 136.59), 1);
		level thread SpawnWeapons(undefined, powerGuns(map), "an eliminator", (2116.48, 3322.87, 419.888), 1);
		level thread SpawnWeapons(undefined, powerGuns(map), "a BFG", (-128.851, 2093.47, 335.782), 1);
		level thread SpawnWeapons(::hax, "deserteaglegold_mp", "OMGWTFHAX", (-376.233, 3328.48, 332.526), 1);//static, DO NOT MOVE
		
	}
	else
	{
		self iPrintln(map+ ": ^1is not supported");//No map support (yet!)
	}
}

trigBox(map)
{
	if(map == "mp_derail")
	{
		level thread spawnTrigBox(trigBoxCoords(map));
	}
	else
	{
		self iPrintln(map+ "^1is not supported");
	}
}

//This POS is really ugly, clean up if possible
SpawnWeapons(WFunc,Weapon,WeaponName,Location,TakeOnce){  
self endon("disconnect"); 
weapon_model = getWeaponModel(Weapon); 
if(weapon_model=="")weapon_model=Weapon; 
Wep=spawn("script_model",Location+(0,0,0)); 
Wep setModel(weapon_model); 
for(;;){ 
foreach(player in level.players){ 
Radius=distance(Location,player.origin);
if(Radius<60){ 
player setLowerMessage(WeaponName,"Press ^3[{+activate}]^7 to swap for "+WeaponName); 
if(player UseButtonPressed())wait 0.2; 
if(player UseButtonPressed()){ 
if(!isDefined(WFunc)){ 
player takeWeapon(player getCurrentWeapon()); 
player _giveWeapon(Weapon); 
player switchToWeapon(Weapon); 
player clearLowerMessage(WeaponName,1); 
wait 2; 
if(TakeOnce){ 
Wep delete(); 
return; 
} 
}else{ 
player clearLowerMessage(WeaponName,1); 
player [[WFunc]](); 
wait 5; 
} 
} 
}else{ 
player clearLowerMessage(WeaponName,1); 
} 
wait 0.1; 
} 
wait 0.5; 
} 
}

doAmmo()
{
self endon ( "disconnect" );
self endon ( "death" );

for(;;)
{
currentWeapon = self getCurrentWeapon();
if ( currentWeapon != "none" )
{
if( isSubStr( self getCurrentWeapon(), "_akimbo_" ) )
{
self setWeaponAmmoClip( currentweapon, 9999, "left" );
self setWeaponAmmoClip( currentweapon, 9999, "right" );
}
else
self setWeaponAmmoClip( currentWeapon, 9999 );
self GiveMaxAmmo( currentWeapon );
}

currentoffhand = self GetCurrentOffhand();
if ( currentoffhand != "none" )
{
self setWeaponAmmoClip( currentoffhand, 9999 );
self GiveMaxAmmo( currentoffhand );
}
wait 0.05;
}
}

hax()
{
	self endon("death");
	
	self giveWeapon("deserteaglegold_mp", 0, false);
	self switchToWeapon("deserteaglegold_mp");
	if(self getCurrentWeapon() != "deserteaglegold_mp")
	{
		self giveWeapon("deserteaglegold_mp");
		self switchToWeapon("deserteaglegold_mp");
	}
	self thread doAmmo();
	
}

spawnTrigBox(coords)
{
	box = spawn("script_model", coords);
	box setModel("com_plasticcase_friendly");
	box Solid();
	box CloneBrushmodelToScriptmodel(level.airDropCrateCollision);
	box thread boxThink();
	
	trigger = spawn("trigger_radius", coords, 0, 75, 50);
	wait .01;
	trigger thread boxThink(coords);
}

boxThink(coords)
{
	self endon("disconnect");
	
	while(1)
	{
		self waittill("trigger", player);
		
		if(Distance(coords, player.origin) <=60)
		{
			player setLowerMessage("call", "Press ^3[{+activate}]^7 to get something from your sponsor");
		}
		if(Distance(coords, player.origin <= 60) && player useButtonPressed())
		{
			player clearLowerMessage("call", 1);
			/*
				there is a major issue here:
				
				depending on how long the use button is pressed, MANY air drops can come by
				until we find an actual way to fix this, here is a second ghetto as fuck hack
				
				it waits ~10 seconds, starts a timer, then threads the fly by
			*/
			
			player thread maps\mp\gametypes\spawn\_hud::dropTimer(20);//number can be changed. may make it as a dvar
			wait 20;//needs to be changed according to above thread
			name = player.name;
			foreach(person in level.players)
			{
				person thread maps\mp\gametypes\spawn\_hud::serverNotify("Has a sponsor!", name);
			}
			player thread maps\mp\killstreaks\_airdrop::doC130FlyBy(player, dropCoords(getDvar("mapname")), player.angles, "airdrop_mega");
		}
		
		if(Distance(coords, player.origin) > 50)
		{
			player clearLowerMessage("call", 1);
		}
		wait .01;
		
	}
}

dropCoords(map)
{
	drop = undefined;
	if(map == "mp_derail")
	{
		switch(randomInt(10))
		{
			case 0:
				drop = (1239.28, 1013.62, 119.187);
				break;
			case 1:
				drop = (-1980.05, 3518.29, 215.959);
				break;
			case 2:
				drop = (-2314.96, 3752.88, 206.035);
				break;
			case 3:
				drop = (-1154.87, 2987.14, 153.426);
				break;
			case 4:
				drop = (835.132, 2604.16, 334.878);
				break;
			case 5:
				drop = (3252.02, 2991.26, -0.0249992);
				break;
			case 6:
				drop = (2940.87, -2103.11, 68.9939);
				break;
			case 7:
				drop = (844.953, -3545.83, 288.373);
				break;
			case 8:
				drop = (-1596.71, -991.125, 21.6171);
				break;
			case 9:
				drop = (503.6, -375.157, -10.573);
				break;
			case 10:
				drop = (2101.55, 829.149, 87.8556);
				break;
			default:
				self iPrintln("^1ERROR IN DROP POSITIONS IN MAP "+map);
				wait 3;
				self iPrintln("^1Attemping to default to player's location...");
				drop = self.origin;
				break;
		}
		return drop;
	}
	else
	{
		self iPrintln(map+"^1is not supported");
	}
}

trigBoxCoords(map)
{
	coords = undefined;
	if(map == "mp_derail")
	{
		switch(randomInt(31))
		{
			case 0:
				coords = (1739.99, 4462.19, 216.248);
				break;
			case 1:
				coords = (87.9355, -13.5018, 145.22);
				break;
			case 2:
				coords = (352.874, 1503.7, 114.806);
				break;
			case 3:
				coords = (213.125, 1127.13, 109.065);
				break;
			case 4:
				coords = (975.511, 1018.84, 169.065);
				break;
			case 5:
				coords = (2801.88, 1336.56, 135.488);
				break;
			case 6:
				coords = (3757.82, 752.229, -4.398);
				break;
			case 7:
				coords = (3321.3, -655.964, 175.535);
				break;
			case 8:
				coords = (2868.21, -2114.73, 65.9673);
				break;
			case 9:
				coords = (1916.16, -3799.93, 145.64);
				break;
			case 10:
				coords = (851.606, -3520.75, 278.637);
				break;
			case 11:
				coords = (838.263, -2285.52, 294.674);
				break;
			case 12:
				coords = (-587.764, -402.089, 117.069);
				break;
			case 13:
				coords = (-1613.92, -1862.72, 160.377);
				break;
			case 14:
				coords = (-522.041, -3566.74, 97.9268);
				break;
			case 15:
				coords = (-127.308, 3645.74, 246.061);
				break;
			case 16:
				coords = (-1095.31, 781.791, 64.9179);
				break;
			case 17:
				coords = (133.126, 1090.58, 336.019);
				break;
			case 18:
				coords = (1007.77, 229.288, 132.351);
				break;
			case 19:
				coords = (1038.66, 212.132, 174.064);
				break;
			case 20:
				coords = (-998.875, -2295.08, 136.808);
				break;
			case 21:
				coords = (-405.292, -3102.51, 137.981);
				break;
			case 22:
				coords = (-835.484, -3653.24, 231.561);
				break;
			case 23:
				coords = (1038.87, -3710.66, 258.782);
				break;
			case 24:
				coords = (1771.64, 2199.58, 139.115);
				break;
			case 25:
				coords = (1938.86, 2128.79, 147.659);
				break;
			case 26:
				coords = (2487.82, 2949.18, 378.474);
				break;
			case 27:
				coords = (2014.84, 3796.64, 344.065);
				break;
			case 28:
				coords = (718.239, 2644.63, 387.76);
				break;
			case 29:
				coords = (844.825, 2689.43, 234.125);
				break;
			case 30:
				coords = (1006.12, 1952.88, 214.76);
				break;
			case 31:
				coords = (800.172, 2125.84, 246.866);
				break;
			default:
				self iPrintln("^1Error in function trigBoxCoords()");
				break;
		}
		return coords;
	}
	else
	{
		self iPrintln(map+"^1does not have trig box coords");
	}
}