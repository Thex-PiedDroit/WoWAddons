
g_createPollFrame = {};

local mainFrameSize =
{
	x = 800,
	y = 600
};
local framesMargin = (mainFrameSize.x / 40);

local CreatePollTypesDropdownList = nil;


function InitCreatePollFrame()

	local mainFrame = CreateBackdroppedFrame("CreatePollFrame", UIParent, mainFrameSize.x, mainFrameSize.y, true);
	mainFrame:SetPoint("CENTER", 0, 0);

	local titleFrame = CreateBackdroppedFrame("CreatePollFrameTitleBackdrop", mainFrame, 250, 35);
	titleFrame:SetPoint("TOP", 0, -20);
	local mainFrameTitle = CreateLabel(titleFrame, "PollCraft - Create Poll", 20);
	mainFrameTitle:SetPoint("CENTER", 0, 0);



	local optionsFrameSize =
	{
		x = mainFrameSize.x - framesMargin,
		y = mainFrameSize.y - (framesMargin * 4)
	};

	local newPollFrame = CreateBackdroppedFrame("CreatePollFrame", mainFrame, optionsFrameSize.x, optionsFrameSize.y);
	newPollFrame:SetPoint("BOTTOM", 0, mainFrameSize.x / 80);

	local pollTypesListPosY = -50;
	CreatePollTypesDropdownList(newPollFrame, pollTypesListPosY);

	local allowNewAnswersLabel = CreateLabel(newPollFrame, "Allow users to add answers", 16);
	allowNewAnswersLabel:SetPoint("TOPLEFT", framesMargin + 220, pollTypesListPosY + 22);
	local allowNewAnswersCheck = CreateCheckButton(newPollFrame, "AllowNewAnswersCheckButton");
	allowNewAnswersCheck:SetPoint("TOPLEFT", framesMargin + 195, pollTypesListPosY + 25);

	local allowMultipleVotesLabel = CreateLabel(newPollFrame, "Allow multiple votes", 16);
	allowMultipleVotesLabel:SetPoint("TOPLEFT", framesMargin + 220, pollTypesListPosY - 5);
	local allowMultipleVotesCheck = CreateCheckButton(newPollFrame, "AllowMultipleVotesCheckButton");
	allowMultipleVotesCheck:SetPoint("TOPLEFT", framesMargin + 195, pollTypesListPosY - 2);


	g_createPollFrame.panel = mainFrame;
end


CreatePollTypesDropdownList = function(parentFrame, posY)

	local listLabel = CreateLabel(parentFrame, "Poll Type", 16);
	listLabel:SetPoint("TOPLEFT", framesMargin + 3, posY + 22);

	local availableOptions =
	{
		{
			text = "Direct (raid/party)",
			value = "RAID",
			checked = true
		},
		{
			text = "Permanent (guild)",
			value = "GUILD"
		},
	}

	local pollTypesList = CreateDropDownList("PollTypesList", parentFrame, 140, availableOptions);
	pollTypesList:SetPoint("TOPLEFT", 0, posY);
	UIDropDownMenu_SetSelectedValue(pollTypesList, availableOptions[1].value, false);
	parentFrame.pollTypesDropDownList = pollTypesList;
end
