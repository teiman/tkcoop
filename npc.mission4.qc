
$cd /raid/quake/id1/models/player_4
$origin 0 -6 24
$base base              
$skin skin

//
// running
//
$frame axrun1 axrun2 axrun3 axrun4 axrun5 axrun6

$frame rockrun1 rockrun2 rockrun3 rockrun4 rockrun5 rockrun6

//
// standing
//
$frame stand1 stand2 stand3 stand4 stand5

void()  npc_mission4_stand1;
void()  npc_mission4_stand2;
void()  npc_mission4_stand3;
void()  npc_mission4_stand4;
void()  npc_mission4_stand5;


var float NPC_TRIGGER_STARTED = 0;

void()  npc_mission4_stand1 =[        $stand1,       npc_mission4_stand2   ] { };
void()  npc_mission4_stand2 =[        $stand2,       npc_mission4_stand3   ] { };
void()  npc_mission4_stand3 =[        $stand3,       npc_mission4_stand4   ] { };
void()  npc_mission4_stand4 =[        $stand4,       npc_mission4_stand5   ] { };
void()  npc_mission4_stand5 =[        $stand5,       npc_mission4_stand1   ] { 
    local entity trig;

    if(GLOBAL_MISSION_STAGE & EPISODE3_COMPLETE){
        setmodel(self,"progs/player.mdl");          
        self.skin = PLAYERSKIN_SARGE;
        self.effects = self.effects | EF_BOSS;

        if(NPC_TRIGGER_STARTED==0){
            NPC_TRIGGER_STARTED = 1;
            trig = create_npc_trigger();
            
            //HACK
            setorigin(trig, trig.origin + '0 0 10');
        }
    }else{
        setmodel(self,"progs/invisible.spr");  
        self.skin = 0;
        self.effects = 0;
    }

};


void() npc_mission4_talk = {
    local string f1 = "General: This is your last mission";
    local string f2 = "Explore the location.";
    local string f3 = "Our enemy must be hidding\nthere.";
    local string f4 = "Go and destroy it!";
    local string ftalk;

    if( !(GLOBAL_MISSION_STAGE & EPISODE3_COMPLETE) ){
        centerprint(self.oldenemy, "General: Hello soldier.");
        return;
    }

    if( GLOBAL_MISSION_STAGE & EPISODE4_COMPLETE ){
        centerprint(self.oldenemy, "Ultron: Try hacking the computer\nfor more missions");
        return;
    }


    if(self.dialog_stage<4)
        self.dialog_stage = self.dialog_stage + 1;

    switch(self.dialog_stage){
        case 1:
            ftalk = f1;
            break;
        case 2:
            ftalk = f2;
            break;
        case 3:
            ftalk = f3;
            break;        
        case 4:
            ftalk = f4;    
            nextmap_selected = MISSION4;
            break;            
    }
    sound (self, CHAN_VOICE, "boss/bossblah.wav", 1, ATTN_NORM);
    centerprint(self.oldenemy, ftalk);
};

void() npc_mission4_start = {
    setmodel(self,"progs/invisible.spr");    

    self.think = npc_mission4_stand1;
    self.nextthink = time + 0.1;
    self.movetype = MOVETYPE_TOSS;
    setsize (self, '-16 -16 -24', '16 16 40');
    self.solid = SOLID_BBOX;
    self.dialog_stage = 1;
    self.th_talk = npc_mission4_talk;
    self.skin = 0;
    


};


void() npc_mission4_precache = {
    precache_model ("progs/player.mdl");
    precache_sound("boss/bossblah.wav");
};


void() npc_mission4 = {
    npc_mission4_precache();
    npc_mission4_start();
};