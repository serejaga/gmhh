/* hh character system, made by @surelyreplica */
gm.char = {}

-- trait system 
include( "sh_traits.lua" )





 






/* base character fields */
local base = {
    -- name field: first, last, nick 
    name = { first = "John", last = "Doe", nick = "anon" },

    -- age field: biological, chronological 
    age = { bio = 21, chrono = 21 },

    -- skills: shooting, melee, crafting, social etc...
    skills = { shooting = 5, melee = 5, crafting = 5, building = 5, social = 5 },

    -- backstory: addition to skills 
    backstory = 1,

    -- traits: addition to skills. health, speed, damage multipliers ( bitflag )
    traits = 0,
} 

/* backstory field */
local backstories = {
    {
        str = "Солдатик",
        description = "Спасибо деду за победу",
        models = "soldier",
        loadout = { "bb_ak47" },
    },
    {
        str = "Медик",
        description = "Зато бесплатно",
        models = "medic",
        loadout = { "weapon_medkit" },
    },
    {
        str = "Меллстрой",
        description = "Ам ам ам ам ам че за бизнесс сука",
        models = "mellstroy",
        loadout = { "bb_deagle" },
    }
}

local BACKSTORY_COUNT = #backstories 

/* Handle player spawn */
function gm.char.OnSpawn( ply )
    ply.character = {
        name = base.name,
        age = base.age,
        skills = base.skills
    }

    -- select random backstory 
    local iBackstory = math.random( 1, BACKSTORY_COUNT )
    local data = backstories[ iBackstory ]

    ply.character.backstory = iBackstory 

    -- select backstory related models
    if data.models then
        local model = gm.models[ data.models ]
        ply:SetModel( isstring( model ) and model or model[ math.random( 1, #model ) ] ) 
    else
        local citizen = gm.models.citizen
        ply:SetModel( citizen[ math.random( 1, #citizen ) ] ) 
    end

    ply:SetupHands()

    -- Apply random traits  
    local bitTraits = 0

    for i = 1, math.random( 1, 3 ) do
        bitTraits = bit.bor( bitTraits, gm.CharacterTraits[ math.random( 1, #gm.CharacterTraits ) ].index )
    end 
    
    ply.character.traits = bitTraits
    print(bitTraits)

    -- backstory given weapon 
    if data.loadout then
        for i = 1, #data.loadout do
            ply:Give( data.loadout[ i ] )
        end
    end
end