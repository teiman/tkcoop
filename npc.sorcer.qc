

void() SorcerBallTouch = {
	if (other == self.owner)
		return;		// don't explode on owner

	T_RadiusDamage (self, self.owner, 40, world, "sorcer");
	sound (self, CHAN_WEAPON, "weapons/r_exp3.wav", 1, ATTN_NORM);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);
	multicast (self.origin, MULTICAST_PHS);	

	remove (self);
};


void() SorcerBallIgnition = {
    self.movetype = MOVETYPE_BOUNCE;
    self.solid = SOLID_BBOX;
    self.touch = SorcerBallTouch;

    self.think = SUB_Remove;
    self.nextthink = time + 5;
}


void(vector org, vector dir) ShotSorcerShadow = {
    local entity e = spawn();

    //setmodel(e,"progs/sorcer.spr" );
    //setmodel(e,"progs/evilwiz.spr" );
    setmodel(e,"progs/zasca.spr");
    setorigin(e, org);

    e.skin = SPR_ORIENTED;
    e.angles = vectoangles('0 0 1');
    e.avelocity_z = -600;    
    e.velocity = dir;
    e.movetype = MOVETYPE_FLY;
    e.solid = SOLID_NOT;
    e.frame = 1;
    e.nextthink = time + 2;
    e.think = SorcerBallIgnition ;
    e.effects = EF_RED | EF_BLUE;
    e.owner = self;
}



void() npc_sorcer_explode = {

    local vector v;
    v_x = (random()-0.5)*2;
    v_y = (random()-0.5)*2;
    v_z = 0;
    v = normalize(v) * 200;

    ShotSorcerShadow(self.origin, v);    
    
    self.nextthink = time + 0.1;    

    self.cnt = self.cnt - 1;
    if(self.cnt<0){
        self.think = SUB_Remove;
    }
};

void() npc_sorcer_think = {

    self.velocity = '0 0 0';

    if(self.frame<4){
        self.frame = self.frame + 1;
    }else{
        self.cnt = 50;
        self.frame = 4;
        self.think = npc_sorcer_explode;
    }

    self.nextthink = time + 0.1;
};

void() npc_sorcer_precache = {
    precache_model("progs/sorcer.spr");
    precache_model ("progs/evilwiz.spr");
    precache_model ("progs/zasca.spr");
    precache_sound ("woo.wav");
};


void() npc_sorcer_start = {    
    
    //setmodel(self,"progs/evilwiz.spr");
    setmodel(self,"progs/sorcer.spr" );
    self.skin = SPR_VP_PARALLEL;
    self.frame = 0;    
    
    self.movetype = MOVETYPE_FLY;
    setsize (self, '-16 -16 -24', '16 16 40');

    self.solid = SOLID_BBOX;
    self.effects = self.effects | EF_DIMLIGHT;

    self.nextthink = time + 4;
    self.think = npc_sorcer_think;

    self.velocity = '0 0 50';
    //self.avelocity = 200;

    //lightstyle(0,"m");
};


void(vector org) SpawnSorcerHere = {
    local entity e = spawn();

    setorigin(e, org);
    e.nextthink = time + 0.1;
    e.think = npc_sorcer_start;

    sound (e, CHAN_VOICE, "woo.wav", 1, ATTN_NONE);
};