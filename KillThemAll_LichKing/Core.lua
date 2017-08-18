
g_cerberus.RegisterAddonModule("KillThemAll");
g_cerberus.HookThisFile();

local eventsListener = CreateFrame("Frame");
local events = {};

function events:ADDON_LOADED(arg)

	if arg ~= "KillThemAll_LichKing" then
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

eventsListener:SetScript("OnEvent", function(self, event, ...)
	events[event](self, ...);
end);

for k, v in pairs(events) do
	eventsListener:RegisterEvent(k);
end
