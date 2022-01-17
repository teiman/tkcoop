 
// prototypes
void () W_WeaponFrame;
void (string from) W_SetCurrentAmmo;
void (entity e, float f) player_pain;
void () player_stand1;
void (vector org) spawn_tfog;
void (vector org, entity death_owner) spawn_tdeath;
void () RandomAxeAttack;
float() nextmap_isset;

//void () DisplayMap;

float   modelindex_eyes, modelindex_player;

void () CheckMOTD = {
};

void () AutoRecord = {
};

void () AliasCommands = {	
};

void () CommandsList = {
};

void() SkillUp =
{
	local string s;

	skill = skill + 1;
	if (skill > 3)
		skill = 0;
	s = ftos(skill);
	cvar_set("skill", s);
	bprint3(PRINT_MEDIUM, "skill ", s, "\n");
}

void() SkillDown =
{
	local string s;

	skill = skill - 1;
	if (skill < 0)
		skill = 3;
	s = ftos(skill);
	cvar_set("skill", s);
	bprint3(PRINT_MEDIUM, "skill ", s, "\n");
}


/*
=============================================================================

				LEVEL CHANGING / INTERMISSION

=============================================================================
*/

string nextmap;

float   intermission_running;
float   intermission_exittime;

/*QUAKED info_intermission (1 0.5 0.5) (-16 -16 -16) (16 16 16)
This is the camera point for the intermission.
Use mangle instead of angle, so you can set pitch or roll as well as yaw.  'pitch roll yaw'
*/
void() info_intermission =
{
	self.angles = self.mangle;      // so C can get at it
};


/*
void PF2_setspawnparms(byte* base, uintptr_t mask, pr2val_t* stack, pr2val_t*retval)
{
	int			i;
	//edict_t		*ent;
	int			entnum=stack[0]._int;
	client_t	*client;

	//ent = EDICT_NUM(entnum);

	if (entnum < 1 || entnum > MAX_CLIENTS)
		PR2_RunError("Entity is not a client");

	// copy spawn parms out of the client_t
	client = svs.clients + (entnum - 1);

	for (i = 0; i < NUM_SPAWN_PARMS; i++)
		(&pr_global_struct->parm1)[i] = client->spawn_parms[i];
}
*/

void() SetChangeParms = {

	if (self.health <= 0) {
		SetNewParms ();	
		return;
	}
	
	self.health = 100;
	parm1 = self.items;
	parm2 = self.health;
	parm3 = self.armorvalue;	
	parm4 = self.mission_stage;
};

void() SetNewParms = {
	//Tei: really reset everything
	dprint("Resetting global params\n");

	parm1 = IT_SHOTGUN | IT_AXE;
	parm2 = 100;	
};

void() DecodeLevelParms =
{	
	//if (world.model == "maps/start.bsp")
	//	SetNewParms ();         // take away all stuff on starting new episode
	
	self.weapon = IT_SHOTGUN;
	self.items = parm1;
	self.health = parm2;
	self.armorvalue = parm3;
	self.mission_stage = parm4;		
	self.armortype = parm9 * 0.01;	
	
	/*
	dprint("[DecodeLevelParms] parm1=");dprint(ftos(parm1));dprint("\n");
	dprint("[DecodeLevelParms] parm2=");dprint(ftos(parm2));dprint("\n");
	dprint("[DecodeLevelParms] parm3=");dprint(ftos(parm3));dprint("\n");
	dprint("[DecodeLevelParms] parm4=");dprint(ftos(parm4));dprint("\n");
	dprint("[DecodeLevelParms] parm5=");dprint(ftos(parm5));dprint("\n");
	dprint("[DecodeLevelParms] parm6=");dprint(ftos(parm6));dprint("\n");
	dprint("[DecodeLevelParms] parm7=");dprint(ftos(parm7));dprint("\n");
	dprint("[DecodeLevelParms] parm8=");dprint(ftos(parm8));dprint("\n");
	*/
};

/*
============
FindIntermission

Returns the entity to view from
============
*/
entity() FindIntermission = {
	local   entity spot;
	local   float cyc;

	// look for info_intermission first
	spot = find (world, classname, "info_intermission");
	if (spot) {
		// pick a random one
		cyc = random() * 4;
		while (cyc > 1) {
			spot = find (spot, classname, "info_intermission");
			if (!spot)
				spot = find (spot, classname, "info_intermission");
			cyc = cyc - 1;
		}
		return spot;
	}

	// then look for the start position
	spot = find (world, classname, "info_player_start");
	if (spot)
		return spot;

	objerror ("FindIntermission: no spot");
	
	return spot; // quiet warning
};


void() GotoNextMap = {
	local string newmap;
    local float players;
	local entity e;
	
	if( mapname != "hub1"){

		e = find(world, classname, "player");
		while (e != world) {
			if(mapname == MISSION1){
				e.mission_stage = e.mission_stage | EPISODE1_COMPLETE;			
			}else if(mapname == MISSION2){
				e.mission_stage = e.mission_stage | EPISODE2_COMPLETE;			
			}else if (mapname == MISSION3){
				e.mission_stage = e.mission_stage | EPISODE3_COMPLETE;			
			}else if (mapname == MISSION4){
				e.mission_stage = e.mission_stage | EPISODE4_COMPLETE;			
			}

			e = find(e, classname, "player");
		}

		changelevel ("hub1");
	} else {
		if(nextmap_isset()){
			changelevel (nextmap_selected);
		}
	}
};

void() ExitIntermission = {
	GotoNextMap();
};

/*
============
IntermissionThink

When the player presses attack or jump, change to the next level
============
*/
void() IntermissionThink =
{
	//We got rid of intermission waittimes
	GotoNextMap();
};

/*
============
execute_changelevel

The global "nextmap" has been set previously.
Take the players to the intermission spot
============
*/
void() execute_changelevel =
{
    

};


void() changelevel_touch = {
	local entity    pos;

	if (other.classname != "player")
		return;

	nextmap = self.map;

	SUB_UseTargets ();

	GotoNextMap();
};

/*QUAKED trigger_changelevel (0.5 0.5 0.5) ? NO_INTERMISSION
When the player touches this, he gets sent to the map listed in the "map" variable.  Unless the NO_INTERMISSION flag is set, the view will go to the info_intermission spot and display stats.
*/
void() trigger_changelevel =
{
	if (!self.map)
		objerror ("chagnelevel trigger doesn't have map");
	
	InitTrigger ();
	self.touch = changelevel_touch;
};


/*
=============================================================================

				PLAYER GAME EDGE FUNCTIONS

=============================================================================
*/

void() set_suicide_frame;

// called by ClientKill and DeadThink
void() respawn =
{
	//dprint("[respawn] ...\n");

	// make a copy of the dead body for appearances sake
	CopyToBodyQue (self);

	// get the spawn parms as they were at level start
	// setspawnparms (self); David 09-03-2016 Issue #3
	SetNewParms ();
	
	// mighty hack alert!
	// frags should not reset to level start amount
	// this is the easiest way to do that
	parm11 = self.frags;

	/*
	dprint("parm1=");dprint(ftos(parm1));dprint("\n");
	dprint("parm2=");dprint(ftos(parm2));dprint("\n");
	dprint("parm3=");dprint(ftos(parm3));dprint("\n");
	dprint("parm4=");dprint(ftos(parm4));dprint("\n");
	dprint("parm5=");dprint(ftos(parm5));dprint("\n");
	dprint("parm6=");dprint(ftos(parm6));dprint("\n");
	dprint("parm7=");dprint(ftos(parm7));dprint("\n");
	dprint("parm8=");dprint(ftos(parm8));dprint("\n");
	*/
	
	// respawn
	PutClientInServer ();
};


/*
============
ClientKill

Player entered the suicide command
============
*/
void() ClientKill =
{
	bprint (PRINT_MEDIUM, self.netname);
	bprint (PRINT_MEDIUM, " suicides\n");
	set_suicide_frame ();
	self.modelindex = modelindex_player;
	logfrag (self, self);
	self.frags = self.frags - 2;    // extra penalty
	respawn ();
};

float(vector v) CheckSpawnPoint =
{
	return FALSE;
};

/*
============
SelectSpawnPoint

Returns the entity to spawn at
============
*/
entity() SelectSpawnPoint =
{
	local   entity spot, newspot, thing;
	local   float   numspots, totalspots;
	local   float   rnum, pcount;
	local   float   rs;
	local entity spots;

	numspots = 0;
	totalspots = 0;

// testinfo_player_start is only found in regioned levels
	spot = find (world, classname, "testplayerstart");
	if (spot)
		return spot;
		
	if (coop)
	{
		lastspawn = find(lastspawn, classname, "info_player_coop");
		if (lastspawn == world)
			lastspawn = find (lastspawn, classname, "info_player_start");
		if (lastspawn != world)
			return lastspawn;
	}
	else if (deathmatch)
	{
	// choose a info_player_deathmatch point

	// ok, find all spots that don't have players nearby
		spots = world;
		spot = find (world, classname, "info_player_deathmatch");       
		while (spot)
		{
			totalspots = totalspots + 1;

			thing=findradius(spot.origin, 84);
			pcount=0;               
			while (thing)
			{
				if (thing.classname == "player")
					pcount=pcount + 1;                      
				thing=thing.chain;      
			}
			if (pcount == 0) {
				spot.goalentity = spots;
				spots = spot;
				numspots = numspots + 1;
			}

			// Get the next spot in the chain
			spot = find (spot, classname, "info_player_deathmatch");                
		}
		totalspots=totalspots - 1;
		if (!numspots) {
			// ack, they are all full, just pick one at random
			//		bprint (PRINT_MEDIUM, "Ackk! All spots are full. Selecting random spawn spot\n");
			totalspots = rint((random() * totalspots));
			spot = find (world, classname, "info_player_deathmatch");       
			while (totalspots > 0) {
				totalspots = totalspots - 1;
				spot = find (spot, classname, "info_player_deathmatch");
			}
			return spot;
		}
		
	// We now have the number of spots available on the map in numspots

		// Generate a random number between 1 and numspots

		numspots = numspots - 1;
	
		numspots = rint((random() * numspots ) );

		spot = spots;
		while (numspots > 0) {
			spot = spot.goalentity;
			numspots = numspots - 1;
		}
		return spot;
	}

	if (serverflags)
	{	// return with a rune to start
		spot = find (world, classname, "info_player_start2");
		if (spot)
			return spot;
	}

	spot = find (world, classname, "info_player_start");
	if (!spot)
		error ("PutClientInServer: no info_player_start on level");

	return spot;
};
void() DecodeLevelParms;
void() PlayerDie;

/*
===========
ValidateUser


============
*/
float(entity e) ValidateUser =
{
/*
	local string    s;
	local string    userclan;
	local float     rank, rankmin, rankmax;

//
// if the server has set "clan1" and "clan2", then it
// is a clan match that will allow only those two clans in
//
	s = serverinfo("clan1");
	if (s)
	{
		userclan = masterinfo(e,"clan");
		if (s == userclan)
			return true;
		s = serverinfo("clan2");
		if (s == userclan)
			return true;
		return false;
	}

//
// if the server has set "rankmin" and/or "rankmax" then
// the users rank must be between those two values
//
	s = masterinfo (e, "rank");
	rank = stof (s);

	s = serverinfo("rankmin");
	if (s)
	{
		rankmin = stof (s);
		if (rank < rankmin)
			return false;
	}
	s = serverinfo("rankmax");
	if (s)
	{
		rankmax = stof (s);
		if (rankmax < rank)
			return false;
	}

	return true;
*/
	return TRUE;
};


/*
===========
PutClientInServer

called each time a player enters a new level
============
*/
void() PutClientInServer =
{
	local   entity spot;
	local 	string	s;

	self.classname = "player";
	self.health = 100;
	self.takedamage = DAMAGE_AIM;
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_WALK;
	self.show_hostile = 0;
	self.max_health = 100;
	self.flags = FL_CLIENT;
	self.air_finished = time + 12;
	self.dmg = 2;                   // initial water damage
	self.super_damage_finished = 0;
	self.radsuit_finished = 0;
	self.invisible_finished = 0;
	self.invincible_finished = 0;
	self.effects = 0;
	self.invincible_time = 0;

	DecodeLevelParms ();
	
	W_SetCurrentAmmo ("PutClientInServer");


	self.attack_finished = time +1;
	self.th_pain = player_pain;
	self.th_die = PlayerDie;
	
	self.deadflag = DEAD_NO;

	// paustime is set by teleporters to keep the player from moving a while
	self.pausetime = 0;
	
	spot = SelectSpawnPoint ();

	self.origin = spot.origin + '0 0 1';
	self.angles = spot.angles;
	self.fixangle = TRUE;           // turn this way immediately

	// oh, this is a hack!
	setmodel (self, "progs/eyes.mdl");
	modelindex_eyes = self.modelindex;

	setmodel (self, "progs/player.mdl");
	modelindex_player = self.modelindex;

	setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
	
	self.view_ofs = '0 0 22';

	// Mod - Xian (May.20.97)
	// Bug where player would have velocity from their last kill
	self.velocity = '0 0 0';

	player_stand1 ();
	
	makevectors(self.angles);
	spawn_tfog (self.origin + v_forward*20);
	spawn_tdeath (self.origin, self);

	//Tei clean the zone from foes before the player spawn
	ClearLandingZone(self.origin,300);	

	if(self.book_level>0){
		self.book_level = 0;
		centerprint(self, "Your magic book level restart to zero");
	}

	GLOBAL_MISSION_STAGE = GLOBAL_MISSION_STAGE | self.mission_stage;
};


/*
=============================================================================

				QUAKED FUNCTIONS

=============================================================================
*/


/*QUAKED info_player_start (1 0 0) (-16 -16 -24) (16 16 24)
The normal starting point for a level.
*/
void() info_player_start =
{
};


/*QUAKED info_player_start2 (1 0 0) (-16 -16 -24) (16 16 24)
Only used on start map for the return point from an episode.
*/
void() info_player_start2 =
{
};

/*QUAKED info_player_deathmatch (1 0 1) (-16 -16 -24) (16 16 24)
potential spawning position for deathmatch games
*/
void() info_player_deathmatch =
{
};

/*QUAKED info_player_coop (1 0 1) (-16 -16 -24) (16 16 24)
potential spawning position for coop games
*/
void() info_player_coop =
{
	ClearLandingZone(self.origin,300);
};

/*
===============================================================================

RULES

===============================================================================
*/

/*
go to the next level for deathmatch
*/
void() NextLevel =
{
	local entity o;
	local string newmap;

	if (nextmap != "")
		return; // already done

	if (mapname == "start")
	{
		if (!cvar("registered"))
		{
			mapname = "e1m1";
		}
		else if (!(serverflags & 1))
		{
			mapname = "e1m1";
			serverflags = serverflags | 1;
		}
		else if (!(serverflags & 2))
		{
			mapname = "e2m1";
			serverflags = serverflags | 2;
		}
		else if (!(serverflags & 4))
		{
			mapname = "e3m1";
			serverflags = serverflags | 4;
		}
		else if (!(serverflags & 8))
		{
			mapname = "e4m1";
			serverflags = serverflags - 7;
		}
 
		o = spawn();
		o.map = mapname;
	}
	else
	{
		// find a trigger changelevel
		o = find(world, classname, "trigger_changelevel");
		if (!o || mapname == "start")
		{       // go back to same map if no trigger_changelevel
			o = spawn();
			o.map = mapname;
		}
	}


	nextmap = o.map;

	if (o.nextthink < time)
	{
		o.think = execute_changelevel;
		o.nextthink = time + 0.1;
	}
};

/*
============
CheckRules

Exit deathmatch games upon conditions
============
*/
void() CheckRules =
{       
	if (deathmatch && timelimit && time >= timelimit)
		NextLevel ();
	
	if (deathmatch && fraglimit && self.frags >= fraglimit)
		NextLevel ();
};

//============================================================================

void() PlayerDeathThink =
{
	local entity    old_self;
	local float             forward;

	if ((self.flags & FL_ONGROUND))
	{
		forward = vlen (self.velocity);
		forward = forward - 20;
		if (forward <= 0)
			self.velocity = '0 0 0';
		else    
			self.velocity = forward * normalize(self.velocity);
	}

// wait for all buttons released
	if (self.deadflag == DEAD_DEAD)
	{
		if (self.button2 || self.button1 || self.button0)
			return;
		self.deadflag = DEAD_RESPAWNABLE;
		return;
	}

// wait for any button down
	if (!self.button2 && !self.button1 && !self.button0)
		return;

	self.button0 = 0;
	self.button1 = 0;
	self.button2 = 0;
	respawn();
};




void() PlayerJump =
{
	local vector start, end;

	if (self.flags & FL_WATERJUMP)
		return;
	
	if (self.waterlevel >= 2){
		// play swiming sound
		if (self.swim_flag < time){
			self.swim_flag = time + 1;
			if (random() < 0.5)
				sound (self, CHAN_BODY, "misc/water1.wav", 1, ATTN_NORM);
			else
				sound (self, CHAN_BODY, "misc/water2.wav", 1, ATTN_NORM);
		}

		return;
	}

	/*
	dprint("boots_ammo=");
	dprint(ftos(self.boots_ammo));
	dprint("\n");*/

	//No esta en el suelo
	if (!(self.flags & FL_ONGROUND)){
		if (!(self.flags & FL_JUMPRELEASED)) {
			return;
		}				
		
		self.button2 = 0;			
		self.boots_onground = FALSE;
		self.flags = (self.flags - (self.flags & FL_JUMPRELEASED));
		self.flags = (self.flags - (self.flags & FL_ONGROUND));		
		
		if(self.boots_ammo<5){
			//dprint("2222222222\n");
			sound (self, CHAN_BODY, "player/plyrjmp8.wav", 1, ATTN_NORM);
			//self.velocity_z = (self.velocity_z + 270);
			self.velocity_z = (self.velocity_z + 380);
		}

		self.boots_ammo = 5;
	} else {

		if(self.boots_onground || self.boots_ammo >=1) {
			if (!(self.flags & FL_JUMPRELEASED)){
				return;
			}

			self.flags = (self.flags - (self.flags & FL_JUMPRELEASED));
			self.button2 = 0;
									
			if(self.boots_ammo<=4){
				//dprint("11111111111111\n");
				sound (self, CHAN_BODY, "player/plyrjmp8.wav", 1, ATTN_NORM);			
				//self.punchangle_x = 0;			
				if ((self.velocity_z > 360))				{
					self.velocity_z = (self.velocity_z + 360);
				} else {
					self.velocity_z = 360;
				}
			}

			if (self.boots_onground){
				self.boots_ammo = 5;
			}
			self.boots_onground = FALSE;
			self.boots_ammo = self.boots_ammo - 1;
		}else{

		}

	}	
	
	/*
	if ( !(self.flags & FL_JUMPRELEASED) ){
		dprint("no pogo stick!\n");
		return;         // don't pogo stick
	}

	dprint("...\n");

	//Tei: dbljump!
	if (!(self.flags & FL_ONGROUND)){
		dprint("dbljump!\n");
		self.velocity_z = (self.velocity_z + 360);
	}

	//

	//Quitar flag 
	self.flags = self.flags - (self.flags & FL_JUMPRELEASED);       
	self.button2 = 0;

	// player jumping sound
	sound (self, CHAN_BODY, "player/plyrjmp8.wav", 1, ATTN_NORM);
	*/
};


/*
===========
WaterMove

============
*/
.float  dmgtime;

void() WaterMove =
{
//dprint (ftos(self.waterlevel));
	if (self.movetype == MOVETYPE_NOCLIP)
		return;
	if (self.health < 0)
		return;

	if (self.waterlevel != 3)
	{
		if (self.air_finished < time)
			sound (self, CHAN_VOICE, "player/gasp2.wav", 1, ATTN_NORM);
		else if (self.air_finished < time + 9)
			sound (self, CHAN_VOICE, "player/gasp1.wav", 1, ATTN_NORM);
		self.air_finished = time + 12;
		self.dmg = 2;
	}
	else if (self.air_finished < time)
	{       // drown!
		if (self.pain_finished < time)
		{
			self.dmg = self.dmg + 2;
			if (self.dmg > 15)
				self.dmg = 10;
			T_Damage (self, world, world, self.dmg);
			self.pain_finished = time + 1;
		}
	}
	
	if (!self.waterlevel)
	{
		if (self.flags & FL_INWATER)
		{       
			// play leave water sound
			sound (self, CHAN_BODY, "misc/outwater.wav", 1, ATTN_NORM);
			self.flags = self.flags - FL_INWATER;
		}
		return;
	}

	if (self.watertype == CONTENT_LAVA)
	{       // do damage
		if (self.dmgtime < time)
		{
			if (self.radsuit_finished > time)
				self.dmgtime = time + 1;
			else
				self.dmgtime = time + 0.2;

			T_Damage (self, world, world, 10*self.waterlevel);
		}
	}
	else if (self.watertype == CONTENT_SLIME)
	{       // do damage
		if (self.dmgtime < time && self.radsuit_finished < time)
		{
			self.dmgtime = time + 1;
			T_Damage (self, world, world, 4*self.waterlevel);
		}
	}
	
	if ( !(self.flags & FL_INWATER) )
	{       

// player enter water sound

		if (self.watertype == CONTENT_LAVA)
			sound (self, CHAN_BODY, "player/inlava.wav", 1, ATTN_NORM);
		if (self.watertype == CONTENT_WATER)
			sound (self, CHAN_BODY, "player/inh2o.wav", 1, ATTN_NORM);
		if (self.watertype == CONTENT_SLIME)
			sound (self, CHAN_BODY, "player/slimbrn2.wav", 1, ATTN_NORM);

		self.flags = self.flags + FL_INWATER;
		self.dmgtime = 0;
	}       
};

void() CheckWaterJump =
{
	local vector start, end;

// check for a jump-out-of-water
	makevectors (self.angles);
	start = self.origin;
	start_z = start_z + 8; 
	v_forward_z = 0;
	normalize(v_forward);
	end = start + v_forward*24;
	traceline (start, end, TRUE, self);
	if (trace_fraction < 1)
	{       // solid at waist
		start_z = start_z + self.maxs_z - 8;
		end = start + v_forward*24;
		self.movedir = trace_plane_normal * -50;
		traceline (start, end, TRUE, self);
		if (trace_fraction == 1)
		{       // open at eye level
			self.flags = self.flags | FL_WATERJUMP;
			self.velocity_z = 225;
			self.flags = self.flags - (self.flags & FL_JUMPRELEASED);
			self.teleport_time = time + 2;  // safety net
			return;
		}
	}
};

/*
================
PlayerPreThink

Called every frame before physics are run
================
*/
void() PlayerPreThink =
{
	local   float   mspeed, aspeed;
	local   float   r;

	if (intermission_running){
		IntermissionThink ();   // otherwise a button could be missed between
		return;     // the think tics
	}

	if (self.view_ofs == '0 0 0')
		return;         // intermission or finale

	makevectors (self.v_angle);             // is this still used?

	//Clear deathtype in the prethink. will be set for something if we die
    self.deathtype = "";

	CheckRules ();
	WaterMove ();

	if (self.deadflag >= DEAD_DEAD){
		PlayerDeathThink ();
		return;
	}
	
	if (self.deadflag == DEAD_DYING){
		return; // dying, so do nothing
	}

	if (self.button2){
		PlayerJump ();
	}else{
		self.flags = self.flags | FL_JUMPRELEASED;
	}

	// teleporters can force a non-moving pause time        
	if (time < self.pausetime){
		self.velocity = '0 0 0';
	}

	// Tei Autokick	
	if(!PlayerHasShield(self)){
		if(time > self.attack_finished){
			vector source = self.origin + '0 0 16';
			traceline (source, source + v_forward*84, FALSE, self);

			//Theres somethign to hit and is not another player (No friendly damage in coop!)
			if (trace_fraction != 1.0 && trace_ent.takedamage && trace_ent.classname != "player"){
				self.weapon = IT_AXE;
				self.currentammo = 0;
				self.weaponmodel = "progs/v_axe.mdl";	
				RandomAxeAttack ();
			}else{
				self.weapon = IT_SHOTGUN;
			}
		}
	}
	// /Tei Autokick
	
	if (self.flags & FL_ONGROUND){
		self.boots_onground = TRUE;
	}

	//Shield visible when having it
	if(self.armorvalue>0){
		self.effects = self.effects | EF_BLUE;
	}else{
		if(self.effects & EF_BLUE){
			self.effects = self.effects - EF_BLUE;
		}
	}


	float len;

	if(self.talkingtome ){
		len = vlen(self.origin - self.talkingtome.origin);

		if(len>50){
			self.talkingtome = 0;
			centerprint(self,"");//clear message
		}
	}

};
	
/*
================
CheckPowerups

Check for turning off powerups
================
*/
void() CheckPowerups =
{
	if (self.health <= 0)
		return;

	// invisibility
	if (self.invisible_finished)
	{
		// sound and screen flash when items starts to run out
		if (self.invisible_sound < time)
		{
			sound (self, CHAN_AUTO, "items/inv3.wav", 0.5, ATTN_IDLE);
			self.invisible_sound = time + ((random() * 3) + 1);
		}


		if (self.invisible_finished < time + 3)
		{
			if (self.invisible_time == 1)
			{
				sprint (self, PRINT_MEDIUM, "Ring of Shadows magic is fading\n");
				stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, "items/inv2.wav", 1, ATTN_NORM);
				self.invisible_time = time + 1;
			}
			
			if (self.invisible_time < time)
			{
				self.invisible_time = time + 1;
				stuffcmd (self, "bf\n");
			}
		}

		if (self.invisible_finished < time) {       // just stopped
			self.items = self.items - IT_INVISIBILITY;
			self.invisible_finished = 0;
			self.invisible_time = 0;
		}
		
		// use the eyes
		self.frame = 0;
		self.modelindex = modelindex_eyes;
	}
	else
		self.modelindex = modelindex_player;    // don't use eyes

	// invincibility
	if (self.invincible_finished)
	{
		// sound and screen flash when items starts to run out
		if (self.invincible_finished < time + 3)
		{
			if (self.invincible_time == 1)
			{
				sprint (self, PRINT_MEDIUM, "Protection is almost burned out\n");
				stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, "items/protect2.wav", 1, ATTN_NORM);
				self.invincible_time = time + 1;
			}
			
			if (self.invincible_time < time)
			{
				self.invincible_time = time + 1;
				stuffcmd (self, "bf\n");
			}
		}
		
		if (self.invincible_finished < time)
		{       // just stopped
			self.items = self.items - IT_INVULNERABILITY;
			self.invincible_time = 0;
			self.invincible_finished = 0;
		}
		if (self.invincible_finished > time)
		{
			self.effects = self.effects | EF_DIMLIGHT;
			if (deathmatch || coop)	// Tonik
				self.effects = self.effects | EF_RED;
		}
		else
		{
			self.effects = self.effects - (self.effects & EF_DIMLIGHT);
			self.effects = self.effects - (self.effects & EF_RED);
		}
	}

	// super damage
	if (self.super_damage_finished)
	{

// sound and screen flash when items starts to run out

		if (self.super_damage_finished < time + 3)
		{
			if (self.super_time == 1)
			{
				if (deathmatch == 4)
					sprint (self, PRINT_MEDIUM, "OctaPower is wearing off\n");
				else
					sprint (self, PRINT_MEDIUM, "Quad Damage is wearing off\n");
				stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, "items/damage2.wav", 1, ATTN_NORM);
				self.super_time = time + 1;
			}         
			
			if (self.super_time < time)
			{
				self.super_time = time + 1;
				stuffcmd (self, "bf\n");
			}
		}

		if (self.super_damage_finished < time)
		{       // just stopped
			self.items = self.items - IT_QUAD;
			if (deathmatch == 4)
			{
				self.ammo_cells = 255;
				self.armorvalue = 1;
				self.armortype = 0.8;
				self.health = 100;
			}
			self.super_damage_finished = 0;
			self.super_time = 0;
		}
		if (self.super_damage_finished > time)
		{
			self.effects = self.effects | EF_DIMLIGHT;
			if (deathmatch || coop)	// Tonik
				self.effects = self.effects | EF_BLUE;
		}
		else
		{
			self.effects = self.effects - (self.effects & EF_DIMLIGHT);
			self.effects = self.effects - (self.effects & EF_BLUE);
		}
	}       

// suit 
	if (self.radsuit_finished){
		self.air_finished = time + 12;          // don't drown

		// sound and screen flash when items starts to run out
		if (self.radsuit_finished < time + 3){
			if (self.rad_time == 1)
			{
				sprint (self, PRINT_MEDIUM, "Air supply in Biosuit expiring\n");
				stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, "items/suit2.wav", 1, ATTN_NORM);
				self.rad_time = time + 1;
			}
			
			if (self.rad_time < time)
			{
				self.rad_time = time + 1;
				stuffcmd (self, "bf\n");
			}
		}

		if (self.radsuit_finished < time)
		{       // just stopped
			self.items = self.items - IT_SUIT;
			self.rad_time = 0;
			self.radsuit_finished = 0;
		}
	}       

};


/*
================
PlayerPostThink

Called every frame after physics are run
================
*/


//float last_wf = 0;
void() PlayerPostThink =
{
	local   float   mspeed, aspeed;
	local   float   r;
	local string s;

	if (intermission_running)
		return;

	if (self.deadflag)
		return;

	//centerprint(self, "hip");

	// check to see if player landed and play landing sound 
	if ((self.jump_flag < -300) && (self.flags & FL_ONGROUND) ){
		if (self.watertype == CONTENT_WATER)
			sound (self, CHAN_BODY, "player/h2ojump.wav", 1, ATTN_NORM);
		else if (self.jump_flag < -650){
			self.deathtype = "falling";
			T_Damage (self, world, world, 1); //Tei: it was 5 			
			sound (self, CHAN_VOICE, "player/land2.wav", 1, ATTN_NORM);
		}else{
			sound (self, CHAN_VOICE, "player/land.wav", 1, ATTN_NORM);
		}
	}    

	self.jump_flag = self.velocity_z;

	CheckPowerups ();
	W_WeaponFrame ();


		//Shield visible when having it
		if(self.armorvalue>0){
			self.effects = self.effects | EF_BLUE;
		}else{
			if(self.effects & EF_BLUE){
				self.effects = self.effects - EF_BLUE;
			}
		}
};


/*
===========
ClientConnect

called when a player connects to a server
============
*/
void() ClientConnect =
{
	local string entering;
	entering = infokey(world, "coop_enter_msg");

	// old fashion style, lets do it custom
	//	bprint (PRINT_MEDIUM, self.netname);
	//	bprint (PRINT_MEDIUM, " entered the realm\n");
	bprint (PRINT_MEDIUM, self.netname);
	bprint (PRINT_MEDIUM, " ");
	bprint (PRINT_MEDIUM, entering);
	bprint (PRINT_MEDIUM, "\n");

	// test
	local string the_map;
	the_map = infokey(world, "map");

	/*
	dprint("The map:");
	dprint(the_map);
	dprint("\n");*/

	stuffcmd(self, "team coop\n");

	//retriving info
    //    self.autorecord = parm10;

	// autorecording
	/*
	if(self.autorecord == 1) {
        stuffcmd(self, "record ");
		stuffcmd(self, self.netname);
		stuffcmd(self, " _");
		stuffcmd(self, the_map);
		stuffcmd(self, "_coop\n");
	}*/

    AliasCommands ();
	//stuffcmd(self, "on_coop\n");
	//stuffcmd(self, "on_enter\n");

	stuffcmd(self, "showmapname\n");

	// a client connecting during an intermission can cause problems
	if (intermission_running)
		GotoNextMap ();

	//self.mapshowtime = time + 3;//Tei: show map for 3 seconds
	//dprint("Spawn in.. \n");
};


/*
===========
ClientDisconnect

called when a player disconnects from a server
============
*/
void() ClientDisconnect =
{
	local string leaving;
	local string tmp;
	local float reset_server;

	reset_server = stof(infokey(world, "coop_reset_empty_server"));
	leaving = infokey(world, "coop_leave_msg");

	// let everyone else know
	bprint (PRINT_MEDIUM, self.netname);
	bprint (PRINT_MEDIUM, " ");
	bprint (PRINT_MEDIUM, leaving);
	bprint (PRINT_MEDIUM, "\n");

	tmp = ftos(self.frags);
	bprint (PRINT_MEDIUM, tmp);
	bprint (PRINT_MEDIUM, " frags\n");
	sound (self, CHAN_BODY, "player/tornoff2.wav", 1, ATTN_NONE);
	set_suicide_frame ();
	
	self.classname = "droppedplayer"; // player entities remain even after they disconnect so bodies remain, this will affect GetPlayerCount()

	if (GetPlayerCount() == 0)
	{
		// No one is left on the server
		// if every player leaves lets get rid of their work
		if (reset_server)
		{
			bprint(PRINT_MEDIUM, "Server is resetting\n");
	        serverflags = 0;
			localcmd ("map start\n");
		}
	}
};

/*
===========
ClientObituary

called when a player dies
============
*/

void(entity targ, entity attacker) ClientObituary =
{
	local   float rnum;
	local   string deathstring, deathstring2;
	local   string s;
	local   string  attackerteam, targteam;


	//Tei - If both are monsters, we do not anoy the player with messages
	if( (attacker.flags & FL_MONSTER)&&(targ.flags & FL_MONSTER) ){
		return;
	}


	rnum = random();

	//ZOID 12-13-96: self.team doesn't work in QW.  Use keys
	attackerteam = infokey(attacker, "team");
	targteam = infokey(targ, "team");

	if (targ.classname == "player"){

		if (attacker.classname == "teledeath") {
			bprint (PRINT_MEDIUM,targ.netname);
			bprint (PRINT_MEDIUM," was telefragged by ");
			bprint (PRINT_MEDIUM,attacker.owner.netname);
			bprint (PRINT_MEDIUM,"\n");
			logfrag (attacker.owner, targ);

			stuffcmd(targ, "showdeath \"TELEFRAGGED\"\n" );

			attacker.owner.frags = attacker.owner.frags + 1;
			return;
		}

		if (attacker.classname == "teledeath2") {
			bprint (PRINT_MEDIUM,"Satan's power deflects ");
			bprint (PRINT_MEDIUM,targ.netname);
			bprint (PRINT_MEDIUM,"'s telefrag\n");

			stuffcmd(targ, "showdeath \"TELEFRAGGED\"\n" );

			targ.frags = targ.frags - 1;
			logfrag (targ, targ);
			return;
		}

		// double 666 telefrag (can happen often in deathmatch 4)
		if (attacker.classname == "teledeath3") {
			bprint (PRINT_MEDIUM,targ.netname);
			bprint (PRINT_MEDIUM," was telefragged by ");
			bprint (PRINT_MEDIUM,attacker.owner.netname);
			bprint (PRINT_MEDIUM, "'s Satan's power\n");

			stuffcmd(targ, "showdeath \"TELEFRAGGED\"\n" );

			targ.frags = targ.frags - 1;
			logfrag (targ, targ);
			return;
		}
	

		if (targ.deathtype == "squish") {
			if (teamplay && targteam == attackerteam && attackerteam != "" && targ != attacker)
			{
				logfrag (attacker, attacker);
				attacker.frags = attacker.frags - 1; 
				bprint (PRINT_MEDIUM,attacker.netname);
				bprint (PRINT_MEDIUM," squished a teammate\n");

				stuffcmd(targ, "showdeath \"SQUISHED\"\n" );
				return;
			}	else if (attacker.classname == "player" && attacker != targ){
				bprint (PRINT_MEDIUM, attacker.netname);
				bprint (PRINT_MEDIUM," squishes ");
				bprint (PRINT_MEDIUM,targ.netname);
				bprint (PRINT_MEDIUM,"\n");

				stuffcmd(targ, "showdeath \"SQUISHED\"\n" );

				logfrag (attacker, targ);
				attacker.frags = attacker.frags + 1;
				return;
			}	else {
				logfrag (targ, targ);
				targ.frags = targ.frags - 1;            // killed self
				bprint (PRINT_MEDIUM,targ.netname);
				bprint (PRINT_MEDIUM," was squished\n");

				stuffcmd(targ, "showdeath \"SQUISHED\"\n" );				
				return;
			}
		}

		// killed by a montser?
		if (attacker.flags & FL_MONSTER){

			bprint (PRINT_MEDIUM,targ.netname);

			if (attacker.classname == "monster_army"){
				bprint (PRINT_MEDIUM, " was blown away by a Grunt\n");
				stuffcmd(targ, "showdeath \"BLOWN AWAY\"\n" );
			} else if (attacker.classname == "monster_demon1"){
				bprint (PRINT_MEDIUM, " was owned by a Fiend\n");
				stuffcmd(targ, "showdeath \"OWNED\"\n" );
			} else if (attacker.classname == "monster_dog"){
				bprint (PRINT_MEDIUM, " was mauled to tiny pieces by a Rottweiler\n");
				stuffcmd(targ, "showdeath \"MAULED\"\n" );
			}else  if (attacker.classname == "monster_enforcer"){
				bprint (PRINT_MEDIUM, " was zapped by a Enforcer\n");
				stuffcmd(targ, "showdeath \"ZAPPED\"\n" );
			}else if (attacker.classname == "monster_fish"){
				bprint (PRINT_MEDIUM, " was trying to make friends with Fishes\n");
				stuffcmd(targ, "showdeath \"EATEN\"\n" );
			}else if (attacker.classname == "monster_hell_knight"){
				bprint (PRINT_MEDIUM, " had his head knocked off by a Hell Knight\n");
				stuffcmd(targ, "showdeath \"KNOCKED\"\n" );
			}else if (attacker.classname == "monster_knight"){
				bprint (PRINT_MEDIUM, " was slashed in three pieces by a Knight\n");
				stuffcmd(targ, "showdeath \"SLASHED\"\n" );
			}else if (attacker.classname == "monster_ogre"){
				bprint (PRINT_MEDIUM, " didn't know Ogres are good\n");
				stuffcmd(targ, "showdeath \"KILLED\"\n" );
			}else if (attacker.classname == "monster_oldone"){
				bprint (PRINT_MEDIUM, " became one with [Shub-Niggurath]\n");
				stuffcmd(targ, "showdeath \"TRANSCENDED\"\n" );
			}else if (attacker.classname == "monster_shalrath"){
				bprint (PRINT_MEDIUM, " was exploded by a Vore\n");
				stuffcmd(targ, "showdeath \"EXPLODED\"\n" );
			}else if (attacker.classname == "monster_shambler"){
				bprint (PRINT_MEDIUM, " was brutally smashed by the great Shambler\n");
				stuffcmd(targ, "showdeath \"SMASHED\"\n" );
			}else if (attacker.classname == "monster_tarbaby"){
				bprint (PRINT_MEDIUM, " was slimed by a Slime\n");
				stuffcmd(targ, "showdeath \"SLIMED\"\n" );
			}else if (attacker.classname == "monster_wizard"){
				bprint (PRINT_MEDIUM, " was lead poisoned by a Scrag\n");
				stuffcmd(targ, "showdeath \"POISONED\"\n" );
			}else if (attacker.classname == "monster_zombie"){
				bprint (PRINT_MEDIUM, " eats some dead meat from a Zombie\n");
				stuffcmd(targ, "showdeath \"KILLED\"\n" );
			}else if (attacker.classname == "light"){
				bprint (PRINT_MEDIUM, " fried by laser\n");
				stuffcmd(targ, "showdeath \"LASERED\"\n" );								 
			}else {
				stuffcmd(targ, "showdeath \"MURDERED\"\n" );
			}
			return;
		}

		dprint("Command sent...\n");
		stuffcmd(targ, "showdeath \"YOU DIED\"\n" );

		rnum = targ.watertype;

		if (rnum == -3)
		{
			if (random() < 0.5)
				bprint (PRINT_MEDIUM," sleeps with the fishes\n");
			else
				bprint (PRINT_MEDIUM," sucks it down\n");
			return;
		}
		else if (rnum == -4)
		{
			if (random() < 0.5)
				bprint (PRINT_MEDIUM," gulped a load of slime\n");
			else
				bprint (PRINT_MEDIUM," can't exist on slime alone\n");
			return;
		}
		else if (rnum == -5)
		{
			if (targ.health < -15)
			{
				bprint (PRINT_MEDIUM," burst into flames\n");
				return;
			}
			if (random() < 0.5)
				bprint (PRINT_MEDIUM," turned into hot slag\n");
			else
				bprint (PRINT_MEDIUM," visits the Volcano God\n");
			return;
		}

		if (attacker.classname == "explo_box")
		{
			bprint (PRINT_MEDIUM," blew up\n");
			
			return;
		}
		if (targ.deathtype == "falling")
		{
			bprint (PRINT_MEDIUM," fell to his death\n");
			return;
		}
		if (targ.deathtype == "nail" || targ.deathtype == "supernail")
		{
			bprint (PRINT_MEDIUM," was spiked\n");
			return;
		}
		if (targ.deathtype == "laser")
		{
			bprint (PRINT_MEDIUM," was zapped\n");
			return;
		}
		if (attacker.classname == "fireball")
		{
			bprint (PRINT_MEDIUM," ate a lavaball\n");
			return;
		}
		if (attacker.classname == "trigger_changelevel")
		{
			bprint (PRINT_MEDIUM," tried to leave\n");
			return;
		}

		bprint (PRINT_MEDIUM," died\n");
		
	}
};

