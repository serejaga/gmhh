// load

// load

if not file.Exists("havoc/playerinv","GAME") then
	file.CreateDir("havoc/playerinv")
end
hook.Add("PlayerInitialSpawn", "loadinv", function(ply) 

	ply.inv = {}
	ply.inv.slots = {}
	ply.inv.resourse = {}

	if not file.Exists("havoc/playerinv/".. ply:SteamID64() .. "resorse.txt" ,"DATA") then
		ply.inv.resourse = {
			["rock"] = 0,
			["wood"] = 0
		}

		ply:SetNWInt("Wood",0)
		ply:SetNWInt("Rock",0)

		file.Write("havoc/playerinv/".. ply:SteamID64() .. "resorse.txt", util.TableToJSON(ply.inv.resourse,false))
	else
		ply.inv.resourse = {
			util.JSONToTable(file.Read("havoc/playerinv/".. ply:SteamID64() .. "resorse.txt", "DATA"))
		}
		ply:SetNWInt("Wood",ply.inv.resourse[1]["wood"])
		ply:SetNWInt("Rock",ply.inv.resourse[1]["rock"])
	end

	if not file.Exists("havoc/playerinv/".. ply:SteamID64() .. ".txt" ,"DATA") then
		ply.inv.slots[1] = {

		[1] = {

			["model"] = "empty",
			["name"] = "empty",
			["weapon"] = "empty",
			["type"] = "empty"

		},
		[2] = {

			["model"] = "empty",
			["name"] = "empty",
			["weapon"] = "empty",
			["type"] = "empty"

		},
		[3] = {

			["model"] = "empty",
			["name"] = "empty",
			["weapon"] = "empty",
			["type"] = "empty"

		},
		[4] = {

			["model"] = "empty",
			["name"] = "empty",
			["weapon"] = "empty",
			["type"] = "empty"

		},
		[5] = {

			["model"] = "empty",
			["name"] = "empty",
			["weapon"] = "empty",
			["type"] = "empty"

		},
		[6] = {

			["model"] = "empty",
			["name"] = "empty",
			["weapon"] = "empty",
			["type"] = "empty"

		},

		[7] = {

			["model"] = "empty",
			["name"] = "empty",
			["weapon"] = "empty",
			["type"] = "empty"

		},

		[8] = {

			["model"] = "empty",
			["name"] = "empty",
			["weapon"] = "empty",
			["type"] = "empty"

		},

	}
		file.Write("havoc/playerinv/".. ply:SteamID64() .. ".txt", util.TableToJSON(ply.inv.slots[1],false))
	else
		ply.inv.slots = {

			util.JSONToTable(file.Read("havoc/playerinv/".. ply:SteamID64() .. ".txt", "DATA"))
		}

		for k, v in pairs(ply.inv.slots[1]) do
			if ply.inv.slots[1][k]["weapon"] != "empty" then
				net.Start("InventroryAdd")
				net.WriteTable(ply.inv.slots[1][k])
				net.Send(ply)
			end
		end
		PrintTable(ply.inv.slots)
	end

end)

