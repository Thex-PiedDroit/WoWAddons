
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
	--TestCreateSimplePoll();
	TestAddSomePollsToData();
	--TestOneSimpleVote();
	--TestSomeVotes();
	PanelTemplates_SetTab(g_currentPollsMotherFrame.panel, 2);
	g_currentPollsMotherFrame.pollsListFrame:Show();
end

pollCraftEventListener:SetScript("OnEvent", function(self, event, ...)
	events[event](self, ...);
end);

for k, v in pairs(events) do
	pollCraftEventListener:RegisterEvent(k);
end
