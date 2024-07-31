include( "shared.lua" ) 

-- character 
include( "modules/character/sh_character.lua" ) 
include( "modules/daynight/sh_daytime.lua" ) 

-- client global table 
cl = cl or { localplayer = NULL, stamina = 0, bDisabled = false }

/* extended surface rendering */
local surface = surface

-- surface.DrawSimpleText
function surface.DrawSimpleText( x, y, str )
    surface.SetTextPos( x, y )
    surface.DrawText( str )
end

/*  */

































/* HUD cant get disabled by the server */
cl.bDisabled = false 

net.Receive( "s2c.sethud", function()
    cl.bDisabled = net.ReadBool()
end )






























/* Cached IMaterial */
local gradient_down = Material( "vgui/gradient_down", "noclamp smooth" )
local gradient_up   = Material( "vgui/gradient_up", "noclamp smooth" )
local gradient      = Material( "vgui/gradient-l", "noclamp smooth" )

/* Screen resolution data */
cl.screen = { w = ScrW(), h = ScrH() }

/* OnScreenSizeChanged: Called when the player's screen resolution of the game changes */
function GM:OnScreenSizeChanged( oldW, oldH, newW, newH )
    cl.screen = { w = newW, h = newH }
end

/* Setup fonts */
surface.CreateFont( "SubjectIsDead", {
	font = "Roboto Bk", 
	size = 32,
	weight = 500,
	additive = true,
} )


/* HUDShouldDraw: Called when the Gamemode is about to draw a given element on the client's HUD */
local allowed = { ["CHudGMod"] = true, ["NetGraph"] = true }

function GM:HUDShouldDraw( str )
    return allowed[ str ]
end

/* HUDPaintBackground: Called before GM:HUDPaint when the HUD background is being drawn */
function GM:HUDPaintBackground()
    local screen = cl.screen

    -- prevent HUD rendering if server told so 
    if cl.bDisabled then
        surface.SetDrawColor( 0, 0, 0, 128 )
        surface.DrawRect( 0, 0, screen.w, screen.h )

        return 
    end

   













    -- render simple vignette
    local vignette_size = math.floor( screen.h / 6 )

    surface.SetDrawColor( 0, 0, 0, 128 )

    surface.SetMaterial( gradient_down )
    surface.DrawTexturedRect( 0, 0, screen.w, vignette_size )
    
    surface.SetMaterial( gradient_up )
    surface.DrawTexturedRect( 0, screen.h - vignette_size, screen.w, vignette_size )
end

/* HUDPaint: Called whenever the HUD should be drawn, this is the ideal place to draw custom HUD elements */
local health, armor, stamina, progress = 0, 0, 0, 0
function GM:HUDPaint()
    local ratio, alpha, time, str, tw, th
    local screen = cl.screen
    local x, y = math.floor( screen.w / 2 ), math.floor( screen.h / 2 )

    -- validate local player 
    local ply = LocalPlayer()

    if not IsValid( ply ) then
        return 
    end

    cl.localplayer = ply

    -- prevent farther hud rendering if player died 
    if not ply:Alive() then
        -- draw black rect 
        surface.SetDrawColor( 0, 0, 0, progress * 220 )
        surface.DrawRect( 0, 0, screen.w, screen.h )

        -- prepare to draw text
        surface.SetFont( "SubjectIsDead" )
        surface.SetTextColor( 150, 55, 55 )

        str = string.format( "Subject: %s", ply:Name() )
        tw, th = surface.GetTextSize( str )

        surface.SetTextPos( x - math.floor( tw / 2 ), y - math.floor( th / 2 ) )

        -- draw clipped text 
        x, y = surface.GetTextPos()

        render.SetScissorRect( x, y, x + math.ceil( tw * progress ), y + th, true )
            surface.DrawText( str )
        render.SetScissorRect( 0, 0, 0, 0, false )

        -- progress
        progress = math.Approach( progress, 1, FrameTime() / 5 )

        return 
    end

    progress = 0

    -- used to make blinking effect
    time = math.sin( SysTime() * 3 )

    -- health indicators 
    ratio = ply:Health() / ply:GetMaxHealth()
    health = Lerp( 0.05, health, ratio * 256 )
    health = math.Clamp( health, 0, 256 )

    surface.SetDrawColor( 16, 16, 16, 220 )
    surface.DrawRect( 24, screen.h - 32, 256, 16 )

    alpha = 72 + math.floor( time * 64 )
    surface.SetDrawColor( 255, 64, 64, alpha )
    surface.SetMaterial( gradient )
    surface.DrawTexturedRect( 28, screen.h - 36, 256, 16 )

    surface.SetDrawColor( 255, 255, 255 )
    surface.DrawRect( 28, screen.h - 36, health, 16 )

    -- armor indicator
    local iArmor = ply:Armor()
   
    if iArmor > 0 then
        ratio = iArmor / ply:GetMaxArmor()
        armor = Lerp( 0.05, armor, ratio * 256 )
        armor = math.Clamp( armor, 0, 256 )

        surface.SetDrawColor( 16, 16, 16, 220 )
        surface.DrawRect( 24, screen.h - 48, 256, 8 )
    
        surface.SetDrawColor( 175, 215, 255 )
        surface.DrawRect( 28, screen.h - 52, armor, 8 )
    else
        armor = 0
    end

    -- stamina indicator
    ratio = cl.stamina / 100
    stamina = Lerp( 0.05, stamina, ratio * 256 )
    stamina = math.Clamp( stamina, 0, 254 )

    if cl.stamina < 100 then
        surface.SetDrawColor( 16, 16, 16, 220 )
        surface.DrawRect( x - 128, 8, 256, 8 )
        
        surface.SetDrawColor( 200, 255, 135 )
        surface.DrawRect( x - 126, 10, stamina, 4 )
    end
end

/*  */

/* StartCommand: Allows you to change the players inputs before they are processed by the server. */
function GM:StartCommand( ply, CUserCmd )
    cl.stamina = ply:GetNWInt( "Stamina", 0 )

    if cl.stamina < 1 then
        CUserCmd:RemoveKey( IN_SPEED )
    end
end


/* */
function GM:Think()
    gm.DaytimeThink()
end