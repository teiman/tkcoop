/*
==============================================================================

SOLDIER / PLAYER

==============================================================================
*/

$cd id1/models/soldier3
$origin 0 -6 24
$base base		
$skin skin

$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8

$frame death1 death2 death3 death4 death5 death6 death7 death8
$frame death9 death10

$frame deathc1 deathc2 deathc3 deathc4 deathc5 deathc6 deathc7 deathc8
$frame deathc9 deathc10 deathc11

$frame load1 load2 load3 load4 load5 load6 load7 load8 load9 load10 load11

$frame pain1 pain2 pain3 pain4 pain5 pain6

$frame painb1 painb2 painb3 painb4 painb5 painb6 painb7 painb8 painb9 painb10
$frame painb11 painb12 painb13 painb14

$frame painc1 painc2 painc3 painc4 painc5 painc6 painc7 painc8 painc9 painc10
$frame painc11 painc12 painc13

$frame run1 run2 run3 run4 run5 run6 run7 run8

$frame shoot1 shoot2 shoot3 shoot4 shoot5 shoot6 shoot7 shoot8 shoot9

$frame prowl_1 prowl_2 prowl_3 prowl_4 prowl_5 prowl_6 prowl_7 prowl_8
$frame prowl_9 prowl_10 prowl_11 prowl_12 prowl_13 prowl_14 prowl_15 prowl_16
$frame prowl_17 prowl_18 prowl_19 prowl_20 prowl_21 prowl_22 prowl_23 prowl_24

/*
==============================================================================
SOLDIER CODE
==============================================================================
*/

void() army_fire;

void()	army_stand1	=[	$stand1,	army_stand2	] {ai_stand();};
void()	army_stand2	=[	$stand2,	army_stand3	] {ai_stand();};
void()	army_stand3	=[	$stand3,	army_stand4	] {ai_stand();};
void()	army_stand4	=[	$stand4,	army_stand5	] {ai_stand();};
void()	army_stand5	=[	$stand5,	army_stand6	] {ai_stand();};
void()	army_stand6	=[	$stand6,	army_stand7	] {ai_stand();};
void()	army_stand7	=[	$stand7,	army_stand8	] {ai_stand();};
void()	army_stand8	=[	$stand8,	army_stand1	] {ai_stand();};

void()	army_load1	=[	$load1,	army_load2	] {ai_stand();};
void()	army_load2	=[	$load2,	army_load3	] {ai_stand();};
void()	army_load3	=[	$load3,	army_load4	] {ai_stand();};
void()	army_load4	=[	$load4,	army_load5	] {ai_stand();};
void()	army_load5	=[	$load5,	army_load6	] {ai_stand();};
void()	army_load6	=[	$load6,	army_load7	] {ai_stand();};
void()	army_load7	=[	$load7,	army_load8	] {ai_stand();};
void()	army_load8	=[	$load8,	army_load9	] {ai_stand();};
void()	army_load9	=[	$load9,	army_load10	] {ai_stand();};
void()	army_load10	=[	$load10,	army_load11	] {ai_stand();};
void()	army_load11	=[	$load11,	army_run1	] {ai_stand();};



void()	army_walk1	=[	$prowl_1,	army_walk2	] {
	if (random() < 0.1)//Tei less noisy 
		sound (self, CHAN_VOICE, "soldier/idle.wav", 1, ATTN_IDLE);

	ai_walk(1);
};
void()	army_walk2	=[	$prowl_2,	army_walk3	] {ai_walk(1);};
void()	army_walk3	=[	$prowl_3,	army_walk4	] {ai_walk(1);};
void()	army_walk4	=[	$prowl_4,	army_walk5	] {ai_walk(1);};
void()	army_walk5	=[	$prowl_5,	army_walk6	] {ai_walk(2);};
void()	army_walk6	=[	$prowl_6,	army_walk7	] {ai_walk(3);};
void()	army_walk7	=[	$prowl_7,	army_walk8	] {ai_walk(4);};
void()	army_walk8	=[	$prowl_8,	army_walk9	] {ai_walk(4);};
void()	army_walk9	=[	$prowl_9,	army_walk10	] {ai_walk(2);};
void()	army_walk10	=[	$prowl_10,	army_walk11	] {ai_walk(2);};
void()	army_walk11	=[	$prowl_11,	army_walk12	] {ai_walk(2);};
void()	army_walk12	=[	$prowl_12,	army_walk13	] {ai_walk(1);};
void()	army_walk13	=[	$prowl_13,	army_walk14	] {ai_walk(0);};
void()	army_walk14	=[	$prowl_14,	army_walk15	] {ai_walk(1);};
void()	army_walk15	=[	$prowl_15,	army_walk16	] {ai_walk(1);};
void()	army_walk16	=[	$prowl_16,	army_walk17	] {ai_walk(1);};
void()	army_walk17	=[	$prowl_17,	army_walk18	] {ai_walk(3);};
void()	army_walk18	=[	$prowl_18,	army_walk19	] {ai_walk(3);};
void()	army_walk19	=[	$prowl_19,	army_walk20	] {ai_walk(3);};
void()	army_walk20	=[	$prowl_20,	army_walk21	] {ai_walk(3);};
void()	army_walk21	=[	$prowl_21,	army_walk22	] {ai_walk(2);};
void()	army_walk22	=[	$prowl_22,	army_walk23	] {ai_walk(1);};
void()	army_walk23	=[	$prowl_23,	army_walk24	] {ai_walk(1);};
void()	army_walk24	=[	$prowl_24,	army_walk1	] {ai_walk(1);};

void()	army_run1	=[	$run1,		army_run2	] {
	if (random() < 0.1)//less noisy
		sound (self, CHAN_VOICE, "soldier/idle.wav", 1, ATTN_IDLE);
	ai_run(11);
};
void()	army_run2	=[	$run2,		army_run3	] {ai_run(15);};
void()	army_run3	=[	$run3,		army_run4	] {ai_run(10);};
void()	army_run4	=[	$run4,		army_run5	] {ai_run(10);};
void()	army_run5	=[	$run5,		army_run6	] {ai_run(8);};
void()	army_run6	=[	$run6,		army_run7	] {ai_run(15);};
void()	army_run7	=[	$run7,		army_run8	] {ai_run(10);};
void()	army_run8	=[	$run8,		army_run1	] {ai_run(8);};

void()	army_atk1	=[	$shoot1,	army_atk2	] {ai_face();};
void()	army_atk2	=[	$shoot2,	army_atk3	] {ai_face();};
void()	army_atk3	=[	$shoot3,	army_atk4	] {ai_face();};
void()	army_atk4	=[	$shoot4,	army_atk5	] {ai_face();};
void()	army_atk5	=[	$shoot5,	army_atk6	] {ai_face();army_fire();muzzleflash();};
void()	army_atk6	=[	$shoot6,	army_atk7	] {ai_face();};
void()	army_atk7	=[	$shoot7,	army_atk8	] {ai_face();SUB_CheckRefire (army_atk1);};
void()	army_atk8	=[	$shoot8,	army_atk9	] {ai_face();};
void()	army_atk9	=[	$shoot9,	army_run1	] {	
	ai_face();
	
	//Tei they will randomly reload
	if(random()<0.2){
		self.think = army_load1;
	}
};


void()	army_pain1	=[	$pain1,		army_pain2	] {};
void()	army_pain2	=[	$pain2,		army_pain3	] {};
void()	army_pain3	=[	$pain3,		army_pain4	] {};
void()	army_pain4	=[	$pain4,		army_pain5	] {};
void()	army_pain5	=[	$pain5,		army_pain6	] {};
void()	army_pain6	=[	$pain6,		army_run1	] {ai_pain(1);};

void()	army_painb1	=[	$painb1,	army_painb2	] {};
void()	army_painb2	=[	$painb2,	army_painb3	] {ai_painforward(13);};
void()	army_painb3	=[	$painb3,	army_painb4	] {ai_painforward(9);};
void()	army_painb4	=[	$painb4,	army_painb5	] {};
void()	army_painb5	=[	$painb5,	army_painb6	] {};
void()	army_painb6	=[	$painb6,	army_painb7	] {};
void()	army_painb7	=[	$painb7,	army_painb8	] {};
void()	army_painb8	=[	$painb8,	army_painb9	] {};
void()	army_painb9	=[	$painb9,	army_painb10] {};
void()	army_painb10=[	$painb10,	army_painb11] {};
void()	army_painb11=[	$painb11,	army_painb12] {};
void()	army_painb12=[	$painb12,	army_painb13] {ai_pain(2);};
void()	army_painb13=[	$painb13,	army_painb14] {};
void()	army_painb14=[	$painb14,	army_run1	] {};

void()	army_painc1	=[	$painc1,	army_painc2	] {};
void()	army_painc2	=[	$painc2,	army_painc3	] {ai_pain(1);};
void()	army_painc3	=[	$painc3,	army_painc4	] {};
void()	army_painc4	=[	$painc4,	army_painc5	] {};
void()	army_painc5	=[	$painc5,	army_painc6	] {ai_painforward(1);};
void()	army_painc6	=[	$painc6,	army_painc7	] {ai_painforward(1);};
void()	army_painc7	=[	$painc7,	army_painc8	] {};
void()	army_painc8	=[	$painc8,	army_painc9	] {ai_pain(1);};
void()	army_painc9	=[	$painc9,	army_painc10] {ai_painforward(4);};
void()	army_painc10=[	$painc10,	army_painc11] {ai_painforward(3);};
void()	army_painc11=[	$painc11,	army_painc12] {ai_painforward(6);};
void()	army_painc12=[	$painc12,	army_painc13] {ai_painforward(8);};
void()	army_painc13=[	$painc13,	army_run1] {};

void(entity attacker, float damage)	army_pain = {
	local float rs;
	
	if (self.pain_finished > time)
		return;

	self.pain_finished = time + 1.1;
	rs = rint((random() * 5) + 1);

	self.noise = "";
	if (rs == 1){
		self.noise = "player/pain1.wav";
		army_pain1 ();
	} else if (rs == 2) {
		self.noise = "player/pain2.wav";
		army_painb1 ();
	} else if (rs == 3) {
		army_painc1 ();
		self.noise = "player/pain3.wav";
	} else if (rs == 4) {
		army_pain1 ();
		self.noise = "player/pain4.wav";
	} else if (rs == 5) {
		army_painb1 ();
		self.noise = "player/pain5.wav";
	} else {
		army_painc1 ();
		self.noise = "player/pain6.wav";
	}

	/*
	dprint("army pain r:");
	dprint(ftos(rs));
	dprint("\n");*/

	sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM);
};


void() army_fire = {
	local	vector	dir;
	local	entity	en;
	
	ai_face();
	
	sound (self, CHAN_WEAPON, "soldier/sattck1.wav", 1, ATTN_NORM);	

	// fire somewhat behind the player, so a dodging player is harder to hit
	en = self.enemy;
	
	dir = en.origin - en.velocity*0.2;
	dir = normalize (dir - self.origin);
	
	FireBullets (4, dir, '0.1 0.1 0');
};



void()	army_die1	=[	$death1,	army_die2	] {
	self.solid = SOLID_NOT;
	ThrowWeapon ("progs/soldier_weapon.mdl", self.health, '-21 -7 -5', '8 0 3');
};
void()	army_die2	=[	$death2,	army_die3	] {};
void()	army_die3	=[	$death3,	army_die4	]
{self.solid = SOLID_NOT;self.ammo_shells = 5;DropBackpack();};
void()	army_die4	=[	$death4,	army_die5	] {};
void()	army_die5	=[	$death5,	army_die6	] {};
void()	army_die6	=[	$death6,	army_die7	] {};
void()	army_die7	=[	$death7,	army_die8	] {};
void()	army_die8	=[	$death8,	army_die9	] {};
void()	army_die9	=[	$death9,	army_die10	] {};
void()	army_die10	=[	$death10,	army_die10	] {};



void()	army_cdie1	=[	$deathc1,	army_cdie2	] {
	self.solid = SOLID_NOT;
	ThrowWeapon ("progs/soldier_weapon.mdl", self.health, '-21 -7 -5', '8 0 3');
};
void()	army_cdie2	=[	$deathc2,	army_cdie3	] {ai_back(5);
	if(random()<0.3){
		ThrowGib ("progs/eye.mdl", self.health);
		ThrowGib ("progs/eye.mdl", self.health);
	}
};
void()	army_cdie3	=[	$deathc3,	army_cdie4	] {
	self.solid = SOLID_NOT;
	self.ammo_shells = 5;
	DropBackpack();
	ai_back(4);
};
void()	army_cdie4	=[	$deathc4,	army_cdie5	] {ai_back(13);};
void()	army_cdie5	=[	$deathc5,	army_cdie6	] {ai_back(3);};
void()	army_cdie6	=[	$deathc6,	army_cdie7	] {ai_back(4);};
void()	army_cdie7	=[	$deathc7,	army_cdie8	] {};
void()	army_cdie8	=[	$deathc8,	army_cdie9	] {};
void()	army_cdie9	=[	$deathc9,	army_cdie10	] {};
void()	army_cdie10	=[	$deathc10,	army_cdie11	] {};
void()	army_cdie11	=[	$deathc11,	army_cdie11	] {};

void(vector location) TempBloodSplat = {
	local entity temp;

	temp = spawn();

	setorigin(temp,location);
	setmodel(temp,"progs/s_explod.spr");

	temp.think = SUB_Remove;
	temp.nextthink = time + 0.3;
};

void()	army_teledie1	=[	$death1,	army_teledie2	] {
	self.solid = SOLID_NOT;
	ThrowWeapon ("progs/soldier_weapon.mdl", self.health*0.5, '-21 -7 -5', '8 0 3');
};
void()	army_teledie2	=[	$death2,	army_teledie2	] {
	self.ammo_shells = 5;
	DropBackpack();
	TempBloodSplat(self.origin);
	sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
	ThrowGib ("progs/gib1.mdl", self.health);
	ThrowGib ("progs/gib2.mdl", self.health);
	ThrowGib ("progs/gib3.mdl", self.health);

	ThrowGib ("progs/eye.mdl", self.health);
	ThrowGib ("progs/eye.mdl", self.health);

	ThrowHead ("progs/h_guard.mdl", self.health);
};


void() army_die = {
	local float rs;

	// check for gib
	if (self.health < -35) {
		self.think = army_teledie1;
		self.nextthink = time + 0.1;	
		return;
	}

	if ( !(other.flags & FL_ONGROUND) ){
		self.movetype = MOVETYPE_TOSS;  
	}		

	rs = rint((random() * 5) + 1);

	self.noise = "";
	if (rs == 1){
		self.noise = "player/pain1.wav";
	} else if (rs == 2) {
		self.noise = "player/pain2.wav";
	} else if (rs == 3) {
		self.noise = "player/pain3.wav";
	} else if (rs == 4) {
		self.noise = "player/pain4.wav";
	} else if (rs == 5) {
		self.noise = "player/pain5.wav";
	} else if (rs == 6){
		self.noise = "player/pain6.wav";
	}else {
		self.noise = "soldier/death1.wav";
	}	

	// regular death
	sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM);

	if (random() < 0.5)
		army_die1 ();
	else
		army_cdie1 ();
};



void() monster_army_start = {
	self.classname = "monster_army";

	self.skin = rint(random()*5);//Tei, experiment

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/soldier.mdl");
	setsize (self, '-16 -16 -24', '16 16 40');
	self.health = MultiplyHealth(30);

	self.th_stand = army_stand1;
	self.th_walk = army_walk1;
	self.th_run = army_run1;
	self.th_missile = army_atk1;
	self.th_pain = army_pain;
	self.th_die = army_die;

	//self.alpha = 0.5;
	self.effects = self.effects | EF_BOSS;		
    

	walkmonster_start ();
};


/*QUAKED monster_army (1 0 0) (-16 -16 -24) (16 16 40) Ambush
*/
void() monster_army = {		
	monster_army_precache(); //unnecesary, always called 
	monster_army_start();
};
