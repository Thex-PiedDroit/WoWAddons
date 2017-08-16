
Cerberus_HookThisFile();


local pollCraftEventListener = CreateFrame("Frame");
local events = {};

DEBUG_VERSION = true;


function events:ADDON_LOADED(sAddonName)

	if sAddonName ~= "PollCraft" then
		return;
	end

	InitCreatePollFrame();
	InitCurrentPollsFrame();
	InitMinimapButton();

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
