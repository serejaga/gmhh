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
    PrintTable(Backstory)

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

    -- Setup data 
    self:SetModel( mModel )
    self:SetupHands()

    -- Give loadout 
    for i = 1, #mLoadOut do
        self:Give( mLoadOut[ i ] )
    end
end 