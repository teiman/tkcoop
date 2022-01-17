

/*---------------------------------------------*/

void() npc_signal_think= {
    if(nextmap_isset()){
        setmodel(self, "progs/fx.spr");
        self.skin = SPR_ORIENTED;  

        if(is_hacked()){
            self.frame = 8;        
            self.effects = EF_GREEN;
        }else {
            self.frame = 7;        
            self.effects = EF_RED;
        }              
    } else{
        setmodel(self, "progs/invisible.spr");
        self.frame = 0;
        self.effects = 0;
    }
        
    self.nextthink = time + 0.3;     
}


void() npc_signal_precache = {    
    precache_model("progs/invisible.spr");
};

void() npc_signal_start = {
    setmodel(self,"progs/invisible.spr");
    self.think = npc_signal_think;
    self.angles = self.angles * -1;
    self.nextthink = time + 1;
};


void() npc_signal = {
    npc_signal_precache();
    npc_signal_start();
};

/*---------------------------------------------*/


void() red_ambient = {
	precache_model("progs/invisible.spr");
	setmodel(self,"progs/invisible.spr");
	self.effects = self.effects | EF_RED;
};


/*---------------------------------------------*/





void() red_alert_think= {
    if(nextmap_isset()){        
        self.effects = self.effects | EF_RED;
    }else{
        self.effects = 0;
    }

    self.nextthink = time + 0.3;
};

void() red_alert = {
	precache_model("progs/invisible.spr");
	setmodel(self,"progs/invisible.spr");

	self.nextthink = time + 3;
    self.think = red_alert_think;
};


/*---------------------------------------------*/


void() npc_arrow_think = {

    if(nextmap_isset() && nextmap_selected == self.message){        
        self.frame = 1;
        self.skin = SPR_VP_PARALLEL;    
        self.effects = self.effects | EF_BOSS;
    }else{
        self.frame = 0;
        self.effects = 0;
    }

    self.nextthink = time + 0.3;
};


void() npc_arrow = {
	precache_model("progs/invisible.spr");

    setmodel(self,"progs/invisible.spr");
    self.think = npc_arrow_think;
    self.nextthink = time + 3;
};

/*---------------------------------------------*/

void() npc_redeye = {
	precache_model("progs/invisible.spr");
    self.frame = 2;
	setmodel(self,"progs/invisible.spr");
	self.effects = self.effects | EF_GREEN;
};


void() npc_screen = {
	precache_model("progs/misc/misc_oscill.mdl");
    precache_model("progs/misc/misc_starfield.mdl");
    precache_model("progs/misc/misc_levels.mdl");

    local float r = random();

    if(r<0.3){
	    setmodel(self,"progs/misc/misc_oscill.mdl");	
    }else if(r<0.6){
        setmodel(self,"progs/misc/misc_starfield.mdl");	
    }else{
        setmodel(self,"progs/misc/misc_levels.mdl");	
    }

    self.angles_y = self.angles_y  - 90;
};



void() decor_giro = {
    precache_model("progs/aspa.spr");
    setmodel(self, "progs/aspa.spr");

    self.frame = 0;
    self.skin = SPR_ORIENTED;    
    self.angles = vectoangles('0 0 1');
    self.avelocity_z = 200;
    self.movetype = MOVETYPE_FLY;
    self.solid = SOLID_NOT;
};



void() npc_ciber = {
    precache_model("progs/gridsense1.spr");
    setmodel(self, "progs/gridsense1.spr");

    self.angles = self.angles * -1;

    /*
    dprint("my frame is: ");
    dprint(ftos(self.frame));
    dprint("\n");*/

    if(!self.frame)
        self.frame = 2;

    self.skin = SPR_ORIENTED;        
    self.movetype = MOVETYPE_NONE;
    self.solid = SOLID_NOT;

    if(self.frame!=3){
        self.effects = EF_BLUE | EF_SMALLFX;
    }else{
        self.effects = EF_GREEN | EF_SMALLFX;
    }
    
};



void() npc_fx_emitter_think = {
    local entity grid;     

    dprint("Spawn!\n");
    grid = spawn();
    setmodel(grid,"progs/gridsense1.spr");
    
    grid.angles = self.angles;
    grid.frame = 0;
    grid.skin = SPR_ORIENTED;        
    grid.movetype = MOVETYPE_FLY;
    grid.solid = SOLID_BBOX;
    
    makevectors(grid.angles);
    grid.velocity = v_forward * 100;

    setorigin(grid,self.origin+ v_forward*30);

    grid.touch = SUB_Remove;

    local float r = random();
    if(r<0.3)
        grid.avelocity_z = 10;
    else if (r>0.6)
        grid.avelocity_z = -10;

    self.nextthink = time + 1;
};

void() npc_fx_emitter = {    
    precache_model("progs/gridsense1.spr");

    //self.think = npc_fx_emitter_think;
    //self.nextthink = time + 1;
};


void() npc_workbench = {
    local entity p;

    precache_model("progs/misc/misc_workbench.mdl");
    precache_model("progs/nail2.mdl");

    setmodel(self,"progs/misc/misc_workbench.mdl");

    self.movetype = MOVETYPE_TOSS;
    self.solid = SOLID_BBOX;

    self.angles = self.angles * -1;

    p = spawn();
    p.solid = SOLID_BBOX;
    setmodel(p, "progs/nail2.mdl");
    setorigin(p, self.origin + '0 0 -42');    
};
