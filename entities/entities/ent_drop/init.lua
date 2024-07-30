AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/props_c17/SuitCase_Passenger_Physics.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	self.nospam = 0
	phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
	end
end

function ENT:Use(activator)



	for i = 1, #activator.inv.slots[1] do
		if activator.inv.slots[1][i]["weapon"] == "empty" then
			activator.inv.slots[1][i] ={

			["model"] = self:GetVar("Model"),
			["name"] = self:GetVar("Name"),
			["weapon"] = self:GetVar("Item"),
			["id"] = i

			}
			net.Start("InventroryAdd")
			net.WriteTable(activator.inv.slots[1][i])
			net.Send(activator)
			PrintTable(activator.inv.slots[1])
			self:Remove()
			file.Write("havoc/playerinv/".. activator:SteamID64() .. ".txt", util.TableToJSON(activator.inv.slots[1],false) )
			break
		end
	end



end