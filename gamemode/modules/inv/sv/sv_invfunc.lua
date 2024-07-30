// load

util.AddNetworkString("InventroryAdd")
util.AddNetworkString("GiveSwep")
util.AddNetworkString("DropSwep")

local PLY = FindMetaTable("Player")
function PLY:DropEnt(why,id)
	local pos = self:GetPos()
	if why == "text" then
	if not self:GetActiveWeapon():IsValid() then return end
	local ent = ents.Create("ent_drop")
	ent:SetPos(Vector(pos.x,pos.y,pos.z + 20))
	ent:SetVar("Item",self:GetActiveWeapon():GetClass())
	ent:SetVar("Model",self:GetActiveWeapon():GetModel())
	ent:SetVar("Name",self:GetActiveWeapon():GetPrintName())
	ent:Spawn()
	self:StripWeapon(self:GetActiveWeapon():GetClass())
	elseif why == "inv" then
		local ent = ents.Create("ent_drop")
		ent:SetPos(Vector(pos.x,pos.y,pos.z + 20))
		ent:SetVar("Item",self.inv.slots[1][id]["weapon"])
		ent:SetVar("Model",self.inv.slots[1][id]["model"])
		ent:SetVar("Name",self.inv.slots[1][id]["name"])
		ent:Spawn()
		self.inv.slots[1][id]["weapon"] = "empty"
		self.inv.slots[1][id]["name"] = "empty"
		self.inv.slots[1][id]["model"] = "empty"
		file.Write("havoc/playerinv/".. self:SteamID64() .. ".txt", util.TableToJSON(self.inv.slots[1],false) )
	end 

end

function PLY:Giveinv(id) 

	if self.inv.slots[1][id]["weapon"] != "empty" then
		self:Give(self.inv.slots[1][id]["weapon"])
		self.inv.slots[1][id]["weapon"] = "empty"
		self.inv.slots[1][id]["name"] = "empty"
		self.inv.slots[1][id]["model"] = "empty"
		PrintTable(self.inv.slots[1][id])
		file.Write("havoc/playerinv/".. self:SteamID64() .. ".txt", util.TableToJSON(self.inv.slots[1],false) )
	else

	end

end
  
hook.Add("PlayerSay","SayDroppls",function(ply,text) 

	if text == "/drop" then
		ply:DropEnt("text")
	end

end)

net.Receive("GiveSwep", function(len,ply) 

	ply:Giveinv(net.ReadInt(32))

end)

net.Receive("DropSwep",function(len,ply) 

	ply:DropEnt("inv",net.ReadInt(32))

end)
