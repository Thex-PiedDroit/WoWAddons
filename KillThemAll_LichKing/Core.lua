
local eventsListener = CreateFrame("Frame");
local events = {};

function events:ADDON_LOADED(arg)

	if arg ~= "KillThemAll_LichKing" then
		return;
	end

	if S_ktaOptions ~= nil and S_ktaOptions.gods ~= nil then
		SetGods(GetWords(S_ktaOptions.gods), true);
	end

	if g_godsListSettings ~= nil then
		AddGodToSettingsList(lichking);
	else
		KTA_Print("An update is available for KillThemAll");
	end
end

eventsListener:SetScript("OnEvent", function(self, event, ...)
	events[event](self, ...);
end);

for k, v in pairs(events) do
	eventsListener:RegisterEvent(k);
end
