
void () DoAdmin = {
}

void () CheckAdmin = {

}

void() AdminCommandsList = {
	sprint(self, PRINT_HIGH, "kick ... Kick a player\n");
}

void() AdminKick = {
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

void() AdminImpulseCommand = {
}
