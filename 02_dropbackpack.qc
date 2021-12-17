

void(entity item) DropHasHealth = {	
    setmodel(item, "progs/vial.mdl");
    item.noise = "items/r_item1.wav";
    item.healamount = 5;
    item.healtype = 0;

    //item.effects = item.effects | EF_FLAG1;	
	item.cnt = 5;
	item.classname = "item_health";
    item.flags = 0;
    item.skin = 0;

    //setsize (item, '0 0 0', '0 0 0');
    setsize (item, '-2 -2 1', '2 2 16');


    setorigin (item, self.origin);
    item.solid = SOLID_BBOX;

    item.avelocity = '300 300 300';
    item.velocity_z = 200;

	item.touch = health_touch;
	item.nextthink = time + 3;    // items start after other solids
	item.think = PlaceItem;	
};




void(entity item) DropHasKey = {
	if (world.worldtype == 0){			
		setmodel (item, "progs/w_s_key.mdl");
		item.netname = "silver key";
		item.noise = "misc/medkey.wav";
	} else if (world.worldtype == 1) {			
		setmodel (item, "progs/m_s_key.mdl");
		item.netname = "silver runekey";
		item.noise = "misc/runekey.wav";
	} else if (world.worldtype == 2) {			
		setmodel (item, "progs/b_s_key.mdl");
		item.netname = "silver keycard";
		item.noise = "misc/basekey.wav";
	}	

	item.touch = key_touch;
	item.items = IT_KEY1;
	setsize (item, '-16 -16 -24', '16 16 32');
	item.nextthink = time + 0.5;    // items start after other solids
	item.think = PlaceItem;	
};


void(entity item) DropHasQuad = {
	
	item.noise = "items/damage.wav";
	setmodel (item, "progs/quaddama.mdl");	
	item.netname = "Quad Damage";	
	item.items = IT_QUAD;	
	item.effects = item.effects | EF_BLUE;	
	item.cnt = 10;
	item.classname = "item_artifact_super_damage";

	setsize (item, '-16 -16 -24', '16 16 32');
	item.touch = powerup_touch;
	item.nextthink = time + 0.5;    // items start after other solids
	item.think = PlaceItem;	
};


void(entity item) DropHasRing = {	
	item.noise = "items/inv1.wav";
	setmodel (item, "progs/invisibl.mdl");
	item.netname = "Ring of Shadows";
	item.items = IT_INVISIBILITY;
	item.effects = item.effects | EF_BLUE;
	item.cnt = 10;
	item.classname = "item_artifact_invisibility";

	setsize (item, '-16 -16 -24', '16 16 32');
	item.touch = powerup_touch;
	item.nextthink = time + 0.5;    // items start after other solids
	item.think = PlaceItem;	
};

void(entity item) DropHasArmour = {	
	setmodel (item, "progs/shard.mdl");	
	item.cnt = 10;
	item.classname = "item_artifact_shard";
	item.noise = "items/armor1.wav";

	setsize (item, '-8 -1 0', '5 2 17');	

	item.touch = powerup_touch;
	item.nextthink = time + 0.5;    // items start after other solids
	item.think = PlaceItem;	
};


void(entity item) DropHasBackpack = {
    item.items = self.weapon;
    if (item.items == IT_AXE)
        item.netname = "Axe";
    else if (item.items == IT_SHOTGUN)
        item.netname = "Shotgun";
    else if (item.items == IT_SUPER_SHOTGUN)
        item.netname = "Double-barrelled Shotgun";
    else if (item.items == IT_NAILGUN)
        item.netname = "Nailgun";
    else if (item.items == IT_SUPER_NAILGUN)
        item.netname = "Super Nailgun";
    else if (item.items == IT_GRENADE_LAUNCHER)
        item.netname = "Grenade Launcher";
    else if (item.items == IT_ROCKET_LAUNCHER)
        item.netname = "Rocket Launcher";
    else if (item.items == IT_LIGHTNING)
        item.netname = "Thunderbolt";
    else
        item.netname = "";

    item.ammo_shells = self.ammo_shells;
    item.ammo_nails = self.ammo_nails;
    item.ammo_rockets = self.ammo_rockets;
    item.ammo_cells = self.ammo_cells;
    //item.health = 10;//Tei health a bit    //Tei: not neccesary anymore, spawns has secondary.
    
    setmodel (item, "progs/backpack.mdl");
    setsize (item, '-16 -16 0', '16 16 56');
    item.touch = BackpackTouch;	
};

entity(vector org) MakeDropableItem = {
    local entity item;

	item = spawn();
	item.origin = org;
	item.velocity_z = 300;
	item.velocity_x = -100 + (random() * 200);
	item.velocity_y = -100 + (random() * 200);

    item.flags = FL_ITEM;
    item.solid = SOLID_TRIGGER;
    //item.movetype = MOVETYPE_TOSS;

    item.movetype = MOVETYPE_BOUNCE;

    return item;
}


/*
===============
DropBackpack
===============
*/
void() DropBackpack = {
	local entity    item;
    local entity healthkit, shard;
	local float r;

	if (!(self.ammo_shells + self.ammo_nails + self.ammo_rockets + self.ammo_cells)){
		return; // nothing in it
    }

    item = MakeDropableItem(self.origin);
	r = random();

	if(r<0.1){
		r = random();
		if(r<0.3)
			DropHasQuad(item);
		else if (r<0.5)
			DropHasArmour(item);
		else if (r<0.8)
			DropHasRing(item);
		else
			DropHasKey(item);
	}else{
       // DropHasBackpack(item);
	}

	item.nextthink = time + 120;    // remove after 2 minutes
	item.think = SUB_Remove;

	if(random()<0.8){
		//Spawn healthkits    
		healthkit = MakeDropableItem(self.origin);
		DropHasHealth(healthkit);
	}else{
		//Spawn shard    
		shard = MakeDropableItem(self.origin);
		DropHasArmour(shard);
	}
};