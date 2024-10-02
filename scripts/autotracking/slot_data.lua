function get_slot_options(slot_data)

    if slot_data["secret_needed"] ~= nil and slot_data["blind_goal"] ~= true then
		local obj = Tracker:FindObjectForCode('opt_goal')
		local setting = slot_data["secret_needed"]
		if setting == true then
			obj.CurrentStage = 1
		else
			obj.CurrentStage = 0
		end
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
		local obj = Tracker:FindObjectForCode('opt_goal')
		local setting = slot_data["secret_needed"]
		if setting == true then
			obj.CurrentStage = 1
		else
			obj.CurrentStage = 0
		end
	else
		print("\nWARNING: You're using an apworld without bind_song_needed_to_get_under_rock_bulb in the slot data!\nUse a beta apworld for better poptracking.\nPlease fill this option manually in the Settings popout.\n")
	end
	
    if slot_data["no_progression_hard_or_hidden_locations"] ~= nil then
		local obj = Tracker:FindObjectForCode('opt_excluded')
		local setting = slot_data["no_progression_hard_or_hidden_locations"]
		if setting == true then
			obj.CurrentStage = 1
		else
			obj.CurrentStage = 0
		end
	else
		print("\nWARNING: You're using an apworld without no_progression_hard_or_hidden_locations in the slot data!\nUse a beta apworld for better poptracking.\nPlease fill this option manually in the Settings popout.\n")
	end

    if slot_data["light_needed_to_get_to_dark_places"] ~= nil then
		local obj = Tracker:FindObjectForCode('opt_light')
		local setting = slot_data["light_needed_to_get_to_dark_places"]
		if setting == true then
			obj.CurrentStage = 1
		else
			obj.CurrentStage = 0
		end
	else
		print("\nWARNING: You're using an apworld without light_needed_to_get_to_dark_places in the slot data!\nUse a beta apworld for better poptracking.\nPlease fill this option manually in the Settings popout.\n")
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
		
	else
		print("\nWARNING: You're using an apworld without turtle_randomizer in the slot data!\nUse a beta apworld for better poptracking.\nPlease fill this option manually in the Settings popout.\n")
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