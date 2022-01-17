
.float next_alert_sound;

void() npc_announcer_think = {

    if(nextmap_isset()){
        //Normal warning
        sound (self, CHAN_VOICE, "alert.wav", 0.2, ATTN_NONE);
    }else{
        //Alert sound
        if(self.next_alert_sound < time){
            sound (self, CHAN_VOICE, "misc/2hours.wav", 0.2, ATTN_NONE);
            self.next_alert_sound = time + 20 *random() + 15;
        }
    }

    self.nextthink = time + 2;
};

void() npc_announcer_precache = {
    precache_sound("misc/2hours.wav");
    precache_sound("alert.wav");
    precache_sound("office2000.wav");
};

void() npc_announcer =  {
    npc_announcer_precache();

    ambientsound(self.origin,"office2000.wav", 0.3, ATTN_NONE);

    self.nextthink = time + 15;
    self.think = npc_announcer_think;
};