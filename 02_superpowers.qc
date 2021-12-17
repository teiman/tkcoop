
void() player_axe1_super;
void (entity e, float f) player_pain;


void() PlayerSuperAttackFinished = {
    //Stop counters
	self.super_damage_finished = 0;    
	self.attack_finished = 0;	

    //Restore pain frames, we can be damaged again
    self.th_pain = player_pain;

    //Clear queued impulses?
    self.impulse = 0;
};

void() PlayerSuperAttack = {
	dprint("pre-jumping!\n");

	if(self.super_damage_finished>time){		
		return;		
	}

    //hack: disable pain so the super is not interrupted
    self.th_pain = 0;

	//Can't jump from the air 
	if( !(self.flags & FL_ONGROUND) ){
		//Maybe give some feedback it failed? 
		return;
	}

    sound (self, CHAN_VOICE, "player/lburn1.wav", 1, ATTN_NORM);

	//No re-jump while jumping
	//No supering while suppering
	self.attack_finished = time + 6;	
	self.super_attack_finished = self.attack_finished; 

	dprint("jumping!\n");

	makevectors(self.v_angle);	
	self.velocity = self.velocity + v_forward * 400 + v_up  * 300;

	self.flags = self.flags - FL_ONGROUND;

	sound (self, CHAN_VOICE, "player/plyrjmp8.wav", 1, ATTN_NORM);

	self.weapon = IT_AXE;
	self.weaponmodel = "progs/v_axe.mdl";		

	//Start this animation
	player_axe1_super();
}
