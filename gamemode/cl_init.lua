include( "shared.lua" ) 

-- character 
include( "modules/character/sh_character.lua" ) 

-- client global table 
cl = cl or {}

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
local gradient_down, gradient_up = Material( "vgui/gradient_down", "noclamp smooth" ), Material( "vgui/gradient_up", "noclamp smooth" )

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
function GM:HUDPaint()



end


