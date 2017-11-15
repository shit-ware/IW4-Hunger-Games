#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;

//Part of Hunger Games

//Code from AI Zombies, because it looks beautiful

//renamed from _intro to _hud because this is now where any and all HUD elements will be created, destroyed, threaded, etc.

introText(text)
{
	self endon( "disconnect" );
	wait ( 0.05 );
	self.introText destroy();
	self notify( "textPopup2" );
	self endon( "textPopup2" );
	self.introText = newClientHudElem( self );
	self.introText.horzAlign = "center";
	self.introText.vertAlign = "middle";
	self.introText.alignX = "center";
	self.introText.alignY = "middle";
	self.introText.x = 0;
	self.introText.y = 0;
	self.introText.font = "hudbig";
	self.introText.fontscale = 0.69;
	self.introText.color = (25.5, 25.5, 3.6);
	self.introText setText(text);
	self.introText.alpha = 0.85;
	self.introText.glowColor = (0.3, 0.9, 0.3);
	self.introText.glowAlpha = 0.55;
	self.introText ChangeFontScaleOverTime( 0.1 );
	self.introText.fontScale = 0.75;	
    wait 0.1;
	self.introText ChangeFontScaleOverTime( 0.1 );
	self.introText.fontScale = 0.69;	
	switch(randomInt(2))
	{
	    case 0:
		self.introText moveOverTime( 2.00 );
		self.introText.x = 60;
		self.introText.y = 0;
		break;
		case 1:
		self.introText moveOverTime( 2.00 );
		self.introText.x = -60;
		self.introText.y = 0;
		break;
	}
	wait 1;
	self.introText fadeOverTime( 5.00 );
	self.introText.alpha = 0;
}

blackScreen(map)//oh noes
{
	//needs to be improved BADLY
	/*self freezeControls(true);
	VisionSetNaked("blacktest", 5);
	wait 5;
	VisionSetNaked(map, 5);
	self freezeControls(false);*/
	
	/*if(level.canSpawn == 0)
	{
		self AllowSpectateTeam("freelook", true);
		self iPrintln("^2Please wait until all players are eliminated");
		wait 3;
		self iPrintln("^2 or until time expires.");
	}
	else
	{
		foreach(player in level.players)
		{
			//player thread blackScreen_doit(map);
			if(isReallyAlive(player) && !player maps\mp\gametypes\_playerlogic::maySpawn())
			{
				player thread blackScreen_doit(map);
			}
		}
	}*/
	
	foreach(player in level.players)
	{
		if(!player maps\mp\gametypes\_playerlogic::maySpawn())
		{
			self AllowSpectateTeam("freelook", true);
			self iPrintln("^2Please wait until all players are eliminated");
			wait 3;
			self iPrintln("^2 or until time expires.");		
		}
		else
		{
			if(isReallyAlive(player) && player maps\mp\gametypes\_playerlogic::maySpawn())
			{
				player blackScreen_doit(map);
			}
		}
	}
}

blackScreen_doit(map)
{
	self freezeControls(true);
	self VisionSetNakedForPlayer("blacktest", 0);
	wait 5;
	self VisionSetNakedForPlayer(map, 5);
	wait 5;
	self freezeControls(false);
}

enemyCountHUD()
{
	self endon("disconnect");
	{
		self.MainHud[0] = self createFontString("objective", 1.5);
		self.MainHud[0] setPoint("TOPLEFT", "TOPLEFT", 0, 125);
		self.MainHud[0].label = &"Enemies: ";
		self.MainHud[0].HideWhenInMenu = true;
		self.MainHud[0] thread updatePlayerCount(self);
		self.MainHud[0].color = (1,0.5,0.2);
		self.MainHud[0].alpha = 1;
	}
}

updatePlayerCount(player)
{
	player endon("disconnect");
	
	while(1)
	{
		if(playerCount() < 1)
		{
			self.color = (0.3, 0.9, 0.3);
			self setValue(playerCount());
		}
		else
		{
			self.color = (1,0.5,0.2);
			self setValue(playerCount());
		}
		wait .1;
	}
}

playerCount()
{
	//not actually HUD, mostly logic, may be moved in the future for logic's sake
	//but is used in HUD operations
	
	count = -1;
	foreach(player in level.players)
	{
		//check if each player is actually alive
		if(isAlive(player) && isReallyAlive(player))
		{
			count++;
		}
	}
	return count;
}

version()
{
	if(getDvarInt("hg_displayVersion"))
	{
		version = self createFontString("objective", 1);
		version setPoint("CENTER", "TOP", 0, 30);
		for(;;)
		{
			version setText("^1Hunger Games v 1.0");
			/*wait .01;
			version setText("^2Hunger Games v 1.0 Public Beta");
			wait .01;
			version setText("^3Hunger Games v 1.0 Public Beta");
			wait .01;
			version setText("^4Hunger Games v 1.0 Public Beta");
			wait .01;
			version setText("^5Hunger Games v 1.0 Public Beta");
			wait .01;
			version setText("^6Hunger Games v 1.0 Public Beta");
			wait .01;
			version setText("^7Hunger Games v 1.0 Public Beta");
			wait .01;
			version setText("^8Hunger Games v 1.0 Public Beta");
			wait .01;
			version setText("^9Hunger Games v 1.0 Public Beta");
			wait .01;
			version setText("^0Hunger Games v 1.0 Public Beta");
			wait .01;*/
		}
	}
}

dropTimer(interval)
{
	self endon("stop_count");
	
	timer = self createFontString("default", 1.2);
	timer setPoint("RIGHT", "CENTER", 0, -30);
	timer.color = ((255,255,255));
	timer setText("Package inbound, please wait");
	timer.foreground = false;
	
	count = self createFontString("default", 1.2);
	count setPoint("RIGHT", "CENTER", 0, 30);
	count.color = ((255, 251, 102));
	count.foreground = false;
	count setTimer(interval);
	self thread remove(interval, timer, count);
	count maps\mp\gametypes\_hud::fontPulseInit();
	
}

remove(time, obj, obj2)
{
	wait time;
	obj destroy();
	obj2 destroy();
	self notify("stop_count");
}

serverNotify(text, name)
{
	self endon("disconnect");
	{
		self.serverNotify[0] = self createFontString("hudbig", 1);
		self.serverNotify[0] setPoint("TOPRIGHT", "TOPRIGHT", 0, 125);
		self.serverNotify[0] setText("^2"+name);
		self.serverNotify[0].color = (25.5, 25.5, 3.6);
		self.serverNotify[0].alpha = 1;
		self.serverNotify[1] = self createFontString("hudbig", 0.5);
		self.serverNotify[1] setPoint("TOPRIGHT", "TOPRIGHT", 0, 140);
		self.serverNotify[1] setText(text);
		self.serverNotify[1].color = (25.5, 25.5, 3.6);
		self.serverNotify[1].alpha = 1;
		wait 5;
		self.serverNotify[0] destroy();
		self.serverNotify[1] destroy();
	}
}