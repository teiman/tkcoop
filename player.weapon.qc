


void() PlayRandomRicochetSound = {
	float r;

	r = random();
	if(r<0.5){
		sound (other, CHAN_WEAPON, "weapons/ric1.wav", 1, ATTN_NORM);
	}else if (r<0.7){
		sound (other, CHAN_WEAPON, "weapons/ric2.wav", 1, ATTN_NORM);
	}else {
		sound (other, CHAN_WEAPON, "weapons/ric3.wav", 1, ATTN_NORM);
	}
};

void(vector org) TouchPow = {
    local entity t = spawn();
    
    t.think = SUB_Remove;    
    t.nextthink = time + 0.8;
    t.frame = 1;
	t.solid = SOLID_NOT;
    t.skin = SPR_VP_PARALLEL;
    setmodel(t,"progs/fx.spr");
	setorigin(t,org);	
};

void(vector org) TouchTink = {
    local entity t = spawn();
    
    t.think = SUB_Remove;    
    t.nextthink = time + 0.8;
    t.frame = 2;
	t.solid = SOLID_NOT;
    t.skin = SPR_VP_PARALLEL;
    setmodel(t,"progs/fx.spr");
	setorigin(t,org);	
};


void() T_LaserTouch = {
	local float     damg;
	local float extra_book;
	local float force = 1;

	if (other == self.owner)
		return;         // don't explode on owner

	if (self.voided) {
		return;
	}

    if(other.classname == "player"){
        return;
    }

	self.voided = 1;

	if (pointcontents(self.origin) == CONTENT_SKY){
		remove(self);
		return;
	}

	//dprint("HIT\n");

	//Push them	
	if(
		other.takedamage &&
		other.movetype != MOVETYPE_NONE && 
		other.movetype != MOVETYPE_PUSH && 
		other.movetype != MOVETYPE_NOCLIP
		){

		if(other.classname != "monster_supershambler"){
			setorigin (other, other.origin + '0 0 1');

			if (other.flags & FL_ONGROUND)
				other.flags = other.flags - FL_ONGROUND;
				
			//other.velocity = other.velocity + v_forward * 20 + '0 0 1';
			makevectors (other.v_angle);

			if(other.classname == "monster_demon1"){
				force = 8;
			}

			other.velocity = aim (other, 10000) + v_forward*100*force + v_up*(50 *force);
		}
	}

	extra_book = self.owner.book_level * 25 ;

	damg = 25 + random()*5 + extra_book;

	if(other.armorvalue >0){
		//dprint("Ricochet!\n");
		PlayRandomRicochetSound();

		self.think = SUB_Remove;
		self.nextthink = time + random();

		other.armorvalue = other.armorvalue - 10;
		if(other.armorvalue<0)
			other.armorvalue = 0;

		//if armour is too high, it does not even feel the byte
		if(self.armorvalue<90){			
			if (other.health){
				//dprint("Damage!\n");
				other.deathtype = "laser";
				T_Damage (other, self, self.owner, damg*0.1 );
				TouchTink(self.origin);
			}
		}else{
			TouchTink(self.origin);
		}
		return;			
	}

	if (other.health){
		other.deathtype = "laser";
		T_Damage (other, self, self.owner, damg );

		TouchPow(self.origin);
	}

	//sound (self, CHAN_WEAPON, "weapons/sgun1.wav", 1, ATTN_NORM);
	self.origin = self.origin - 8 * normalize(self.velocity);
	
	SUPERSPIKE(self.origin);
	remove(self);
};

void() W_FireLaser = {	
	local entity newmis;
		
	//sound (self, CHAN_WEAPON, "enforcer/enfire.wav", 0.4, ATTN_NORM);
	sound (self, CHAN_WEAPON, "lazerin.wav", 1, ATTN_NORM);	

	newmis = spawn ();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_FLYMISSILE;
	newmis.solid = SOLID_BBOX;

	if(random()>0.8){
		setmodel (newmis, "progs/laser.mdl");	
		//setmodel (newmis, "progs/orb.spr");			
	}

	//newmis.frame = random()*3;
	//newmis.skin = SPR_ORIENTED;//Tei: hack to force a orientation type for sprites
	//newmis.skin = SPR_TEI_TYPEHACK;//Tei: hack to force a orientation type for sprites
	//newmis.effects = newmis.effects | EF_RED;

	/*dprint("r=");
	dprint(ftos(newmis.frame));
	dprint("\n");*/

	//setmodel (newmis, "progs/orb.spr");	

	// set newmis speed     
	makevectors (self.v_angle);

	newmis.velocity = aim(self, 3000);
	newmis.velocity = newmis.velocity * 3000;
	newmis.angles = vectoangles(newmis.velocity);
	
	//newmis.angles = vectoangles('0 0 1');

	newmis.touch = T_LaserTouch;
	newmis.voided = 0;
	
	// set newmis duration
	newmis.nextthink = time + 0.5;
	newmis.think = SUB_Remove;
	newmis.classname = "laser";

	setsize (newmis, '0 0 0', '0 0 0');             	

	// lower origin 
	setorigin (newmis,self.origin + '0 0 8');
};


void(vector org) CreateTree = {
	local entity e;

	e = spawn();
	setmodel(e,"progs/tree_simple.mdl");
	setorigin(e, org);
}


//void(vector org) SpawnAngelHere;
void(vector org, float left) SpawnZasca;
void() SpawnAngel;

void() PlantUSAFlag =  {
	local entity flag;
	local vector plantzone;

	//dprint("Centerprint2...\n");
	//centerprint2(self, "Go USA!","GO USA!");

	//makevectors(self.angles);
	//plantzone = self.origin + v_forward * 100  ;
	//traceline(self.origin, plantzone, 1,self);


	//if(random()<0.5)
	//	SpawnZasca(plantzone, 1);
	//else		
	//	SpawnZasca(plantzone, 0);
	/*
	flag = spawn();
	setmodel(flag,"progs/flag.mdl");
	setorigin(flag,trace_endpos + '0 0 20' );
	*/		

	//SpawnAngel();


	GLOBAL_MISSION_STAGE = EPISODE1_COMPLETE | EPISODE2_COMPLETE | EPISODE3_COMPLETE ;

	/*
	dprint("x=");dprint(ftos(self.origin_x));dprint("\n");
	dprint("y=");dprint(ftos(self.origin_y));dprint("\n");
	dprint("z=");dprint(ftos(self.origin_z));dprint("\n");
	*/

	//LIGHTNING2(self.origin, '-1056 -1312 8' +'0 0 10');

	//CreateTree(plantzone);

	/*
	SpawnSorcerHere(trace_endpos + '0 0 20');	
    makevectors(self.angles);
    SpawnZasca(self.origin + v_right * -30,1);
    SpawnZasca(self.origin + v_right * 30,0);
	GUNSHOT(trace_endpos,10);
	sound (flag, CHAN_AUTO, "demon/dland2.wav", 1, ATTN_NORM);	
	sound (flag, CHAN_AUTO, "gousa.wav", 1, ATTN_NORM);		
	*/
	
};

