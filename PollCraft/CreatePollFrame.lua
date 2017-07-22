
g_createPollFrame = {};

local mainFrameSize =
{
	x = 800,
	y = 600
};


function InitCreatePollFrame()

	local mainFrame = CreateBackdroppedFrame("CreatePollFrame", UIParent, mainFrameSize.x, mainFrameSize.y, true);
	mainFrame:SetPoint("CENTER", 0, 0);

	local titleFrame = CreateBackdroppedFrame("CreatePollFrameTitleBackdrop", mainFrame, 250, 35);
	titleFrame:SetPoint("TOP", 0, -20);
	local mainFrameTitle = CreateLabel(titleFrame, "PollCraft - Create Poll", 20);
	mainFrameTitle:SetPoint("CENTER", 0, 0);


	g_createPollFrame.panel = mainFrame;
end
