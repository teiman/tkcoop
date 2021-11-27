/*
Experimental ending function =)
17.08.2004 - goq
*/

void arenawinners () {
local entity pl;

pl = find (world, classname, "player");
	while (pl != world)
	{
		//18.08.2004 goq - here i should make logic test for 2 most 'fraggy' guys


		pl = find (pl, classname, "player");
	}
global entity player1;
global entity player2;

player1 = winner;
player2 = winner2;

};

void clearserver () {

pl = find (world, classname, "player");
      while(pl != world)
      {
      if(pl != player1 or pl != player2)
      {
      sprintf(pl, PRINT_HIGH, "You are now moved to observe the final duel\n");
      stuffcmd(pl, "observe\n");
      }
      pl = find (pl, classname, "player");
      }
SetupArena();
};

void SetupArena () {
bprint(PRINT_HIGH, "The arena now comes up\n");


