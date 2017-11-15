#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;


/*
	/////////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////HUNGER GAMES////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////
	
	Projected started: May 10th, 2015
	Project finished: August 5th, 2015
	Initial idea: Dr. Poopenstein
	Code: Angry Ghost Patriot
	Current version: v1.0 Public Beta
	
	3rd party code:
		Se7ensins (MW2 Managed Code List (TU6))
		MPGH
		NGU
		AI Zombies(Text)
		MW2 dm code for the base
		aIW
	
	
	
	GREETZ:
		Artyom
		Triple-Horn
		aIW Team
		IW Studios
		Chris Sawyer, because small teams can do big things
		
	(fuck TTG)
	
	"It may be a dirt road now, but it will be a boulevard in the end." - Dr. Poopenstein
*/

main()
{
	//setDvar("scr_game_spectatetype", "0");
	
	maps\mp\gametypes\_globallogic::init();
	maps\mp\gametypes\_callbacksetup::SetupCallbacks();
	maps\mp\gametypes\_globallogic::SetupCallbacks();

	registerRoundSwitchDvar(level.gameType, 3,0,9);
	registerTimeLimitDvar( level.gameType, 5, 0, 1440 );
	registerScoreLimitDvar( level.gameType, 20, 0, 500 );
	registerWinLimitDvar( level.gameType, 6, 0, 5000 );
	registerRoundLimitDvar( level.gameType, 0, 0, 12 );
	registerNumLivesDvar( level.gameType, 1, 0, 10 );
	registerHalfTimeDvar( level.gameType, 0, 0, 1 );
	
	//Hunger Games Dvars
	
	if(getDvarInt("hg_displayVersion") == "")
	{
		setDvar("hg_displayVersion", 1);
	}
	

	level.onStartGameType = ::onStartGameType;
	level.getSpawnPoint = ::getSpawnPoint;
	level.onOneLeftEvent = ::onOneLeftEvent;
	level.graceTime = 45;
	level.onPlayerKilled = ::onPlayerKilled;
	level.teamBased = false;
	level.objectiveBased = false;

	game["dialog"]["gametype"] = "freeforall";

	if ( getDvarInt( "g_hardcore" ) )
		game["dialog"]["gametype"] = "hc_" + game["dialog"]["gametype"];
	else if ( getDvarInt( "camera_thirdPerson" ) )
		game["dialog"]["gametype"] = "thirdp_" + game["dialog"]["gametype"];
	else if ( getDvarInt( "scr_diehard" ) )
		game["dialog"]["gametype"] = "dh_" + game["dialog"]["gametype"];
	else if (getDvarInt( "scr_" + level.gameType + "_promode" ) )
		game["dialog"]["gametype"] = game["dialog"]["gametype"] + "_pro";
		
	
	level thread onPlayerConnect();
	
	level thread maps\mp\gametypes\spawn\_spawns::mapGuns(getDvar("mapname"));
	level thread maps\mp\gametypes\spawn\_spawns::trigBox(getDvar("mapname"));
	level.canSpawn = 1;
	wait level.graceTime;
	level.canSpawn = 0;
}


onStartGameType()
{
	setClientNameMode("auto_change");

	setObjectiveText( "allies", "Be the last one alive." );
	setObjectiveText( "axis", "Be the last one alive." );

	if ( level.splitscreen )
	{
		setObjectiveScoreText( "allies", "Be the last one alive." );
		setObjectiveScoreText( "axis", "Be the last one alive." );
	}
	else
	{
		setObjectiveScoreText( "allies", "Be the last one alive." );
		setObjectiveScoreText( "axis", "Be the last one alive." );
	}
	setObjectiveHintText( "allies", "Be the last one alive." );
	setObjectiveHintText( "axis", "Be the last one alive." );

	level.spawnMins = ( 0, 0, 0 );
	level.spawnMaxs = ( 0, 0, 0 );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "allies", "mp_dm_spawn" );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "axis", "mp_dm_spawn" );
	level.mapCenter = maps\mp\gametypes\_spawnlogic::findBoxCenter( level.spawnMins, level.spawnMaxs );
	setMapCenter( level.mapCenter );
	
	allowed[0] = "dm";
	maps\mp\gametypes\_gameobjects::main(allowed);

	maps\mp\gametypes\_rank::registerScoreInfo( "kill", 1 );
	maps\mp\gametypes\_rank::registerScoreInfo( "headshot", 2 );
	maps\mp\gametypes\_rank::registerScoreInfo( "assist", 10 );
	maps\mp\gametypes\_rank::registerScoreInfo( "suicide", 0 );
	maps\mp\gametypes\_rank::registerScoreInfo( "teamkill", 0 );
	
	level.QuickMessageToAll = true;
}


getSpawnPoint()
{
	spawnPoints = maps\mp\gametypes\_spawnlogic::getTeamSpawnPoints( self.pers["team"] );
	spawnPoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_DM( spawnPoints );

	return spawnPoint;

}


onPlayerConnect()
{
	for(;;)
	{
		level waittill("connected", player);
		
		//thread for onPlayerSpawned() moved to onJoinedTeam()
		player thread onJoinedTeam();

	}
}

onDisconnect()
{
	level endon("game_ended");
	
	self waittill("disconnect");
	
	if(!getDvarInt("con_gameMsgWindow0MsgTime"))
	{
		self setClientDvar("con_gameMsgWindow0MsgTime", "1");
	}
	else
	{
		//force
		self setClientDvar("con_gameMsgWindow0MsgTime", "1");
	}
}

onJoinedTeam()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("joined_team");
		self thread forceSpawn();
		self thread onPlayerSpawned();
	}
}

forceSpawn()
{
	self closepopupmenu();
	self closeInGameMenu();
	self notify("menuresponse", "changeclass", "class1");
	self thread playerCountUpdate();
	self thread monitorTwoLeftEvent();
}

clearKillFeed()
{
	self setClientDvar("con_gameMsgWindow0MsgTime", "0");
}

onPlayerSpawned()
{
	self endon("disconnect");
	for(;;)
	{
		self waittill("spawned_player");
		self thread takeAll();
		self.randomspawn=getSpawnNumber(getDvar("mapname"));
		self clearKillStreaks();
		self thread maps\mp\gametypes\spawn\_spawns::hgSpawns(self.randomspawn, getDvar("mapname"));
		self thread maps\mp\gametypes\spawn\_hud::blackScreen(getDvar("mapname"));
		self thread maps\mp\gametypes\spawn\_hud::introText("May the odds ever be in your favor...");
		self thread clearKillFeed();
		self thread maps\mp\gametypes\_class::setKillstreaks("none", "none", "none");//supposed to remove player killstreaks, but keep killstreaks themselves enabled on the server
		self thread maps\mp\gametypes\spawn\_hud::enemyCountHUD();
		self thread maps\mp\gametypes\spawn\_hud::version();
		self thread onDisconnect();
	}
	
	level notify("spawned_player");
}

clearKillstreaks()
{
	foreach ( index, streakStruct in self.pers["killstreaks"] )
		self.pers["killstreaks"][index] = undefined;
}

getSpawnNumber(mapname)
{
	self endon("disconnect");
	self endon("death");
	level endon("game_ended");
	
	if(mapname == "mp_derail")
	{
		return randomInt(15);
	}
	else
	{
		self iPrintlnBold("Error: No spawn points for map");
	}
}

takeAll()
{
	self endon("death");
	self endon("disconnect");
	
	self takeAllWeapons();
	self _clearPerks();
}

onOneLeftEvent(man)
{
	lastPlayer = getLastLiving(man);
	endGame(man);
}

getLastLiving(man)
{
	living = undefined;
	
	foreach(player in level.players)
	{
		if(!isReallyAlive(player) && !player maps\mp\gametypes\_playerlogic::maySpawn())
		{
			continue;
		}
		
		assertEx(!isDefined(living), "getLastLiving() found more than one living player.");
		
		living = player;
	}
	return living;
}

endGame(man)
{
	/*self endon("death");
	self endon("disconnect");
	level endon("game_ended");
	
	foreach(players in level.players)
	{
		level thread teamPlayerCardSplash("callout_lastteammemberalive", self, undefined);
	}
	wait 4;
	
	setDvar("g_gametype", "hg");
	level setDvar("map", "mp_derail");*/
	
	foreach(players in level.players)
	{
		level thread teamPlayerCardSplash("callout_lastteammemberalive", self, undefined);
	}
	thread maps\mp\gametypes\_gamelogic::endGame(getLastLiving(man), "Last alive!");
}

playerCountUpdate()
{
	self endon("disconnect");
	
	for(;;)
	{
		level.alive = 0;
		foreach(player in level.players)
		{
			if(!player.pers["lives"] && gameHasStarted() && !isAlive(player))
			{
			}
			else
			{
				if(player.team != "spectator" && isAlive(player) && isReallyAlive(player))
				{
					level.alive += 1;
				}
			}
		}
		wait 0.05;
	}
}

monitorTwoLeftEvent()
{
	self endon("disconnect");
	
	wait 45;
	
	for(;;)
	{
		if(level.alive < 3)
		{
			foreach(player in level.players)
			{
				if(!player.UAV)
				{
					player.UAV = 1;
					player thread maps\mp\killstreaks\_uav::launchUAV(player, player.team, 99999, false);
					player thread maps\mp\gametypes\spawn\_hud::serverNotify("UAV online!", undefined);
				}
			}
		}
		wait 0.05;
		//PLEASE WORK FUCK
	}
}

onPlayerKilled(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration, killId)
{
	thread checkAllowSpectating();
}

checkAllowSpectating()
{
	wait ( 0.05 );
	
	update = false;
	if ( !level.aliveCount[ game["attackers"] ] )
	{
		level.spectateOverride[game["attackers"]].allowEnemySpectate = 1;
		update = true;
	}
	if ( !level.aliveCount[ game["defenders"] ] )
	{
		level.spectateOverride[game["defenders"]].allowEnemySpectate = 1;
		update = true;
	}
	if ( update )
		maps\mp\gametypes\_spectating::updateSpectateSettings();
}