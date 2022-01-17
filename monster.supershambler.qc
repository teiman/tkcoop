/*
==============================================================================

SHAMBLER

==============================================================================
*/



$cd id1/models/shams
$origin 0 0 24
$base base		
$skin base

$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8 stand9
$frame stand10 stand11 stand12 stand13 stand14 stand15 stand16 stand17

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 
$frame walk8 walk9 walk10 walk11 walk12

$frame	run1 run2 run3 run4 run5 run6

$frame smash1 smash2 smash3 smash4 smash5 smash6 smash7 
$frame smash8 smash9 smash10 smash11 smash12

$frame swingr1 swingr2 swingr3 swingr4 swingr5 
$frame swingr6 swingr7 swingr8 swingr9

$frame swingl1 swingl2 swingl3 swingl4 swingl5 
$frame swingl6 swingl7 swingl8 swingl9

$frame magic1 magic2 magic3 magic4 magic5 
$frame magic6 magic7 magic8 magic9 magic10 magic11 magic12

$frame pain1 pain2 pain3 pain4 pain5 pain6

$frame death1 death2 death3 death4 death5 death6 
$frame death7 death8 death9 death10 death11


float() DynamicSpawnHere;

void() SuperShamMissileTouch;
void() SuperShamHome;
void() GarbageCollector;
void(vector org) SightSignBoss;

void(vector org, float left) SpawnZasca;
void() SmallJump;


void() monster_ogre_precache;///will spawn these
void() monster_wizard_precache;///will spawn these

void() SpawnAngel;
void() BossHealing;

var float global_talking_phase = 0;
var float superhamattack_enabled = 0;//Enable/disable the homming missiles
var vector reset_safe_zone = '-1 -1141 305.2';//hardcoded, but can be modified
var float boss_time  = 0;
var float boss_maxhealth = 40000;
var float boss_reportvalue = 40000;
var float talktime_boss = 0;//cooldown since the last time the boss talked, to avoid repeated messages in a short period of time 
var float angeltime_boss = 0;//time to spawn the next angel


//On top platforms
var vector v0 = '-596 -1692 280';
var vector v1 = '644 -1006 280';
var vector v2 = '-579 -412 312';

//Below in the arena 
var vector v3 = '94 -1735 40';
var vector v4 = '887 -83 8';
var vector v5 = '-831 -1114 40';


//For the healing ray fx
var float rotation = 0;

//Slowdown healing 
var float cooldown_angelspawn = 0;
var float cooldown_fx = 0;

//THE BOSS
var entity boss;

//Angel Ruin Eyes
var entity s0;
var entity s1;
var entity s2;
var float  s0_inuse = FALSE;
var float  s1_inuse = FALSE;
var float  s2_inuse = FALSE;



/*--------------------------------------*/

void(string msg) bossSpeak = {
    local entity p;

    sound (self, CHAN_VOICE, "boss2/sight.wav", 1, ATTN_NONE);

    dprint("TYPHOON: ");
    dprint(msg);
    dprint("\n");

    talktime_boss = time + 4 + 8*random();// boss text updates can't be produced faster than in 4 seconds from now

    global_talking_phase = global_talking_phase + 1 ;

    self.armorvalue = self.armorvalue + 100;     
};


void () AngelThink = {    
    self.frame = 6;

    if(random()<0.3)
        SpawnAngel();

    BossHealing();

    self.nextthink = time + 0.1;
};


void() AngelDieFX = {
    dprint("Angel of Ruin vanished\n");    

    ThrowGib ("progs/gib1.mdl",  -10);
    ThrowGib ("progs/gib2.mdl",  -60);
    ThrowGib ("progs/gib3.mdl",  -50);
    ThrowGib ("progs/gib1.mdl",  -40);
    ThrowGib ("progs/gib2.mdl", -30);
    TELEPORT(self.origin);
    setmodel(self, "");

    cooldown_angelspawn = time + 10;//Delay next spawn a lot so the player has time to relax
};

void() s0die = {    
    s0_inuse = FALSE;
   
    AngelDieFX();
    self.nextthink = time + 0.1;
    self.think = SUB_Remove;    
};

void() s1die = {
    s1_inuse = FALSE;
    
    AngelDieFX();
    self.nextthink = time +0.1;
    self.think = SUB_Remove;
};

void() s2die = {
    s2_inuse = FALSE;


    AngelDieFX();
    self.nextthink = time +0.1;
    self.think = SUB_Remove;
};

void(entity attacker, float take) AngelPain = {

    if(random()<0.3)
        ThrowGib ("progs/gib2.mdl", -30);

    self.frame = 5;
};


entity() angel_spawn = {
    local entity s;

    s = spawn();
    setmodel(s, "progs/evilwiz.spr");   
    setsize(s,VEC_HULL2_MIN, VEC_HULL2_MAX); 
    s.skin = SPR_VP_PARALLEL;
    s.frame = 6;
    s.solid = SOLID_BBOX;
    s.health = 300;
    s.think = AngelThink;
    s.nextthink = time + 0.1;
    s.th_pain = AngelPain;
    s.th_missile = SUB_Null;
    s.th_melee = SUB_Null;
    s.th_run = SUB_Null;
    s.th_stand = SUB_Null;
    s.th_walk = SUB_Null;
    s.th_die = SUB_Null;    
    s.flags = s.flags | FL_MONSTER;
    s.view_ofs = '0 0 25';
    s.takedamage = DAMAGE_AIM;
    s.use = monster_use;
    s.yaw_speed = 20;
    s.ideal_yaw = s.angles * '0 1 0';

    cooldown_angelspawn = time + 9;

    return s;
};


void() s0spawn = {
    s0 = angel_spawn();
    s0_inuse = TRUE;
    
    setorigin(s0, v0+'0 0 100');        
    s0.th_die = s0die;
    
    dprint("Angel of Ruins I has spawned...\n");    
};

void() s1spawn = {
    s1 = angel_spawn();
    s1_inuse = TRUE;
    
    setorigin(s1, v1+'0 0 100');        
    s1.th_die = s1die;

    dprint("Angel of Ruins II has spawned...\n");
};

void() s2spawn = {
    s2 = angel_spawn();
    s2_inuse = TRUE;
    
    setorigin(s2, v2+'0 0 100');        
    s2.th_die = s2die;

    dprint("Angel of Ruins III has spawned...\n");
};


void (vector org) ZapBoss = {
    if(!boss)
        return;

    LIGHTNING2(v2+'0 0 100', boss.origin +'0 0 100');
  
    
    dprint("Typhoon is getting healed by the angels of ruin\n");

    if(boss.health < boss_maxhealth){
        boss.health = boss.health + 100;
    }
};


void() BossHealing =  {
    if(!s0_inuse || !s1_inuse || !s2_inuse){
        return;
    }

    if(cooldown_fx>time){
        return;
    }
    
    cooldown_fx = time + 0.3;

    rotation = rotation + 1;
    if(rotation>2)
        rotation = 0;    

    switch(rotation){
        case 0:
            LIGHTNING2(v0+'0 0 100', v1 +'0 0 100');

            if(random()<0.3)
                ZapBoss(v0+'0 0 100');                
            break;
        case 1:
            LIGHTNING2(v1+'0 0 100', v2 +'0 0 100');

            if(random()<0.3)
                ZapBoss(v1+'0 0 100');
            break;
        case 2:
            LIGHTNING2(v2+'0 0 100', v0 +'0 0 100');

            if(random()<0.3)
                ZapBoss(v2+'0 0 100');
            break;                        
    }
}



void() SpawnAngel = {
    if(s0_inuse && s1_inuse && s2_inuse){
        return;
    }

    if(cooldown_angelspawn>time)
        return;

    if(global_talking_phase<1)        
        return;

    if(!s0_inuse){
        s0spawn();
        return;
    }

    if(!s1_inuse){
        s1spawn();
        return;
    }

    if(!s2_inuse){
        s2spawn();        
        return;
    }
};


void() boss_lifebar_update = {

    if(angeltime_boss<time){
        angeltime_boss = time + 10;//
        SpawnAngel();
    }

    if(talktime_boss>time)
        return;

    talktime_boss = time + 4 + 8*random();// boss text updates can't be produced faster than in 4 seconds from now

    if(self.health < boss_reportvalue){

        if( self.health >= boss_maxhealth){
            dprint("Boss health [##########] 100% health\n");
        }else if ( self.health >= boss_maxhealth - boss_maxhealth/10*1  ){
            dprint("Boss health [#########-] 90% health\n");
        }else if ( self.health >= boss_maxhealth - boss_maxhealth/10*2  ){
            dprint("Boss health [########--] 80% health\n");
        }else if ( self.health >= boss_maxhealth - boss_maxhealth/10*3  ){
            dprint("Boss health [#######---] 70% health\n");
        }else if ( self.health >= boss_maxhealth - boss_maxhealth/10*4  ){
            dprint("Boss health [######----] 60% health\n");
        }else if ( self.health >= boss_maxhealth - boss_maxhealth/10*5  ){
            dprint("Boss health [#####-----] 50% health\n");
        }else if ( self.health >= boss_maxhealth - boss_maxhealth/10*6  ){
            dprint("Boss health [####------] 40% health\n");
        }else if ( self.health >= boss_maxhealth - boss_maxhealth/10*7  ){
            dprint("Boss health [###-------] 30% health\n");
        }else if ( self.health >= boss_maxhealth - boss_maxhealth/10*8  ){
            dprint("Boss health [##--------] 20% health\n");
        }else if ( self.health >= boss_maxhealth - boss_maxhealth/10*9  ){
            dprint("Boss health [#---------] 20% health\n");
        }else  {
            dprint("Boss health [#---------] 10% health\n");
        }

        boss_reportvalue = boss_reportvalue - boss_maxhealth/10;
    }

};


void() boss_reposition ={ 
    local float dis;    
    local vector vz;
    local float r;

    dis = vlen( self.origin - reset_safe_zone);

    if(dis>800+random()*300){
        

        r = random();
        if(r<0.3)
            vz = v3;
        else if (r<0.6)
            vz = v4;
        else
            vz = v5; 

        //vz = vz + '0 0 100';

        TELEPORT(self.origin);
        TELEPORT(vz);
        LIGHTNING2(self.origin, vz);

        setorigin(self,vz);

        //SmallJump();
    }
};


void() do_the_talking = {

    if(talktime_boss>time) // so we don't talk about many stuff too fast
        return;

	switch(global_talking_phase){
		case 0:
            if(self.health>=boss_maxhealth)
                return;	

			bossSpeak("Wellcome to my Realm, bug");       
			break;
        case 1:
            if(self.health>boss_maxhealth - boss_maxhealth/10*1)
                return;			

            bossSpeak("Ha!, do you intend to present a fight?");

            MONSTER_MIX = "monster_wizard";

            superhamattack_enabled = 1;
            break;

        case 2:
            if(self.health>boss_maxhealth - boss_maxhealth/10*2)
                return;				
                
            bossSpeak("I will summon my pets to deal with you");    

            MONSTER_BRUTE = "monster_demon1";
            MONSTER_MIX = "monster_army";
            MONSTER_TRASH = "monster_demon1";
            break;					
        case 3:
            if(self.health>boss_maxhealth - boss_maxhealth/10*3)
                return;			
                
            bossSpeak("You insect");    

            MONSTER_TRASH = "monster_army";
            MONSTER_MIX = "monster_army";
            MONSTER_BRUTE = "monster_enforcer";
            
            break;					
        case 4:
            if(self.health>boss_maxhealth - boss_maxhealth/10*4)
                return;			
                
            bossSpeak("Hahahaha.. your attacks are nothing");   

            MONSTER_TRASH = "monster_army";
            MONSTER_MIX = "monster_ogre";
            MONSTER_BRUTE = "monster_enforcer";
            break;		
        case 5:
            if(self.health>boss_maxhealth - boss_maxhealth/10*5)
                return;				
                
            bossSpeak("Pest");    

            MONSTER_BRUTE = "monster_demon1";
            MONSTER_MIX = "monster_ogre";
            MONSTER_TRASH = "monster_demon1";            
            break;	            
        case 6:
            if(self.health>boss_maxhealth - boss_maxhealth/10*6)
                return;	
                
            bossSpeak("I will slave your realm\ninto mindless drones");    

            MONSTER_BRUTE = "monster_enforcer";
            MONSTER_MIX = "monster_army";
            MONSTER_TRASH = "monster_enforcer";            
            break;	       
        case 7:
            if(self.health>boss_maxhealth - boss_maxhealth/10*7)
                return;	
                
            bossSpeak("Hahahaha");    

            MONSTER_BRUTE = "monster_wizard";
            MONSTER_MIX = "monster_demon1";
            MONSTER_TRASH = "monster_demon1";
            break;	                      
        case 8:
            if(self.health>boss_maxhealth - boss_maxhealth/10*8)
                return;	
                
            bossSpeak("Is time for you,.. to DIE");    

            MONSTER_BRUTE = "monster_enforcer";
            MONSTER_MIX = "monster_army";
            MONSTER_TRASH = "monster_enforcer";
            break;	             

        case 9:
            if(self.health>boss_maxhealth - boss_maxhealth/10*9)
                return;	
                
            bossSpeak("You will suffer for a eternity!");    

            MONSTER_BRUTE = "monster_army";
            MONSTER_MIX = "monster_wizard";
            MONSTER_TRASH = "monster_enforcer";
            break;	         
	}
};

/*--------------------------------------*/

void() SuperShamMissile = {
	local	entity 	missile;
	local	vector	dir;
	local	float	dist, flytime;

    if(!superhamattack_enabled)
        return;

	dir = normalize((self.enemy.origin + '0 0 10') - self.origin);
	dist = vlen (self.enemy.origin - self.origin);
	flytime = dist * 0.002;
	if (flytime < 0.1)
		flytime = 0.1;

	muzzleflash();
	sound (self, CHAN_WEAPON, "shalrath/attack2.wav", 1, ATTN_NORM);

	missile = spawn ();
	missile.owner = self;

	missile.solid = SOLID_BBOX;
	missile.movetype = MOVETYPE_FLYMISSILE;
    setmodel(missile,"progs/evilwiz.spr" );  

	setsize (missile, '0 0 0', '0 0 0');		

	missile.origin = self.origin + '0 0 50' + '0 0 20'*random();
	setorigin(missile, missile.origin);//unnecesary?

	missile.velocity = dir * 400;
	missile.avelocity = '300 300 300';
	missile.nextthink = flytime + time;
	missile.think = SuperShamHome;
	missile.enemy = self.enemy;
	missile.touch = SuperShamMissileTouch;
    missile.cnt = 10;

    missile.skin = SPR_VP_PARALLEL;
    missile.frame = 0;    
    missile.effects = EF_RED | EF_BLUE;
   

    sound (missile, CHAN_VOICE, "kriek.wav", 1, ATTN_NORM);
};

void() SuperShamHome =
{
	local vector	dir, vtemp;
	vtemp = self.enemy.origin + '0 0 10';


	if (self.enemy.health < 1){
		remove(self);
		return;
	}

    if(random()<0.5)
        sound (self, CHAN_VOICE, "kriek.wav", 1, ATTN_NORM);

	dir = normalize(vtemp - self.origin);

	self.velocity = dir * 250;

	self.nextthink = time + 0.2;
	self.think = SuperShamHome;	

    self.cnt = self.cnt  -1 ;
    if(self.cnt<0){
        self.nextthink = time + 3;
        self.think = SUB_Remove;
    }

};

void() SuperShamMissileTouch =
{
	if (other == self.owner)
		return;		// don't explode on owner

	T_RadiusDamage (self, self.owner, 40, world, "shalrath");
	sound (self, CHAN_WEAPON, "player/gib.wav", 1, ATTN_NORM);

	LIGHTNINGBLOOD(self.origin);

	remove (self);
};

void() SUB_SpawnEnemy = {
    setorigin(self,self.origin + '0 0 50');

    self.solid = SOLID_NOT;
    setmodel(self, "");

    if(random()<0.3)
        DynamicSpawnHere();

    if(random()<0.1){
		local entity item = MakeDropableItem(self.origin);
		DropHasBook(item);        
		item.nextthink = time + 120;    // remove after 2 minutes
		item.think = SUB_Remove;
    }

    self.nextthink = time + 3;
    self.think = SUB_Remove;

    
};

entity() SpawnBall = {
    local entity ball;
    
    ball = spawn();
    //setmodel(ball,"progs/lavaball.mdl");    
    setmodel(ball,"progs/orb.spr");    

    ball.skin = SPR_VP_PARALLEL;
    ball.frame = 4;
    ball.effects = EF_GREEN | EF_SMALLFX;

    setorigin(ball, self.origin + '0 0 50');
    ball.owner = self;
    ball.movetype = MOVETYPE_BOUNCE;
    ball.solid = SOLID_BBOX;

    return ball;
};

void() SpawnLavaballs = {

    local entity ball_1;
    local entity ball_2;
    local entity ball_3;
    local entity ball_4;

    sound (self, CHAN_WEAPON, "weapons/grenade.wav", 1, ATTN_NORM);

    makevectors (self.angles);

    local float r = random();

    if(r<0.5 || global_talking_phase > 5){
        ball_1 = SpawnBall();
        ball_1.velocity = normalize(self.enemy.origin - self.origin);
        ball_1.velocity = ball_1.velocity * 200;
        ball_1.velocity_z = 600;
        ball_1.nextthink = time + 5;
        ball_1.think = SUB_SpawnEnemy;

        ball_2 = SpawnBall();
        ball_2.velocity = normalize(self.enemy.origin - self.origin) * -1;
        ball_2.velocity = ball_2.velocity * 200;
        ball_2.velocity_z = 600;
        ball_2.nextthink = time + 5;
        ball_2.think = SUB_SpawnEnemy;
    }

    if(r>0.5  || global_talking_phase > 5){
        ball_3 = SpawnBall();
        ball_3.velocity = v_right;
        ball_3.velocity = ball_3.velocity * 200;
        ball_3.velocity_z = 600;
        ball_3.nextthink = time + 5;
        ball_3.think = SUB_SpawnEnemy;

        ball_4 = SpawnBall();
        ball_4.velocity = -v_right;
        ball_4.velocity = ball_4.velocity * 200;
        ball_4.velocity_z = 600;
        ball_4.nextthink = time + 5;
        ball_4.think = SUB_SpawnEnemy;
    }

    GarbageCollector();
};

void() SmallJump = {
    if(random()<0.8)
        return;

	makevectors (self.angles);
	self.origin_z = self.origin_z + 1;
	self.velocity = v_forward * 35 + '0 0 20';
	if (self.flags & FL_ONGROUND)
		self.flags = self.flags - FL_ONGROUND;   
};


void() supersham_stand1	=[	$stand1,	supersham_stand2	] {ai_stand();boss_lifebar_update();};
void() supersham_stand2	=[	$stand2,	supersham_stand3	] {ai_stand();};
void() supersham_stand3	=[	$stand3,	supersham_stand4	] {ai_stand();};
void() supersham_stand4	=[	$stand4,	supersham_stand5	] {ai_stand();boss_lifebar_update();};
void() supersham_stand5	=[	$stand5,	supersham_stand6	] {ai_stand();};
void() supersham_stand6	=[	$stand6,	supersham_stand7	] {ai_stand();};
void() supersham_stand7	=[	$stand7,	supersham_stand8	] {ai_stand();boss_lifebar_update();};
void() supersham_stand8	=[	$stand8,	supersham_stand9	] {ai_stand();};
void() supersham_stand9	=[	$stand9,	supersham_stand10] {ai_stand();boss_lifebar_update();};
void() supersham_stand10	=[	$stand10,	supersham_stand11] {ai_stand();};
void() supersham_stand11	=[	$stand11,	supersham_stand12] {ai_stand();};
void() supersham_stand12	=[	$stand12,	supersham_stand13] {ai_stand();boss_lifebar_update();};
void() supersham_stand13	=[	$stand13,	supersham_stand14] {ai_stand();};
void() supersham_stand14	=[	$stand14,	supersham_stand15] {ai_stand();};
void() supersham_stand15	=[	$stand15,	supersham_stand16] {ai_stand();boss_lifebar_update();};
void() supersham_stand16	=[	$stand16,	supersham_stand17] {ai_stand();};
void() supersham_stand17	=[	$stand17,	supersham_stand1	] {ai_stand();};

void() supersham_walk1		=[      $walk1,        supersham_walk2 ] {ai_walk(10);boss_lifebar_update();};
void() supersham_walk2       =[      $walk2,        supersham_walk3 ] {ai_walk(9);};
void() supersham_walk3       =[      $walk3,        supersham_walk4 ] {ai_walk(9);};
void() supersham_walk4       =[      $walk4,        supersham_walk5 ] {ai_walk(5);boss_lifebar_update();};
void() supersham_walk5       =[      $walk5,        supersham_walk6 ] {ai_walk(6);};
void() supersham_walk6       =[      $walk6,        supersham_walk7 ] {ai_walk(12);};
void() supersham_walk7       =[      $walk7,        supersham_walk8 ] {ai_walk(8);boss_lifebar_update();};
void() supersham_walk8       =[      $walk8,        supersham_walk9 ] {ai_walk(3);};
void() supersham_walk9       =[      $walk9,        supersham_walk10] {ai_walk(13);};
void() supersham_walk10      =[      $walk10,       supersham_walk11] {ai_walk(9);boss_lifebar_update();};
void() supersham_walk11      =[      $walk11,       supersham_walk12] {ai_walk(7);};
void() supersham_walk12      =[      $walk12,       supersham_walk1 ] {ai_walk(7);
    if (random() > 0.8)
	    sound (self, CHAN_VOICE, "shambler/sidle.wav", 1, ATTN_IDLE);

    boss_lifebar_update();
    SmallJump();
};

void() supersham_run1       =[      $run1,        supersham_run2      ] {
    ai_run(20);
    boss_lifebar_update();
    SmallJump();
    boss_reposition();
};
void() supersham_run2       =[      $run2,        supersham_run3      ] {
    ai_run(24);
    do_the_talking();
    SmallJump();
    boss_reposition();
};
void() supersham_run3       =[      $run3,        supersham_run4      ] {
    ai_run(20);
    SmallJump();
    boss_lifebar_update();
    boss_reposition();
};
void() supersham_run4       =[      $run4,        supersham_run5      ] {
    ai_run(20);
    
    do_the_talking();
    SmallJump();
    boss_reposition();
};
void() supersham_run5       =[      $run5,        supersham_run6      ] {
    ai_run(24);
    SmallJump();
    boss_lifebar_update();
    boss_reposition();
};
void() supersham_run6       =[      $run6,        supersham_run1      ] {    
    ai_run(20);
    SmallJump();
    boss_reposition();

    if (random() > 0.8)
        sound (self, CHAN_VOICE, "shambler/sidle.wav", 1, ATTN_IDLE);

    //dprint("Lavaball!");
    //SpawnLavaballs();

    do_the_talking();
};

void() supersham_smash1     =[      $smash1,       supersham_smash2    ] {
    sound (self, CHAN_VOICE, "shambler/melee1.wav", 1, ATTN_NORM);
    ai_charge(2);

    makevectors(self.angles);
    SpawnZasca(self.origin + v_right * -30,1);
    SpawnZasca(self.origin + v_right * 30,0);
    boss_lifebar_update();
};
void() supersham_smash2     =[      $smash2,       supersham_smash3    ] {ai_charge(6);};
void() supersham_smash3     =[      $smash3,       supersham_smash4    ] {ai_charge(6);};
void() supersham_smash4     =[      $smash4,       supersham_smash5    ] {ai_charge(5);boss_lifebar_update();};
void() supersham_smash5     =[      $smash5,       supersham_smash6    ] {ai_charge(4);};
void() supersham_smash6     =[      $smash6,       supersham_smash7    ] {ai_charge(1);};
void() supersham_smash7     =[      $smash7,       supersham_smash8    ] {ai_charge(0);boss_lifebar_update();};
void() supersham_smash8     =[      $smash8,       supersham_smash9    ] {ai_charge(0);};
void() supersham_smash9     =[      $smash9,       supersham_smash10   ] {ai_charge(0);};
void() supersham_smash10    =[      $smash10,      supersham_smash11   ] {
    local vector	delta;
    local float 	ldmg;

	if (!self.enemy)
		return;
	ai_charge(0);

	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 100)
		return;
	if (!CanDamage (self.enemy, self))
		return;
		
	ldmg = (random() + random() + random()) * 40;
	T_Damage (self.enemy, self, self, ldmg);
	sound (self, CHAN_VOICE, "shambler/smack.wav", 1, ATTN_NORM);

	SpawnMeatSpray (self.origin + v_forward*16, crandom() * 100 * v_right);
	SpawnMeatSpray (self.origin + v_forward*16, crandom() * 100 * v_right);
    boss_lifebar_update();
};
void() supersham_smash11    =[      $smash11,      supersham_smash12   ] {ai_charge(5);boss_lifebar_update();};
void() supersham_smash12    =[      $smash12,      supersham_run1	   ] {ai_charge(4);};

void() supersham_swingr1;

void(float side) SuperShamClaw = {
    local vector	delta;
    local float 	ldmg;

	if (!self.enemy)
		return;
	ai_charge(10);

	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 100)
		return;
		
	ldmg = (random() + random() + random()) * 40;
	T_Damage (self.enemy, self, self, ldmg);
	sound (self, CHAN_VOICE, "shambler/smack.wav", 1, ATTN_NORM);

	if (side) {
		makevectors (self.angles);
		SpawnMeatSpray (self.origin + v_forward*16, side * v_right);
	}
};

void()supersham_jump1;

void()	SuperDemon_JumpTouch =
{
	local	float	ldmg;

	if (self.health <= 0)
		return;
		
	if (other.takedamage)
	{
		if ( vlen(self.velocity) > 400 )
		{
			ldmg = 100 + 20*random();
			T_Damage (other, self, self, ldmg);	
		}
	}

	if (!checkbottom(self))
	{
		if (self.flags & FL_ONGROUND){	
            // jump randomly to not get hung up
            self.touch = SUB_Null;
            self.think = supersham_jump1;
            self.nextthink = time + 0.1;
		}
		return;	// not on ground yet
	}

	self.touch = SUB_Null;
	self.think = supersham_run1;
	self.nextthink = time + 0.1;
};


void() supersham_jump1	=[      $swingl1,      supersham_swingl2   ] {
    sound (self, CHAN_VOICE, "shambler/melee2.wav", 1, ATTN_NORM);
    ai_charge(5);

    self.touch = SuperDemon_JumpTouch;
	makevectors (self.angles);
	self.origin_z = self.origin_z + 1;
	self.velocity = v_forward * 650 + '0 0 300';
	if (self.flags & FL_ONGROUND)
		self.flags = self.flags - FL_ONGROUND;        

};
void() supersham_jump2 =[      $swingl2,      supersham_swingl3   ] {
    ai_charge(3);
    boss_lifebar_update();
};
void() supersham_jump3 =[      $swingl3,      supersham_swingl4   ] {
    ai_charge(7);};
void() supersham_jump4 =[      $swingl4,      supersham_swingl5   ] {
    ai_charge(3);};
void() supersham_jump5 =[      $swingl5,      supersham_swingl6   ] {
    ai_charge(7);
    boss_lifebar_update();
};
void() supersham_jump6 =[      $swingl6,      supersham_swingl7   ] {
    ai_charge(9);};
void() supersham_jump7 =[      $swingl7,      supersham_swingl8   ] {
    ai_charge(5); 
    SuperShamClaw(250);};
void() supersham_jump8 =[      $swingl8,      supersham_swingl9   ] {ai_charge(4);};
void() supersham_jump9 =[      $swingl9,      supersham_run1  ] {
    ai_charge(8);
    boss_lifebar_update();
};


void() supersham_swingl1	=[      $swingl1,      supersham_swingl2   ] {
    sound (self, CHAN_VOICE, "shambler/melee2.wav", 1, ATTN_NORM);
    ai_charge(5);

    makevectors(self.angles);
    SpawnZasca(self.origin + v_right * 30,1);
};
void() supersham_swingl2 =[      $swingl2,      supersham_swingl3   ] {ai_charge(3);};
void() supersham_swingl3 =[      $swingl3,      supersham_swingl4   ] {ai_charge(7);};
void() supersham_swingl4 =[      $swingl4,      supersham_swingl5   ] {ai_charge(3);boss_lifebar_update();};
void() supersham_swingl5 =[      $swingl5,      supersham_swingl6   ] {ai_charge(7);};
void() supersham_swingl6 =[      $swingl6,      supersham_swingl7   ] {ai_charge(9);};
void() supersham_swingl7 =[      $swingl7,      supersham_swingl8   ] {ai_charge(5); SuperShamClaw(250);boss_lifebar_update();};
void() supersham_swingl8 =[      $swingl8,      supersham_swingl9   ] {ai_charge(4);};
void() supersham_swingl9 =[      $swingl9,      supersham_run1  ] {
    ai_charge(8);
    if (random()<0.5)
        self.think = supersham_swingr1;

    boss_lifebar_update();        
};

void() supersham_swingr1	=[      $swingr1,      supersham_swingr2   ] {
    sound (self, CHAN_VOICE, "shambler/melee1.wav", 1, ATTN_NORM);
    ai_charge(1);

    makevectors(self.angles);
    SpawnZasca(self.origin + v_right * -30,1);
};
void() supersham_swingr2	=[      $swingr2,      supersham_swingr3   ] {ai_charge(8);boss_lifebar_update();};
void() supersham_swingr3 =[      $swingr3,      supersham_swingr4   ] {ai_charge(14);};
void() supersham_swingr4 =[      $swingr4,      supersham_swingr5   ] {ai_charge(7);};
void() supersham_swingr5 =[      $swingr5,      supersham_swingr6   ] {ai_charge(3);boss_lifebar_update();};
void() supersham_swingr6 =[      $swingr6,      supersham_swingr7   ] {ai_charge(6);};
void() supersham_swingr7 =[      $swingr7,      supersham_swingr8   ] {ai_charge(6); SuperShamClaw(-250);};
void() supersham_swingr8 =[      $swingr8,      supersham_swingr9   ] {ai_charge(3);boss_lifebar_update();};
void() supersham_swingr9 =[      $swingr9,      supersham_run1  ] {
    ai_charge(11);
    if (random()<0.5)
        self.think = supersham_swingl1;
};

void() supersham_melee =
{
	local float chance;
	
	chance = random();
	if (chance > 0.6 || self.health == 600)
        supersham_smash1 ();
	else if (chance > 0.3)
        supersham_swingr1 ();
	else
        supersham_swingl1 ();
};


entity (vector org, vector vec) LaunchHand =
{
    local vector vec = normalize(vec);
	
	newmis = spawn();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_FLY;
	newmis.solid = SOLID_BBOX;	

	setmodel (newmis, "progs/shamhand.mdl");
	
	setsize (newmis, '0 0 0', '0 0 0');             

	setorigin (newmis, org);

	newmis.velocity = vec * 1600;
    //newmis.velocity = vec * 300;
	newmis.angles = vectoangles(newmis.velocity);

	newmis.nextthink = time + 5;
	newmis.think = SUB_Remove;
	newmis.touch = SuperShamMissileTouch;
    //newmis.avelocity_x = 300;//counter-clockwise clock 
    //newmis.avelocity_y = 300;//horizontal cc clock
    newmis.angles_z = random() * 360;
    newmis.avelocity_z = 300;//


	return newmis;
};


//============================================================================

void() SuperCastLightning = {
	local	vector	org, dir;
	
	muzzleflash();

	ai_face ();

	org = self.origin + '0 0 40';

	dir = self.enemy.origin + '0 0 16' - org;
	dir = normalize (dir);

	traceline (org, self.origin + dir*600, TRUE, self);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_LIGHTNING1);
	WriteEntity (MSG_BROADCAST, self);
	WriteCoord (MSG_BROADCAST, org_x);
	WriteCoord (MSG_BROADCAST, org_y);
	WriteCoord (MSG_BROADCAST, org_z);
	WriteCoord (MSG_BROADCAST, trace_endpos_x);
	WriteCoord (MSG_BROADCAST, trace_endpos_y);
	WriteCoord (MSG_BROADCAST, trace_endpos_z);

	LightningDamage (org, trace_endpos, self, 10);	//was 20
    LaunchHand(org,  self.enemy.origin - org);
};

void() supersham_magic1     =[      $magic1,       supersham_magic2    ] {

    if(random()>0.5){
        self.think = supersham_jump1;
        return;
    }


	ai_face();
	sound (self, CHAN_WEAPON, "shambler/sattck1.wav", 1, ATTN_NORM);
	
};
void() supersham_magic2     =[      $magic2,       supersham_magic3    ] {
	ai_face();
    boss_lifebar_update();
};
void() supersham_magic3     =[      $magic3,       supersham_magic4    ] {
    ai_face();
    self.nextthink = self.nextthink + 0.2;

	local entity o;

	muzzleflash();
	ai_face();
	self.owner = spawn();
	o = self.owner;
	setmodel (o, "progs/s_light.mdl");
	setorigin (o, self.origin);
	o.angles = self.angles;
	o.nextthink = time + 0.7;
	o.think = SUB_Remove;
	

    if(random()<0.1){
        SpawnSorcerHere(self.origin + '0 0 100');
    }else {
        muzzleflash();
        SpawnLavaballs();
    }

	SuperShamMissile();	
};

void() supersham_magic4     =[      $magic4,       supersham_magic5    ] {
	
	self.owner.frame = 1;
    muzzleflash();
	
    SpawnLavaballs();
	SuperShamMissile();	
};
void() supersham_magic5     =[      $magic5,       supersham_magic6    ] {
	muzzleflash();
	self.owner.frame = 2;

	
    SpawnLavaballs();
	SuperShamMissile();	
};
void() supersham_magic6     =[      $magic6,       supersham_magic9    ]{
	remove (self.owner);
	SuperCastLightning();
	sound (self, CHAN_WEAPON, "shambler/sboom.wav", 1, ATTN_NORM);
};
void() supersham_magic9     =[      $magic9,       supersham_magic10   ] {SuperCastLightning();boss_lifebar_update();};
void() supersham_magic10    =[      $magic10,      supersham_magic11   ] {SuperCastLightning();};
void() supersham_magic11    =[      $magic11,      supersham_magic12   ] {};
void() supersham_magic12    =[      $magic12,      supersham_run1	   ] {};

void() supersham_pain1       =[      $pain1, supersham_pain2      ] {
    do_the_talking();
    if(random()<0.5) self.think = supersham_run1;
};
void() supersham_pain2       =[      $pain2, supersham_pain3      ] {
    if(random()<0.5) self.think = supersham_run1;
};
void() supersham_pain3       =[      $pain3, supersham_pain4      ] {
    if(random()<0.5) self.think = supersham_run1;

    boss_lifebar_update();
};
void() supersham_pain4       =[      $pain4, supersham_pain5      ] {
    if(random()<0.5) self.think = supersham_run1;
};
void() supersham_pain5       =[      $pain5, supersham_pain6      ] {
    if(random()<0.5) self.think = supersham_run1;
};
void() supersham_pain6       =[      $pain6, supersham_run1      ] {};

void(entity attacker, float damage)	supersham_pain = {
	sound (self, CHAN_VOICE, "shambler/shurt2.wav", 1, ATTN_NORM);

	if (self.health <= 0)
		return;		// allready dying, don't go into pain frame

	if (random()*400 > damage)
		return;		// didn't flinch

	if (self.pain_finished > time)
		return;
	self.pain_finished = time + 2;
		
	supersham_pain1 ();
};


//============================================================================

void() supersham_death1      =[      $death1,       supersham_death2     ] {};
void() supersham_death2      =[      $death2,       supersham_death3     ] {};
void() supersham_death3      =[      $death3,       supersham_death4     ] {self.solid = SOLID_NOT;};
void() supersham_death4      =[      $death4,       supersham_death5     ] {};
void() supersham_death5      =[      $death5,       supersham_death6     ] {};
void() supersham_death6      =[      $death6,       supersham_death7     ] {};
void() supersham_death7      =[      $death7,       supersham_death8     ] {};
void() supersham_death8      =[      $death8,       supersham_death9     ] {};
void() supersham_death9      =[      $death9,       supersham_death10    ] {};
void() supersham_death10     =[      $death10,      supersham_death11    ] {};
void() supersham_death11     =[      $death11,      supersham_death11    ] {};



void() ReturnHUB = {
    //changelevel("hub1");
    GotoNextMap();
};

void() supersham_die = {
    sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);    
    
    ThrowGib ("progs/gib1.mdl",  -90);
    ThrowGib ("progs/gib2.mdl", -80);    
    ThrowGib ("progs/gib3.mdl",  -80);
    ThrowGib ("progs/gib1.mdl",  -10);
    ThrowGib ("progs/gib2.mdl",  -60);
    ThrowGib ("progs/gib3.mdl",  -50);
    ThrowGib ("progs/gib1.mdl",  -40);
    ThrowGib ("progs/gib2.mdl", -30);
    ThrowGib ("progs/gib3.mdl",  -20);
    ThrowHead ("progs/h_shams.mdl", -20);

    WriteByte (MSG_ALL, SVC_FINALE);
    WriteString (MSG_ALL, "Typhoon has been killed\nall his magic dispate in the air.\nHis legions withouth a commander\nwill disband and earth will be\nsafe again thank\nyour courage!\nThis Ends\nThe Konspiration Episode\nThank You!");

    self.nextthink = time + 28;
    self.think = ReturnHUB;
};

//============================================================================

void() monster_supershambler_precache = {

	precache_model ("progs/shambler.mdl");
	precache_model ("progs/s_light.mdl");
	precache_model ("progs/h_shams.mdl");
	precache_model ("progs/bolt.mdl");
	
	precache_sound ("shambler/sattck1.wav");
	precache_sound ("shambler/sboom.wav");
	precache_sound ("shambler/sdeath.wav");
	precache_sound ("shambler/shurt2.wav");
	precache_sound ("shambler/sidle.wav");
	precache_sound ("shambler/ssight.wav");
	precache_sound ("shambler/melee1.wav");
	precache_sound ("shambler/melee2.wav");
	precache_sound ("shambler/smack.wav");

    precache_sound ("weapons/grenade.wav");    
    precache_sound ("items/r_item1.wav");    
    precache_sound ("items/r_item2.wav");     

    precache_sound ("kriek.wav");     
    precache_sound ("boss2/sight.wav");     
    
    precache_model ("progs/orb.spr");//for the ball summoning     

    precache_model ("progs/shamhand.mdl");
};


/*QUAKED monster_shambler (1 0 0) (-32 -32 -24) (32 32 64) Ambush
*/
void() monster_supershambler = {
	monster_supershambler_precache();
	monster_ogre_precache();///will spawn these
    monster_wizard_precache();///will spawn these

    self.classname = "monster_supershambler";

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel (self, "progs/shambler.mdl");

	setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
	self.health = 40000;

	self.th_stand = supersham_stand1;
	self.th_walk = supersham_walk1;
	self.th_run = supersham_run1;
	self.th_die = supersham_die;
	self.th_melee = supersham_melee;
	self.th_missile = supersham_magic1;
	self.th_pain = supersham_pain;
	
	self.armorvalue = 300;
	self.effects = self.effects | EF_RED | EF_BLUE;	    
		
    self.is_boss = TRUE;
	self.skin = 3;	

    boss = self;//only one allowed

    walkmonster_start();
};
