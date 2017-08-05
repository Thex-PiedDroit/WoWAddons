

g_currentPollsMotherFrame = {};


local motherFrameSize =
{
	x = 600,
	y = 700
}
function GetMotherFrameSize()
	return motherFrameSize;
end
local innerFramesMargin = (motherFrameSize.x / 40);
function GetInnerFramesMargin()
	return innerFramesMargin;
end


function InitCurrentPollsFrame()

	if g_currentPollsMotherFrame.panel ~= nil then
		return;
	end

	local mainFrame = CreateBackdroppedFrame("CurrentPollsMotherFrame", UIParent, motherFrameSize.x, motherFrameSize.y, true);
	mainFrame:SetPoint("CENTER", 0, 0);
	MakeFrameClosable(mainFrame, "CurrentPollsMotherFrame");

	g_currentPollsMotherFrame.panel = mainFrame;

	InitVoteFrame();
	InitResultsFrame();

	mainFrame:Hide();
end