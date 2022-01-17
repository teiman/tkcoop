
float CCAM_SHOW = 1;
float CCAM_HIDE = 2;

void () player_shield1;
void () player_shield_off;


int(entity player) PlayerHasShield = {
    //Only players can use shield
    if(player.classname != "player")
        return FALSE;

    //We are using this flag     
    if(player.aflag == TRUE)
        return TRUE;

    return FALSE;    
};



void () CCamShieldToggle =  {
    local entity camera;
    local entity spot;

    if (self.aflag == FALSE) {
        self.aflag = TRUE;
        stuffcmd (self, "cl_camera_tpp 1\n");
        sprint (self,PRINT_LOW,"Chase Cam On\n");

        self.effects = self.effects | EF_BLUE;
        player_shield1();

        sound (self, CHAN_VOICE, "items/protect.wav", 1, ATTN_NORM);
    } else {
        self.aflag = FALSE;     
        stuffcmd (self, "cl_camera_tpp 0\n");
        sprint (self,PRINT_LOW,"Chase Cam Off\n");     

        if(self.effects & EF_BLUE)
        self.effects = self.effects - EF_BLUE;

        sound (self, CHAN_VOICE, "items/protect3.wav", 1, ATTN_NORM);

        player_shield_off();      
    }
};

