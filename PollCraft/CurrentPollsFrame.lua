
Cerberus_HookThisFile();

g_currentPollsMotherFrame = {};


local motherFrameSize =
{
	x = 600,
	y = 700
}
function GetMotherFrameSize()
	return motherFrameSize;
end


function InitCurrentPollsFrame()

	if g_currentPollsMotherFrame.panel ~= nil then
		return;
	end

	local mainFrame = CreateTabbedFrame("CurrentPollsMotherFrame", UIParent, motherFrameSize, true, { "Poll", "Current polls list" });
	mainFrame:SetPoint("CENTER", 0, 0);
	MakeFrameClosable(mainFrame, "CurrentPollsMotherFrame");

	local currentPollFrame = CreateFrame("Frame", "PollCraft_CurrentPollContainerFrame", mainFrame);
	currentPollFrame:SetSize(motherFrameSize.x, motherFrameSize.y);
	currentPollFrame:SetPoint("CENTER", 0, 0);
	g_currentPollsMotherFrame.currentPollFrame = currentPollFrame;

	local pollsListFrame = CreateFrame("Frame", "PollCraft_PollListContainerFrame", mainFrame);
	pollsListFrame:SetSize(motherFrameSize.x, motherFrameSize.y);
	pollsListFrame:SetPoint("CENTER", 0, 0);
	g_currentPollsMotherFrame.pollsListFrame = pollsListFrame;


	g_currentPollsMotherFrame.panel = mainFrame;

	InitVoteFrame();
	InitResultsFrame();
	InitPollsListFrame();

	table.insert(mainFrame.tabFrames, currentPollFrame);
	table.insert(mainFrame.tabFrames, pollsListFrame);

	currentPollFrame:Hide();
	--pollsListFrame:Hide();
	--mainFrame:Hide();
	PanelTemplates_SetTab(mainFrame, 2);
end

function OpenPoll(pollData)

	if g_currentPollsMotherFrame.currentPollFrame:IsVisible() then
		return "Busy";
	end

	PanelTemplates_SetTab(g_currentPollsMotherFrame.panel, 1);
	g_currentPollsMotherFrame.pollsListFrame:Hide();

	if IAlreadyVotedForThisPoll(pollData.sPollGUID) then
		LoadAndOpenPollResultsFrame(pollData);
	else
		LoadAndOpenVoteFrame(pollData);
	end
end

function OpenCurrentPollsFrameTab(tabContent)

	local iTabToSet = OpenTab(g_currentPollsMotherFrame.panel, tabContent);

	if iTabToSet ~= -1 then
		PanelTemplates_SetTab(g_currentPollsMotherFrame.panel, iTabToSet);
		g_currentPollsMotherFrame.panel:Show();
	end
end
