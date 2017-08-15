
Cerberus_HookThisFile();

local fInnerFramesMargin = GetInnerFramesMargin();
local fMarginBetweenUpperBordersAndText = GetTextMarginFromUpperFramesBorders();


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
		x = innerFrameSize.x - (fInnerFramesMargin * 2),
		y = ((innerFrameSize.y - fInnerFramesMargin) * 0.5) + (fMarginBetweenUpperBordersAndText * 2)
	}

		--[[      POLLS CREATED BY ME      ]]--
	local createdByMeListFrame = CreateScrollFrame("CreatedByMeListFrame", mainFrame, listsFramesSize);
	createdByMeListFrame:SetPoint("TOP", mainFrame, "TOP", 0, fMarginBetweenUpperBordersAndText * 2);

	local createdByMeSectionLabel = CreateLabel(createdByMeListFrame, "Created by me:", 16);
	createdByMeSectionLabel:SetPoint("TOPLEFT", fInnerFramesMargin + 10, -fMarginBetweenUpperBordersAndText);


		--[[      POLLS CREATED BY OTHERS      ]]--
	local createdByOthersListFrame = CreateScrollFrame("CreatedByOthersListFrame", mainFrame, listsFramesSize);
	createdByOthersListFrame:SetPoint("TOP", createdByMeListFrame, "BOTTOM", 0, fMarginBetweenUpperBordersAndText * 2);

	local createdByOthersSectionLabel = CreateLabel(createdByOthersListFrame, "Created by others:", 16);
	createdByOthersSectionLabel:SetPoint("TOPLEFT", fInnerFramesMargin + 10, -fMarginBetweenUpperBordersAndText);


	g_currentPollsMotherFrame.pollsList = mainFrame;
end
