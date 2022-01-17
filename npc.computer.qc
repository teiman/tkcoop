

void() npc_computer_randommap1 = {

    local float r = rint(random() * 7);

    switch(r){
        case 1:
            nextmap_selected = "e1m1";
            break;
        case 2:
            nextmap_selected = "e1m2";
            break;
        case 3:
            nextmap_selected = "e1m3";
            break;            
        case 4:
            nextmap_selected = "e1m4";
            break;
        case 5:
            nextmap_selected = "e1m5";
            break;
        case 6:
            nextmap_selected = "e1m6";
            break;  
        case 7:
            nextmap_selected = "e1m7";
            break;        
        case 8:
            nextmap_selected = "e1m8";
            break;                                    
    }
};

void() npc_computer_randommap2 = {

    local float r = rint(random() * 7);

    switch(r){
        case 1:
            nextmap_selected = "e2m1";
            break;
        case 2:
            nextmap_selected = "e2m2";
            break;
        case 3:
            nextmap_selected = "e2m3";
            break;            
        case 4:
            nextmap_selected = "e2m4";
            break;
        case 5:
            nextmap_selected = "e2m5";
            break;
        case 6:
            nextmap_selected = "e2m6";
            break;  
        case 7:
            nextmap_selected = "e2m7";
            break;                                          
    }
};


void() npc_computer_randommap3 = {

    local float r = rint(random() * 7);

    switch(r){
        case 1:
            nextmap_selected = "e3m1";
            break;
        case 2:
            nextmap_selected = "e3m2";
            break;
        case 3:
            nextmap_selected = "e3m3";
            break;            
        case 4:
            nextmap_selected = "e3m4";
            break;
        case 5:
            nextmap_selected = "e3m5";
            break;
        case 6:
            nextmap_selected = "e3m6";
            break;  
        case 7:
            nextmap_selected = "e3m7";
            break;                                          
    }
};

void() npc_computer_randommap4 = {

    local float r = rint(random() * 8);

    switch(r){
        case 1:
            nextmap_selected = "e4m1";
            break;
        case 2:
            nextmap_selected = "e4m2";
            break;
        case 3:
            nextmap_selected = "e4m3";
            break;            
        case 4:
            nextmap_selected = "e4m4";
            break;
        case 5:
            nextmap_selected = "e4m5";
            break;
        case 6:
            nextmap_selected = "e4m6";
            break;  
        case 7:
            nextmap_selected = "e4m7";
            break;                                          
        case 8:
            nextmap_selected = "e4m8";
            break;                            
    }
};


void() npc_computer_talk = {
    local float r;

    if(self.dialog_stage<5 ){
        centerprint(self.oldenemy, "HACKING...");
        sound (self, CHAN_VOICE, "typing.wav", 1, ATTN_NORM);
    }else if(self.dialog_stage == 5) {
        centerprint(self.oldenemy, "HACKED!");

        r = random();
        if(r<0.3){
            npc_computer_randommap1();
        }else if(r<0.5){
            npc_computer_randommap2();
        }else if(r<0.8){
            npc_computer_randommap3();
        }else{
            npc_computer_randommap4();
        }

        sound (self, CHAN_VOICE, "typing.wav", 1, ATTN_NORM);
        dprint("New map is ");
        dprint(nextmap_selected);
        dprint("\n");
    }else {
        centerprint(self.oldenemy, "Reseting.");
        nextmap_selected = string_null;
    }

    self.dialog_stage = self.dialog_stage + 1;

    if(self.dialog_stage>10){
        self.dialog_stage = 1;
    }
};


void() npc_computer = {
	precache_model("progs/computer.spr");
    precache_sound("typing.wav");

    setmodel(self,"progs/computer.spr");

    self.th_talk = npc_computer_talk;
    self.dialog_stage = 1;
    
    create_npc_trigger();

    //self.skin = SPR_ORIENTED;
    //self.angles = self.angles * -1;
};