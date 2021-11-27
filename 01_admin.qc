/*
Coop Admin
localinfo coop_admin_code ######
6 digits (0-9)
*/

void () DoAdmin =
{
	self.coop_admin = 1;
	self.check_admin = 0;
	sprint(self, PRINT_HIGH, "Enter admin code:\n");
}

void () CheckAdmin =
{
	if (self.impulse == 10) self.impulse = 0; // 10 is used for 0
	self.check_admin = self.check_admin * 10 + self.impulse;

	if (self.check_admin < 10) sprint(self, PRINT_HIGH, "5 more to go\n");
	else if (self.check_admin < 100) sprint(self, PRINT_HIGH, "4 more to go\n");
	else if (self.check_admin < 1000) sprint(self, PRINT_HIGH, "3 more to go\n");
	else if (self.check_admin < 10000) sprint(self, PRINT_HIGH, "2 more to go\n");
	else if (self.check_admin < 100000) sprint(self, PRINT_HIGH, "1 more to go\n");

	if (self.check_admin > 99999)
		if (self.check_admin == stof(infokey(world, "coop_admin_code"))) {
			bprint2(PRINT_HIGH, self.netname, " is now an admin\n");
			self.coop_admin = 2;
		} else {
			sprint(self, PRINT_HIGH, "Incorrect.\n");
			self.coop_admin = 0;
		}

	self.impulse = 0;
}

void() AdminCommandsList =
{
	sprint(self, PRINT_HIGH, "kick ... Kick a player\n");
}

void() AdminKick =
{
	local string uid;

	uid = infokey(self, "kick");

	if (uid == "") {
		stuffcmd(self, "users\n");
		sprint(self, PRINT_HIGH, "You must setinfo kick <userid> first!\n");
		return;
	}

	localcmd("kick ");
	localcmd(ftos(stof(uid))); // hacker protection
	localcmd("\n");
	stuffcmd(self, "setinfo kick \"\"\n");
}

void() AdminImpulseCommand =
{
	if (self.coop_admin < 2)
		return;

	if (self.impulse == 50)
		AdminKick();
}
