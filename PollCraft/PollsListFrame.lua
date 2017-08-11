
local innerFramesMargin = GetInnerFramesMargin();
local marginBetweenUpperBordersAndText = GetTextMarginFromUpperFramesBorders();


function InitPollsListFrame()

	if g_currentPollsMotherFrame.pollsList ~= nil then
		return;
	end


	local motherFrameSize = GetMotherFrameSize();
	local containingFrame = g_currentPollsMotherFrame.pollsListFrame;

	local mainFrame = CreateBackdropTitledInnerFrame("PollsListFrame", containingFrame, "PollCraft - All current polls");
	local innerFrameSize = GetFrameSizeAsTable(mainFrame);


	local listsFramesSize =
	{
		x = innerFrameSize.x - (innerFramesMargin * 2),
		y = ((innerFrameSize.y - innerFramesMargin) * 0.5) + (marginBetweenUpperBordersAndText * 2)
	}

		--[[      POLLS CREATED BY ME      ]]--
	local createdByMeListFrame = CreateScrollFrame("CreatedByMeListFrame", mainFrame, listsFramesSize);
	createdByMeListFrame:SetPoint("TOP", mainFrame, "TOP", 0, marginBetweenUpperBordersAndText * 2);

	local createdByMeSectionLabel = CreateLabel(createdByMeListFrame, "Created by me:", 16);
	createdByMeSectionLabel:SetPoint("TOPLEFT", innerFramesMargin + 10, -marginBetweenUpperBordersAndText);


		--[[      POLLS CREATED BY OTHERS      ]]--
	local createdByOthersListFrame = CreateScrollFrame("CreatedByOthersListFrame", mainFrame, listsFramesSize);
	createdByOthersListFrame:SetPoint("TOP", createdByMeListFrame, "BOTTOM", 0, marginBetweenUpperBordersAndText * 2);
	listsFrames["theirs"] = createdByOthersListFrame;

	local createdByOthersSectionLabel = CreateLabel(createdByOthersListFrame, "Created by others:", 16);
	createdByOthersSectionLabel:SetPoint("TOPLEFT", innerFramesMargin + 10, -marginBetweenUpperBordersAndText);


	g_currentPollsMotherFrame.pollsList = mainFrame;
end
