GM.Name 	= "Havoc"
GM.Author 	= "replica"
GM.Email 	= "@surelyreplica"
GM.Website 	= "github.com/serejaga"

-- shared global table 
gm = gm or {}

-- player models 
gm.models = {
    -- civilians 
    citizen = {
        -- female
        "models/player/group01/female_01.mdl",
        "models/player/group01/female_02.mdl",
        "models/player/group01/female_03.mdl",
        "models/player/group01/female_04.mdl",
        "models/player/group01/female_05.mdl",
        "models/player/group01/female_06.mdl",
        -- men <3
        "models/player/group01/male_01.mdl",
        "models/player/group01/male_02.mdl",
        "models/player/group01/male_03.mdl",
        "models/player/group01/male_04.mdl",
        "models/player/group01/male_05.mdl",
        "models/player/group01/male_06.mdl",
        "models/player/group01/male_07.mdl",
        "models/player/group01/male_08.mdl",
        "models/player/group01/male_09.mdl"
    },

    -- refugee
    refugee = {
        "models/player/group02/male_02.mdl",
        "models/player/group02/male_04.mdl",
        "models/player/group02/male_06.mdl",
        "models/player/group02/male_08.mdl"
    },

    -- resistance 
    resistance = {
        -- female 
        "models/player/group03/female_01.mdl",
        "models/player/group03/female_02.mdl",
        "models/player/group03/female_03.mdl",
        "models/player/group03/female_04.mdl",
        "models/player/group03/female_05.mdl",
        "models/player/group03/female_06.mdl",
        -- male
        "models/player/group03/male_01.mdl",
        "models/player/group03/male_02.mdl",
        "models/player/group03/male_03.mdl",
        "models/player/group03/male_04.mdl",
        "models/player/group03/male_05.mdl",
        "models/player/group03/male_06.mdl",
        "models/player/group03/male_07.mdl",
        "models/player/group03/male_08.mdl",
        "models/player/group03/male_09.mdl"
    },

    -- medic 
    medic = {
        -- female 
        "models/player/group03m/female_01.mdl",
        "models/player/group03m/female_02.mdl",
        "models/player/group03m/female_03.mdl",
        "models/player/group03m/female_04.mdl",
        "models/player/group03m/female_05.mdl",
        "models/player/group03m/female_06.mdl",
        -- male
        "models/player/group03m/male_01.mdl",
        "models/player/group03m/male_02.mdl",
        "models/player/group03m/male_03.mdl",
        "models/player/group03m/male_04.mdl",
        "models/player/group03m/male_05.mdl",
        "models/player/group03m/male_06.mdl",
        "models/player/group03m/male_07.mdl",
        "models/player/group03m/male_08.mdl",
        "models/player/group03m/male_09.mdl" 
    },

    -- hostages 
    hostage = {
        "models/player/hostage/hostage_01.mdl",
        "models/player/hostage/hostage_02.mdl",
        "models/player/hostage/hostage_03.mdl",
        "models/player/hostage/hostage_04.mdl"
    },

    -- bad guyz
    badboys = {
        "models/player/arctic.mdl",
        "models/player/guerilla.mdl",
        "models/player/phoenix.mdl",
        "models/player/leet.mdl"
    },

    -- smert musoram AYE
    goodboys = {
        "models/player/gasmask.mdl",
        "models/player/riot.mdl",
        "models/player/swat.mdl",
        "models/player/urban.mdl"
    },

    -- civil protection 
    police = { 
        "models/player/police_fem.mdl", 
        "models/player/police.mdl" 
    },

    -- soldiers 
    soldier = {
        "models/player/dod_american.mdl",
        "models/player/dod_german.mdl"
    },

    -- unique player models 
    alyx = "models/player/alyx.mdl",
    barney = "models/player/barney.mdl",
    breen = "models/player/breen.mdl",
    churka = "models/player/eli.mdl",
    gman = "models/player/gman_high.mdl",
    chikatilo = "models/player/kleiner.mdl",
    mellstroy = "models/player/magnusson.mdl",
    monk = "models/player/monk.mdl",
    rapist = "models/player/mossman.mdl",
    rapist = "models/player/mossman_arctic.mdl",
    hohol = "models/player/odessa.mdl",
    chell = "models/player/p2_chell.mdl",
    wigy = "models/player/soldier_stripped.mdl",
    
    -- combine 
    combine_soldier = "models/player/combine_soldier.mdl",
    combine_guard = "models/player/combine_soldier_prisonguard.mdl",
    combine_elite = "models/player/combine_super_soldier.mdl",

    -- nashi rebyata ZV
    charple = "models/player/charple.mdl",
    corpse = "models/player/corpse1.mdl",
    skeleton = "models/player/skeleton.mdl",

    -- Zомби
    zombie = "models/player/zombie_classic.mdl",
    zombie_fast = "models/player/zombie_fast.mdl",
    zombie_combine = "models/player/zombie_soldier.mdl"
}

-- shared networking 
nw = nw or {}