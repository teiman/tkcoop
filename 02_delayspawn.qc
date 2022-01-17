

/* -------------------------------------------------*/
/**
 * Delay spawning some monsters to check conditions like if 
 * it is stuck with other monster
 **/



 void() DelaySpawn_Start = {    
    local entity head;
    local void() start = find_function(self.classname,"_start","");
    
    head = findradius(self.origin, 100);
    while (head){

        if( (head.flags & FL_MONSTER) && head != self){
            dprint("WARNING: Two monsters in the same place, last one supressed\n");
            remove(self);
            return;
        }

        head = head.chain;    
    }

    start();
}


void() DelaySpawn = {
    local void() precache;
    local void() start;
    
    precache = find_function(self.classname,"_precache","");
    start = find_function(self.classname,"_precache","");

    if(!precache){
        dprint("Trying to delay spawn for ");
        dprint(self.classname);
        dprint(" withouth _precache\n");
        return;
    }
    if(!start){
        dprint("Trying to delay spawn for ");
        dprint(self.classname);
        dprint(" withouth _start\n");
        return;
    }

    precache();

    self.nextthink = time + 0.1;
    self.think = DelaySpawn_Start;
};
