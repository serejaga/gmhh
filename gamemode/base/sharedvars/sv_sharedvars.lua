local PLAYER = FindMetaTable( "Player" )
util.AddNetworkString( "sh.var" )

function PLAYER:SetSharedVariable( key, var, iBitCount )
    local variable = sh.vars[ key ]

    if not variable then
        return 
    end

    self[ key ] = var 

    -- Send update 
    net.Start( "sh.var" )
        net.WriteString( key )
        sh.resolve[ variable.type ].Write( var, iBitCount )
    net.Send( self )
end
