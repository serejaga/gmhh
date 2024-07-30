AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")



function ENT:Initialize()
    self:SetModel("models/props/de_inferno/tree_small.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)
	phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
	end
end

hook.Add("EntityTakeDamage", "treedrop", function(target,dmginfo) 

	if target:GetClass() == "ent_tree" then 
		if dmginfo:GetAttacker():GetActiveWeapon():GetClass() != "weapon_crowbar" then return end 
		print(dmginfo:GetAttacker():GetNWInt("Wood"))
		dmginfo:GetAttacker():SetNWInt("Wood",dmginfo:GetAttacker():GetNWInt("Wood") + math.random(1,20))
		dmginfo:GetAttacker().inv.resourse = {
			["rock"] = dmginfo:GetAttacker():GetNWInt("Rock"),
			["wood"] = dmginfo:GetAttacker():GetNWInt("Wood")
		}
		file.Write("havoc/playerinv/".. dmginfo:GetAttacker():SteamID64() .. "resorse.txt", util.TableToJSON(dmginfo:GetAttacker().inv.resourse,false))
	end

end)



local ent = ents.Create("ent_stone")


ent:SetPos(Entity(1):GetPos())

ent:Spawn()
Entity(1):StripWeapons()
Entity(1):Give("weapon_crowbar")