/* Character system */
local Backstories = gm.Backstory

/* Player class methods */
local PLAYER = FindMetaTable( "Player" )

-- Should be called on spawn 
local DefaultModels = gm.models.citizen 

function PLAYER:GenerateCharacter()
    local mModel, mLoadOut = DefaultModels[ math.random( 1, #DefaultModels ) ], { "weapon_fists" }

    -- Give character random backstory 
    local Backstory = Backstories[ math.random( 1, #Backstories ) ]
    
    -- Backstory related model 
    if Backstory.models then
        mModel = Backstory.models[ math.random( 1, #Backstory.models ) ]
    end

    -- Backstory loadouts 
    if Backstory.loadout then
        for i = 1, #Backstory.loadout do
            mLoadOut[ #mLoadOut + 1 ] = Backstory.loadout[ i ]
        end
    end

    -- Give random traits 
    self:GiveRandomTraits()

    -- Tell player given traits 
    local iTraits, iNumTraits = self:GetTraits(), 0

    local strTraits = ""
    for i = 1, #gm.CharacterTraits do
        local Trait = gm.CharacterTraits[ i ]

        if not self:HasTrait( Trait.index ) then
            continue 
        end

        strTraits = iNumTraits > 0 and string.format( "%s, %s", strTraits, Trait.str ) or Trait.str
        iNumTraits = iNumTraits + 1
    end   

    local msg = iNumTraits > 1 and string.format( "%s has %s traits.", self:Name(), strTraits ) or iNumTraits > 0 and string.format( "%s has %s trait.", self:Name(), strTraits )
        or string.format( "%s has no special traits.", self:Name() ) 
 
    self:PrintMessage(HUD_PRINTTALK, msg )

    -- Setup data 
    self:SetModel( mModel )
    self:SetupHands()

    -- Give loadout 
    for i = 1, #mLoadOut do
        self:Give( mLoadOut[ i ] )
    end
end 