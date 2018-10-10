
SLASH_RELOADUI1 = "/rl"
SlashCmdList.RELOADUI = ReloadUI



local l_eventsListener = CreateFrame("Frame");
local l_events = {};

function l_events:ADDON_LOADED(sAddonName)

	if sAddonName ~= "PersonalResourceClickThrough" then
		return;
	end

	C_NamePlate.SetNamePlateSelfClickThrough(true);
end

l_eventsListener:SetScript("OnEvent", function(self, sEvent, ...)
	l_events[sEvent](self, ...);
end);

for k, v in pairs(l_events) do
	l_eventsListener:RegisterEvent(k);
end
