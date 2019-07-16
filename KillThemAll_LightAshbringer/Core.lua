
g_cerberus.RegisterAddonModule("KillThemAll");

local l_eventsListener = CreateFrame("Frame");
local l_events = {};

function l_events:ADDON_LOADED(sAddonName)

	if sAddonName ~= "KillThemAll_LightAshbringer" then
		return;
	end

	if g_godsListSettings ~= nil then
		if g_ktaCurrentSettings ~= nil and g_ktaCurrentSettings.m_sGods ~= nil then

			local currentGods = GetWords(string.upper(g_ktaCurrentSettings.m_sGods));
			if TableContains(currentGods, g_lightAshbringer.m_sDataName) then
				SetGods(currentGods, true, true);
			end
		end

		AddGodToSettingsList(g_lightAshbringer);
	else
		KTA_Print("An update is available for KillThemAll. KillThemAll_LightAshbringer will not work until both are updated.");
		return;
	end
end

l_eventsListener:SetScript("OnEvent", function(self, sEvent, ...)
	l_events[sEvent](self, ...);
end);

for k, v in pairs(l_events) do
	l_eventsListener:RegisterEvent(k);
end
