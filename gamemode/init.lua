AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

-- character system 
AddCSLuaFile( "modules/character/sh_character.lua" ) 
AddCSLuaFile( "modules/inv/cl/panelinv.lua" ) 
AddCSLuaFile( "modules/daynight/all/cl_init.lua" ) 
include( "modules/character/sh_character.lua" ) 
include( "modules/inv/sv/sv_loaddate.lua" ) 
include( "modules/inv/sv/sv_invfunc.lua" ) 
include( "modules/daynight/all/sv_init.lua" ) 

-- networking 
include( "modules/networking/sv_networking.lua" ) 

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

    -- default weapon for all players
    ply:Give( "weapon_fists" )
end

/* StartCommand: Allows you to change the players inputs before they are processed by the server. */
function GM:StartCommand( ply, CUserCmd )
    if commandQueue[ ply ] and not CUserCmd:IsForced() then
        commandQueue[ ply ] = false 
    end

    -- check for stamina
    ply.flLastOutOfStamina = ply.flLastOutOfStamina or 0
    local iStamina = ply:GetNWInt( "Stamina", 0 )

    if iStamina < 1 then
        CUserCmd:RemoveKey( IN_SPEED )
    end

    -- remove stamina points 
    local bInSpeed = CUserCmd:KeyDown( IN_SPEED )
    local flForwardMove, flSideMove = CUserCmd:GetForwardMove(), CUserCmd:GetSideMove()

    if bInSpeed and ( math.abs( flForwardMove ) > 0 or math.abs( flSideMove ) > 0 ) then
        iStamina = math.Approach( iStamina, 0, 1 )
        ply:SetNWInt( "Stamina", iStamina )

        if iStamina == 0 and ply.flLastOutOfStamina < SysTime() then
            ply.flLastOutOfStamina = SysTime()
        end
    elseif ( SysTime() - ply.flLastOutOfStamina ) > 5 then
        iStamina = math.Approach( iStamina, 100, 2 )
        ply:SetNWInt( "Stamina", iStamina )
    end
end

/* GetFallDamage: Called when a player takes damage from falling, allows to override the damage */
function GM:GetFallDamage( ply, iSpeed )
    return math.floor( iSpeed / 8 )
end