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

void () ResetAllVotes =
{
	local entity e;
	
	e = find(world, classname, "player");
	while (e != world) {
		e.voted = 0;
		e.voted_yes = 0;
		e.voted_no = 0;
		e = find(e, classname, "player");
	}
}

void () EndVote =
{
	bprint(PRINT_HIGH, "Vote has timed out!\n");
	
	SendVoteAlertSound();

	coop_voting = 0;
	
	if (coop_voting_map)
		localcmd("localinfo coop_vote_map \"\"\n");
	if (coop_voting_skill)
		localcmd("localinfo coop_vote_skill \"\"\n");
	
	coop_voting_map = 0;
	coop_voting_skill = 0;
	coop_election = 0;
	coop_voting_newgame = 0;
	
	remove(self);
}

void () NewGame =
{
	if (self.coop_admin > 1 || GetPlayerCount() == 1) {
		serverflags = 0;
		localcmd("map start\n");
		return;
	}

	if (coop_voting)
	{
		if (coop_voting_map) {
			sprint(self, PRINT_HIGH, "A vote on \"");
			sprint(self, PRINT_HIGH, infokey(world, "coop_vote_map"));
			sprint(self, PRINT_HIGH, "\" is already in progress\n");
		}
		
		if (coop_voting_skill) {
			sprint(self, PRINT_HIGH, "A vote on skill ");
			sprint(self, PRINT_HIGH, infokey(world, "coop_vote_skill"));
			sprint(self, PRINT_HIGH, " is already in progress\n");
		}
		
		if (coop_election) {
			sprint(self, PRINT_HIGH, coop_electee.netname);
			sprint(self, PRINT_HIGH, " wishes to be admin, type yes or no\n");
		}
		
		if (coop_voting_newgame) {
			sprint(self, PRINT_HIGH, "A vote on a new game is in progress\n");
		}
		
		return;
	}

	ResetAllVotes();
	
	bprint(PRINT_HIGH, self.netname);
	bprint(PRINT_HIGH, " wants a new game, type yes or no in console\n");
	
	SendVoteAlertSound();
	
	coop_voting = 1;
	coop_voting_newgame = 1;
	
	coop_vote_pct = 1 / GetPlayerCount();

	coop_vote_timer = spawn();
	coop_vote_timer.think = EndVote;
	coop_vote_timer.nextthink = time + 30;
	
	self.voted = 1;
	self.voted_yes = 1;
	self.voted_no = 0;
}

void () StartElection =
{
	if (coop_voting)
	{
		if (coop_voting_map) {
			sprint(self, PRINT_HIGH, "A vote on \"");
			sprint(self, PRINT_HIGH, infokey(world, "coop_vote_map"));
			sprint(self, PRINT_HIGH, "\" is already in progress\n");
		}
		
		if (coop_voting_skill) {
			sprint(self, PRINT_HIGH, "A vote on skill ");
			sprint(self, PRINT_HIGH, infokey(world, "coop_vote_skill"));
			sprint(self, PRINT_HIGH, " is already in progress\n");
		}
		
		if (coop_election) {
			sprint(self, PRINT_HIGH, coop_electee.netname);
			sprint(self, PRINT_HIGH, " wishes to be admin, type yes or no\n");
		}
		
		if (coop_voting_newgame) {
			sprint(self, PRINT_HIGH, "A vote on a new game is in progress\n");
		}
		
		return;
	}

	if (GetPlayerCount() <= 1)
	{
		sprint(self, PRINT_HIGH, "More players required to vote!\n");
		return;
	}
	
	ResetAllVotes();
	
	bprint(PRINT_HIGH, self.netname);
	bprint(PRINT_HIGH, " wishes to become admin, type yes or no in console\n");
	
	SendVoteAlertSound();
	
	coop_voting = 1;
	coop_election = 1;
	
	coop_vote_pct = 1 / GetPlayerCount();

	coop_vote_timer = spawn();
	coop_vote_timer.think = EndVote;
	coop_vote_timer.nextthink = time + 30;
	
	self.voted = 1;
	self.voted_yes = 1;
	self.voted_no = 0;
	
	coop_electee = self;
}

void (string sk) StartSkillVote =
{	
	if (coop_voting)
	{
		if (coop_voting_map) {
			sprint(self, PRINT_HIGH, "A vote on \"");
			sprint(self, PRINT_HIGH, infokey(world, "coop_vote_map"));
			sprint(self, PRINT_HIGH, "\" is already in progress\n");
		}
		
		if (coop_voting_skill) {
			sprint(self, PRINT_HIGH, "A vote on skill ");
			sprint(self, PRINT_HIGH, infokey(world, "coop_vote_skill"));
			sprint(self, PRINT_HIGH, " is already in progress\n");
		}
		
		if (coop_election) {
			sprint(self, PRINT_HIGH, coop_electee.netname);
			sprint(self, PRINT_HIGH, " wishes to be admin, type yes or no\n");
		}

		if (coop_voting_newgame) {
			sprint(self, PRINT_HIGH, "A vote on a new game is in progress\n");
		}

		return;
	}
	
	if (sk == "")
	{
		sprint(self, PRINT_HIGH, "You must specify a skill level to vote on!\n");
		return;
	}
	
	if (GetPlayerCount() <= 1)
	{
		sprint(self, PRINT_HIGH, "More players required to vote!\n");
		return;
	}
	
	ResetAllVotes();
	
	bprint(PRINT_HIGH, self.netname);
	bprint(PRINT_HIGH, " wishes to change skill to ");
	bprint(PRINT_HIGH, sk);
	bprint(PRINT_HIGH, ", type yes or no in console\n");
	
	SendVoteAlertSound();
	
	coop_voting = 1;
	coop_voting_skill = 1;
	
	coop_vote_pct = 1 / GetPlayerCount();

	coop_vote_timer = spawn();
	coop_vote_timer.think = EndVote;
	coop_vote_timer.nextthink = time + 30;
	
	self.voted = 1;
	self.voted_yes = 1;
	self.voted_no = 0;
	
	localcmd("localinfo coop_vote_skill \"");
	localcmd(ftos(stof(sk))); // protection against hax0rzz
	localcmd("\"\n");
}

void (string m) StartMapVote =
{	
	if (coop_voting)
	{
		if (coop_voting_map) {
			sprint(self, PRINT_HIGH, "A vote on \"");
			sprint(self, PRINT_HIGH, infokey(world, "coop_vote_map"));
			sprint(self, PRINT_HIGH, "\" is already in progress\n");
		}
		
		if (coop_voting_skill) {
			sprint(self, PRINT_HIGH, "A vote on skill ");
			sprint(self, PRINT_HIGH, infokey(world, "coop_vote_skill"));
			sprint(self, PRINT_HIGH, " is already in progress\n");
		}
		
		if (coop_election) {
			sprint(self, PRINT_HIGH, coop_electee.netname);
			sprint(self, PRINT_HIGH, " wishes to be admin, type yes or no\n");
		}

		if (coop_voting_newgame) {
			sprint(self, PRINT_HIGH, "A vote on a new game is in progress\n");
		}
		
		return;
	}
	
	if (m == "")
	{
		sprint(self, PRINT_HIGH, "You must specify a map to vote on!\n");
		return;
	}
	
	if (GetPlayerCount() <= 1)
	{
		sprint(self, PRINT_HIGH, "More players required to vote!\n");
		return;
	}
	
	ResetAllVotes();
	
	bprint(PRINT_HIGH, self.netname);
	bprint(PRINT_HIGH, " wishes to change map to ");
	bprint(PRINT_HIGH, m);
	bprint(PRINT_HIGH, ", type yes or no in console\n");
	
	SendVoteAlertSound();
	
	coop_voting = 1;
	coop_voting_map = 1;
	
	coop_vote_pct = 1 / GetPlayerCount();

	coop_vote_timer = spawn();
	coop_vote_timer.think = EndVote;
	coop_vote_timer.nextthink = time + 30;
	
	self.voted = 1;
	self.voted_yes = 1;
	self.voted_no = 0;
	
	localcmd("localinfo coop_vote_map \"");
	localcmd(m);
	localcmd("\"\n");
}

void () YesVote =
{
	local float pct_needed;
	
	if (coop_voting == 0)
		return;
	
	if (self.voted) {
		if (self.voted_yes) {
			sprint(self, PRINT_HIGH, "Your yes vote has been counted\n");
			return;
		}
		
		if (self.voted_no) {
			bprint(PRINT_HIGH, self.netname);
			bprint(PRINT_HIGH, " changes his vote to yes\n");
			self.voted_yes = 1;
			self.voted_no = 0;
		}
	} else {
		bprint(PRINT_HIGH, self.netname);
		bprint(PRINT_HIGH, " votes yes\n");
	}
	
	self.voted = 1;
	self.voted_yes = 1;
	self.voted_no = 0;
	
	coop_vote_pct += 1 / GetPlayerCount();
	
	if (coop_vote_pct > 1) // should never happen, but just in case
	{
		coop_vote_pct = 1;
		bprint(PRINT_HIGH, "DEBUG: coop_vote_pct went above one!\n");
	}
	
	if (infokey(world, "coop_vote_pct_needed") == "") // default to 80 percent
		pct_needed = 80;
	else
		pct_needed = stof(infokey(world, "coop_vote_pct_needed"));
		
	pct_needed /= 100;
	
	if (coop_vote_pct >= pct_needed) {		
		if (coop_voting_map) {
			bprint(PRINT_HIGH, "Changing map to ");
			bprint(PRINT_HIGH, infokey(world, "coop_vote_map"));
			bprint(PRINT_HIGH, "\n");
			
			changelevel(infokey(world, "coop_vote_map"));
			localcmd("localinfo coop_vote_map \"\"\n");
		}
		
		if (coop_voting_skill) {
			bprint(PRINT_HIGH, "Changing skill to ");
			bprint(PRINT_HIGH, infokey(world, "coop_vote_skill"));
			bprint(PRINT_HIGH, "\n");
			
			cvar_set("skill", infokey(world, "coop_vote_skill"));
			localcmd("localinfo coop_vote_skill \"\"\n");
		}
		
		if (coop_election) {
			bprint2(PRINT_HIGH, coop_electee.netname, " is now an admin\n");
			coop_electee.coop_admin = 2;
		}
		
		if (coop_voting_newgame) {
			serverflags = 0;
			localcmd("map start\n");
		}
		
		coop_voting_map = 0;
		coop_voting_skill = 0;
		coop_election = 0;
		coop_voting_newgame = 0;
		coop_voting = 0;
		remove(coop_vote_timer);
	}
}

void () NoVote =
{
	if (coop_voting == 0)
		return;
	
	if (self.voted) {
		if (self.voted_no) {
			sprint(self, PRINT_HIGH, "Your no vote has been counted\n");
			return;
		}
		
		if (self.voted_yes) {
			bprint(PRINT_HIGH, self.netname);
			bprint(PRINT_HIGH, " changes his vote to no\n");
			
			self.voted_yes = 0;
			self.voted_no = 1;
			
			coop_vote_pct -= 1 / GetPlayerCount();
			
			if (coop_vote_pct < 0) // should never happen, but just in case
			{
				coop_vote_pct = 0;
				bprint(PRINT_HIGH, "DEBUG: coop_vote_pct dropped below zero!\n");
			}

			return;
		}
	}
			
	self.voted = 1;
	self.voted_yes = 0;
	self.voted_no = 1;

	bprint(PRINT_HIGH, self.netname);
	bprint(PRINT_HIGH, " votes no\n");
}

float (string cmd, string args) GE_ClientCommand =
{
	if (cmd == "help") {
		sprint(self, PRINT_HIGH, "Cmd List:\n");
		sprint(self, PRINT_HIGH, "help            ... gives you this text\n");
		sprint(self, PRINT_HIGH, "admin <code>    ... gain admin\n");
		sprint(self, PRINT_HIGH, "map <map>       ... change map to <map>\n");
		sprint(self, PRINT_HIGH, "skill <s>       ... change skill to <s>\n");
		return TRUE;
	}
	
	if (cmd == "admin") {
		if (args == infokey(world, "coop_admin_code")) {
			bprint2(PRINT_HIGH, self.netname, " is now an admin\n");
			self.coop_admin = 2;
		} else {
			sprint(self, PRINT_HIGH, "Incorrect code\n");
		}
		
		return TRUE;
	}
	
	if (cmd == "map") {
		if (self.coop_admin > 1) {
			bprint(PRINT_HIGH, self.netname);
			bprint(PRINT_HIGH, " changed map to ");
			bprint(PRINT_HIGH, args);
			bprint(PRINT_HIGH, "\n");
			
			changelevel(args);
			return TRUE;
		}
		
		StartMapVote(args);
		return TRUE;
	}
	
	if (cmd == "skill") {
		if (stof(args) < 0 || stof(args) > 3) {
			sprint(self, PRINT_HIGH, "Invalid skill level\n");
			return TRUE;
		}
		
		if (self.coop_admin > 1) {
			bprint(PRINT_HIGH, self.netname);
			bprint(PRINT_HIGH, " changed skill to ");
			bprint(PRINT_HIGH, ftos(stof(args)));
			bprint(PRINT_HIGH, "\n");
			
			cvar_set("skill", ftos(stof(args)));
			return TRUE;
		}
		
		StartSkillVote(args);
		return TRUE;
	}
	
	return FALSE;
}

string ( string monsterClass ) ParseClass =
{
    			if (monsterClass == "monster_army")
					return("Grunt");
				if (monsterClass == "monster_demon1")
					return("Fiend");
				if (monsterClass == "monster_dog")
					return("Dog");
				if (monsterClass == "monster_dragon")
					return("Dragon");
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
				if (monsterClass == "monster_vomit")
					return("Vomitus");
				if (monsterClass == "monster_wizard")
					return("Scrag");
				if (monsterClass == "monster_zombie")
					return("Zombie");

return ("Unknown");

}
