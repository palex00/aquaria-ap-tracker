
local variant = Tracker.ActiveVariantUID

-- Items
Tracker:AddItems("items/items.json")
Tracker:AddItems("items/options.json")
Tracker:AddItems("items/events.json")

-- Logic
ScriptHost:LoadScript("scripts/logic/logic_helper.lua")
ScriptHost:LoadScript("scripts/logic/logic.lua")

-- Maps
Tracker:AddMaps("maps/maps.json")  

-- Layout
Tracker:AddLayouts("layouts/items.json")
Tracker:AddLayouts("layouts/tabbed_maps.json")
Tracker:AddLayouts("layouts/tabs.json")
Tracker:AddLayouts("layouts/tracker.json")
Tracker:AddLayouts("layouts/broadcast.json")
Tracker:AddLayouts("layouts/settings.json")


-- Locations
Tracker:AddLocations("locations/Aquaria.json")
Tracker:AddLocations("locations/Overworld.json")
Tracker:AddLocations("locations/Submaps.json")

-- AutoTracking for Poptracker
ScriptHost:LoadScript("scripts/autotracking.lua")