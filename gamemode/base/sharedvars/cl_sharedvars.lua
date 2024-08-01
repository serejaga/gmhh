local function ReceiveUpdate()
    local key = net.ReadString()
    local var = sh.vars[ key ]

    if not var then
        return 
    end

    local ret = sh.resolve[ var.type ].Read( var.iBits )
    cl.player[ key ] = ret 
end

net.Receive( "sh.var", ReceiveUpdate )