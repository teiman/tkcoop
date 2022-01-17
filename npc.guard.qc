
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

void()  npc_guard_stand1;
void()  npc_guard_stand2;
void()  npc_guard_stand3;
void()  npc_guard_stand4;
void()  npc_guard_stand5;


void()  npc_guard_stand1 =[        $stand1,       npc_guard_stand2   ] { };
void()  npc_guard_stand2 =[        $stand2,       npc_guard_stand3   ] { };
void()  npc_guard_stand3 =[        $stand3,       npc_guard_stand4   ] { };
void()  npc_guard_stand4 =[        $stand4,       npc_guard_stand5   ] { };
void()  npc_guard_stand5 =[        $stand5,       npc_guard_stand1   ] { };


void()  npc_guard_talk = {
    local float r;

    r = random();

    if(r<0.3){
        centerprint(self.oldenemy, "Guard: Yeah");
        sound (self, CHAN_VOICE, "commando/yeah.wav", 1, ATTN_NORM);
    } else  if(r<0.6) {
        centerprint(self.oldenemy, "Guard: Yessir");
        sound (self, CHAN_VOICE, "commando/yessir.wav", 1, ATTN_NORM);
    }else{
        centerprint(self.oldenemy, "Guard: You!");
        sound (self, CHAN_VOICE, "commando/ptd.wav", 1, ATTN_NORM);
    }
};
    

void() npc_guard_start = {
    setmodel(self,"progs/player.mdl");    

    self.think = npc_guard_stand1;
    self.nextthink = time + 0.1;
    self.movetype = MOVETYPE_TOSS;
    //setsize(self,'-53 -47 -24', '46 37 48' );
    setsize (self, '-16 -16 -24', '16 16 40');
    self.solid = SOLID_BBOX;
    self.th_talk = npc_guard_talk;
    self.skin = PLAYERSKIN_GUARD;

    create_npc_trigger();
};

void() npc_guard_precache = {
    precache_model ("progs/player.mdl");

    precache_sound ("commando/yeah.wav");
    precache_sound ("commando/yessir.wav");
    precache_sound ("commando/ptd.wav");
};


void() npc_guard = {
    npc_guard_precache();
    npc_guard_start();
};