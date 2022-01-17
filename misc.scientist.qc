

void() scientist_work_sounds;
void() scientist_work;
void() scientist_die_sounds;
void() scientist_scared_sounds;
void() walkmonster_start_go;

.string type;
.float enemytargetlock;
.entity enemytarget;


entity() SUB_entEnemyTarget = {
	if (!self.enemy) {
		return (world);
	}

	if ((self.enemy.type == "enemytarget")) {
		if ((self.enemy.state == TRUE)) {
			return (self.enemy.enemy);
		} else {
			return (self.enemy);
		}
	} else {
		return (self.enemy);
	}
};

void() SUB_switchEnemyTarget = {
	if ((self.enemytarget.type != "enemytarget")) {
		return;
	}
	self.enemytarget.state = 2;
	self.enemy = self.enemytarget.enemy;
	self.enemytargetlock = (time + 2);
};


void(void() go_function) pacifist_start = {
	self.nextthink = (self.nextthink + (random() * 0.5));
	self.think = go_function;
};

void() walkpacifist_start = {
	pacifist_start(walkmonster_start_go);
};

void(entity attacker, float damage) SUB_NullPain = { };


void(float dist) ai_run_away =
{
	local entity enem;

	movedist = dist;
	enem = SUB_entEnemyTarget();
	if (((enem.health <= FALSE) || (enem.takedamage == FALSE)))
	{
		if ((self.enemy.type == "enemytarget"))
		{
			SUB_switchEnemyTarget();
		}
		self.enemy = world;
		if ((self.oldenemy.health > FALSE))
		{
			self.enemy = self.oldenemy;
		}	else{
			if (self.movetarget) {
				self.th_walk();
			} else	{
				self.th_stand();
			}
			return;
		}
	}

	self.show_hostile = (time + 1);

	enemy_vis = visible(enem);
	if (enemy_vis){
		self.search_time = (time + 5);
	}

	if ((coop && (self.search_time < time))){
		if (FindTarget()){
			return;
		}
	}

	if (self.goalentity.classname == "path_angry") {
		self.ideal_yaw = vectoyaw(self.origin - self.goalentity.origin);
	} else {
		self.ideal_yaw = vectoyaw(self.origin - enem.origin);
	}

	enemy_range = range(self.enemy);

	if (enemy_range >= 2){
		if (self.enemy.type == "enemytarget") {
			SUB_switchEnemyTarget();
		}
		self.enemy = world;
		self.pausetime = (time + 999999);
		self.th_stand();
		return;
	} else {
		if (enemy_range <= FALSE) {
			self.angles_y = self.ideal_yaw;
			walkmove(self.ideal_yaw, dist);
			return;
		}
	}
	movetogoal(dist);
};

void() scientist_work_a_01 = [ 0, scientist_work_a_02 ]
{
	ai_stand();
	scientist_work_sounds();
};

void() scientist_work_a_02 = [ 1, scientist_work_a_03 ]
{
	ai_stand();
};

void() scientist_work_a_03 = [ 2, scientist_work_a_04 ]
{
	ai_stand();
};

void() scientist_work_a_04 = [ 3, scientist_work_a_05 ]
{
	ai_stand();
};

void() scientist_work_a_05 = [ 4, scientist_work_a_06 ]
{
	ai_stand();
};

void() scientist_work_a_06 = [ 5, scientist_work_a_07 ]
{
	ai_stand();
};

void() scientist_work_a_07 = [ 6, scientist_work_a_08 ]
{
	ai_stand();
};

void() scientist_work_a_08 = [ 7, scientist_work_a_09 ]
{
	ai_stand();
};

void() scientist_work_a_09 = [ 8, scientist_work_a_10 ]
{
	ai_stand();
};

void() scientist_work_a_10 = [ 9, scientist_work_a_11 ]
{
	ai_stand();
};

void() scientist_work_a_11 = [ 10, scientist_work_a_12 ]
{
	ai_stand();
};

void() scientist_work_a_12 = [ 11, scientist_work_a_13 ]
{
	ai_stand();
};

void() scientist_work_a_13 = [ 12, scientist_work_a_14 ]
{
	ai_stand();
};

void() scientist_work_a_14 = [ 13, scientist_work_a_15 ]
{
	ai_stand();
};

void() scientist_work_a_15 = [ 14, scientist_work_a_16 ]
{
	ai_stand();
};

void() scientist_work_a_16 = [ 15, scientist_work_a_01 ]
{
	ai_stand();
	scientist_work();
};

void() scientist_work_b_01 = [ 16, scientist_work_b_02 ]
{
	ai_stand();
	scientist_work_sounds();
};

void() scientist_work_b_02 = [ 17, scientist_work_b_03 ]
{
	ai_stand();
};

void() scientist_work_b_03 = [ 18, scientist_work_b_04 ]
{
	ai_stand();
};

void() scientist_work_b_04 = [ 19, scientist_work_b_05 ]
{
	ai_stand();
};

void() scientist_work_b_05 = [ 20, scientist_work_b_06 ]
{
	ai_stand();
};

void() scientist_work_b_06 = [ 21, scientist_work_b_07 ]
{
	ai_stand();
};

void() scientist_work_b_07 = [ 22, scientist_work_b_08 ]
{
	ai_stand();
};

void() scientist_work_b_08 = [ 23, scientist_work_b_09 ]
{
	ai_stand();
};

void() scientist_work_b_09 = [ 24, scientist_work_b_10 ]
{
	ai_stand();
};

void() scientist_work_b_10 = [ 25, scientist_work_b_01 ]
{
	ai_stand();
	scientist_work();
};

void() scientist_work_d_01 = [ 26, scientist_work_d_02 ]
{
	ai_stand();
	scientist_work_sounds();
};

void() scientist_work_d_02 = [ 27, scientist_work_d_03 ]
{
	ai_stand();
};

void() scientist_work_d_03 = [ 28, scientist_work_d_04 ]
{
	ai_stand();
};

void() scientist_work_d_04 = [ 29, scientist_work_d_05 ]
{
	ai_stand();
};

void() scientist_work_d_05 = [ 30, scientist_work_d_06 ]
{
	ai_stand();
};

void() scientist_work_d_06 = [ 31, scientist_work_d_07 ]
{
	ai_stand();
};

void() scientist_work_d_07 = [ 32, scientist_work_d_08 ]
{
	ai_stand();
};

void() scientist_work_d_08 = [ 33, scientist_work_d_09 ]
{
	ai_stand();
};

void() scientist_work_d_09 = [ 34, scientist_work_d_10 ]
{
	ai_stand();
};

void() scientist_work_d_10 = [ 35, scientist_work_d_11 ]
{
	ai_stand();
};

void() scientist_work_d_11 = [ 36, scientist_work_d_12 ]
{
	ai_stand();
};

void() scientist_work_d_12 = [ 37, scientist_work_d_13 ]
{
	ai_stand();
};

void() scientist_work_d_13 = [ 38, scientist_work_d_14 ]
{
	ai_stand();
};

void() scientist_work_d_14 = [ 39, scientist_work_d_15 ]
{
	ai_stand();
};

void() scientist_work_d_15 = [ 40, scientist_work_d_16 ]
{
	ai_stand();
};

void() scientist_work_d_16 = [ 41, scientist_work_d_17 ]
{
	ai_stand();
};

void() scientist_work_d_17 = [ 42, scientist_work_d_18 ]
{
	ai_stand();
};

void() scientist_work_d_18 = [ 43, scientist_work_d_19 ]
{
	ai_stand();
};

void() scientist_work_d_19 = [ 44, scientist_work_d_20 ]
{
	ai_stand();
};

void() scientist_work_d_20 = [ 45, scientist_work_d_21 ]
{
	ai_stand();
};

void() scientist_work_d_21 = [ 46, scientist_work_d_22 ]
{
	ai_stand();
};

void() scientist_work_d_22 = [ 47, scientist_work_d_23 ]
{
	ai_stand();
};

void() scientist_work_d_23 = [ 48, scientist_work_d_24 ]
{
	ai_stand();
};

void() scientist_work_d_24 = [ 49, scientist_work_d_25 ]
{
	ai_stand();
};

void() scientist_work_d_25 = [ 50, scientist_work_d_26 ]
{
	ai_stand();
};

void() scientist_work_d_26 = [ 51, scientist_work_d_27 ]
{
	ai_stand();
};

void() scientist_work_d_27 = [ 52, scientist_work_d_28 ]
{
	ai_stand();
};

void() scientist_work_d_28 = [ 53, scientist_work_d_29 ]
{
	ai_stand();
};

void() scientist_work_d_29 = [ 54, scientist_work_d_30 ]
{
	ai_stand();
};

void() scientist_work_d_30 = [ 55, scientist_work_d_31 ]
{
	ai_stand();
};

void() scientist_work_d_31 = [ 56, scientist_work_d_32 ]
{
	ai_stand();
};

void() scientist_work_d_32 = [ 57, scientist_work_d_33 ]
{
	ai_stand();
};

void() scientist_work_d_33 = [ 58, scientist_work_d_34 ]
{
	ai_stand();
};

void() scientist_work_d_34 = [ 59, scientist_work_d_35 ]
{
	ai_stand();
};

void() scientist_work_d_35 = [ 60, scientist_work_d_36 ]
{
	ai_stand();
};

void() scientist_work_d_36 = [ 61, scientist_work_d_37 ]
{
	ai_stand();
};

void() scientist_work_d_37 = [ 62, scientist_work_d_38 ]
{
	ai_stand();
};

void() scientist_work_d_38 = [ 63, scientist_work_d_39 ]
{
	ai_stand();
};

void() scientist_work_d_39 = [ 64, scientist_work_d_40 ]
{
	ai_stand();
};

void() scientist_work_d_40 = [ 65, scientist_work_d_41 ]
{
	ai_stand();
};

void() scientist_work_d_41 = [ 66, scientist_work_d_42 ]
{
	ai_stand();
};

void() scientist_work_d_42 = [ 67, scientist_work_d_43 ]
{
	ai_stand();
};

void() scientist_work_d_43 = [ 68, scientist_work_d_44 ]
{
	ai_stand();
};

void() scientist_work_d_44 = [ 69, scientist_work_d_45 ]
{
	ai_stand();
};

void() scientist_work_d_45 = [ 70, scientist_work_d_46 ]
{
	ai_stand();
};

void() scientist_work_d_46 = [ 71, scientist_work_d_01 ]
{
	ai_stand();
	scientist_work();
};

void() scientist_work =
{
	local float rng;

	rng = random();
	if (rng < 0.3) {
		scientist_work_d_01();
	} else {
		if (rng < 0.6){
			scientist_work_b_01();
		}else {
			scientist_work_a_01();
		}
	}
};

void() scientist_death_01 = [ 72, scientist_death_02 ]
{
	self.solid = FALSE;
};

void() scientist_death_02 = [ 73, scientist_death_03 ]
{
	scientist_die_sounds();
};

void() scientist_death_03 = [ 74, scientist_death_04 ]
{
};

void() scientist_death_04 = [ 75, scientist_death_05 ]
{
};

void() scientist_death_05 = [ 76, scientist_death_06 ]
{
};

void() scientist_death_06 = [ 77, scientist_death_07 ]
{
};

void() scientist_death_07 = [ 78, scientist_death_08 ]
{
};

void() scientist_death_08 = [ 79, scientist_death_09 ]
{
};

void() scientist_death_09 = [ 80, scientist_death_10 ]
{
};

void() scientist_death_10 = [ 81, scientist_death_11 ]
{
};

void() scientist_death_11 = [ 82, scientist_death_12 ]
{
};

void() scientist_death_12 = [ 83, scientist_death_12 ]
{
};

void() scientist_walk_01 = [ 84, scientist_walk_02 ]
{
	ai_walk(MOVETYPE_STEP);
};

void() scientist_walk_02 = [ 85, scientist_walk_03 ]
{
	ai_walk(MOVETYPE_WALK);
};

void() scientist_walk_03 = [ 86, scientist_walk_04 ]
{
	ai_walk(MOVETYPE_WALK);
};

void() scientist_walk_04 = [ 87, scientist_walk_05 ]
{
	ai_walk(MOVETYPE_WALK);
};

void() scientist_walk_05 = [ 88, scientist_walk_06 ]
{
	ai_walk(MOVETYPE_STEP);
};

void() scientist_walk_06 = [ 89, scientist_walk_07 ]
{
	ai_walk(MOVETYPE_STEP);
};

void() scientist_walk_07 = [ 90, scientist_walk_08 ]
{
	ai_walk(MOVETYPE_FLY);
};

void() scientist_walk_08 = [ 91, scientist_walk_09 ]
{
	ai_walk(MOVETYPE_STEP);
};

void() scientist_walk_09 = [ 92, scientist_walk_10 ]
{
	ai_walk(3);
};

void() scientist_walk_10 = [ 93, scientist_walk_11 ]
{
	ai_walk(2);
};

void() scientist_walk_11 = [ 94, scientist_walk_12 ]
{
	ai_walk(3);
};

void() scientist_walk_12 = [ 95, scientist_walk_01 ]
{
	ai_walk(3);
};

void() scientist_run_away_01 = [ 96, scientist_run_away_02 ]
{
	ai_run_away(30);
	scientist_scared_sounds();
};

void() scientist_run_away_02 = [ 98, scientist_run_away_03 ]
{
	ai_run_away(30);
};

void() scientist_run_away_03 = [ 106, scientist_run_away_04 ]
{
	ai_run_away(30);
};

void() scientist_run_away_04 = [ 104, scientist_run_away_01 ]
{
	ai_run_away(30);
};

void() scientist_duck_01 = [ 108, scientist_duck_02 ]
{
};

void() scientist_duck_02 = [ 109, scientist_duck_03 ]
{
};

void() scientist_duck_03 = [ 110, scientist_duck_04 ]
{
};

void() scientist_duck_04 = [ 111, scientist_duck_05 ]
{
};

void() scientist_duck_05 = [ 112, scientist_duck_06 ]
{
};

void() scientist_duck_06 = [ 113, scientist_cower_01 ]
{
};

void() scientist_cower_01 = [ 114, scientist_cower_02 ]
{
};

void() scientist_cower_02 = [ 115, scientist_cower_01 ]
{
};

void() scientist_work_sounds =
{
	local float rng;


	if ((time < self.aflag))
	{
		return;
	}
	rng = random();

	if ((rng >= 0.3))
	{
		return;
	}
	rng = random();
	if ((rng < 0.125))
	{
		sound(self, 2, "scientist/allnominal.wav", TRUE, 2);
	}
	else
	{
		if ((rng < 0.25))
		{
			sound(self, 2, "scientist/alright.wav", TRUE, 2);
		}
		else
		{
			if ((rng < 0.375))
			{
				sound(self, 2, "scientist/asexpected.wav", TRUE, 2);
			}
			else
			{
				if ((rng < 0.5))
				{
					sound(self, 2, "scientist/c1a0_sci_crit2a.wav", TRUE, 2);
				}
				else
				{
					if ((rng < 0.625))
					{
						sound(self, 2, "scientist/cough.wav", TRUE, 2);
					}
					else
					{
						if ((rng < 0.75))
						{
							sound(self, 2, "scientist/cantbeserious.wav", TRUE, 2);
						}
						else
						{
							sound(self, 2, "scientist/c1a0_sci_stall.wav", TRUE, 2);
						}
					}
				}
			}
		}
	}
	
    self.aflag = (time + MOVETYPE_WALK);
};

void() scientist_scared_sounds =
{
	local float rng;

	if ((time < self.aflag))
	{
		return;
	}
	rng = random();
	if ((rng < 0.0555556))
	{
		sound(self, 2, "scientist/sci_fear6.wav", TRUE, TRUE);
	}
	else
	{
		if ((rng < 0.111111))
		{
			sound(self, 2, "scientist/sci_fear7.wav", TRUE, TRUE);
		}
		else
		{
			if ((rng < 0.166667))
			{
				sound(self, 2, "scientist/sci_fear8.wav", TRUE, TRUE);
			}
			else
			{
				if ((rng < 0.222222))
				{
					sound(self, 2, "scientist/sci_fear13.wav", TRUE, TRUE);
				}
				else
				{
					if ((rng < 0.277778))
					{
						sound(self, 2, "scientist/sci_fear15.wav", TRUE, TRUE);
					}
					else
					{
						if ((rng < 0.333333))
						{
							sound(self, 2, "scientist/scream01.wav", TRUE, TRUE);
						}
						else
						{
							if ((rng < 0.388889))
							{
								sound(self, 2, "scientist/scream06.wav", TRUE, TRUE);
							}
							else
							{
								if ((rng < 0.444444))
								{
									sound(self, 2, "scientist/scream09.wav", TRUE, TRUE);
								}
								else
								{
									if ((rng < 0.5))
									{
										sound(self, 2, "scientist/scream10.wav", TRUE, TRUE);
									}
									else
									{
										if ((rng < 0.555556))
										{
											sound(self, 2, "scientist/scream14.wav", TRUE, TRUE);
										}
										else
										{
											if ((rng < 0.611111))
											{
												sound(self, 2, "scientist/scream15.wav", TRUE, TRUE);
											}
											else
											{
												if ((rng < 0.666667))
												{
													sound(self, 2, "scientist/scream16.wav", TRUE, TRUE);
												}
												else
												{
													if ((rng < 0.722222))
													{
														sound(self, 2, "scientist/scream17.wav", TRUE, TRUE);
													}
													else
													{
														if ((rng < 0.777778))
														{
															sound(self, 2, "scientist/scream18.wav", TRUE, TRUE);
														}
														else
														{
															if ((rng < 0.833333))
															{
																sound(self, 2, "scientist/scream19.wav", TRUE, TRUE);
															}
															else
															{
																if ((rng < 0.888889))
																{
																	sound(self, 2, "scientist/scream20.wav", TRUE, TRUE);
																}
																else
																{
																	if ((rng < 0.944444))
																	{
																		sound(self, 2, "scientist/scream22.wav", TRUE, TRUE);
																	}
																	else
																	{
																		sound(self, 2, "scientist/scream25.wav", TRUE, TRUE);
																	}
																}
															}
														}
													}
												}
											}
										}
									}
								}
							}
						}
					}
				}
			}
		}
	}
	self.aflag = (time + MOVETYPE_WALK);
};

void() scientist_die_sounds =
{
	local float rng;

	rng = random();
	if ((rng < 0.2))
	{
		sound(self, 2, "scientist/sci_die1.wav", TRUE, TRUE);
	}
	else
	{
		if ((rng < 0.4))
		{
			sound(self, 2, "scientist/scream08.wav", TRUE, TRUE);
		}
		else
		{
			if ((rng < 0.6))
			{
				sound(self, 2, "scientist/scream23.wav", TRUE, TRUE);
			}
			else
			{
				if ((rng < 0.8))
				{
					sound(self, 2, "scientist/scream24.wav", TRUE, TRUE);
				}
				else
				{
					sound(self, 2, "scientist/sci_dragoff.wav", TRUE, TRUE);
				}
			}
		}
	}
};

void() scientist_die =
{
	if (((self.health < -15) || (random() < 0.2)))
	{
		sound(self, 2, "zombie/z_gib.wav", TRUE, TRUE);
		self.skin = 0;
		ThrowHead("progs/h_zombie.mdl", self.health);
		ThrowGib("progs/gib1.mdl", self.health);
		ThrowGib("progs/gib2.mdl", self.health);
		ThrowGib("progs/gib3.mdl", self.health);
		return;
	}
	scientist_death_01();
};


void() misc_scientist_start = {

	self.solid = MOVETYPE_WALK;
	self.movetype = MOVETYPE_STEP;
	//self.flags = (self.flags | FL_PACIFIST);
	setmodel(self, "progs/misc/misc_scientist.mdl");
	setsize(self, VEC_HULL_MIN, '16 16 40');
	self.health = 15;
	self.th_stand = scientist_work;
	self.th_walk = scientist_walk_01;
	self.th_run = scientist_run_away_01;
	self.th_melee = SUB_Null;
	self.th_pain = SUB_NullPain;
	self.th_die = scientist_die;

	walkpacifist_start();
};

void() misc_scientist = {
    misc_scientist_precache(); //unnecesary, always called 
    misc_scientist_start();
};