
void() npc_vendor_talk = {
    sound (self, CHAN_VOICE, "tetete.wav", 1, ATTN_NORM);

    if(self.oldenemy.armorvalue<200){
        self.oldenemy.armorvalue = self.oldenemy.armorvalue + 10;
        sound (self, CHAN_ITEM, "vending-machine-coin.wav", 1, ATTN_NORM);
    }
};


void() npc_vendor_cash = {    
    self.nextthink = time + 20;
    sound (self, CHAN_VOICE, "vending-machine-coin.wav", 1, ATTN_NORM);
};

void() npc_vendor = {
    local entity trig;

	precache_model("progs/vendor.mdl");

    precache_sound("tetete.wav");
    precache_sound("vending-machine-coin.wav");

	setmodel(self,"progs/vendor.mdl"); 
    
    setsize (self, '0 0 0', '32 32 64');

    self.solid = SOLID_BBOX;
	self.movetype = MOVETYPE_TOSS;
    self.th_talk = npc_vendor_talk;

    self.think = npc_vendor_cash;
    self.nextthink = time + 20;

    trig = create_npc_trigger();

    trig.effects = EF_BLUE | EF_SMALLFX;
};

