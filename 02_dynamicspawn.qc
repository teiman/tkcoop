
void() monster_enforcer;
void() monster_army;
void (vector org, entity death_owner) spawn_tdeath;


void(vector origin, float distance) ClearLandingZone = {
	local entity head;
	local entity remove_me;
	   
    //Look if a enemy is too near 
    head = findradius(origin, distance);
    while (head){

		if(head.classname == "monster_enforcer"){
            remove_me = head;
        }
        if(head.classname == "monster_army"){
            remove_me = head;
        }

        head = head.chain;

		if(remove_me){
			remove(remove_me);
			remove_me = 0;//already removed
		}
    }

    
};

float() DynamicSpawnHere = {
    local float best;
    local float best_angle;
    local float t;

    local float valid_spawn = 1;
    local string chosen_monster = "monster_army";
    local void() spawn_function;

    local vector chosen_mins = '-16 -16 -24';
    local vector chosen_maxs = '16 16 40';
    
    local	entity	head;

    if(mapname == "start" || mapname=="hub1"){
        return 0;
    }
        
	if (pointcontents(self.origin) != CONTENT_EMPTY){
		return 0;
	}

    if(random()>0.8){
        spawn_function = monster_enforcer;
    }else {
        spawn_function = monster_army;
    }
   
    //Check if theres space for the spawn
    tracebox(self.origin, chosen_mins, chosen_maxs,self.origin, 1, self);

    if(trace_startsolid==1){
        return 0; 
    }

    ClearLandingZone(self.origin, 300);

    /* ------------- Final setup phase -------------------- */

    self.angles_y = random()*360;//test

    //Searching for a good angle where the mob is not looking at a wall, but some decent long distance
    best = 0;
    best_angle = self.angles_y;//save current angle as backup
    for(t=0;t<10;t++){
        self.angles_y = random()*360;//random angle to test

        makevectors(self.angles);
        traceline(self.origin, self.origin + v_forward * 600, 1, self);

        if(trace_fraction>best){ // is better
            best_angle = self.angles_y; //save better angle
            best = trace_fraction; //save best trace fraction so far
        }				
    }

    self.angles_y = best_angle;//use the best angle we found   

    spawn_function();

    return 1; // entity will be preserved
};


void() ConverToMonsterGenerator = {



}

