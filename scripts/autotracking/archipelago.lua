ScriptHost:LoadScript("scripts/autotracking/item_mapping.lua")
ScriptHost:LoadScript("scripts/autotracking/location_mapping.lua")
ScriptHost:LoadScript("scripts/autotracking/slot_data.lua")

CUR_INDEX = -1
SLOT_DATA = {}
LOCAL_ITEMS = {}
GLOBAL_ITEMS = {}

function has_value (t, val)
    for i, v in ipairs(t) do
        if v == val then return 1 end
    end
    return 0
end

function dump_table(o, depth)
    if depth == nil then
        depth = 0
    end
    if type(o) == 'table' then
        local tabs = ('	'):rep(depth)
        local tabs2 = ('	'):rep(depth + 1)
        local s = '{'
        for k, v in pairs(o) do
            if type(k) ~= 'number' then
                k = '"' .. k .. '"'
            end
            s = s .. tabs2 .. '[' .. k .. '] = ' .. dump_table(v, depth + 1) .. ','
        end
        return s .. tabs .. '}'
    else
        return tostring(o)
    end
end


function onClear(slot_data)
	
	if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print("----------------------")
        print("Contents of slot_data:")
        for key, value in pairs(slot_data) do
            print(key, value)
        end
        print("----------------------")
    end
	
    SLOT_DATA = slot_data
    CUR_INDEX = -1
	
	-- reset settings
	local reset_codes = {
		"opt_goal", "opt_turtle", "opt_light", "opt_bindsong",
		"opt_confined", "opt_excluded", "opt_miniboss", "opt_bigboss"
	}
	
	for _, code in ipairs(reset_codes) do
		local obj = Tracker:FindObjectForCode(code)
		if obj then
			obj.Active = false
			obj.AcquiredCount = 0
		end
	end

    -- reset locations
    for _, location_array in pairs(LOCATION_MAPPING) do
        for _, location in pairs(location_array) do
            if location then
                local location_obj = Tracker:FindObjectForCode(location)
                if location_obj then
                    if location:sub(1, 1) == "@" then
                        location_obj.AvailableChestCount = location_obj.ChestCount
                    else
                        location_obj.Active = false
                    end
                end
            end
        end
    end
    -- reset items
    for _, v in pairs(ITEM_MAPPING) do
        if v[1] and v[2] then
            if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
            --    print(string.format("onClear: clearing item %s of type %s", v[1], v[2]))
            end
            local obj = Tracker:FindObjectForCode(v[1])
            if obj then
                if v[2] == "toggle" then
                    obj.Active = false
                elseif v[2] == "progressive" then
                    obj.CurrentStage = 0
                    obj.Active = false
                elseif v[2] == "consumable" then
                    obj.AcquiredCount = 0
                elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
                    print(string.format("onClear: unknown item type %s for code %s", v[2], v[1]))
                end
            elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
                print(string.format("onClear: could not find object for code %s", v[1]))
            end
        end
    end
	get_slot_options(slot_data)	
	
	PLAYERNUMBER = Archipelago.PlayerNumber
	
	-- Sets various listeners.
	-- Dev says I should just do one for each because creating a dictionary would be
	-- too much code change for them
	
    Archipelago:Get({PLAYERNUMBER .. "@miniboss_nautilusprime"})
    Archipelago:SetNotify({PLAYERNUMBER .. "@miniboss_nautilusprime"})
    Archipelago:Get({PLAYERNUMBER .. "@sun_crystal_obtained"})
    Archipelago:SetNotify({PLAYERNUMBER .. "@sun_crystal_obtained"})
    Archipelago:Get({PLAYERNUMBER .. "@miniboss_kingjelly"})
    Archipelago:SetNotify({PLAYERNUMBER .. "@miniboss_kingjelly"})
    Archipelago:Get({PLAYERNUMBER .. "@miniboss_mergog"})
    Archipelago:SetNotify({PLAYERNUMBER .. "@miniboss_mergog"})
    Archipelago:Get({PLAYERNUMBER .. "@miniboss_crab"})
    Archipelago:SetNotify({PLAYERNUMBER .. "@miniboss_crab"})
    Archipelago:Get({PLAYERNUMBER .. "@miniboss_octomun"})
    Archipelago:SetNotify({PLAYERNUMBER .. "@miniboss_octomun"})
    Archipelago:Get({PLAYERNUMBER .. "@miniboss_mantisshrimp"})
    Archipelago:SetNotify({PLAYERNUMBER .. "@miniboss_mantisshrimp"})
    Archipelago:Get({PLAYERNUMBER .. "@miniboss_priests"})
    Archipelago:SetNotify({PLAYERNUMBER .. "@miniboss_priests"})
    Archipelago:Get({PLAYERNUMBER .. "@miniboss_blaster"})
    Archipelago:SetNotify({PLAYERNUMBER .. "@miniboss_blaster"})
    Archipelago:Get({PLAYERNUMBER .. "@energybossdead"})
    Archipelago:SetNotify({PLAYERNUMBER .. "@energybossdead"})
    Archipelago:Get({PLAYERNUMBER .. "@sunkencity_boss"})
    Archipelago:SetNotify({PLAYERNUMBER .. "@sunkencity_boss"})
    Archipelago:Get({PLAYERNUMBER .. "@boss_forest"})
    Archipelago:SetNotify({PLAYERNUMBER .. "@boss_forest"})
    Archipelago:Get({PLAYERNUMBER .. "@boss_mithala"})
    Archipelago:SetNotify({PLAYERNUMBER .. "@boss_mithala"})
    Archipelago:Get({PLAYERNUMBER .. "@boss_sunworm"})
    Archipelago:SetNotify({PLAYERNUMBER .. "@boss_sunworm"})
    Archipelago:Get({PLAYERNUMBER .. "@tongue_removed"})
    Archipelago:SetNotify({PLAYERNUMBER .. "@tongue_removed"})
    Archipelago:Get({PLAYERNUMBER .. "@secret01"})
    Archipelago:SetNotify({PLAYERNUMBER .. "@secret01"})
    Archipelago:Get({PLAYERNUMBER .. "@secret02"})
    Archipelago:SetNotify({PLAYERNUMBER .. "@secret02"})
    Archipelago:Get({PLAYERNUMBER .. "@secret03"})
    Archipelago:SetNotify({PLAYERNUMBER .. "@secret03"})
end

function onItem(index, item_id, item_name, player_number)
    if index <= CUR_INDEX then
        return
    end
    local is_local = player_number == Archipelago.PlayerNumber
    CUR_INDEX = index;
    local item = ITEM_MAPPING[item_id]
    if not item or not item[1] then
        --print(string.format("onItem: could not find item mapping for id %s", item_id))
        return
    end

    item_code = item[1]
    item_type = item[2]
    local item_obj = Tracker:FindObjectForCode(item_code)

    if item_obj then
        if item_obj.Type == "toggle" then
            -- print("toggle")
            item_obj.Active = true
        elseif item_obj.Type == "progressive" then
            -- print("progressive")
            item_obj.Active = true
        elseif item_obj.Type == "consumable" then
            -- print("consumable")
            item_obj.AcquiredCount = item_obj.AcquiredCount + item_obj.Increment
        elseif item_obj.Type == "progressive_toggle" then
            -- print("progressive_toggle")
            if item_obj.Active then
                item_obj.CurrentStage = item_obj.CurrentStage + 1
            else
                item_obj.Active = true
            end
        end
    else
        print(string.format("onItem: could not find object for code %s", item_code[1]))
    end
end

--called when a location gets cleared
function onLocation(location_id, location_name)
    local location_array = LOCATION_MAPPING[location_id]
    if not location_array or not location_array[1] then
        print(string.format("onLocation: could not find location mapping for id %s", location_id))
        return
    end

    for _, location in pairs(location_array) do
        local location_obj = Tracker:FindObjectForCode(location)
        -- print(location, location_obj)
        if location_obj then
            if location:sub(1, 1) == "@" then
                location_obj.AvailableChestCount = location_obj.AvailableChestCount - 1
            else
                location_obj.Active = true
            end
        else
            print(string.format("onLocation: could not find location_object for code %s", location))
        end
    end
end

function onEvent(key, value, old_value)
    updateEvents(key, value)
end

function onEventLaunch(key, value)
    updateEvents(key, value)
end

function onBounce(json)
    local data = json["data"]
    if data ~= nil then
            updateMap(data["area"])
    end
end

function updateEvents(key, value)
    if value ~= nil then
        -- print(string.format("updateEvents: Key - %s, Value - %s", key, value))
		converted_key = key:sub(key:find("@") + 1)
		
		for _, v in pairs(value) do
			if v == 1 then
				Tracker:FindObjectForCode(converted_key).Active = true
				print("Event Done: " .. converted_key)
			end
		end
    end
end

function updateMap(area)
    local areaMap = {
        cathedralunderground = "Cathedral Underground",
        energytemple = "Energy Temple",
        homewater = "Home Water",
        icecave = "Ice Cave",
        kelpforest = "Kelp Forest",
        mithalascathedral = "Mithalas Cathedral",
        mithalascity = "Mithalas City",
        mithalascitycastle = "Mithalas City Castle",
        naijashome = "Naija's Home",
        openwater = "Open Water",
        songcave = "Song Cave",
        suntemple = "Sun Temple",
        sunkencity = "Sunken City",
        thebody = "The Body",
        theveil = "The Veil",
        versecave = "Verse Cave"
    }

    local tabname = areaMap[area] or area  -- Convert area if it matches, otherwise keep original

    if has("auto_tab_on") then
        Tracker:UiHint("ActivateTab", "Subareas")
        Tracker:UiHint("ActivateTab", tabname)
    end
end





Archipelago:AddClearHandler("clear handler", onClear)
Archipelago:AddItemHandler("item handler", onItem)
Archipelago:AddLocationHandler("location handler", onLocation)
Archipelago:AddSetReplyHandler("notify handler", onEvent)
Archipelago:AddRetrievedHandler("notify launch handler", onEventLaunch)
Archipelago:AddBouncedHandler("bounce handler", onBounce)
