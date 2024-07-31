/* Localised frequently used methods, funcs, vars */
local vector_origin = vector_origin
local Vector = Vector 

/* Character trait flags */
gm.CharacterTraits = {}

local function AddTrait( index, str, description, func )
    -- fill trait data fields
    gm.CharacterTraits[ #gm.CharacterTraits + 1 ] = {
        index = index,
        str = str,
        desc = description
    }

    if not func then
        return 
    end
 
    -- Attach to game event 
    local event = string.format( "trait.invoke.%s", str )
    hook.Add( event, event, func )
end

-- Masochist: Buffs mood for short time after getting hurt
TRAIT_MASOCHIST = 1 

AddTrait( TRAIT_MASOCHIST, "Masochist", "For %s, there's something exciting about getting hurt.", function( ply, dmg )

end )

-- Bloodlust: Buffs mood after hurting other players, npcs
TRAIT_BLOODLUST = 2

AddTrait( TRAIT_BLOODLUST, "Bloodlust", "%s gets a rush from hurting people, and never minds the sight of blood or death.", function( ply )

end )

-- Psychopath: No mood buffs/debuffs
TRAIT_PSYCHOPATH = 4

AddTrait( TRAIT_PSYCHOPATH, "Psychopath", "%s has no empathy. The suffering of others doesn't bother them at all.", function( ply )

end )

-- Pyromaniac: Randomly ignites enemy
TRAIT_PYROMANIAC = 8

AddTrait( TRAIT_PYROMANIAC, "Pyromaniac", "%s loves fire and will occasionally go on random fire starting sprees.", function( ply )

end )

-- Cannibal: Allowed to eat children :D
TRAIT_CANNIBAL = 16 

AddTrait( TRAIT_CANNIBAL, "Pyromaniac", "%s was taught that eating human meat is wrong and horrible. But one time, long ago...", function( ply )

end )

-- Nimble: High dodge chance 
TRAIT_NIMBLE = 32

AddTrait( TRAIT_NIMBLE, "Nimble", "%s has remarkable kinesthetic intelligence.", function( ply )

end )

-- Brawler: More melee damage, hit chance 
TRAIT_BRAWLER = 32

AddTrait( TRAIT_BRAWLER, "Brawler", "%s likes to fight up close and personal.", function( ply )

end )

-- Wimp: More incoming damage
TRAIT_WIMP = 64

AddTrait( TRAIT_WIMP, "Wimp", "%s is weak and cowardly. Even a little pain will immobilize her/him.", function( ply, dmg )
    dmg:ScaleDamage( 1.25 )
end )

-- Tough: Less incoming damage
TRAIT_TOUGH = 128

AddTrait( TRAIT_TOUGH, "Tough", "%s has thick skin, dense flesh, and durable bones.", function( ply, dmg )
    dmg:ScaleDamage( 0.85 )
end )

-- Too smart: Fast researches
TRAIT_TOO_SMART = 256

AddTrait( TRAIT_TOO_SMART, "Too smart", "%s is too smart for her/his own good.", function( ply )

end )

-- Chemical interest: High on life
TRAIT_CHEMICAL_INTEREST = 512

AddTrait( TRAIT_CHEMICAL_INTEREST, "Chemical interest", "%s has an unusual interest in chemical sources of enjoyment.", function( ply )

end )

-- Lazy: Slow crafts
TRAIT_LAZY = 1024

AddTrait( TRAIT_LAZY, "Lazy", "%s is a little bit lazy.", function( ply )

end )

-- Industrious: Fast crafts
TRAIT_INDUSTRIOUS = 2048

AddTrait( TRAIT_INDUSTRIOUS, "Industrious", "%s has an easy time staying on-task and focused, and gets things done much faster than the average person.", function( ply )

end )

-- Jogger: Movin fast 
TRAIT_JOGGER = 4096 

AddTrait( TRAIT_JOGGER, "Jogger", "%s always moves with a sense of urgency - so much so that others often fail to keep up.", function( ply )
    ply:SetWalkSpeed( math.floor( ply:GetWalkSpeed() * 1.25 ) )
    ply:SetRunSpeed( math.floor( ply:GetRunSpeed() * 1.15 ) )
end )

-- Slowpoke: Decreased movement speed 
TRAIT_SLOWPOKE = 8192

AddTrait( TRAIT_SLOWPOKE, "Slowpoke", "%s is always falling behind the group anywhere.", function( ply )
    ply:SetWalkSpeed( math.floor( ply:GetWalkSpeed() * 0.75 ) )
    ply:SetRunSpeed( math.floor( ply:GetRunSpeed() * 0.85 ) )
end )

-- Depressive: мать сдохла продам гораж по 993
TRAIT_DEPRESSIVE = 16384

AddTrait( TRAIT_DEPRESSIVE, "Depressive", "%s is perennially unhappy. Мать сдохла продам гораж 1000-7.", function( ply )

end )

-- Sanguine: Constantly nice mood 
TRAIT_SANGUINE = 32768

AddTrait( TRAIT_SANGUINE, "Sanguine", "%s is just naturally upbeat about.", function( ply )

end )

-- Iron-willed: Cant go insane 
TRAIT_IRON_WILLED = 131072

AddTrait( TRAIT_IRON_WILLED, "Iron-willed", "%s's will is an iron shield.", function( ply )

end )

-- Volatile: Can go insane everytime
TRAIT_VOLATILE = 262144

AddTrait( TRAIT_VOLATILE, "Volatile", "%s is on a hair-trigger all the time.", function( ply )

end )

-- Careful shooter: More accuracy 
TRAIT_CAREFUL_SHOOTER = 524288

AddTrait( TRAIT_CAREFUL_SHOOTER, "Careful shooter", "%s is on a hair-trigger all the time.", function( ply, bullet )
    local BulletSpread = bullet.Spread 
    bullet.Spread = vector_origin

    -- Less spread cuz my nibba shootin carefully
    local rX, rY, rZ = ( math.random() * 0.5 ) - 0.25, ( math.random() * 0.5 ) - 0.25, ( math.random() * 0.5 ) - 0.25
    bullet.Dir = bullet.Dir + Vector( BulletSpread.x * rX, BulletSpread.y * rY, BulletSpread.z * rZ )
end )

-- Trigger-happy: Pew pew pew, less accurate but increased fire rate
TRAIT_TRIGGER_HAPPY = 1048576

AddTrait( TRAIT_TRIGGER_HAPPY, "Trigger-happy", "Pew! Pew! Pew! %s just likes pulling the trigger.", function( ply, bullet )
    local BulletSpread = bullet.Spread 
    bullet.Spread = vector_origin

    -- Pew pew pew
    local rX, rY, rZ = ( ( math.random() * 4 ) - 2 ), ( ( math.random() * 4 ) - 2 ), ( ( math.random() * 4 ) - 2 )
    bullet.Dir = bullet.Dir + Vector( BulletSpread.x * rX, BulletSpread.y * rY, BulletSpread.z * rZ )
end )

/* Player class methods */
local PLAYER = FindMetaTable( "Player" )

-- Set trait bits 
function PLAYER:SetTraits( iTraits )
    self:SetNWInt( "Traits", iTraits )
end

-- Get trait bits
function PLAYER:GetTraits()
    return self:GetNWInt( "Traits", 0 )
end

-- Check for trait 
function PLAYER:HasTrait( iTrait )
    local iTraits = self:GetNWInt( "Traits", 0 )

    return bit.band( iTraits, iTrait ) == iTrait 
end 