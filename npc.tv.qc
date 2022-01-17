

float TV_BREAKING = 0;
float TV_STORMS = 1;
float TV_ZELOBITES = 2;
float TV_FTE = 3;
float TV_EZQ = 4;
float TV_AD = 5;
float TV_M1 = 6;
float TV_M2 = 7;
float TV_M3 = 8;
float TV_HACKED = 9;

void() npc_tv_frame0;

void(float f, float delaytime) npc_tv_setframe = {
    if(nextmap_isset()){  
        
        if(nextmap_selected == MISSION1 )
            self.frame = TV_M1;
        else if(nextmap_selected == MISSION2 )
            self.frame = TV_M2;
        else if(nextmap_selected == MISSION3 )
            self.frame = TV_M3;
        else  
            self.frame = TV_HACKED;   

        self.effects = EF_RED;
        self.nextthink = time + 0.1;
        
    }else{
        self.frame = f;
        self.nextthink = time + delaytime;
    }    
};


void () npc_tv_frame5 = {    
    npc_tv_setframe(TV_AD,2);
    self.think = npc_tv_frame0;
    self.effects = EF_DIMLIGHT | EF_SMALLFX;
}

void () npc_tv_frame4 = {
    npc_tv_setframe(TV_FTE,2);    
    self.think = npc_tv_frame5;
    self.effects = EF_BLUE | EF_SMALLFX;
};

void () npc_tv_frame3 = {
    npc_tv_setframe(TV_EZQ,1);
    self.think = npc_tv_frame4;
    self.effects = EF_BLUE | EF_SMALLFX;
};

void () npc_tv_frame2 = {
    npc_tv_setframe(TV_ZELOBITES,6);    
    self.think = npc_tv_frame3;
    self.effects = EF_GREEN | EF_SMALLFX;
};

void () npc_tv_frame1 = {
    npc_tv_setframe(TV_STORMS,6);    
    self.think = npc_tv_frame2;
    self.effects = EF_GREEN | EF_SMALLFX;
};

void () npc_tv_frame0 = {
    npc_tv_setframe(TV_BREAKING,3);    
    self.think = npc_tv_frame1;
    self.effects = EF_BLUE | EF_SMALLFX;
};

void() npc_tv_start = {
    setmodel(self,"progs/tv.spr");
    self.skin = SPR_ORIENTED;    

    self.think = npc_tv_frame0;
    self.nextthink = time + 1;
    self.angles = self.angles * -1;
};

void() npc_tv_precache = {
    precache_model("progs/tv.spr");
};

void() npc_tv = {
    npc_tv_precache();
    npc_tv_start();
}
