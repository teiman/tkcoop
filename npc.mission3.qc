
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

void()  npc_mission3_stand1;
void()  npc_mission3_stand2;
void()  npc_mission3_stand3;
void()  npc_mission3_stand4;
void()  npc_mission3_stand5;


void()  npc_mission3_stand1 =[        $stand1,       npc_mission3_stand2   ] { };
void()  npc_mission3_stand2 =[        $stand2,       npc_mission3_stand3   ] { };
void()  npc_mission3_stand3 =[        $stand3,       npc_mission3_stand4   ] { };
void()  npc_mission3_stand4 =[        $stand4,       npc_mission3_stand5   ] { };
void()  npc_mission3_stand5 =[        $stand5,       npc_mission3_stand1   ] { };


void() npc_mission3_talk = {
    local string f1 = "Ultron: I salute you, soldier";
    local string f2 = "Finnaly!.";
    local string f3 = "We have found the location\n of this creature.";
    local string f4 = "Use the Spipgate and kill\n their leader before\n they organize a army\nagainst us";
    local string ftalk;

    if( !(GLOBAL_MISSION_STAGE & EPISODE2_COMPLETE) ){
        centerprint(self.oldenemy, "Ultron: Hello soldier.");
        return;
    }

    if( GLOBAL_MISSION_STAGE & EPISODE3_COMPLETE ){
        centerprint(self.oldenemy, "Ultron: The general awaits\nyou in the slipgate");
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
            nextmap_selected = MISSION3;
            break;            
    }
    sound (self, CHAN_VOICE, "boss/bossblah.wav", 1, ATTN_NORM);
    centerprint(self.oldenemy, ftalk);
};

void() npc_mission3_start = {
    setmodel(self,"progs/player.mdl");    

    self.think = npc_mission3_stand1;
    self.nextthink = time + 0.1;
    self.movetype = MOVETYPE_TOSS;
    //setsize(self,'-53 -47 -24', '46 37 48' );
    setsize (self, '-16 -16 -24', '16 16 40');
    self.solid = SOLID_BBOX;
    self.dialog_stage = 1;
    self.th_talk = npc_mission3_talk;
    self.skin = PLAYERSKIN_GUARDBOSS;
    self.effects = self.effects | EF_BOSS;

    create_npc_trigger();
};


void() npc_mission3_precache = {
    precache_model ("progs/player.mdl");
    precache_sound("boss/bossblah.wav");
};


void() npc_mission3 = {
    npc_mission3_precache();
    npc_mission3_start();
};