util.AddNetworkString("TimeChange")
time = "day"
function clientchange(ints)

	for k, v in pairs(player.GetAll()) do
		net.Start("TimeChange")
		net.WriteString(ints)
		net.Send(v)
	end

end
timer.Create("Infinity",3600,0,function()
	if time == "day" then
		time = "night"
		clientchange("nig")
	elseif time == "night" then
		time = "day"
		clientchange("day")
	end
end)