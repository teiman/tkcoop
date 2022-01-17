
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

void()  npc_orientation_stand1;
void()  npc_orientation_stand2;
void()  npc_orientation_stand3;
void()  npc_orientation_stand4;
void()  npc_orientation_stand5;


void()  npc_orientation_stand1 =[        $stand1,       npc_orientation_stand2   ] { };
void()  npc_orientation_stand2 =[        $stand2,       npc_orientation_stand3   ] { };
void()  npc_orientation_stand3 =[        $stand3,       npc_orientation_stand4   ] { };
void()  npc_orientation_stand4 =[        $stand4,       npc_orientation_stand5   ] { };
void()  npc_orientation_stand5 =[        $stand5,       npc_orientation_stand1   ] { };


void() npc_orientation_talk = {
    
    
    centerprint(self.oldenemy, "Analizing...");

    dprint("------\n");
    dprint("Completed by ");
    dprint(self.oldenemy.netname);
    dprint("\n");
    if(self.oldenemy.mission_stage & EPISODE1_COMPLETE){
        dprint("- Mission 1\n");
    }
    if(self.oldenemy.mission_stage & EPISODE2_COMPLETE){
        dprint("- Mission 2\n");
    }
    if(self.oldenemy.mission_stage & EPISODE3_COMPLETE){
        dprint("- Mission 3\n");
    }
    dprint("------\n");
};

void() npc_orientation_start = {
    setmodel(self,"progs/player.mdl");    

    self.think = npc_orientation_stand1;
    self.nextthink = time + 0.1;
    self.movetype = MOVETYPE_TOSS;
    setsize (self, '-16 -16 -24', '16 16 40');

    self.solid = SOLID_BBOX;
    self.dialog_stage = 1;
    self.th_talk = npc_orientation_talk;
    self.skin = PLAYERSKIN_ENFORCER1;
    self.effects = self.effects | EF_BOSS;

    create_npc_trigger();
};


void() npc_orientation_precache = {
    precache_model ("progs/player.mdl");
    precache_sound("boss/bossblah.wav");
};


void() npc_orientation = {
    npc_orientation_precache();
    npc_orientation_start();
};