/*
*/
void (entity targ, entity inflictor, entity attacker, float damage) T_Damage;
void () player_run;
void(entity bomb, entity attacker, float rad, entity ignore, string dtype) T_RadiusDamage;

void() SuperDamageSound;
void() W_FireLaser;
entity (vector org, vector vec) LaunchLaser;
void() player_axe1_super;
void() player_drink1;

float() crandom = {
	return 2*(random() - 0.5);
};

/*
================
W_FireAxe
================
*/
void() W_FireAxe =
{
	local   vector  source;
	local   vector  org;

	makevectors (self.v_angle);
	source = self.origin + '0 0 16';
	traceline (source, source + v_forward*84, FALSE, self);

	if (trace_fraction == 1.0){
		return;
	}
	
	org = trace_endpos - v_forward*4;

	if (trace_ent.takedamage && trace_ent.classname != "monster_knight") {
		trace_ent.axhitme = 1;
		BLOOD (org, 20);
		T_Damage (trace_ent, self, self, 120);
	} else {       // hit wall
		sound (self, CHAN_WEAPON, "player/axhit2.wav", 1, ATTN_NORM);
		GUNSHOT(org,5);
	}
};


//============================================================================


vector() wall_velocity = {
	local vector    vel;
	
	vel = normalize (self.velocity);
	vel = normalize(vel + v_up*(random()- 0.5) + v_right*(random()- 0.5));
	vel = vel + 2*trace_plane_normal;
	vel = vel * 200;
	
	return vel;
};


/*
================
SpawnMeatSpray
================
*/
void(vector org, vector vel) SpawnMeatSpray = {
	local   entity missile;
	/*local   vector  org; FIXME: another wtf */

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_NOT;

	makevectors (self.angles);

	missile.velocity = vel;
	missile.velocity_z = missile.velocity_z + 150 + 50*random();

	missile.avelocity = '600 500 500';
	
// set missile duration
	missile.nextthink = time + 1;
	missile.think = SUB_Remove;

	setmodel (missile, "progs/zom_gib.mdl");
	setsize (missile, '0 0 0', '0 0 0');            
	setorigin (missile, org);
};



/*
================
spawn_touchblood
================
*/
void(float damage) spawn_touchblood = {
	local vector    vel;

	vel = wall_velocity () * 0.2;
	BLOOD (self.origin + vel*0.01, damage);
};

/*
==============================================================================

MULTI-DAMAGE

Collects multiple small damages into a single damage

==============================================================================
*/

entity  multi_ent;
float   multi_damage;

vector  blood_org;
float   blood_count;

vector  puff_org;
float   puff_count;

void() ClearMultiDamage = {
	multi_ent = world;
	multi_damage = 0;
	blood_count = 0;
	puff_count = 0;
};

void() ApplyMultiDamage = {
	if (!multi_ent)
		return;
	T_Damage (multi_ent, self, self, multi_damage);
};

void(entity hit, float damage) AddMultiDamage = {
	if (!hit)
		return;
	
	if (hit != multi_ent)
	{
		ApplyMultiDamage ();
		multi_damage = damage;
		multi_ent = hit;
	}
	else
		multi_damage = multi_damage + damage;
};

void() Multi_Finish = {
	if (puff_count){
		GUNSHOT(puff_org, puff_count);
	}

	if (blood_count) {
		BLOOD(blood_org, blood_count);
	}
};

/*
==============================================================================
BULLETS
==============================================================================
*/

/*
================
TraceAttack
================
*/
void(float damage, vector dir) TraceAttack = {
	local   vector  vel, org;
	
	vel = normalize(dir + v_up*crandom() + v_right*crandom());
	vel = vel + 2*trace_plane_normal;
	vel = vel * 200;

	org = trace_endpos - dir*4;

	if (trace_ent.takedamage)
	{
		blood_count = blood_count + 1;
		blood_org = org;
		AddMultiDamage (trace_ent, damage);
	}
	else
	{
		puff_count = puff_count + 1;
	}
};

/*
================
FireBullets

Used by shotgun, super shotgun, and enemy soldier firing
Go to the trouble of combining multiple pellets into a single damage call.
================
*/
void(float shotcount, vector dir, vector spread) FireBullets = {
	local   vector direction;
	local   vector  src;
	
	makevectors(self.v_angle);

	src = self.origin + v_forward*10;
	src_z = self.absmin_z + self.size_z * 0.7;

	ClearMultiDamage ();

	traceline (src, src + dir*2048, FALSE, self);
	puff_org = trace_endpos - dir*4;

	while (shotcount > 0)
	{
		direction = dir + crandom()*spread_x*v_right + crandom()*spread_y*v_up;
		traceline (src, src + direction*2048, FALSE, self);
		if (trace_fraction != 1.0)
			TraceAttack (4, direction);

		shotcount = shotcount - 1;
	}
	ApplyMultiDamage ();
	Multi_Finish ();
};

/*
================
W_FireShotgun
================
*/
void() W_FireShotgun = {
	local vector dir;

	sound (self, CHAN_WEAPON, "weapons/guncock.wav", 1, ATTN_NORM); 

	msg_entity = self;
	WriteByte (MSG_ONE, SVC_SMALLKICK);
	
	if (deathmatch != 4 )
		self.currentammo = self.ammo_shells = self.ammo_shells - 1;

	dir = aim (self, 100000);
	FireBullets (6, dir, '0.04 0.04 0');
};


/*
================
W_FireSuperShotgun
================
*/
void() W_FireSuperShotgun = {
	local vector dir;
		
	sound (self ,CHAN_WEAPON, "weapons/shotgn2.wav", 1, ATTN_NORM); 

	msg_entity = self;
	BIGKICK();
	
	self.currentammo = self.ammo_shells = self.ammo_shells - 1;
	dir = aim (self, 100000);
	FireBullets (14, dir, '0.14 0.08 0');
};


/*
==============================================================================

ROCKETS

==============================================================================
*/

void() T_MissileTouch = {
	local float     damg;

	if (other == self.owner)
		return;         // don't explode on owner

	if (self.voided) {
		return;
	}

	self.voided = 1;

	if (pointcontents(self.origin) == CONTENT_SKY){
		remove(self);
		return;
	}

	damg = 100 + random()*20;
	
	if (other.health){
		other.deathtype = "rocket";
		T_Damage (other, self, self.owner, damg );
	}

	// don't do radius damage to the other, because all the damage
	// was done in the impact

	T_RadiusDamage (self, self.owner, 120, other, "rocket");

	//  sound (self, CHAN_WEAPON, "weapons/r_exp3.wav", 1, ATTN_NORM);
	self.origin = self.origin - 8 * normalize(self.velocity);

	EXPLOSION(self.origin);	

	remove(self);
};

/*
================
W_FireRocket
================
*/
void() W_FireRocket = {
	sound (self, CHAN_WEAPON, "weapons/sgun1.wav", 1, ATTN_NORM);

	msg_entity = self;
	SMALLKICK();

	newmis = spawn ();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_FLYMISSILE;
	newmis.solid = SOLID_BBOX;
		
	// set newmis speed     
	makevectors (self.v_angle);
	newmis.velocity = aim(self, 1000);
	newmis.velocity = newmis.velocity * 1000;
	newmis.angles = vectoangles(newmis.velocity);
	
	newmis.touch = T_MissileTouch;
	newmis.voided = 0;
	
	// set newmis duration
	newmis.nextthink = time + 5;
	newmis.think = SUB_Remove;
	newmis.classname = "rocket";

	setmodel (newmis, "progs/missile.mdl");
	setsize (newmis, '0 0 0', '0 0 0');             
	setorigin (newmis, self.origin + v_forward*8 + '0 0 16');
};

/*
===============================================================================
LIGHTNING
===============================================================================
*/

void(entity from, float damage) LightningHit = {
	LIGHTNINGBLOOD(trace_endpos);

	T_Damage (trace_ent, from, from, damage);
};

/*
=================
LightningDamage
=================
*/
void(vector p1, vector p2, entity from, float damage) LightningDamage = {
	local entity            e1, e2;
	local vector            f;
	
	f = p2 - p1;
	normalize (f);
	f_x = 0 - f_y;
	f_y = f_x;
	f_z = 0;
	f = f*16;

	e1 = e2 = world;

	traceline (p1, p2, FALSE, self);

	if (trace_ent.takedamage) {
		LightningHit (from, damage);
		if (self.classname == "player")	{
			if (other.classname == "player")
				trace_ent.velocity_z = trace_ent.velocity_z + 400;
		}
	}
	e1 = trace_ent;

	traceline (p1 + f, p2 + f, FALSE, self);
	if (trace_ent != e1 && trace_ent.takedamage) {
		LightningHit (from, damage);
	}
	e2 = trace_ent;

	traceline (p1 - f, p2 - f, FALSE, self);
	if (trace_ent != e1 && trace_ent != e2 && trace_ent.takedamage) {
		LightningHit (from, damage);
	}
};


void() W_FireLightning = {
	local   vector          org;
	local   float           cells;

	// explode if under water
	if (self.waterlevel > 1) {
		if (deathmatch > 3) {
			if (random() <= 0.5) {
				self.deathtype = "selfwater";
				T_Damage (self, self, self.owner, 4000 );
			} else {
				cells = self.ammo_cells;
				self.ammo_cells = 0;
				W_SetCurrentAmmo ("");
				T_RadiusDamage (self, self, 35*cells, world, "");
				return;
			}
		} else {
			cells = self.ammo_cells;
			self.ammo_cells = 0;
			W_SetCurrentAmmo ("");
			T_RadiusDamage (self, self, 35*cells, world,"");
			return;
		}
	}

	if (self.t_width < time) {
		sound (self, CHAN_WEAPON, "weapons/lhit.wav", 1, ATTN_NORM);
		self.t_width = time + 0.6;
	}
	msg_entity = self;
	SMALLKICK();

	org = self.origin + '0 0 16';
	
	traceline (org, org + v_forward*600, TRUE, self);
	LIGHTNING2(org, trace_endpos);

	LightningDamage (self.origin, trace_endpos + v_forward*4, self, 30);
};


//=============================================================================


void() GrenadeExplode = {
	if (self.voided) {
		return;
	}
	self.voided = 1;

	T_RadiusDamage (self, self.owner, 120, world, "grenade");

	EXPLOSION(self.origin);
	remove (self);
};

void() GrenadeTouch = {
	if (other == self.owner)
		return;         // don't explode on owner

	if (other.takedamage == DAMAGE_AIM) {
		GrenadeExplode();
		return;
	}

	sound (self, CHAN_WEAPON, "weapons/bounce.wav", 1, ATTN_NORM);  // bounce sound

	//Stop rotating when is on the ground 
	if (self.velocity == '0 0 0')
		self.avelocity = '0 0 0';
};

/*
================
W_FireGrenade
================
*/
void() W_FireGrenade = {       	
	sound (self, CHAN_WEAPON, "weapons/grenade.wav", 1, ATTN_NORM);

	msg_entity = self;
	WriteByte (MSG_ONE, SVC_SMALLKICK);

	newmis = spawn ();
	newmis.voided=0;
	newmis.owner = self;
	newmis.movetype = MOVETYPE_BOUNCE;
	newmis.solid = SOLID_BBOX;
	newmis.classname = "grenade";
		
	// set newmis speed     
	makevectors (self.v_angle);

	if (self.v_angle_x){
		newmis.velocity = v_forward*600 + v_up * 200 + crandom()*v_right*10 + crandom()*v_up*10;
	} else {
		newmis.velocity = aim(self, 10000);
		newmis.velocity = newmis.velocity * 600;
		newmis.velocity_z = 200;
	}

	newmis.avelocity = '300 300 300';

	newmis.angles = vectoangles(newmis.velocity);
	
	newmis.touch = GrenadeTouch;

	newmis.nextthink = time + 2.5;

	newmis.think = GrenadeExplode;

	setmodel (newmis, "progs/grenade.mdl");
	setsize (newmis, '0 0 0', '0 0 0');             
	setorigin (newmis, self.origin);
};


//=============================================================================

void() spike_touch;
void() superspike_touch;


/*
===============
launch_spike

Used for both the player and the ogre
===============
*/
void(vector org, vector dir) launch_spike = {
	newmis = spawn ();
	newmis.voided=0;
	newmis.owner = self;
	newmis.movetype = MOVETYPE_FLYMISSILE;
	newmis.solid = SOLID_BBOX;

	newmis.angles = vectoangles(dir);
	
	newmis.touch = spike_touch;
	newmis.classname = "spike";
	newmis.think = SUB_Remove;
	newmis.nextthink = time + 6;
	setmodel (newmis, "progs/spike.mdl");
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);               
	setorigin (newmis, org);

	newmis.velocity = dir * 1000;
};

void() W_FireSuperSpikes = {
	local vector    dir;
	local entity    old;
	
	sound (self, CHAN_WEAPON, "weapons/spike2.wav", 1, ATTN_NORM);
	self.attack_finished = time + 0.2;

	dir = aim (self, 1000);
	launch_spike (self.origin + '0 0 16', dir);
	newmis.touch = superspike_touch;
	setmodel (newmis, "progs/s_spike.mdl");
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);               
	msg_entity = self;
	
	SMALLKICK();
};

void(float ox) W_FireSpikes = {
	local vector    dir;
	local entity    old;
	
	makevectors (self.v_angle);	
	W_FireSuperSpikes ();
	
	sound (self, CHAN_WEAPON, "weapons/rocket1i.wav", 1, ATTN_NORM);
	self.attack_finished = time + 0.2;

	dir = aim (self, 1000);
	launch_spike (self.origin + '0 0 16' + v_right*ox, dir);

	msg_entity = self;

	SMALLKICK();
};


.float hit_z;

void() spike_touch = {
	local float rand;
	if (other == self.owner)
		return;

	if (self.voided) {
		return;
	}

	self.voided = 1;

	if (other.solid == SOLID_TRIGGER)
		return; // trigger field, do nothing

	if (pointcontents(self.origin) == CONTENT_SKY) {
		remove(self);
		return;
	}
	
	// hit something that bleeds
	if (other.takedamage) {
		spawn_touchblood (9);
		other.deathtype = "nail";
		T_Damage (other, self, self.owner, 9);
	} else	{

		if (self.classname == "wizspike"){
			WIZSPIKE(self.origin);
		}else if(self.classname == ""){
			KNIGHTSPIKE(self.origin);
		}else {
			SPIKE(self.origin);
		}
	}

	remove(self);
};

void() superspike_touch = {
	local float rand;
	if (other == self.owner)
		return;

	if (self.voided) {
		return;
	}

	self.voided = 1;

	if (other.solid == SOLID_TRIGGER){
		return; // trigger field, do nothing
	}

	if (pointcontents(self.origin) == CONTENT_SKY) {
		remove(self);
		return;
	}
	
	// hit something that bleeds
	if (other.takedamage){
		spawn_touchblood (18);
		other.deathtype = "supernail";
		T_Damage (other, self, self.owner, 18);
	} else {
		SUPERSPIKE(self.origin);
	}

	remove(self);
};


/*
===============================================================================

PLAYER WEAPON USE

===============================================================================
*/

void(string from) W_SetCurrentAmmo = {
	player_run ();          // get out of any weapon firing states

	self.items = self.items - ( self.items & (IT_SHELLS | IT_NAILS | IT_ROCKETS | IT_CELLS) );
	
	//dprint("[");
	//dprint(from);
	//dprint("]");
	
	if (self.weapon == IT_AXE) {
		self.currentammo = 0;
		self.weaponmodel = "progs/v_axe.mdl";
		self.weaponframe = 0;
		//dprint("[W_SetCurrentAmmo] AXE Reseting weaponframe\n");
	} else if (self.weapon == IT_SHOTGUN) {
		//Now with infinite ammo
		self.currentammo = 0;
		self.weaponmodel = "progs/v_nail2.mdl";
		self.weaponframe = 0;

		//dprint("[W_SetCurrentAmmo] SGG Reseting weaponframe\n");
	} else if(self.weapon == IT_EXTRA_WEAPON){
		self.weapon = IT_EXTRA_WEAPON;
		self.currentammo = 0;
		self.weaponmodel = "progs/v_drink.mdl";	
	} else	{
		self.currentammo = 0;
		self.weaponmodel = "";
		self.weaponframe = 0;

		//dprint("[W_SetCurrentAmmo] GENERIC Reseting weaponframe\n");
	}
};

float() W_BestWeapon = {
	local   float   it;	
	return self.weapon;
};

float() W_CheckNoAmmo = {	
	return TRUE;
};

/*
============
W_Attack

An attack impulse can be triggered now
============
*/
void()  player_axe1;
void()  player_axeb1;
void()  player_axec1;
void()  player_axed1;
void()  player_shot1;
void()  player_nail1;
void()  player_light1;
void()  player_rocket1;


void() RandomAxeAttack = {
	local float r;

	self.attack_finished = time + 0.5;
	//sound (self, CHAN_WEAPON, "weapons/ax1.wav", 1, ATTN_NORM);	
	sound (self, 0, "weapons/ax1.wav", 1, ATTN_NORM);//set to play in autchannel because otherwise can be eat up by other stuff
	r = random();
	if (r < 0.25)
		player_axe1 ();
	else if (r<0.5)
		player_axeb1 ();
	else if (r<0.75)
		player_axec1 ();
	else
		player_axed1 ();
};


void() W_Attack = {
	local   float   r;

	makevectors(self.v_angle);  

	//TODO: invisibility? 
	self.show_hostile = time + 1;   // wake monsters up

	if (self.weapon == IT_AXE) {
		RandomAxeAttack();
	} else if (self.weapon == IT_SHOTGUN) {
		//Until we fire, we leave the last vmodel alone, whatever it is
		// but when we fire, is the vnail2
		self.weaponmodel = "progs/v_nail2.mdl";	
	
		player_shot1 ();
		self.attack_finished = time + 0.1;
		W_FireLaser ();
	}
};

/*
============
W_ChangeWeapon

============
*/
void() W_ChangeWeapon = {
	local   float   it, am, fl;
	
	it = self.items;
	am = 0;
	
	if (self.impulse == 1){
		fl = IT_AXE;
	} else if (self.impulse == 2) {
		fl = IT_SHOTGUN;
	} else if (self.impulse == 3) {
		fl = IT_SUPER_SHOTGUN;
	} else if (self.impulse == 4) {
		fl = IT_NAILGUN;
	} else if (self.impulse == 5) {
		fl = IT_SUPER_NAILGUN;
	} else if (self.impulse == 6) {
		fl = IT_GRENADE_LAUNCHER;
	} else if (self.impulse == 7) {
		fl = IT_ROCKET_LAUNCHER;
	} else if (self.impulse == 8) {
		fl = IT_LIGHTNING;
	}

	self.impulse = 0;

	//
	// set weapon, set ammo
	//
	self.weapon = fl;               
	W_SetCurrentAmmo ("W_ChangeWeapon");
};

/*
============
CheatCommand
============
*/
void() CheatCommand = {
	if (deathmatch || coop)
		return;

	self.ammo_rockets = 100;
	self.ammo_nails = 200;
	self.ammo_shells = 100;
	self.items = self.items | 
		IT_AXE |
		IT_SHOTGUN |
		IT_SUPER_SHOTGUN |
		IT_NAILGUN |
		IT_SUPER_NAILGUN |
		IT_GRENADE_LAUNCHER |
		IT_ROCKET_LAUNCHER |
		IT_KEY1 | IT_KEY2;

	self.ammo_cells = 200;
	self.items = self.items | IT_LIGHTNING;

	self.weapon = IT_ROCKET_LAUNCHER;
	self.impulse = 0;
	W_SetCurrentAmmo ("CheatCommand");
};

/*
============
CycleWeaponCommand

Go to the next weapon with ammo
============
*/
void() CycleWeaponCommand = {
	//obsoleto
};


/*
============
CycleWeaponReverseCommand

Go to the prev weapon with ammo
============
*/
void() CycleWeaponReverseCommand = {
	//obsoleto
};


/*
============
ServerflagsCommand

Just for development
============
*/
void() ServerflagsCommand = {
	serverflags = serverflags * 2 + 1;
};


/*
============
ImpulseCommands

============
*/
void() AutoRecord;
void() NewGame;
void() CommandsList;
void() SkillUp;
void() SkillDown;
void() PlantUSAFlag;

void() hello_world = {
	dprint("Hello world\n");
};


void() ImpulseCommands = {	
	if (self.impulse >= 1 && self.impulse <= 8)
		W_ChangeWeapon ();

	if (self.impulse == 9){
		//__variant p;
		/*
		local void() p;
		p = find_function("hello","_","world");
		p();*/

		//(find_function("hello","_","world"))();

		//IT_EXTRA_WEAPON
		self.weapon = IT_EXTRA_WEAPON;
		self.currentammo = 0;
		self.weaponmodel = "progs/v_drink.mdl";	

		player_drink1();

		//find_function("hello","_","world")();

		//CheatCommand ();
	}
	if (self.impulse == 10)
		CycleWeaponCommand ();
	if (self.impulse == 11)
		ServerflagsCommand ();
	if (self.impulse == 12)
		CycleWeaponReverseCommand ();

	//if (self.impulse == 15)
	//	PlayerSuperAttack();
	
	if (self.impulse == 15){
		PlantUSAFlag();
		//CCamShieldToggle ();
	}

	if (self.impulse == 22)
		AutoRecord();
    if (self.impulse == 23)
		NewGame();
	if (self.impulse == 24)
		CommandsList();
	if (self.impulse == 25)
		DoAdmin();
	if (self.impulse == 28)
        ShowStatus();
    if (self.impulse == 29)
        ShowScores();
    if (self.impulse == 30)
        ShowNick();
	if (self.impulse == 31)
		YesVote();
	if (self.impulse == 32)
		NoVote();
	if (self.impulse == 33)
		StartElection();
    

	if (self.impulse >= 50)
		AdminImpulseCommand();

	self.impulse = 0;
};

/*
============
W_WeaponFrame

Called every frame so impulse events can be handled as well as possible
============
*/
void() W_WeaponFrame =
{
	if (time < self.attack_finished)
		return;

	ImpulseCommands ();
	
	// check for attack
	if (self.button0) {
		SuperDamageSound ();
		W_Attack ();
	}
};

/*
========
SuperDamageSound

Plays sound if needed
========
*/
void() SuperDamageSound = {
	if (self.super_damage_finished > time) {
		if (self.super_sound < time) {
			self.super_sound = time + 1;
			sound (self, CHAN_BODY, "items/damage3.wav", 1, ATTN_NORM);
		}
	}
	return;
};





