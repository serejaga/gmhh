/* Easy way to assign NWVars with Player methods */
local prefix = "[NWVars]"
local color = Color( 64, 128, 255 )

local function AddNWVariable( type, name, default )
    -- Set method 
    local SetNWVar = string.format( "SetNW%s", type )
    local SetMeta = string.format( "Set%s", name )

    PLAYER[ SetMeta ] = function( self, value )
        ENTITY[ SetNWVar ]( self, name, value )
    end

    -- Get method 
    local GetNWVar = string.format( "GetNW%s", type )
    local GetMeta = string.format( "Get%s", name )

    PLAYER[ GetMeta ] = function( self )
        return ENTITY[ GetNWVar ]( self, name, default )
    end

    -- debug message 
    local str = string.format( "Assigned Get/Set %s with Get/Set %s, with %s as default value.",  )
    MsgC( color, prefix, color_white, str )
end