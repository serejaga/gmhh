// load

// load

if not file.Exists("havoc/playerinv","GAME") then
	file.CreateDir("havoc/playerinv")
end

hook.Add("PlayerInitialSpawn", "loadinv", function(ply) 

	ply.inv = {}
	ply.inv.slots = {}

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
		PrintTable(ply.inv.slots)
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

