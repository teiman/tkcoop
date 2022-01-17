
/**
 *  
 *  Mark dead mobs for deletion. 
 *  Generally is unnecesary, but may be in use in large fights with bosses
 * 
 */

/*-------------------------*/

.float marked_deletion;

//var float global_enemy_count = 0;

void(entity e) GC_CheckDeletion ={
    if(e.health>0)
        return;

    if(!e.marked_deletion){
        e.marked_deletion = time + 3;
    }

    if(e.marked_deletion && e.marked_deletion<time){
        e.think = SUB_Remove;
        e.nextthink = time + 0.1;
        //dprint("mob eliminado\n");
    }
};

void(entity e) GC_CheckDeletionItem = {
    if(e.solid == SOLID_NOT){
        return;
    }

    if(!e.marked_deletion){
        e.marked_deletion = time + 3;
    }

    if(e.marked_deletion && e.marked_deletion<time){
        e.think = SUB_Remove;
        e.nextthink = time + 0.1;
        //dprint("item eliminado\n");
    }
};


void() GarbageCollector = {
    local entity p;    
    local float armycount = 0;
    local float enforcercount = 0;

    if(1){
        p = find(world, classname, "monster_army");    
        while (p != world){                  
            if(p.health>0)
                armycount++;

            GC_CheckDeletion(p);
            p = find(p, classname, "monster_army");         
        }
    }


    if(1){
        p = find(world, classname, "monster_enforcer");    
        while (p != world){                  
            if(p.health>0)
                enforcercount++;

            GC_CheckDeletion(p);
            p = find(p, classname, "monster_enforcer"); 
        }
    }

    if(1){
        p = find(world, classname, "monster_demon1");    
        while (p != world){                  
            GC_CheckDeletion(p);
            p = find(p, classname, "monster_demon1"); 
        }
    }
    
    if(1){
        p = find(world, classname, "item_artifact_shard");  
        if(p)  
        while (p != world){                  
            GC_CheckDeletionItem(p);
            p = find(p, classname, "item_artifact_shard"); 
        }
    }

    if(1){
        p = find(world, classname, "item_artifact_super_damage");  
        if(p)  
        while (p != world){                  
            GC_CheckDeletionItem(p);
            p = find(p, classname, "item_artifact_super_damage"); 
        }
    }

    
    if(1){
        p = find(world, classname, "item_artifact_invisibility");  
        if(p)  
        while (p != world){                  
            GC_CheckDeletionItem(p);
            p = find(p, classname, "item_artifact_invisibility"); 
        }
    }


    if(1){
        p = find(world, classname, "item_health");  
        if(p)  
        while (p != world){                  
            GC_CheckDeletionItem(p);
            p = find(p, classname, "item_health"); 
        }
    }

    if(1){
        p = find(world, classname, "item_key");  
        if(p)  
        while (p != world){                  
            GC_CheckDeletionItem(p);
            p = find(p, classname, "item_key"); 
        }
    }

    
    if(1){
        p = find(world, classname, "item_book");  
        if(p)  
        while (p != world){                  
            GC_CheckDeletionItem(p);
            p = find(p, classname, "item_book"); 
        }
    }   

};

/*------------------------*/
