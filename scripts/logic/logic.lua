function soup()
	return has("Hotsoup")
end

function LI()
	return has("LiandLisong")
end

function damage()
	return has("Energyform")
	or has("Natureform")
	or has("Beastform")
	or has("LiandLisong")
	or has("BabyNautilus")
	or has("BabyPiranha")
	or has("BabyBlaster")
end

function damage_no_nature()
	return has("Energyform")
	or has("Beastform")
	or has("LiandLisong")
	or has("BabyNautilus")
	or has("BabyPiranha")
	or has("BabyBlaster")
end

function energyattack()
	return has("Energyform")
	or (has("Dualform") and has("LiandLisong"))
end

function shield()
	return has("Shieldsong")
end

function bind()
	return has("Bindsong")
end

function bindbulb()
	if Tracker:FindObjectForCode("opt_bindsong").CurrentStage == 0 then
		return AccessibilityLevel.Normal
	elseif Tracker:FindObjectForCode("opt_bindsong").CurrentStage == 1 and has("Bindsong") then
		return AccessibilityLevel.Normal
	elseif Tracker:FindObjectForCode("opt_bindsong").CurrentStage == 1 and Tracker:FindObjectForCode("opt_logic").CurrentStage == 0 then
		return AccessibilityLevel.SequenceBreak
	else
		return AccessibilityLevel.None
	end
end

function energy()
	return has("Energyform")
end

function beast()
	return has("Beastform")
end

function beastandsoup()
	return has("Beastform")
	and has("Hotsoup")
end

function beastorarnassi()
	return has("Beastform")
	or has("ArnassiArmor")
end

function nature()
	return has("Natureform")
end

function sun()
	return has("Sunform")
end

function light()
	return has("Sunform")
	or has("BabyDumbo")
end

function optlight()
	if Tracker:FindObjectForCode("opt_light").CurrentStage == 0 then
		return AccessibilityLevel.Normal
	elseif Tracker:FindObjectForCode("opt_light").CurrentStage == 1 and (has("Sunform") or has("BabyDumbo")) then
		return AccessibilityLevel.Normal
	elseif Tracker:FindObjectForCode("opt_light").CurrentStage == 1 and Tracker:FindObjectForCode("opt_logic").CurrentStage == 0 then
		return AccessibilityLevel.SequenceBreak
	else
		return AccessibilityLevel.None
	end
end

function dual()
	return has("Dualform")
end

function fish()
	return has("Fishform")
end

function spirit()
	return has("Spiritform")
end

function bigbosses()
    local bigbosses = {
		"energybossdead",
		"sunkencity_boss",
		"boss_forest",
		"boss_mithala",
		"boss_sunworm"
	}
    local count = 0
    for _, code in ipairs(bigbosses) do
        if Tracker:FindObjectForCode(code).Active then
            count = count + 1
        end
    end

    local endgamereq = Tracker:FindObjectForCode('opt_bigboss').AcquiredCount
    return count >= endgamereq
end

function secrets()
	return Tracker:FindObjectForCode("opt_goal").CurrentStage ~= 1 or
	(has("secret01")
	and has("secret02")
	and has("secret03"))
end

function minibosses()
    local minibosses = {
        "miniboss_nautilusprime",
        "miniboss_kingjelly",
        "miniboss_mergog",
        "miniboss_crab",
        "miniboss_octomun",
        "miniboss_mantisshrimp",
        "miniboss_priests",
        "miniboss_blaster"
    }
    local count = 0
    for _, code in ipairs(minibosses) do
        if Tracker:FindObjectForCode(code).Active then
            count = count + 1
        end
    end

    local endgamereq = Tracker:FindObjectForCode('opt_miniboss').AcquiredCount
    return count >= endgamereq
end


function beginning()
	return true
end

function transturtle(where)
    -- List of locations to check
    local locations = {
        "@Aquaria/veil_tl", 
        "@Aquaria/veil_tr_l", 
        "@Aquaria/openwater_tr_turtle", 
        "@Aquaria/forest_bl", 
        "@Aquaria/home_water_transturtle", 
        "@Aquaria/abyss_r_transturtle", 
        "@Aquaria/final_boss_tube", 
        "@Aquaria/simon", 
        "@Aquaria/arnassi_cave_transturtle"
    }

    -- Get the Transturtle object and ensure it's active
    local transturtleObject = Tracker:FindObjectForCode("Transturtle" .. where)
    if not transturtleObject or not transturtleObject.Active then
        return AccessibilityLevel.None
    end

    -- Track the highest accessibility level found
    local highestAccessibility = AccessibilityLevel.None

    for _, loc in ipairs(locations) do
        local location = Tracker:FindObjectForCode(loc)
        if location and location.AccessibilityLevel then
            -- Update highest accessibility if the current location has a higher level
            if location.AccessibilityLevel > highestAccessibility then
                highestAccessibility = location.AccessibilityLevel
            end
        end
    end

    return highestAccessibility
end

function excluded()
	if Tracker:FindObjectForCode("opt_excluded").CurrentStage == 1 and Tracker:FindObjectForCode("opt_excludedvisibility").CurrentStage == 1 then
		return false
	else
		return true
	end
end

function is_four_gods()
	local s = Tracker:FindObjectForCode("opt_goal").CurrentStage
	return s == 2 or s == 3
end

-- Returns false (hide) when the given per-region no-progression option is on
-- and the "hide excluded locations" toggle is on. True (show) otherwise.
function excluded_region(code)
	if Tracker:FindObjectForCode(code).CurrentStage == 1 and Tracker:FindObjectForCode("opt_excludedvisibility").CurrentStage == 1 then
		return false
	else
		return true
	end
end

-- Abyss, Sunken City, Body and Frozen Veil no-progression have no effect when
-- the objective is a four gods goal, so never hide those regions in that case.
function excluded_region_nofourgods(code)
	if is_four_gods() then
		return true
	end
	return excluded_region(code)
end

function excluded_forest()       return excluded_region("opt_excluded_forest") end
function excluded_veil()         return excluded_region("opt_excluded_veil") end
function excluded_mithalas()     return excluded_region("opt_excluded_mithalas") end
function excluded_energytemple() return excluded_region("opt_excluded_energytemple") end
function excluded_arnassi()      return excluded_region("opt_excluded_arnassi") end
function excluded_frozenveil()   return excluded_region_nofourgods("opt_excluded_frozenveil") end
function excluded_abyss()        return excluded_region_nofourgods("opt_excluded_abyss") end
function excluded_sunkencity()   return excluded_region_nofourgods("opt_excluded_sunkencity") end
function excluded_body()         return excluded_region_nofourgods("opt_excluded_body") end

-- Simon Says is excluded by its own option, or by the Arnassi Ruins option when
-- the turtles are not randomized (matching the apworld's behaviour).
function excluded_simon()
	if Tracker:FindObjectForCode("opt_excludedvisibility").CurrentStage == 1 and (
		Tracker:FindObjectForCode("opt_excluded_simon").CurrentStage == 1 or
		(Tracker:FindObjectForCode("opt_excluded_arnassi").CurrentStage == 1 and Tracker:FindObjectForCode("opt_turtle").CurrentStage == 0)
	) then
		return false
	else
		return true
	end
end

function show_miniboss()
    if minibosses() == true then
        return false
    else
        return true
    end
end

function show_boss()
    if bigbosses() == true then
        return false
    else
        return true
    end
end
