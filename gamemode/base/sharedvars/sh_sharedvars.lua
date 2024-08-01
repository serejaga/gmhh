sh = sh or { vars = {} }

-- Types 
sh.resolve = {
    { Write = net.WriteBit,     Read = net.ReadBit },
    { Write = net.WriteUInt,    Read = net.ReadUInt },
    { Write = net.WriteInt,     Read = net.ReadInt },
    { Write = net.WriteString,  Read = net.ReadString },
    { Write = net.WriteVector,  Read = net.ReadVector },
}

-- Share Bit
function sh.AddBit( key, bVar )
    sh.vars[ key ] = { type = 1, default = bVar }
end

-- Share Unsigned int 
function sh.AddUInt( key, iUnsigned, iBitCount )
    sh.vars[ key ] = { type = 2, default = iUnsigned, iBits = iBitCount }
end

-- Share Integer
function sh.AddInt( key, iNum, iBitCount )
    sh.vars[ key ] = { type = 3, default = iNum, iBits = iBitCount }
end

-- Share String 
function sh.AddString( key, default )
    sh.vars[ key ] = { type = 4, default = default }
end

-- Share Vector
function sh.AddVector( key, default )
    sh.vars[ key ] = { type = 5, default = default }
end

-- Setup defaults
function sh.Setup( ply )
    for key, value in pairs( sh.vars ) do
        ply[ key ] = value.default 
    end
end