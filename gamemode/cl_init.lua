include( "shared.lua" ) 

-- character 
include( "modules/character/sh_character.lua" ) 

-- client global table 
cl = cl or {}

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

/* HUDShouldDraw: Called when the Gamemode is about to draw a given element on the client's HUD */
local allowed = { ["CHudGMod"] = true, ["NetGraph"] = true }

function GM:HUDShouldDraw( str )
    return allowed[ str ]
end

/* HUDPaintBackground: Called before GM:HUDPaint when the HUD background is being drawn */
function GM:HUDPaintBackground()
    local screen = cl.screen

    -- render simple vignette
    local vignette_size = math.floor( screen.h / 6 )

    surface.SetDrawColor( 0, 0, 0, 128 )

    surface.SetMaterial( gradient_down )
    surface.DrawTexturedRect( 0, 0, screen.w, vignette_size )
    
    surface.SetMaterial( gradient_up )
    surface.DrawTexturedRect( 0, screen.h - vignette_size, screen.w, vignette_size )
end

/* HUDPaint: Called whenever the HUD should be drawn, this is the ideal place to draw custom HUD elements */
local health, armor = 256, 256 
function GM:HUDPaint()
    local ratio, alpha, time 
    local screen = cl.screen

    -- validate local player 
    local ply = LocalPlayer()

    if not IsValid( ply ) then
        return 
    end

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
end


