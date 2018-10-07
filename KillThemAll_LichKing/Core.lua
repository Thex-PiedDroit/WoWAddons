
g_cerberus.RegisterAddonModule("KillThemAll");

local l_eventsListener = CreateFrame("Frame");
local l_events = {};

function l_events:ADDON_LOADED(sAddonName)

	if sAddonName ~= "KillThemAll_LichKing" then
		return;
	end

	if g_godsListSettings ~= nil then
		if S_ktaOptions ~= nil and S_ktaOptions.sGods ~= nil then

			local currentGods = GetWords(string.upper(S_ktaOptions.sGods));
			if TableContains(currentGods, g_lichking.sDataName) then
				SetGods(currentGods, true);
			end
		end

		AddGodToSettingsList(g_lichking);
	else
		KTA_Print("An update is available for KillThemAll. KillThemAll_LichKing will not work until both are updated.");
		return;
	end
end

l_eventsListener:SetScript("OnEvent", function(self, sEvent, ...)
	l_events[sEvent](self, ...);
end);

for k, v in pairs(l_events) do
	l_eventsListener:RegisterEvent(k);
end
