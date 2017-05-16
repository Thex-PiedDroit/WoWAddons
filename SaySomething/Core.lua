
SLASH_RELOADUI1 = "/rl"
SlashCmdList.RELOADUI = ReloadUI

---------------------------------


local saySomethingEventListener = CreateFrame("Frame");
local events = {};
local initDone = false;

function events:PLAYER_ENTERING_WORLD(...)

	if initDone then
		return;
	end

	initDone = true;
end

saySomethingEventListener:SetScript("OnEvent", function(self, event, ...)
										events[event](self, ...);
									end);

for k, v in pairs(events) do
	saySomethingEventListener:RegisterEvent(k);
end
