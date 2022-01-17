
void() monster_ogre_precache;
void() npc_sorcer_precache;

void () World_precache = {

	precache_file ("progs.dat");
	precache_file ("gfx.wad");
	precache_file ("quake.rc");
	precache_file ("default.cfg");

	precache_file ("end1.bin");
	precache_file2 ("end2.bin");

	precache_file ("demo1.dem");
	precache_file ("demo2.dem");
	precache_file ("demo3.dem");

//
// these are all of the lumps from the cached.ls files
//
	precache_file ("gfx/palette.lmp");
	precache_file ("gfx/colormap.lmp");

	precache_file2 ("gfx/pop.lmp");

	precache_file ("gfx/complete.lmp");
	precache_file ("gfx/inter.lmp");

	precache_file ("gfx/ranking.lmp");
	precache_file ("gfx/vidmodes.lmp");
	precache_file ("gfx/finale.lmp");
	precache_file ("gfx/conback.lmp");
	precache_file ("gfx/qplaque.lmp");

	precache_file ("gfx/menudot1.lmp");
	precache_file ("gfx/menudot2.lmp");
	precache_file ("gfx/menudot3.lmp");
	precache_file ("gfx/menudot4.lmp");
	precache_file ("gfx/menudot5.lmp");
	precache_file ("gfx/menudot6.lmp");

	precache_file ("gfx/menuplyr.lmp");
	precache_file ("gfx/bigbox.lmp");
	precache_file ("gfx/dim_modm.lmp");
	precache_file ("gfx/dim_drct.lmp");
	precache_file ("gfx/dim_ipx.lmp");
	precache_file ("gfx/dim_tcp.lmp");
	precache_file ("gfx/dim_mult.lmp");
	precache_file ("gfx/mainmenu.lmp");
	
	precache_file ("gfx/box_tl.lmp");
	precache_file ("gfx/box_tm.lmp");
	precache_file ("gfx/box_tr.lmp");
	
	precache_file ("gfx/box_ml.lmp");
	precache_file ("gfx/box_mm.lmp");
	precache_file ("gfx/box_mm2.lmp");
	precache_file ("gfx/box_mr.lmp");
	
	precache_file ("gfx/box_bl.lmp");
	precache_file ("gfx/box_bm.lmp");
	precache_file ("gfx/box_br.lmp");
	
	precache_file ("gfx/sp_menu.lmp");
	precache_file ("gfx/ttl_sgl.lmp");
	precache_file ("gfx/ttl_main.lmp");
	precache_file ("gfx/ttl_cstm.lmp");
	
	precache_file ("gfx/mp_menu.lmp");
	
	precache_file ("gfx/netmen1.lmp");
	precache_file ("gfx/netmen2.lmp");
	precache_file ("gfx/netmen3.lmp");
	precache_file ("gfx/netmen4.lmp");
	precache_file ("gfx/netmen5.lmp");
	
	precache_file ("gfx/sell.lmp");
	
	precache_file ("gfx/help0.lmp");
	precache_file ("gfx/help1.lmp");
	precache_file ("gfx/help2.lmp");
	precache_file ("gfx/help3.lmp");
	precache_file ("gfx/help4.lmp");
	precache_file ("gfx/help5.lmp");

	precache_file ("gfx/pause.lmp");
	precache_file ("gfx/loading.lmp");

	precache_file ("gfx/p_option.lmp");
	precache_file ("gfx/p_load.lmp");
	precache_file ("gfx/p_save.lmp");
	precache_file ("gfx/p_multi.lmp");

// sounds loaded by C code
	precache_sound ("misc/menu1.wav");
	precache_sound ("misc/menu2.wav");
	precache_sound ("misc/menu3.wav");

	precache_sound ("ambience/water1.wav");
	precache_sound ("ambience/wind2.wav");

// shareware
	precache_file ("maps/start.bsp");

	precache_file ("maps/e1m1.bsp");
	precache_file ("maps/e1m2.bsp");
	precache_file ("maps/e1m3.bsp");
	precache_file ("maps/e1m4.bsp");
	precache_file ("maps/e1m5.bsp");
	precache_file ("maps/e1m6.bsp");
	precache_file ("maps/e1m7.bsp");
	precache_file ("maps/e1m8.bsp");

// registered
	precache_file2 ("gfx/pop.lmp");

	precache_file2 ("maps/e2m1.bsp");
	precache_file2 ("maps/e2m2.bsp");
	precache_file2 ("maps/e2m3.bsp");
	precache_file2 ("maps/e2m4.bsp");
	precache_file2 ("maps/e2m5.bsp");
	precache_file2 ("maps/e2m6.bsp");
	precache_file2 ("maps/e2m7.bsp");

	precache_file2 ("maps/e3m1.bsp");
	precache_file2 ("maps/e3m2.bsp");
	precache_file2 ("maps/e3m3.bsp");
	precache_file2 ("maps/e3m4.bsp");
	precache_file2 ("maps/e3m5.bsp");
	precache_file2 ("maps/e3m6.bsp");
	precache_file2 ("maps/e3m7.bsp");

	precache_file2 ("maps/e4m1.bsp");
	precache_file2 ("maps/e4m2.bsp");
	precache_file2 ("maps/e4m3.bsp");
	precache_file2 ("maps/e4m4.bsp");
	precache_file2 ("maps/e4m5.bsp");
	precache_file2 ("maps/e4m6.bsp");
	precache_file2 ("maps/e4m7.bsp");
	precache_file2 ("maps/e4m8.bsp");

	precache_file2 ("maps/end.bsp");

	precache_file2 ("maps/dm1.bsp");
	precache_file2 ("maps/dm2.bsp");
	precache_file2 ("maps/dm3.bsp");
	precache_file2 ("maps/dm4.bsp");
	precache_file2 ("maps/dm5.bsp");
	precache_file2 ("maps/dm6.bsp");
};

void() System_precache = {
    // the area based ambient sounds MUST be the first precache_sounds
    
    // sounds used from C physics code
    precache_sound ("demon/dland2.wav");            // landing thud
    precache_sound ("misc/h2ohit1.wav");            // landing splash

    // setup precaches allways needed
    precache_sound ("items/itembk2.wav");           // item respawn sound
    precache_sound ("player/plyrjmp8.wav");         // player jump
    precache_sound ("player/land.wav");                     // player landing
    precache_sound ("player/land2.wav");            // player hurt landing
    precache_sound ("player/drown1.wav");           // drowning pain
    precache_sound ("player/drown2.wav");           // drowning pain
    precache_sound ("player/gasp1.wav");            // gasping for air
    precache_sound ("player/gasp2.wav");            // taking breath
    precache_sound ("player/h2odeath.wav");         // drowning death

    precache_sound ("misc/talk.wav");                       // talk
    precache_sound ("player/teledth1.wav");         // telefrag
    precache_sound ("misc/r_tele1.wav");            // teleport sounds
    precache_sound ("misc/r_tele2.wav");
    precache_sound ("misc/r_tele3.wav");
    precache_sound ("misc/r_tele4.wav");
    precache_sound ("misc/r_tele5.wav");
    precache_sound ("weapons/lock4.wav");           // ammo pick up
    precache_sound ("weapons/pkup.wav");            // weapon up
    precache_sound ("items/armor1.wav");            // armor up
    precache_sound ("weapons/lhit.wav");            //lightning
    precache_sound ("weapons/lstart.wav");          //lightning start
    precache_sound ("items/damage3.wav");

    precache_sound ("misc/power.wav");                      //lightning for boss

    // player gib sounds
    precache_sound ("player/gib.wav");                      // player gib sound
    precache_sound ("player/udeath.wav");           // player gib sound
    precache_sound ("player/tornoff2.wav");         // gib sound

    // player pain sounds

    precache_sound ("player/pain1.wav");
    precache_sound ("player/pain2.wav");
    precache_sound ("player/pain3.wav");
    precache_sound ("player/pain4.wav");
    precache_sound ("player/pain5.wav");
    precache_sound ("player/pain6.wav");

    // player death sounds
    precache_sound ("player/death1.wav");
    precache_sound ("player/death2.wav");
    precache_sound ("player/death3.wav");
    precache_sound ("player/death4.wav");
    precache_sound ("player/death5.wav");

    precache_sound ("boss1/sight1.wav");

    // ax sounds    
    precache_sound ("weapons/ax1.wav");                     // ax swoosh
    precache_sound ("player/axhit1.wav");           // ax hit meat
    precache_sound ("player/axhit2.wav");           // ax hit world

    precache_sound ("player/h2ojump.wav");          // player jumping into water
    precache_sound ("player/slimbrn2.wav");         // player enter slime
    precache_sound ("player/inh2o.wav");            // player enter water
    precache_sound ("player/inlava.wav");           // player enter lava
    precache_sound ("misc/outwater.wav");           // leaving water sound

    precache_sound ("player/lburn1.wav");           // lava burn
    precache_sound ("player/lburn2.wav");           // lava burn

    precache_sound ("misc/water1.wav");                     // swimming
    precache_sound ("misc/water2.wav");                     // swimming

    // Invulnerability sounds
    precache_sound ("items/protect.wav");
    precache_sound ("items/protect2.wav");
    precache_sound ("items/protect3.wav");


    precache_model ("progs/player.mdl");
    precache_model ("progs/eyes.mdl");
    precache_model ("progs/h_player.mdl");
    precache_model ("progs/gib1.mdl");
    precache_model ("progs/gib2.mdl");
    precache_model ("progs/gib3.mdl");

    precache_model ("progs/s_bubble.spr");  // drowning bubbles
    precache_model ("progs/s_explod.spr");  // sprite explosion

    precache_model ("progs/v_axe.mdl");
    precache_model ("progs/v_shot.mdl");//TODO: remove
    precache_model ("progs/v_nail.mdl");//TODO: remove
    precache_model ("progs/v_rock.mdl");//TODO: remove
    precache_model ("progs/v_shot2.mdl");//TODO: remove
    precache_model ("progs/v_nail2.mdl");
    precache_model ("progs/v_rock2.mdl");//TODO: remove
	precache_model ("progs/v_drink.mdl");

    precache_model ("progs/bolt.mdl");              // for lightning gun
    precache_model ("progs/bolt2.mdl");             // for lightning gun
    precache_model ("progs/bolt3.mdl");             // for boss shock
    precache_model ("progs/lavaball.mdl");  // for testing

    precache_model ("progs/missile.mdl");
    precache_model ("progs/grenade.mdl");
    precache_model ("progs/spike.mdl");
    precache_model ("progs/s_spike.mdl");

    precache_model ("progs/backpack.mdl");

    precache_model ("progs/zom_gib.mdl");

    precache_model ("progs/v_light.mdl");


    //
    // Setup light animation tables. 'a' is total darkness, 'z' is maxbright.
    //

    // 0 normal
    lightstyle(0, "m");

    // 1 FLICKER (first variety)
    lightstyle(1, "mmnmmommommnonmmonqnmmo");

    // 2 SLOW STRONG PULSE
    lightstyle(2, "abcdefghijklmnopqrstuvwxyzyxwvutsrqponmlkjihgfedcba");

    // 3 CANDLE (first variety)
    lightstyle(3, "mmmmmaaaaammmmmaaaaaabcdefgabcdefg");

    // 4 FAST STROBE
    lightstyle(4, "mamamamamama");

    // 5 GENTLE PULSE 1
    lightstyle(5,"jklmnopqrstuvwxyzyxwvutsrqponmlkj");

    // 6 FLICKER (second variety)
    lightstyle(6, "nmonqnmomnmomomno");

    // 7 CANDLE (second variety)
    lightstyle(7, "mmmaaaabcdefgmmmmaaaammmaamm");

    // 8 CANDLE (third variety)
    lightstyle(8, "mmmaaammmaaammmabcdefaaaammmmabcdefmmmaaaa");

    // 9 SLOW STROBE (fourth variety)
    lightstyle(9, "aaaaaaaazzzzzzzz");

    // 10 FLUORESCENT FLICKER
    lightstyle(10, "mmamammmmammamamaaamammma");

    // 11 SLOW PULSE NOT FADE TO BLACK
    lightstyle(11, "abcdefghijklmnopqrrqponmlkjihgfedcba");

    // styles 32-62 are assigned by the light program for switchable lights

    // 63 testing
    lightstyle(63, "a");
};



void() misc_scientist_precache = {
    precache_model("progs/misc/misc_scientist.mdl");
	precache_model("progs/h_zombie.mdl");
	precache_sound("zombie/z_gib.wav");
	precache_sound("scientist/allnominal.wav");
	precache_sound("scientist/alright.wav");
	precache_sound("scientist/asexpected.wav");
	precache_sound("scientist/c1a0_sci_crit2a.wav");
	precache_sound("scientist/cough.wav");
	precache_sound("scientist/cantbeserious.wav");
	precache_sound("scientist/c1a0_sci_stall.wav");
	precache_sound("scientist/sci_die1.wav");
	precache_sound("scientist/scream08.wav");
	precache_sound("scientist/scream23.wav");
	precache_sound("scientist/scream24.wav");
	precache_sound("scientist/sci_dragoff.wav");
	precache_sound("scientist/sci_fear6.wav");
	precache_sound("scientist/sci_fear7.wav");
	precache_sound("scientist/sci_fear8.wav");
	precache_sound("scientist/sci_fear13.wav");
	precache_sound("scientist/sci_fear15.wav");
	precache_sound("scientist/scream01.wav");
	precache_sound("scientist/scream06.wav");
	precache_sound("scientist/scream09.wav");
	precache_sound("scientist/scream10.wav");
	precache_sound("scientist/scream14.wav");
	precache_sound("scientist/scream15.wav");
	precache_sound("scientist/scream16.wav");
	precache_sound("scientist/scream17.wav");
	precache_sound("scientist/scream18.wav");
	precache_sound("scientist/scream19.wav");
	precache_sound("scientist/scream20.wav");
	precache_sound("scientist/scream22.wav");
	precache_sound("scientist/scream25.wav");
};

void() monster_demon1_precache = {
	precache_model ("progs/demon.mdl");
	precache_model ("progs/h_demon.mdl");

	precache_sound ("demon/ddeath.wav");
	precache_sound ("demon/dhit2.wav");
	precache_sound ("demon/djump.wav");
	precache_sound ("demon/dpain1.wav");
	precache_sound ("demon/idle1.wav");
	precache_sound ("demon/sight2.wav");
};

void() monster_army_precache = {	
	
	precache_model ("progs/soldier.mdl");
	precache_model ("progs/soldier_weapon.mdl");
	precache_model ("progs/h_guard.mdl");
	precache_model ("progs/gib1.mdl");
	precache_model ("progs/gib2.mdl");
	precache_model ("progs/gib3.mdl");

	precache_sound ("soldier/death1.wav");
	precache_sound ("soldier/idle.wav");
	precache_sound ("soldier/pain1.wav");
	precache_sound ("soldier/pain2.wav");
	precache_sound ("soldier/sattck1.wav");
	precache_sound ("soldier/sight1.wav");

	precache_sound ("player/udeath.wav");		// gib death
}	

void() monster_enforcer_precache = {
	precache_model2 ("progs/enforcer.mdl");
	precache_model2 ("progs/h_mega.mdl");
	precache_model2 ("progs/laser.mdl");

	precache_sound2 ("enforcer/death1.wav");
	precache_sound2 ("enforcer/enfire.wav");
	precache_sound2 ("enforcer/enfstop.wav");
	precache_sound2 ("enforcer/idle1.wav");
	precache_sound2 ("enforcer/pain1.wav");
	precache_sound2 ("enforcer/pain2.wav");
	precache_sound2 ("enforcer/sight1.wav");
	precache_sound2 ("enforcer/sight2.wav");
	precache_sound2 ("enforcer/sight3.wav");
	precache_sound2 ("enforcer/sight4.wav");
};



void() monster_fish_precache = {

	precache_model2 ("progs/fish.mdl");

	precache_sound2 ("fish/death.wav");
	precache_sound2 ("fish/bite.wav");
	precache_sound2 ("fish/idle.wav");
};

// called by worldspawn
void() W_Precache =
{
	precache_sound ("weapons/r_exp3.wav");  // new rocket explosion
	precache_sound ("weapons/rocket1i.wav");        // spike gun
	precache_sound ("weapons/sgun1.wav");
	precache_sound ("weapons/guncock.wav"); // player shotgun
	precache_sound ("weapons/ric1.wav");    // ricochet (used in c code)
	precache_sound ("weapons/ric2.wav");    // ricochet (used in c code)
	precache_sound ("weapons/ric3.wav");    // ricochet (used in c code)
	precache_sound ("weapons/spike2.wav");  // super spikes
	precache_sound ("weapons/tink1.wav");   // spikes tink (used in c code)
	precache_sound ("weapons/grenade.wav"); // grenade launcher
	precache_sound ("weapons/bounce.wav");          // grenade bounce
	precache_sound ("weapons/shotgn2.wav"); // super shotgun
	precache_model ("progs/w_spike.mdl");
	
	//Enforcer fire
	precache_model2 ("progs/laser.mdl");
	precache_sound2 ("enforcer/enfire.wav");
	precache_sound2 ("lazerin.wav");

	//Keys lotable
	precache_model ("progs/w_s_key.mdl");
	precache_model ("progs/m_s_key.mdl");
	precache_model ("progs/b_s_key.mdl");
	precache_model ("progs/w_g_key.mdl");
	precache_model ("progs/m_g_key.mdl");
	precache_model ("progs/b_g_key.mdl");
	precache_sound ("misc/medkey.wav");
	precache_sound ("misc/runekey.wav");
	precache_sound ("misc/basekey.wav");

	//Quad lotable
	precache_model ("progs/quaddama.mdl");
	precache_sound ("items/damage.wav");
	precache_sound ("items/damage2.wav");
	precache_sound ("items/damage3.wav");

	//ring lotable
	precache_model ("progs/invisibl.mdl");
	precache_sound ("items/inv1.wav");
	precache_sound ("items/inv2.wav");
	precache_sound ("items/inv3.wav");

	//Health lotable	
	precache_model("progs/vial.mdl");
	precache_model("progs/shard.mdl");

	precache_sound ("soldier/pain1.wav");
	precache_sound ("soldier/pain2.wav");	

	precache_model("progs/eye.mdl");

	precache_model("progs/orb.spr");
	precache_model("progs/fx.spr");

	//Boss
	precache_sound ("boss1/sight1.wav");
	precache_sound ("shalrath/attack2.wav");
	precache_model("progs/v_spike.mdl");

	//Shield
	precache_sound ("items/protect.wav");
	precache_sound ("items/protect2.wav");
	precache_sound ("items/protect3.wav");

	precache_sound ("horde1.wav");
	precache_sound ("horde2.wav");
	precache_sound ("horde3.wav");
	precache_sound ("horde4.wav");
	precache_sound ("horde5.wav");

	//Many uses
	precache_model("progs/invisible.spr");
	precache_model("progs/flag.mdl");
	precache_sound ("gousa.wav");
	
	precache_model("progs/artifact_tome.mdl");

	precache_model("progs/zasca.spr");

	//Generic monster to use everywhere
	monster_army_precache();
	monster_enforcer_precache();
	monster_fish_precache();
	monster_demon1_precache();
	misc_scientist_precache();

	npc_sorcer_precache();
};


