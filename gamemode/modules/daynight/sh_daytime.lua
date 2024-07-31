/* Day time system */
local iTime, flPrevTime = 720, 0

if SERVER then
    util.AddNetworkString( "hh.update-ls" )
end

-- Painted skybox changes 
local SkyPaint = ents.FindByClass( "env_skypaint" )[ 1 ]
local EnvSun = ents.FindByClass( "env_sun" )[ 1 ]

-- Cached cycles 
local DayCycles = {
    {
        Top = Color( 5, 5, 15 ),
        Bottom = Color( 15, 15, 25 ),
        Dusk = Color( 45, 25, 55 ),
        Style = "e",
    },
    {
        Top = Color( 5, 5, 35 ),
        Bottom = Color( 25, 25, 55 ),
        Dusk = Color( 235, 75, 35 ),
        Style = "g",
    },
    {
        Top = Color( 55, 75, 130 ),
        Bottom = Color( 185, 75, 55 ),
        Dusk = Color( 235, 165, 135 ),
        Style = "h",
    },
    {
        Top = Color( 90, 180, 210 ),
        Bottom = Color( 235, 170, 100 ),
        Dusk = Color( 225, 225, 100 ),
        Style = "j",
    },
    {
        Top = Color( 90, 180, 210 ),
        Bottom = Color( 100, 155, 235 ),
        Dusk = Color( 225, 225, 100 ),
        Style = "l",
    },
    {
        Top = Color( 65, 175, 230 ),
        Bottom = Color( 90, 180, 210 ),
        Dusk = Color( 100, 155, 235 ),
        Style = "m",
    },
    {
        Top = Color( 95, 35, 45 ),
        Bottom = Color( 230, 125, 65 ),
        Dusk = Color( 225, 165, 65 ),
        Style = "j",
    },
    {
        Top = Color( 25, 15, 35 ),
        Bottom = Color( 25, 15, 60 ),
        Dusk = Color( 30, 15, 65 ),
        Style = "g",
    }
}

-- Fixed up colors to follow 0-1 range
for i = 1, #DayCycles do
    local cycle = DayCycles[ i ]

    local Top = cycle.Top
    cycle.Top = Vector( Top.r / 255, Top.g / 255, Top.b / 255 )

    local Bottom = cycle.Bottom
    cycle.Bottom = Vector( Bottom.r / 255, Bottom.g / 255, Bottom.b / 255 )

    local Dusk = cycle.Dusk
    cycle.Dusk = Vector( Dusk.r / 255, Dusk.g / 255, Dusk.b / 255 )
end

-- Darken world colors a bit
local WorldMaterials = false

-- Process time 
local SunColor, SunAngle = Vector( 1, 1, 1 ), Angle( 0, 0, 0 )
local TopColor, BottomColor, FadeBias = Vector( 0.2, 0.5, 1.0 ), Vector( 0.8, 1.0, 1.0 ), 1
local DuskScale, DuckIntensity, DuskColor = 1, 1, Vector( 1.0, 0.2, 0.0 )
local PrevLightStyle = "m"

function gm.ProcessTime()
    local flCurrentTime = CurTime()

    -- allow changes every passed second 
    if math.floor( flCurrentTime - flPrevTime ) < 1 then
        return 
    end
 
    flPrevTime = flCurrentTime

    -- progress and share variable 
    iTime = iTime + 1 

    if iTime > 1440 then
        iTime = 0 
    end
    
    SetGlobalInt( "iGlobalTime", iTime )

    if not IsValid( SkyPaint ) then
        return 
    end

    local nMult = iTime / 1440

    -- Change world colors 
    local World = Entity( 0 )

    if not WorldMaterials and IsValid( World ) then
        WorldMaterials = World:GetMaterials()

        for i = 1, #WorldMaterials do
            local material = WorldMaterials[ i ]
            WorldMaterials[ i ] = Material( material )
        end
    end

    -- Setup star overlay  
    SkyPaint:SetNetworkKeyValue( "drawstars", true )
    SkyPaint:SetNetworkKeyValue( "starlayers", 1 )
    SkyPaint:SetNetworkKeyValue( "starfade", 1 )
    SkyPaint:SetNetworkKeyValue( "starspeed", 0.01 )

    -- Change star overlay texture 
    local bIsDayTime = iTime > 480 and iTime < 1200
    SkyPaint:SetNetworkKeyValue( "startexture", bIsDayTime and "skybox/clouds" or "skybox/starfield" )
    SkyPaint:SetNetworkKeyValue( "starscale", bIsDayTime and 1.5 or 1 )

    -- Sun direction, size, color 
    SunAngle.x = nMult * 360
    EnvSun:SetKeyValue( "sun_dir", tostring( SunAngle:Forward() ) )

    EnvSun:SetKeyValue( "sunsize", "0.2" )
    EnvSun:SetKeyValue( "overlaysize", "0.2" )
    EnvSun:SetKeyValue( "suncolor", tostring( SunColor ) )
    EnvSun:SetKeyValue( "overlaycolor", tostring( SunColor ) )
     
    local vNormal = EnvSun:GetInternalVariable( "m_vDirection" )
    SkyPaint:SetNetworkKeyValue( "sunsize", 0.2 )
    SkyPaint:SetNetworkKeyValue( "suncolor", SunColor )
    SkyPaint:SetNetworkKeyValue( "sunnormal", vNormal )
     
    -- Sky top, bottom, dusk colors, scales
    local iDayCycle = math.max( 1, math.floor( nMult * #DayCycles ) )
    local mCycle = DayCycles[ iDayCycle ]

    SkyPaint:SetNetworkKeyValue( "fadebias", FadeBias )

    TopColor = LerpVector( 0.01, TopColor, mCycle.Top )
    SkyPaint:SetNetworkKeyValue( "topcolor", TopColor )

    BottomColor = LerpVector( 0.01, BottomColor, mCycle.Bottom )
    SkyPaint:SetNetworkKeyValue( "bottomcolor", BottomColor )
   
    DuskColor = LerpVector( 0.01, DuskColor, mCycle.Dusk )
    SkyPaint:SetNetworkKeyValue( "duskcolor", DuskColor )

    SkyPaint:SetNetworkKeyValue( "duskintensity", DuckIntensity )
    SkyPaint:SetNetworkKeyValue( "duskscale", DuskScale )

    -- Set ligh style
    if PrevLightStyle != mCycle.Style then
        engine.LightStyle( 0, mCycle.Style )

        net.Start( "hh.update-ls" )
        net.Broadcast()

        PrevLightStyle = mCycle.Style
    end
end
  
-- Client side modulation 
if not CLIENT then
    return 
end

-- light-style values
local function RedownloadLightmaps()
    render.RedownloadAllLightmaps( true, false )
end

net.Receive( "hh.update-ls", RedownloadLightmaps )