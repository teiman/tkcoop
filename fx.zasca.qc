
void() ZascaFade = {
	self.frame = 1;
	self.nextthink = time + 0.2;
	self.think = SUB_Remove;
};


void() ZascaTouch = {
    if(other == self.owner)
        return;

    remove(self);
}


void(vector org, float left) SpawnZascaBase = {
	local entity z = spawn();
	local vector v;
	local float side;

	setmodel(z, "progs/zasca.spr");
	z.owner = self;
	z.movetype = MOVETYPE_FLYMISSILE;
	z.solid = SOLID_NOT;
	setorigin(z,org);

	z.angles = vectoangles('0 0 1');

	makevectors(self.angles);
	z.velocity = v_forward * 300;

	z.nextthink = time + 20;
	z.think = ZascaTouch;	
	z.skin = SPR_ORIENTED;

	if(left){		
		v = '0 0 5' ;
		v = v + v_right * -5 ;	
		v = -v;
	}else{
		v = '0 0 5' ;
		v = v + v_right * 5;	
	}

	z.angles = vectoangles( v );

	z.think = ZascaFade;
	z.nextthink = time + 0.5;
};

/**
 *  Wrapper of the original method that for convencience raise the origin
 */
void(vector org, float left) SpawnZasca = {
    SpawnZascaBase(org + '0 0 50', left);
};