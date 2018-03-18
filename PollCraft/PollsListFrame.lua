
Cerberus_HookThisFile();

local fInnerFramesMargin = GetInnerFramesMargin();
local fMarginBetweenUpperBordersAndText = GetTextMarginFromUpperFramesBorders();

local listsFrames =
{
	["mine"] = nil,
	["theirs"] = nil
};

local UpdateLists = nil;
function RequestPollsListsUpdate()

	if g_currentPollsMotherFrame.pollsList ~= nil and g_currentPollsMotherFrame.pollsList:IsVisible() then
		UpdateLists();
	end
end


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
	};


		--[[      POLLS CREATED BY ME      ]]--
	local createdByMeListFrame = CreateScrollFrame("CreatedByMeListFrame", mainFrame, listsFramesSize);
	createdByMeListFrame:SetPoint("TOP", mainFrame, "TOP", 0, fMarginBetweenUpperBordersAndText * 2);
	listsFrames["mine"] = createdByMeListFrame.content;

	local createdByMeSectionLabel = CreateLabel(createdByMeListFrame, "Created by me:", 16);
	createdByMeSectionLabel:SetPoint("TOPLEFT", fInnerFramesMargin + 10, -fMarginBetweenUpperBordersAndText);


		--[[      POLLS CREATED BY OTHERS      ]]--
	local createdByOthersListFrame = CreateScrollFrame("CreatedByOthersListFrame", mainFrame, listsFramesSize);
	createdByOthersListFrame:SetPoint("TOP", createdByMeListFrame, "BOTTOM", 0, fMarginBetweenUpperBordersAndText * 2);
	listsFrames["theirs"] = createdByOthersListFrame.content;

	local createdByOthersSectionLabel = CreateLabel(createdByOthersListFrame, "Created by others:", 16);
	createdByOthersSectionLabel:SetPoint("TOPLEFT", fInnerFramesMargin + 10, -fMarginBetweenUpperBordersAndText);


	mainFrame:SetScript("OnShow", function() UpdateLists(); end);
	g_currentPollsMotherFrame.pollsList = mainFrame;
end


local itemsObjects =
{
	["mine"] = {},
	["mineCount"] = 0,
	["theirs"] = {},
	["theirsCount"] = 0
};
local iItemsTotalCount = 0;
local itemsSize =
{
	x = 0,
	y = 40
};
local fTotalHeightOfEachItem = itemsSize.y + (fInnerFramesMargin * 0.5);

local RemovePollFromData = nil;

local function ResizeLargeSilverButtonTexture(button, fSizeY)	-- Because they don't get resized with the button on this template

	local itemRegions = { button:GetRegions() };

	for i = 1, #itemRegions do
		local currentRegion = itemRegions[i];
		if currentRegion.GetTexture ~= nil then
			currentRegion:SetHeight(fSizeY + 15);
		end
	end
end

local bDontShowDialogAgain = false;
local function OnClickCallbackRemovePoll(listItem)

	if not bDontShowDialogAgain then
		local popup = StaticPopup_Show("PollCraft_ConfirmRemovePollFromData");
		popup.data = listItem;

	else
		RemovePollFromData(listItem);
	end
end

local OpenPollFromItem = nil;

local function CreateNewItem(list, sListType, iActiveItemsCountInList, pollData)

	--[[      QUESTION FRAME      ]]--
	if itemsSize.x == 0 then
		itemsSize.x = list:GetWidth() - (fInnerFramesMargin * 2) - list:GetParent().scrollbar:GetWidth();
	end

	local sItemNumberStr = tostring(iActiveItemsCountInList + 1) .. sListType;
	local newItemFrame = CreateFrame("Frame", "Poll" .. sItemNumberStr .. "ContainingFrame", list);
	newItemFrame:SetSize(itemsSize.x, itemsSize.y);
	local fNewItemPosY = -(fTotalHeightOfEachItem * iActiveItemsCountInList) - fInnerFramesMargin;
	newItemFrame:SetPoint("TOPLEFT", fInnerFramesMargin, fNewItemPosY);

		--[[      VOTED CHECK      ]]--
	local newItemVotedCheck = CreateCheckButton("Poll" .. sItemNumberStr .. "IsVotedCheck", newItemFrame, nil, nil, 30);
	newItemVotedCheck:SetDisabledCheckedTexture(nil);
	newItemVotedCheck:Disable();
	newItemVotedCheck:SetPoint("LEFT", 0, 0);

		--[[      QUESTION BUTTON      ]]--
	local questionFrameSize =
	{
		x = itemsSize.x - (fInnerFramesMargin * 2) - 54,
		y = itemsSize.y
	};
	local newItemQuestionButton = CreateButton("Poll" .. sItemNumberStr .. "QuestionTextFrame", newItemFrame, questionFrameSize, "Question here", OpenPollFromItem, { sItemListType = sListType, iPollItemIndex = #(itemsObjects[sListType]) + 1 }, "UIPanelLargeSilverButton");
	newItemQuestionButton:SetPoint("TOPLEFT", 30, 0);
	ResizeLargeSilverButtonTexture(newItemQuestionButton, questionFrameSize.y);

	local buttonFontString = CreateLabel(newItemQuestionButton, "Question here", 16, "LEFT");
	buttonFontString:SetPoint("TOPLEFT", fInnerFramesMargin + 4, -fInnerFramesMargin - 4);
	buttonFontString:SetPoint("BOTTOMRIGHT", newItemQuestionButton, "BOTTOMRIGHT", -fInnerFramesMargin - 4, fInnerFramesMargin + 4);
	newItemQuestionButton:SetFrameLevel(20);

	item =
	{
		containingFrame = newItemFrame,
		sPollGUID = sPollGUID,
		questionButtonLabel = buttonFontString,
		alreadyVotedCheck = newItemVotedCheck,
		bAborted = false,
	};

		--[[      REMOVE POLL BUTTON      ]]--
	local deleteButton = CreateIconButton("RemovePoll" .. sItemNumberStr .. "Button", newItemFrame, 20, "Interface/Buttons/Ui-grouploot-pass-up", "Interface/Buttons/Ui-grouploot-pass-down", "Interface/Buttons/Ui-grouploot-pass-highlight", OnClickCallbackRemovePoll, item);
	deleteButton:SetPoint("TOPLEFT", newItemQuestionButton, "RIGHT", fInnerFramesMargin, questionFrameSize.y * 0.28);


	table.insert(itemsObjects[sListType], item);
	return item;
end

local function AddItemToLists(sPollGUID)

	local pollData = GetPollData(sPollGUID);

	local sPollListType = "theirs";
	if pollData.sPollMasterFullName == Me() then
		sPollListType = "mine";
	end

	local associatedListFrame = listsFrames[sPollListType];
	local iItemsCountInThisList = #itemsObjects[sPollListType];
	local iActiveItemsCountInList = itemsObjects[sPollListType .. "Count"];


	local item = nil;

	if iItemsCountInThisList > iActiveItemsCountInList then	-- Use unused item
		item = itemsObjects[sPollListType][iActiveItemsCountInList + 1];
		item.containingFrame:Show();

	else
		item = CreateNewItem(associatedListFrame, sPollListType, iActiveItemsCountInList, pollData);
	end

	item.sPollGUID = sPollGUID;
	item.questionButtonLabel:SetText(pollData.sQuestion);
	item.alreadyVotedCheck:SetChecked(pollData.bIVoted);

	iItemsTotalCount = iItemsTotalCount + 1;
	itemsObjects[sPollListType .. "Count"] = iActiveItemsCountInList + 1;
end

local function HideUnusedItemsFromList(list, pollsToAddGUIDs)

	local iUnusedItemsCount = 0;

	for i = 1, #list do
		local currentItem = list[i];
		local sCurrentItemPollGUID = currentItem.sPollGUID;

		local bCurrentPollGUIDExists = true;

		if sCurrentItemPollGUID == nil then
			break;

		elseif pollsToAddGUIDs[sCurrentItemPollGUID] == nil then
			bCurrentPollGUIDExists = false;
			iUnusedItemsCount = iUnusedItemsCount + 1;
			currentItem.sPollGUID = nil;
			currentItem.containingFrame:Hide();

		elseif iUnusedItemsCount > 0 then

			local itemToReplace = list[i - iUnusedItemsCount];
			itemToReplace.sPollGUID = sCurrentItemPollGUID;
			itemToReplace.questionButtonLabel:SetText(currentItem.questionButtonLabel:GetText());
			itemToReplace.alreadyVotedCheck:SetChecked(currentItem.alreadyVotedCheck:GetChecked());
			itemToReplace.containingFrame:Show();
			currentItem.containingFrame:Hide();
			currentItem.sPollGUID = nil;
		end

		if bCurrentPollGUIDExists then
			pollsToAddGUIDs[sCurrentItemPollGUID] = nil;
		end
	end

	iItemsTotalCount = iItemsTotalCount - iUnusedItemsCount;
	return iUnusedItemsCount;
end

local function HideUnusedItems(pollsToAddGUIDs)

	itemsObjects["mineCount"] = itemsObjects["mineCount"] - HideUnusedItemsFromList(itemsObjects["mine"], pollsToAddGUIDs);
	itemsObjects["theirsCount"] = itemsObjects["theirsCount"] - HideUnusedItemsFromList(itemsObjects["theirs"], pollsToAddGUIDs);
end

StaticPopupDialogs["PollCraft_ConfirmRemovePollFromData"] =
{
	text = "This will remove the poll from your list until someone shares it back with you.\nAre you sure you want to do this?",
	button1 = ACCEPT,
	button2 = CANCEL,
	button3 = "Don't show again",
	OnAccept = function(self, data)
		RemovePollFromData(data);
	end,
	OnAlt = function(self, data)
		RemovePollFromData(data);
		bDontShowDialogAgain = true;
	end,
	whileDead = true,
	hideOnEscape = true,
}

--[[local]] RemovePollFromData = function(listItem)
	local sPollGUID = listItem.sPollGUID;

	local pollData = GetPollData(sPollGUID);

	if pollData.sPollMasterFullName == Me() then
		local resultsMessageData =
		{
			sPollGUID = sPollGUID,
			pollAnswers = pollData.answers,
			results = pollData.results
		}
		SendPollMessage({ resultsData = resultsMessageData }, "PollAbort", pollData.sPollType);

	else
		RemovePollDataFromMemory(sPollGUID);
	end
end

function AddAbortedMessageToQuestionInPollsList(sPollGUID)

	for i = 1, itemsObjects["theirsCount"] do
		if itemsObjects["theirs"][i].sPollGUID == sPollGUID then
			local item = itemsObjects["theirs"][i];
			item.questionButtonLabel:SetText(ColoriseText("(This poll has been aborted by its master) ", g_cRedWarningColor) .. item.questionButtonLabel:GetText());
			item.bAborted = true;
			return;
		end
	end
end


function TickVoteForPoll(sPollGUID, bVoted, bIsPollMine)

	local sPollListType = "theirs";
	if bIsPollMine then
		sPollListType = "mine";
	end

	for i = 1, itemsObjects[sPollListType .. "Count"] do
		local currentItem = itemsObjects[sPollListType][i];
		if currentItem.sPollGUID == sPollGUID then
			currentItem.alreadyVotedCheck:SetChecked(bVoted);
			break;
		end
	end
end

--[[local]] UpdateLists = function()

	local pollsToAddGUIDs = table.clone(GetAllPollsGUID());
	HideUnusedItems(pollsToAddGUIDs);

	for sPollGUID, _ in pairs(pollsToAddGUIDs) do
		AddItemToLists(sPollGUID);
	end

	UpdateScrollBar(listsFrames["mine"]:GetParent(), (itemsObjects["mineCount"] * fTotalHeightOfEachItem) - fInnerFramesMargin);
	UpdateScrollBar(listsFrames["theirs"]:GetParent(), (itemsObjects["theirsCount"] * fTotalHeightOfEachItem) - fInnerFramesMargin);
end

OpenPollFromItem = function(self, args)

	local item = itemsObjects[args.sItemListType][args.iPollItemIndex];
	if not item.bAborted then
		OpenPoll(GetPollData(item.sPollGUID));
	else
		item.bAborted = false;
		RequestPollsListsUpdate();
	end
end

function OpenPollsListFrame()

	PanelTemplates_SetTab(g_currentPollsMotherFrame.panel, 2);
	g_currentPollsMotherFrame.panel:Show();
	g_currentPollsMotherFrame.pollsListFrame:Show();
end
