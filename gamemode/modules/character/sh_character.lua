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
    if Backstory.model then
        mModel = Backstory.model[ math.random( 1, #Backstory.model ) ]
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