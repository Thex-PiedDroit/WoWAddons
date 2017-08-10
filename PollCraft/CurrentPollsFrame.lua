

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

	g_currentPollsMotherFrame.panel = mainFrame;
	g_currentPollsMotherFrame.currentPollFrame = currentPollFrame;

	InitVoteFrame();
	InitResultsFrame();

	table.insert(mainFrame.tabFrames, currentPollFrame);

	mainFrame:Hide();
end
