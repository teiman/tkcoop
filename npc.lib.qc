


void() npc_trigger_talk = {

    if(other.classname != "player")
        return;

    if(self.dialog_cooldown>time)        
        return;

    self.dialog_cooldown = time + 2;
    self.oldenemy = other;

    if(self.owner.th_talk){
        other.talkingtome = self;
        self.owner.th_talk();
    }    
};

/**
 * Creates a entity that speak for the character and does the triggering for that
 */
entity() create_npc_trigger = {
    local entity trig = spawn();

    makevectors(self.angles);    

    //setsize(trig, '0 0 0', '0 0 0');
    setsize (trig, '-16 -16 0', '16 16 56');

    setorigin(trig,self.origin + v_forward * 32 + '0 0 10');
    setmodel(trig,"progs/invisible.spr");
    //setmodel(trig,"progs/player.mdl");

    trig.solid = SOLID_TRIGGER;
    trig.touch = npc_trigger_talk;

    trig.owner = self;

    return trig;
};


/* ------------------------------------- */


/**
 * Checks if theres a map selected
 */
float() nextmap_isset = {
    if(!nextmap_selected || nextmap_selected == string_null ){
        return FALSE;
    }
    
    return TRUE;
};


/**
 *  The map was selected trough hacking is detected 
 */
float() is_hacked = {
    if(!nextmap_isset()){
        return FALSE;
    }

    switch(nextmap_selected){
        case MISSION1:
            return FALSE;
        case MISSION2:
            return FALSE;            
        case MISSION3:
            return FALSE;                        
    }

    return TRUE;
};
