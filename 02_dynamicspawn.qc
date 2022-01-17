
void() monster_enforcer;
void() monster_army;
void (vector org, entity death_owner) spawn_tdeath;
void() DynamicSpawnHere_raw
void() monster_fish_start;

/**
 *  Spawntable.  Change this affect future spawns. Such has in boss fights
 */
var string MONSTER_TRASH = "monster_army";//easy to deal with
var string MONSTER_MIX = "monster_army";//break the player way to play
var string MONSTER_BRUTE = "monster_enforcer";//hard to kill

void(vector origin, float distance) ClearLandingZone = {
	local entity head;
	local entity remove_me;
	   
    //Look if a enemy is too near 
    head = findradius(origin, distance);
    while (head){

		if(head.classname == "monster_enforcer"){
            remove_me = head;
        }
        if(head.classname == "monster_army"){
            remove_me = head;
        }
        if(head.classname == "monster_demon1"){
            remove_me = head;
        }

        head = head.chain;

		if(remove_me){
			remove(remove_me);
			remove_me = 0;//already removed
		}
    }   
};

float() DynamicSpawnHere = {
    local string target_class;
    local entity newmonster;

    self.classname = "dynamic_spawn";

    // Make decissions about what to spawn 
    if(random()>0.8){
        target_class = MONSTER_BRUTE;
    }else if(random()<0.2) {
        target_class = MONSTER_MIX;
    }else{
        target_class = MONSTER_TRASH;
    }     
    
    newmonster = spawn();
    newmonster.think = DynamicSpawnHere_raw;    
    newmonster.nextthink = time + 3 + random() *5;
    setorigin(newmonster, self.origin);
    newmonster.classname = target_class;

    return 0;// Safe to delete, since we don't need it anymore 
};


/* ------------ delayed fx ------------ */
void() RandomTeleportSound = {
    local float r;

    r= random()*0.5;

    if(r<0.1)
        sound (self, CHAN_VOICE, "misc/r_tele1.wav", 1, ATTN_NORM);
    else if(r<0.2)        
        sound (self, CHAN_VOICE, "misc/r_tele2.wav", 1, ATTN_NORM);
    else if(r<0.3)        
        sound (self, CHAN_VOICE, "misc/r_tele3.wav", 1, ATTN_NORM);
    else if(r<0.4)        
        sound (self, CHAN_VOICE, "misc/r_tele4.wav", 1, ATTN_NORM);                
    else         
        sound (self, CHAN_VOICE, "misc/r_tele5.wav", 1, ATTN_NORM);        
}

/*
void() DelayedTeleportEffectFinal = {
    local entity target;

    target = self.owner;

    setorigin(self,target.origin);
    TELEPORT(target.origin);
    RandomTeleportSound();

    self.think = SUB_Remove;
    ///self.nextthink = time + 0.5;
    self.nextthink = time + 15;
    self.movetype = MOVETYPE_FLY;
    //self.velocity = '0 0 10';
};


void(entity target) DelayedTeleportEffect = {
    local entity t = spawn();
    setorigin(t,target.origin);
    t.classname = "DelayedUse";
    t.think = DelayedTeleportEffectFinal;    
    t.owner = target;
    t.nextthink = time + 0.2;
    t.frame = 3;
    t.solid = SOLID_NOT;
    t.skin = SPR_ORIENTED;
    t.skin = SPR_VP_PARALLEL;
    t.skin = SPR_VP_PARALLEL_ORIENTED;
    t.skin = SPR_ORIENTED;
    t.skin = SPR_TEI_TYPEHACK;
    //t.skin = random()*6;

    t.angles = vectoangles('0 0 1');
    setmodel(t,"progs/orb.spr");
    t.avelocity_z = 200;
    //t.effects = t.effects | EF_RED;    
    t.effects = t.effects | EF_GREEN;    
    //t.avelocity = '1900 1900 1900';
};
*/



void() DelayedTeleportEffectFinal = {
    local entity target;

    target = self.owner;

    setorigin(self,target.origin);
    TELEPORT(target.origin);
    RandomTeleportSound();

    self.think = SUB_Remove;
    self.nextthink = time + 10;
    self.movetype = MOVETYPE_FLY;
    self.velocity = '0 0 -10';
};

void(entity target) DelayedTeleportEffect = {
    local entity t = spawn();
    setorigin(t,target.origin);
    t.classname = "DelayedUse";
    t.think = DelayedTeleportEffectFinal;    
    t.owner = target;
    t.nextthink = time + 0.2;
    t.frame = 0;
    t.solid = SOLID_NOT;
    t.skin = SPR_ORIENTED;
    t.angles = vectoangles('0 0 1');
    setmodel(t,"progs/fx.spr");
    //t.effects = t.effects | EF_RED;    
    t.effects = t.effects | EF_BOSS;		

    //t.avelocity = '1900 1900 1900';
    t.avelocity_z = 300;
};

/* ------------ /delayed fx ------------ */




void() DynamicSpawnHere_raw = {
    local float best;
    local float best_angle;
    local float t;
    local void() spawn_function;

    local vector chosen_mins = '-16 -16 -24';
    local vector chosen_maxs = '16 16 40';
    
    local entity	head;
    local float area_content;

    if(mapname == "start" || mapname=="hub1"){
        remove(self);
        return;
    }

    area_content =  pointcontents(self.origin);

    if(area_content == CONTENT_EMPTY){
        //Normal spawning
        spawn_function = find_function("",self.classname,"_start");    
    }else if ( area_content != CONTENT_WATER || area_content != CONTENT_SLIME ){
        //Underwater => Fish
        spawn_function = monster_fish_start;    
        //NOTE: probably will never trigger here        
    }else /*TODO: fiends on lava? */ {
        remove(self);
        return;
    }

    if(!spawn_function){
        dprint("ERROR: can find becometospawn for ");
        dprint(self.classname);
        dprint("\n");

        remove(self);
        return;
    }

    /* ------------- Valid spawn test -------------------- */


    //Check if theres space for the spawn
    tracebox(self.origin, chosen_mins, chosen_maxs, self.origin, 1, self);

    if(trace_startsolid==1){
        remove(self);
        return ; 
    }

    //Look if a enemy is too near 
    head = findradius(self.origin, 20);
    while (head){

        if(head.classname == "monster_enforcer" && head != self){
            remove(self);
            return;
        }

        if(head.classname == "monster_army"  && head != self){
            remove(self);
            return;
        }

        head = head.chain;    
    }

    head = findradius(self.origin, 600);
    while (head){
        if(head.classname == "info_player_coop"){
            dprint("Coop start proximity too low!\n");
            remove(self);
            return;
        }

        head = head.chain;    
    }

    /* ------------- Final setup phase -------------------- */

    self.angles_y = random()*360;

    //Searching for a good angle where the mob is not looking at a wall, but some decent long distance
    best = 0;
    best_angle = self.angles_y;//save current angle as backup
    for(t=0;t<10;t++){
        self.angles_y = random()*360;//random angle to test

        makevectors(self.angles);
        traceline(self.origin, self.origin + v_forward * 600, 1, self);

        if(trace_fraction>best){ // is better
            best_angle = self.angles_y; //save better angle
            best = trace_fraction; //save best trace fraction so far
        }				
    }

    self.angles_y = best_angle;//use the best angle we found   

    /* ------------- Spawning -------------------- */

    DelayedTeleportEffect(self);
    spawn_function();    
};


