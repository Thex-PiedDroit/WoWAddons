
SLASH_RELOADUI1 = "/rl"
SlashCmdList.RELOADUI = ReloadUI



local eventsListener = CreateFrame("Frame");
local events = {};

function events:ADDON_LOADED(arg)

	if arg ~= "PersonalResourceClickThrough" then
		return;
	end

	C_NamePlate.SetNamePlateSelfClickThrough(true);
end

eventsListener:SetScript("OnEvent", function(self, event, ...)
	events[event](self, ...);
end);

for k, v in pairs(events) do
	eventsListener:RegisterEvent(k);
end
