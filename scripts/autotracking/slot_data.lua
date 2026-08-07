function get_slot_options(slot_data)

    if slot_data["goal"] ~= nil and slot_data["blind_goal"] ~= true then
		Tracker:FindObjectForCode('opt_goal').CurrentStage = slot_data["goal"]
	elseif slot_data["blind_goal"] == true then
		print("Sorry, the YAML setting hides this from you!")
	end

    if slot_data["bigbosses_to_kill"] ~= nil and slot_data["blind_goal"] ~= true then
		Tracker:FindObjectForCode('opt_bigboss').AcquiredCount = slot_data["bigbosses_to_kill"]
	elseif slot_data["blind_goal"] == true then
		print("Sorry, the YAML setting hides this from you!")
	end
	
    if slot_data["minibosses_to_kill"] ~= nil and slot_data["blind_goal"] ~= true  then
		Tracker:FindObjectForCode('opt_miniboss').AcquiredCount = slot_data["minibosses_to_kill"]
	elseif slot_data["blind_goal"] == true then
		print("Sorry, the YAML setting hides this from you!")
	end

    if slot_data["unconfine_home_water_transturtle"] ~= nil and slot_data["unconfine_home_water_energy_door"] ~= nil then
		local obj = Tracker:FindObjectForCode('opt_confined')
		local transturtle = slot_data["unconfine_home_water_transturtle"]
		local energydoor = slot_data["unconfine_home_water_energy_door"]
		if transturtle == false and energydoor == false then
			obj.CurrentStage = 0
		elseif transturtle == false and energydoor == true then
			obj.CurrentStage = 1
		elseif transturtle == true and energydoor == false then
			obj.CurrentStage = 2
		elseif transturtle == true and energydoor == true then
			obj.CurrentStage = 3
		else
			print("How the fuck did you get here")
		end
	end
	
    if slot_data["bind_song_needed_to_get_under_rock_bulb"] ~= nil then
		local obj = Tracker:FindObjectForCode('opt_bindsong')
		local setting = slot_data["bind_song_needed_to_get_under_rock_bulb"]
		if setting == true then
			obj.CurrentStage = 1
		else
			obj.CurrentStage = 0
		end
	end
	
    if slot_data["no_progression_hard_or_hidden_locations"] ~= nil then
		local obj = Tracker:FindObjectForCode('opt_excluded')
		local setting = slot_data["no_progression_hard_or_hidden_locations"]
		if setting == true then
			obj.CurrentStage = 1
		else
			obj.CurrentStage = 0
		end
	end

    if slot_data["light_needed_to_get_to_dark_places"] ~= nil then
		local obj = Tracker:FindObjectForCode('opt_light')
		local setting = slot_data["light_needed_to_get_to_dark_places"]
		if setting == true then
			obj.CurrentStage = 1
		else
			obj.CurrentStage = 0
		end
	end
	
    if slot_data["throne_as_location"] ~= nil then
		local obj = Tracker:FindObjectForCode('opt_throne')
		local setting = slot_data["throne_as_location"]
		if setting == true then
			obj.CurrentStage = 1
		else
			obj.CurrentStage = 0
		end
	end

    if slot_data["open_body_tongue"] ~= nil then
		local obj = Tracker:FindObjectForCode('opt_bodytongue')
		local setting = slot_data["open_body_tongue"]
		if setting == true then
			obj.CurrentStage = 1
		else
			obj.CurrentStage = 0
		end
	end

    -- Per-region "no progression" options
    local no_progression_map = {
		no_progression_simon_says    = "opt_excluded_simon",
		no_progression_kelp_forest   = "opt_excluded_forest",
		no_progression_veil          = "opt_excluded_veil",
		no_progression_mithalas      = "opt_excluded_mithalas",
		no_progression_energy_temple = "opt_excluded_energytemple",
		no_progression_arnassi_ruins = "opt_excluded_arnassi",
		no_progression_frozen_veil   = "opt_excluded_frozenveil",
		no_progression_abyss         = "opt_excluded_abyss",
		no_progression_sunken_city   = "opt_excluded_sunkencity",
		no_progression_body          = "opt_excluded_body",
	}
	for key, code in pairs(no_progression_map) do
		if slot_data[key] ~= nil then
			local obj = Tracker:FindObjectForCode(code)
			if slot_data[key] == true then
				obj.CurrentStage = 1
			else
				obj.CurrentStage = 0
			end
		end
	end

    if slot_data["turtle_randomizer"] ~= nil then
		local obj = Tracker:FindObjectForCode('opt_turtle')
		local stage = slot_data["turtle_randomizer"]
		
		if stage >= 2 then
			stage = 2
		end
		if obj then
			obj.CurrentStage = stage
		end
		
	end

----------------------
-- Contents of slot_data:
-- unconfine_home_water_transturtle        false
-- ingredientReplacement   table: 000002a933ad7330
-- secret_needed   false
-- aquarianTranslate       true
-- skip_first_vision       false
-- unconfine_home_water_energy_door        false
-- bigbosses_to_kill       2
-- minibosses_to_kill      2
----------------------


end