/* main networking for hh, made by @surelyreplica */
local networking = {}

local PLAYER = FindMetaTable( "Player" )

/* Sent to player after respawn */
util.AddNetworkString( "s2c.respawn" )

function PLAYER:Respawn()



end

/* Set players HUD state */
util.AddNetworkString( "s2c.sethud" )


