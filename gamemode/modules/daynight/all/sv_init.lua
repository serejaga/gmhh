util.AddNetworkString("TimeChange")
time = "day"


local skyPaint = ents.FindByClass( "env_skypaint" )[ 1 ]
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
		skyPaint:SetTopColor( Vector( 0.1, 0.4, 0.9 ) - Vector( 0.2,0.2,0.2 ) )
		skyPaint:SetBottomColor( Vector( 0.7, 0.9, 0.9 ) - Vector( 0.2,0.2,0.2 ) )
		skyPaint:SetFadeBias( 1 )

		skyPaint:SetSunNormal( Vector( 0.1, 0.0, 0.01 ) - Vector( 0.2,0.2,0.2 ) )
		skyPaint:SetSunColor( Vector( 0.2, 0.1, 0.0 ) - Vector( 0.2,0.2,0.2 ) )
		skyPaint:SetSunSize( 2.0 )

		skyPaint:SetDuskColor( Vector( 1.0, 0.2, 0.0 ) - Vector( 0.2,0.2,0.2 ) )
		skyPaint:SetDuskScale( 1 )
		skyPaint:SetDuskIntensity( 1 )

		skyPaint:SetDrawStars( true )
		skyPaint:SetStarLayers( 1 )
		skyPaint:SetStarSpeed( 0.01 )
		skyPaint:SetStarScale( 0.5 )
		skyPaint:SetStarFade( 1.5 )
		skyPaint:SetStarTexture( "skybox/starfield" )

	elseif time == "night" then
				skyPaint:SetTopColor( Vector( 0.1, 0.4, 0.9 ) )
		skyPaint:SetBottomColor( Vector( 0.7, 0.9, 0.9 ) )
		skyPaint:SetFadeBias( 1 )

		skyPaint:SetSunNormal( Vector( 0.1, 0.0, 0.01 ) )
		skyPaint:SetSunColor( Vector( 0.2, 0.1, 0.0 ) )
		skyPaint:SetSunSize( 2.0 )

		skyPaint:SetDuskColor( Vector( 1.0, 0.2, 0.0 ) )
		skyPaint:SetDuskScale( 1 )
		skyPaint:SetDuskIntensity( 1 )

		skyPaint:SetDrawStars( true )
		skyPaint:SetStarLayers( 1 )
		skyPaint:SetStarSpeed( 0.01 )
		skyPaint:SetStarScale( 0.5 )
		skyPaint:SetStarFade( 1.5 )
		skyPaint:SetStarTexture( "skybox/starfield" )
		time = "day"
		clientchange("day")
	end
end)