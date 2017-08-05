
SLASH_RELOADUI1 = "/rl"
SlashCmdList.RELOADUI = ReloadUI

--------------------------------


local pollCraftEventListener = CreateFrame("Frame");
local events = {};


function events:ADDON_LOADED(addonName)

	if addonName ~= "PollCraft" then
		return;
	end

	InitCreatePollFrame();
	InitCurrentPollsFrame();
	--TestOneSimpleVote();
	--TestSomeVotes();
end

pollCraftEventListener:SetScript("OnEvent", function(self, event, ...)
	events[event](self, ...);
end);

for k, v in pairs(events) do
	pollCraftEventListener:RegisterEvent(k);
end
