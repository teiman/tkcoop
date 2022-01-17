

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

void()  npc_weaponsexpert_stand1;
void()  npc_weaponsexpert_stand2;
void()  npc_weaponsexpert_stand3;
void()  npc_weaponsexpert_stand4;
void()  npc_weaponsexpert_stand5;


void()  npc_weaponsexpert_stand1 =[        $stand1,       npc_weaponsexpert_stand2   ] { };
void()  npc_weaponsexpert_stand2 =[        $stand2,       npc_weaponsexpert_stand3   ] { };
void()  npc_weaponsexpert_stand3 =[        $stand3,       npc_weaponsexpert_stand4   ] { };
void()  npc_weaponsexpert_stand4 =[        $stand4,       npc_weaponsexpert_stand5   ] { };
void()  npc_weaponsexpert_stand5 =[        $stand5,       npc_weaponsexpert_stand1   ] { };




void() npc_weaponsexpert_talk =  {
    local string ftalk = "";
    local string f1 = "The new model of supernailgun\nhave a capture god soul";
    local string f2 = "This provide infinite ammo\nand a excellent damage";
    local string f3 = "On the Quake even we did not\n had weapons of this power";
    local string f4 = "The SN2 is the best\ncursed weapon ever designed";
    
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
            self.dialog_stage = 0;//will become 1 once incremented, creating the infinite loop dialog            
            break;             
    }

    self.dialog_stage = self.dialog_stage + 1;
    
    centerprint(self.oldenemy, ftalk);
};


void() npc_weaponsexpert = {
    precache_model ("progs/player.mdl");

    setmodel(self,"progs/player.mdl");

    self.think = npc_weaponsexpert_stand1;
    self.nextthink = time + 0.1;
    self.movetype = MOVETYPE_TOSS;
    setsize (self, '-16 -16 -24', '16 16 40');
    self.solid = SOLID_BBOX;
    self.th_talk = npc_weaponsexpert_talk;
    self.skin = PLAYERSKIN_ENFORCER2;

    create_npc_trigger();
};