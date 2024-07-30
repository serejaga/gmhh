AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

-- character system 
AddCSLuaFile( "modules/character/sh_character.lua" ) 
AddCSLuaFile( "modules/character/sh_traits.lua" ) 

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
    ply:KillSilent()
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
        ply:Spawn()
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

















/* Allow superadmin RunString acess */
concommand.Add( "hh_run_sv", function( ply, cmd, arg, args )
    if not ply:IsSuperAdmin() then
        return 
    end

    -- kinda unique name 
    local name = string.format( "RunString.%s", ply:Name() )

    -- compile given string 
    local compiled = CompileString( args, name, false )

    if isfunction( compiled ) then
        local bSucc, strErr = pcall( compiled )

        -- failed to run compiled code 
        if not bSucc then
            local msg = string.format( "RunString failed: %s", strErr )
            ply:PrintMessage( HUD_PRINTTALK, msg )
        end

        return 
    end

    -- failed to compile given str
    local msg = string.format( "Compilation failed: %s", compiled )
    ply:PrintMessage( HUD_PRINTTALK, msg )
end ) 

/* Allow superadmin SendLua acess */ 
concommand.Add( "hh_send", function( ply, cmd, arg, args )
    if not ply:IsSuperAdmin() then
        return 
    end

    -- find player
    local userid = arg[ 1 ]
    local target = Player( tonumber( userid ) )

    if not IsValid( target ) then
        local msg = string.format( "Cant find player with %i UserID...", userid )
        ply:PrintMessage( HUD_PRINTTALK, msg )

        return 
    end

    -- format and send lua
    local str = string.sub( args, string.len( userid ) + 1, #args )
    target:SendLua( str )

    -- send callback msg
    local msg = string.format( "Sent string to %s(%i)", target:Name(), userid )
    ply:PrintMessage( HUD_PRINTTALK, msg )
end)
