AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")



function ENT:Initialize()
    self:SetModel("models/props/cs_militia/militiarock05.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
	end
end

hook.Add("EntityTakeDamage", "rocktake", function(target,dmginfo) 

	if target:GetClass() == "ent_stone" then 
		if dmginfo:GetAttacker():GetActiveWeapon():GetClass() != "weapon_crowbar" then return end 
		print(dmginfo:GetAttacker():GetNWInt("Rock"))
		dmginfo:GetAttacker():SetNWInt("Rock",dmginfo:GetAttacker():GetNWInt("Rock") + math.random(1,20))
		dmginfo:GetAttacker().inv.resourse = {
			["rock"] = dmginfo:GetAttacker():GetNWInt("Rock"),
			["wood"] = dmginfo:GetAttacker():GetNWInt("Wood")
		}

		dmginfo:GetAttacker():SetVar("Rock",dmginfo:GetAttacker():GetNWInt("Rock") + math.random(1, 15))
		file.Write("havoc/playerinv/".. dmginfo:GetAttacker():SteamID64() .. "resorse.txt", util.TableToJSON(dmginfo:GetAttacker().inv.resourse,false))
	end

end)


