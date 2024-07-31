/* Character backstories */
gm.Backstory = {}

local function AddBackstory( str, description, models, loadout )
    gm.Backstory[ #gm.Backstory + 1 ] = {
        str = str,
        desc = description,
        models = false or models,
        loadout = false or loadout
    }
end

-- Default backstories
AddBackstory( "Citizen", "%s is regular person caught in extraordinary circumstances. They might be teacher, doctor, or simple office worker whose life is turned upside down by war, political upheaval, or personal tragedy." ) 
AddBackstory( "Veteran", "%s's backstory is one of service, sacrifice, and indelible marks left by combat. The only one who survived rp_bangclaw", gm.models.hostage, { "weapon_357", "weapon_crowbar" } ) 
AddBackstory( "Hunter", "Former military pilot, disillusioned by bureaucracy and the inability to make significant impact through official channels, %s embarks on mission to aid those in dire need. %s decides to take matters into their own hands, using their skills and resources to deliver aid directly to conflict zones.", gm.models.refugee, { "bb_scout_alt" } ) 
AddBackstory( "Special Forces", "Raised in military family, %s was destined for life of service. Trained from young age, they excel in physical and mental challenges, mastering art of warfare and strategy.", gm.models.goodboys, { "bb_fiveseven_alt", "bb_css_knife_alt" } ) 
AddBackstory( "Separatist", "Born into culture oppressed by an occupying power, %s grew up witnessing injustices inflicted upon their people.", gm.models.badboys, { "bb_p228_alt" } ) 
AddBackstory( "Terrorist", "%s backstory is complex, often rooted in personal trauma, political oppression, or profound sense of injustice. They may have been radicalized by charismatic leader or through exposure to violence and hardship.", gm.models.badboys, { "bb_mac10_alt", "bb_css_knife_alt" } ) 
AddBackstory( "Police Officer", "Coming from humble background, %s worked their way up through the ranks, driven by desire to serve and protect.", { "models/player/barney.mdl" }, { "bb_usp_alt" } ) 
AddBackstory( "Monk", "%s's journey is one of spiritual discovery and inner peace. Born into wealthy family, they renounced material possessions to seek enlightenment, dedicating their life to meditation, study, and serving others.", { "models/player/monk.mdl" } ) 
AddBackstory( "Bandit", "Raised in poverty, %s turned to life of crime out of necessity, seeking revenge against those who wronged them or simply desiring wealth and freedom denied to them.", gm.models.resistance, { "weapon_crowbar" } ) 
AddBackstory( "Hobo", "%s's backstory is one of resilience and redemption. Born into poverty, they faced numerous hardships, including addiction and homelessness.", { "models/player/corpse1.mdl" }, { "weapon_bugbait" } ) 
AddBackstory( "Medic", "Born into family of physicians, they were drawn to medical field from young age.", gm.models.medic, { "weapon_medkit" } ) 
AddBackstory( "Big Boss", "%s ascended to leadership through charisma, ruthlessness, and strategic acumen. Born into life of crime, they carved out territory for themselves, imposing order through fear and intimidation.", { "models/player/gman_high.mdl" }, { "bb_deagle_alt" } ) 
AddBackstory( "Mayor", "%s's path to leadership was marked by ambition, hard work, and commitment to public service. Coming from modest background, they rose through ranks of politics, driven by vision for their community.", { "models/player/breen.mdl" }, { "bb_glock_alt" } ) 
AddBackstory( "Resistance Leader", "Born into society under oppressive rule, the %s emerged as natural leader, rallying others to fight for freedom. Their backstory is one of inspiration and resilience, highlighting their ability to inspire hope and unity amidst despair.", { "models/player/alyx.mdl", "models/player/eli.mdl" }, { "bb_dualelites_alt" } ) 