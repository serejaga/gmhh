// load
print("123")

local _b = ScrW()
local function ss(a)
	return a / 1920 * _b
end


surface.CreateFont( "InHaloocStyle", {
	font = "Arial",
	extended = false,
	size = ss(60),
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = false,
	outline = false,
} )


local inmy = 0
	local blur = Material("pp/blurscreen")
	local function blurs(panel, amount)
	    local x, y = panel:LocalToScreen(0, 0)
	    local scrW, scrH = ScrW(), ScrH()
	    surface.SetDrawColor(255, 255, 255)
	    surface.SetMaterial(blur)
	    for i = 1, 3 do
	        blur:SetFloat("$blur", (i / 3) * (amount or 6))
	        blur:Recompute()
	        render.UpdateScreenEffectTexture()
	        surface.DrawTexturedRect(x * -1, y * -1, scrW, scrH)
	    end
	end
	local timeout = 0
	local scw,sch = ScrW(),ScrH()
	local frame = vgui.Create("DFrame")
	local gD = Material("vgui/gradient_up")
	function AddPanel(whys,whypanel,modelg,name,id)
		local val = 0
		local valsmooth = 0
		local vals = 0
		local valsmooths = 0
		local adp = whys:Add("DPanel",whypanel)
		adp:Dock(TOP)
		adp:SetSize(scw,sch/5)
				local model = adp:Add("DModelPanel")
		model:Dock(LEFT)
		model:SetSize(scw/6)
		model:SetModel(modelg)
		model:SetCamPos(Vector(15, 15, 0))
		model:SetLookAt(Vector(0, 0, 0))
		function model:LayoutEntity( ent )
		end

		function adp:Paint(w,h)
			val = Lerp(0.1,val,valsmooth)
			vals = Lerp(0.1,vals,valsmooths)
			draw.RoundedBox(0, 0, 0, w, h, Color(30,30,30,200))
			blurs(adp,val)
			if adp:IsHovered() then 
				if input.IsMouseDown(107) then
					if CurTime() < timeout then return end
					adp:Remove()
					surface.PlaySound("physics/metal/weapon_impact_soft2.wav")
					net.Start("GiveSwep")
					net.WriteInt(id,32)
					net.SendToServer()
					timeout = CurTime() + 0.30
				end
				if input.IsMouseDown(108) then
					if CurTime() < timeout then return end
					adp:Remove()
					surface.PlaySound("physics/metal/weapon_impact_soft2.wav")
					net.Start("DropSwep")
					net.WriteInt(id,32)
					net.SendToServer()
					timeout = CurTime() + 0.30
				end
				valsmooth = 10
				valsmooths = 255
				draw.SimpleText("Взять/Выбросить", "InHaloocStyle", w/2, h/2, Color(255,255,255,vals), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			else
				valsmooth = 0
				valsmooths = 0
			end
		end


	end

	frame:Dock(FILL)
	frame:MakePopup()
	frame:Hide()
	frame:SetAlpha(0)
	frame:SetTitle("")
	frame:ShowCloseButton(false)
	function frame:Paint(w,h)
		surface.SetMaterial(gD)
		surface.SetDrawColor(0, 0, 0,200)
		surface.DrawTexturedRect(0,0,w,h)
	end
	local panemain = vgui.Create("DPanel", frame)
	panemain:Dock(RIGHT)
	panemain:SetSize(scw/2,sch/2)

	local s = panemain:Add("DScrollPanel")
	s:Dock(FILL)

	local sV = s:GetVBar()
	function sV:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 100))
	end
	function sV.btnUp:Paint(w, h)
	end
	function sV.btnDown:Paint(w, h)
	end
	function sV.btnGrip:Paint(w, h)
		draw.RoundedBox(10, 0, 0, w, h, Color(45, 45, 45))
	end

	function panemain:Paint(w,h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0,0,0,200))
	end
	net.Receive("InventroryAdd", function() 
		local tags = net.ReadTable()
		AddPanel(s,panemain,tags["model"],tags["name"],tags["id"])

	end)


	local model = vgui.Create("DModelPanel",frame)
	model:Dock(FILL)
	model:SetFOV(56)
local mytime = 0

hook.Add("Think","keyopen",function()
	if CurTime() < mytime then return end
	if inmy == 0 then
		if input.IsKeyDown(19) then
			frame:AlphaTo(255, 0.20, 0)
			frame:Show()
			inmy = 1
			mytime = CurTime() + 0.50
			model:SetModel(LocalPlayer():GetModel())
		end
	else
		if input.IsKeyDown(19) then
			frame:AlphaTo(0, 0.20, 0)
			timer.Simple(0.20,function() frame:Hide() end)
			inmy = 0
			mytime = CurTime() + 0.50
		end
	end

end)