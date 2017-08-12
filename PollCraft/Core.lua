
SLASH_RELOADUI1 = "/rl"
SlashCmdList.RELOADUI = ReloadUI

--------------------------------


local pollCraftEventListener = CreateFrame("Frame");
local events = {};

DEBUG_VERSION = true;


function events:ADDON_LOADED(addonName)

	if addonName ~= "PollCraft" then
		return;
	end

	InitCreatePollFrame();
	InitCurrentPollsFrame();

	if DEBUG_VERSION then
		--TestCreateSimplePoll();
		--TestAddSomePollsToData();
		--TestOneSimpleVote();
		--TestSomeVotes();
	end
end

pollCraftEventListener:SetScript("OnEvent", function(self, event, ...)
	events[event](self, ...);
end);

for k, v in pairs(events) do
	pollCraftEventListener:RegisterEvent(k);
end
