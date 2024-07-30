
local val = 0
local valsmooth = 0

net.Receive("TimeChange",function()
	local num = net.ReadString()
	print(num)
	hook.Add("Think", "sycdhka", function()
	val = Lerp(0.01,val,valsmooth)
	if num == "day" then 
		valsmooth = 1
	elseif num == "nig" then
		valsmooth = 0.10
	end
	local worldmats = Entity( 0 ):GetMaterials()

	for i = 1, #worldmats do
            local value = worldmats[i]

            Material( value ):SetVector( "$color", Vector(val,val,val) )
            Material( value ):SetFloat( "$alpha", 1 )
    end
	end)
end)
