/*
 * misc_model.qc requires math.qc
 *
 * Author: Joshua Skelton joshua.skelton@gmail.com
 * Edited by: Inky 20201219 Minor changes for a better integration with my own code
 */

// Forward declarations
void() misc_model_think;

/*QUAKED misc_model (0 0.5 0.8) (-8 -8 -8) (8 8 8) X X X X X X X X NOT_ON_EASY NOT_ON_NORMAL NOT_ON_HARD_OR_NIGHTMARE NOT_IN_DEATHMATCH NOT_IN_COOP NOT_IN_SINGLEPLAYER X NOT_ON_HARD_ONLY NOT_ON_NIGHTMARE_ONLY
{
	model ({"path" : mdl, "skin" : skin, "frame": frame});
}
An entity for displaying models. A frame range can be given to animate the
model.

model:   The model to display. Can be of type mdl, bsp, or spr.
frame:   The frame to display (static models).
button0: Can be used to offset the animation.
button1: The starting frame of the animation.
button2: The last frame of the animation.
frags:   How long the animation frames last; default 0.05
*/

void() ShowMe = {	
	local entity e = checkclient();
	LIGHTNING2(self.origin,  e.origin );
	dprint(".\n");

	self.nextthink = time + 0.5;
};


void() MiscMark = {
	setmodel(self, "progs/player.mdl");	
	self.frame = 0;
	self.skin = 0;
	self.effects = EF_SMALLFX | EF_GREEN;
	TELEPORT(self.origin);

	self.nextthink = time + 1;
};

void() misc_model_debug = {    	
	local entity s;	

	s = spawn();
	precache_model("progs/tree_simple.mdl");
	setmodel(s, "progs/tree_simple.mdl");	
	setorigin(s, self.origin + '100 100 10');

	s.classname = "misc_model";	
	s.solid = SOLID_NOT;	    

	s.nextthink = time + 5;
	s.think = MiscMark;
};

void() misc_model = {

	precache_model(self.model);
    setmodel(self, self.model);

	setorigin(self, self.origin + '16 16 10');

	if (!self.frame) self.frame = self.button1;

    self.think = misc_model_think;	

	// Only animate if given a frame range
    if (!self.button2) {
		return;
	}

    if (self.button0) self.frame = self.button0;

    if (!self.frags) self.frags = 0.05; // Default animation speed

    self.nextthink = time + self.frags;	
};

void() misc_model_old = {
    

	self.classname = "misc_model";	
	self.solid = SOLID_NOT;

	if(!self.model){ 
		dprint("Misc_model withouth model\n");
		return;
	}
	
	precache_model(self.model);
    setmodel(self, self.model);	

	dprint("New misc_model with model [");
	dprint(self.model);
	dprint("]\n");	

	dprint("x=");dprint(ftos(self.origin_x));dprint("\n");
	dprint("y=");dprint(ftos(self.origin_y));dprint("\n");
	dprint("z=");dprint(ftos(self.origin_z));dprint("\n");

    if (!self.frame) self.frame = self.button1;

    self.think = misc_model_think;
	
	if(0){
		self.think = ShowMe;
		self.nextthink = time + 0.3;
		return;
	}

	// Only animate if given a frame range
    if (!self.button2) {
		return;
	}

    if (self.button0) self.frame = self.button0;

    if (!self.frags) self.frags = 0.05; // Default animation speed

    self.nextthink = time + self.frags;
};

/*
 * misc_model_think
 *
 * Handles animation for misc_model entity.
 */
void() misc_model_think = {
    self.nextthink = time + fabs(self.frags);
    self.frame = self.frame + sign(self.frags);
	
	if (self.spawnflags & /*Anim back & forth*/2 && self.frame < self.button1)
	{
		self.frags = -1 * self.frags;
		self.frame+=2;
	}
	else if (self.spawnflags & /*Anim back & forth*/2 && self.frame > self.button2)
	{
		self.frags = -1 * self.frags;
		self.frame-=2;
	}
	else
		self.frame = wrap(self.frame, self.button1, self.button2);
		
	if( self.frame==self.button2 && self.button2!=self.button1)
	{
		if(self.spawnflags & /*Only once*/1) self.nextthink = -1;
		if(self.target) SUB_UseTargets();
	}
};