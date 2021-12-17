/* 

GetPlayerCount()

@return
Returns the number of players currently playing

*/
float() GetPlayerCount =
{
	local float plcount;
	local entity pl;
	plcount = 0;

	pl = find (world, classname, "player");
	
    while ( pl != world )
    {
        ++plcount;
        pl = find (pl, classname, "player");
    }

	return (plcount);
}

/*
MultiplyHealth( float inputHealth )

@param1
inputHealth / float
@returnValue
outputHealth / float
@description
Performs a multiplication of an input value to substantially increase it
*/
float( float inputHealth ) MultiplyHealth =
{
	local float outputHealth;
	local float multiply;

	outputHealth = inputHealth;
	multiply = stof(infokey(world, "coop_players_online"));

	// skillcheck
	if(skill <= 2) 
		// easy, normal, hard
		outputHealth = outputHealth + ((outputHealth*0.25)*(multiply-1));
	else
		// nightmare
		outputHealth = outputHealth * multiply;

	return (outputHealth);
}

/*
ShowStatus( )

@description
Prints the current status of the mod
*/
void () ShowStatus =
{
	local float currentPlayers;
	local string strPlayers;
	local string strMapName;
	local float extraHealth;

    currentPlayers = stof(infokey(world, "coop_players_online"));
    strPlayers = ftos(GetPlayerCount());
    strMapName = mapname;
	
	if(skill <= 2)
		extraHealth = 100 + (25 * (currentPlayers-1));
	else
		extraHealth = 100 * currentPlayers;
	
	if (currentPlayers == 0) // this usually happens after server reset and someone joins on map start
		extraHealth = 100;

	sprint(self, PRINT_HIGH, "...... TKexCoop status ......\n");
	sprint(self, PRINT_HIGH, "Players online : ");
	sprint(self, PRINT_HIGH, strPlayers);
	sprint(self, PRINT_HIGH, "\n");
	sprint(self, PRINT_HIGH, "Mapname : ");
	sprint(self, PRINT_HIGH, strMapName);
	sprint(self, PRINT_HIGH, "\n");
	sprint(self, PRINT_HIGH, "Monster bonus health: ");
	sprint(self, PRINT_HIGH, ftos(extraHealth));
	sprint(self, PRINT_HIGH, "% health\n");
}

/*
ShowScores( )

@description
Prints out the current scores of every player present on the server

*/

void () ShowScores =
{
	local entity pl;

	pl = find (world, classname, "player");
	
    while ( pl != world )
    {
        sprint(self, PRINT_HIGH,  pl.netname);
        sprint(self, PRINT_HIGH, " >>> ");
        sprint(self, PRINT_HIGH, ftos(pl.frags));
        sprint(self, PRINT_HIGH, " frags\n");
        pl = find (pl, classname, "player");
    }

}

void () ShowNick =
{
	local vector org, aimv;
    local string sHealth, sArmor;
	
	makevectors(self.v_angle);
	
	org = self.origin + self.view_ofs;

	aimv = org + 10000 * v_forward;

	traceline(org, aimv, FALSE, self);
	
	if (trace_fraction != 1.0)
		if (trace_ent.classname == "player")
        {
        sHealth = ftos(trace_ent.health);
        sArmor = ftos(trace_ent.armorvalue);
			centerprint5(self, trace_ent.netname,"\nH: ", sHealth, " A: ", sArmor);
        }
}

void () SendVoteAlertSound =
{
	local entity e;
	
	e = find(world, classname, "player");
	while (e != world) {
		stuffcmd(e, "play misc/talk.wav\n");
		e = find(e, classname, "player");
	}
}

void () ResetAllVotes = {
}

void () EndVote = {
}

void () NewGame = {
}

void () StartElection = {
}

void (string sk) StartSkillVote = {	

}

void (string m) StartMapVote = {	

}

void () YesVote = {
	
}

void () NoVote = {
	
}

float (string cmd, string args) GE_ClientCommand = {
	if (cmd == "help") {
		sprint(self, PRINT_HIGH, "Cmd List:\n");
		sprint(self, PRINT_HIGH, "help            ... gives you this text\n");
		sprint(self, PRINT_HIGH, "admin <code>    ... gain admin\n");
		sprint(self, PRINT_HIGH, "map <map>       ... change map to <map>\n");
		sprint(self, PRINT_HIGH, "skill <s>       ... change skill to <s>\n");
		return TRUE;
	}
	
	if (cmd == "admin") {	
		return TRUE;
	}
	
	if (cmd == "map") {	
		StartMapVote(args);
		return TRUE;
	}
	
	if (cmd == "skill") {
		if (stof(args) < 0 || stof(args) > 3) {
			sprint(self, PRINT_HIGH, "Invalid skill level\n");
			return TRUE;
		}
		
		StartSkillVote(args);
		return TRUE;
	}
	
	return FALSE;
}

string ( string monsterClass ) ParseClass = {
	if (monsterClass == "monster_army")
		return("Grunt");
	if (monsterClass == "monster_demon1")
		return("Fiend");
	if (monsterClass == "monster_dog")
		return("Dog");
	if (monsterClass == "monster_enforcer")
		return("Enforcer");
	if (monsterClass == "monster_fish")
		return("Fish");
	if (monsterClass == "monster_hell_knight")
		return("Hell Knight");
	if (monsterClass == "monster_knight")
		return("Knight");
	if (monsterClass == "monster_ogre")
		return("Ogre");
	if (monsterClass == "monster_oldone")
		return("Shub Niggurath");
	if (monsterClass == "monster_shalrath")
		return("Vore");
	if (monsterClass == "monster_shambler")
		return("Shambler");
	if (monsterClass == "monster_tarbaby")
		return("Slime");
	if (monsterClass == "monster_wizard")
		return("Scrag");
	if (monsterClass == "monster_zombie")
		return("Zombie");

	return ("Unknown");
}
