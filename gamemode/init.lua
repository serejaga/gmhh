AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

-- character system 
AddCSLuaFile( "modules/character/sh_character.lua" ) 
include( "modules/character/sh_character.lua" ) 

-- server global table 
sv = sv or {}


/* Hooked events */
local hk = {}

/* PlayerInitialSpawn: Called when the player spawns for the first time. */
local commandQueue = {} -- wait for first command b4 player "actually spawns", some kind of spawn protection

function GM:PlayerInitialSpawn( ply, bTransition ) 
    commandQueue[ ply ] = true 
end

/* PlayerSpawn: Called whenever a player spawns, including respawns. */

function GM:PlayerSpawn( ply, bTransition )
    gm.char.OnSpawn( ply )

    ply:Give( "weapon_fists" )
end

/* StartCommand: Allows you to change the players inputs before they are processed by the server. */
function GM:StartCommand( ply, CUserCmd )
    if commandQueue[ ply ] and not CUserCmd:IsForced() then
        commandQueue[ ply ] = false 
    end
end