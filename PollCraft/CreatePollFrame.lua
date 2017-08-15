
Cerberus_HookThisFile();

g_createPollFrame = {};

local containingFrameSize =
{
	x = 800,
	y = 600
};
local fInnerFramesMargin = GetInnerFramesMargin();
local fMarginBetweenUpperBordersAndText = GetTextMarginFromUpperFramesBorders();
local fSizeDifferenceBetweenFrameAndEditBox = GetSizeDifferenceBetweenFrameAndEditBox();

local CreatePollTypesDropdownList = nil;
local answersParentFrame = nil;
local answersScrollFrame = nil;
local CreateAnswerEditBox = nil;

local SendNewPollAway = nil;


function InitCreatePollFrame()

	if g_createPollFrame.createPollFrame ~= nil then
		return;
	end

	local containingFrame = CreateBackdroppedFrame("CreatePollFrame", UIParent, containingFrameSize, true);
	containingFrame:SetPoint("CENTER", 0, 0);

	local mainFrame = CreateBackdropTitledInnerFrame("CreatePollFrame", containingFrame, "PollCraft - Create Poll");
	local innerFrameSize = GetFrameSizeAsTable(mainFrame);


		--[[      CREATE POLL BUTTON      ]]--
	local createPollButton = CreateButton("CreatePollButton", mainFrame, { x = 120, y = 30 }, "Create Poll", SendNewPollAway);
	createPollButton:SetPoint("BOTTOM", mainFrame, "BOTTOM", 0, fInnerFramesMargin * 2);


		--[[      POLL OPTIONS      ]]--
	CreatePollTypesDropdownList(mainFrame);
	containingFrame.pollTypesDropDownList = mainFrame.pollTypesDropDownList;

	local fChecksPosX = fInnerFramesMargin + 195;
	local allowNewAnswersLabel = CreateLabel(mainFrame, "Allow users to add answers", 16);
	allowNewAnswersLabel:SetPoint("TOPLEFT", fChecksPosX + 25, fMarginBetweenUpperBordersAndText);
	local allowNewAnswersCheck = CreateCheckButton(mainFrame, "AllowNewAnswersCheckButton");
	allowNewAnswersCheck:SetPoint("TOPLEFT", fChecksPosX, fMarginBetweenUpperBordersAndText + 3);
	containingFrame.allowNewAnswersCheck = allowNewAnswersCheck;

	local allowMultipleVotesLabel = CreateLabel(mainFrame, "Allow multiple votes", 16);
	allowMultipleVotesLabel:SetPoint("TOPLEFT", allowNewAnswersLabel, "TOPLEFT", 0, fMarginBetweenUpperBordersAndText * 1.5);
	local allowMultipleVotesCheck = CreateCheckButton(mainFrame, "AllowMultipleVotesCheckButton");
	allowMultipleVotesCheck:SetPoint("TOPLEFT", allowNewAnswersCheck, "TOPLEFT", 0, fMarginBetweenUpperBordersAndText * 1.5);
	containingFrame.allowMultipleVotesCheck = allowMultipleVotesCheck;



		--[[      QUESTION EDITBOX      ]]--
	local fQuestionEditBoxPosY = fMarginBetweenUpperBordersAndText * 6;
	local questionEditBoxSize =
	{
		x = innerFrameSize.x - (fInnerFramesMargin * 2) - fSizeDifferenceBetweenFrameAndEditBox,
		y = 44
	}
	local newQuestionEditBox = CreateEditBox("QuestionEditBox", mainFrame, questionEditBoxSize, false, nil, nil, 16);
	newQuestionEditBox:SetPoint("TOPLEFT", mainFrame.pollTypesDropDownList, "BOTTOMLEFT", fInnerFramesMargin + (fSizeDifferenceBetweenFrameAndEditBox * 0.5), fMarginBetweenUpperBordersAndText * 2);
	local questionEditBoxLabel = CreateLabel(newQuestionEditBox, "Question:", 16);
	questionEditBoxLabel:SetPoint("TOPLEFT", 10 - (fSizeDifferenceBetweenFrameAndEditBox * 0.5), (fSizeDifferenceBetweenFrameAndEditBox * 0.5) - fMarginBetweenUpperBordersAndText);

	containingFrame.questionEditBoxScrollFrame = newQuestionEditBox;


		--[[      ANSWERS FRAME      ]]--
	local answersFrameSize =
	{
		x = questionEditBoxSize.x + fSizeDifferenceBetweenFrameAndEditBox,
		y = 100		-- Placeholder before resizing
	}
	local answersFrame = CreateScrollFrame("AnswersFrame_InterfacePoll", mainFrame, answersFrameSize);
	answersFrame:SetPoint("TOP", newQuestionEditBox, "BOTTOM", 0, fMarginBetweenUpperBordersAndText * 2);
	answersFrame:SetPoint("BOTTOM", createPollButton, "TOP", 0, (fInnerFramesMargin * 2) - 8);
	local answersEditBoxLabel = CreateLabel(answersFrame, "Answers:", 16);
	answersEditBoxLabel:SetPoint("TOPLEFT", 10, -fMarginBetweenUpperBordersAndText);

	answersFrame.content.answersBoxes = {};
	answersParentFrame = answersFrame.content;
	answersScrollFrame = answersFrame;
	CreateAnswerEditBox();
	local iAnswersFrameLevel = answersFrame.content:GetFrameLevel();
	allowNewAnswersCheck:SetFrameLevel(iAnswersFrameLevel + 10);
	allowMultipleVotesCheck:SetFrameLevel(iAnswersFrameLevel + 10);
	newQuestionEditBox:SetFrameLevel(iAnswersFrameLevel + 10);

	createPollButton:SetFrameLevel(iAnswersFrameLevel + 10);


	g_createPollFrame.createPollFrame = mainFrame;
	g_createPollFrame.panel = containingFrame;
end


--[[local]] CreatePollTypesDropdownList = function(parentFrame)

	local listLabel = CreateLabel(parentFrame, "Poll Type", 16);
	listLabel:SetPoint("TOPLEFT", fInnerFramesMargin + 10, fMarginBetweenUpperBordersAndText);

	local availableOptions =
	{
		{
			sText = "Direct (raid/party)",
			value = "RAID",
			checked = true
		},
		{
			sText = "Permanent (guild)",
			value = "GUILD"
		},
	}

	local pollTypesList = CreateDropDownList("PollTypesList", parentFrame, 140, availableOptions);
	pollTypesList:SetPoint("TOPLEFT", 0, fMarginBetweenUpperBordersAndText * 2);
	UIDropDownMenu_SetSelectedValue(pollTypesList, availableOptions[1].value, false);
	parentFrame.pollTypesDropDownList = pollTypesList;
end


local iAnswersCount = 0;
local fMarginBetweenAnswers = 20;
local answerEditBoxSize = { x = 0, y = 44 };
local fTotalHeightOfEachAnswer = answerEditBoxSize.y + fMarginBetweenAnswers;
local AddOrRemoveAnswerEditBox = nil;
local RemoveAnswer = nil;
local answerObjects = {};

--[[local]] CreateAnswerEditBox = function()

	local answerObject = {};

	local sAnswerNumberStr = tostring(iAnswersCount + 1);

	if answerEditBoxSize.x == 0 then
		answerEditBoxSize.x = answersParentFrame:GetWidth() - (fInnerFramesMargin * 2) - 90;
	end

	local fBoxPosY = -((fTotalHeightOfEachAnswer * iAnswersCount) + fMarginBetweenAnswers);

	local newAnswerEditBox = CreateEditBox("AnswerEditBox", answersParentFrame, answerEditBoxSize, false, AddOrRemoveAnswerEditBox, iAnswersCount + 1, 16);
	newAnswerEditBox:SetPoint("TOPLEFT", fInnerFramesMargin + 40, fBoxPosY);

	local answerNumber = CreateLabel(answersParentFrame, sAnswerNumberStr .. ".", 16);
	answerNumber:SetPoint("TOPRIGHT", newAnswerEditBox, "TOPLEFT", -fInnerFramesMargin, 0);

	local deleteButton = CreateIconButton("DeleteAnswer" .. sAnswerNumberStr .. "Button", answersParentFrame, 20, "Interface/Buttons/Ui-grouploot-pass-up", "Interface/Buttons/Ui-grouploot-pass-down", nil, RemoveAnswer, iAnswersCount + 1);
	deleteButton:SetPoint("TOPLEFT", newAnswerEditBox, "TOPRIGHT", fInnerFramesMargin, 0);

	iAnswersCount = iAnswersCount + 1;

	answerObject.number = answerNumber;
	answerObject.editBoxScrollFrame = newAnswerEditBox;
	answerObject.deleteButton = deleteButton;

	table.insert(answersParentFrame.answersBoxes, newAnswerEditBox);
	table.insert(answerObjects, answerObject);
end

--[[local]] AddOrRemoveAnswerEditBox = function(iCurrentlyModifiedAnswerIndex)

	local object = answerObjects[iCurrentlyModifiedAnswerIndex];
	local sBoxText = object.editBoxScrollFrame.EditBox:GetText();

	if sBoxText == nil or sBoxText == "" then
		RemoveAnswer(iCurrentlyModifiedAnswerIndex);

	elseif iCurrentlyModifiedAnswerIndex == iAnswersCount then
		if iAnswersCount < #answerObjects then
			local nextObject = answerObjects[iCurrentlyModifiedAnswerIndex + 1];
			nextObject.number:Show();
			nextObject.editBoxScrollFrame:Show();
			nextObject.deleteButton:Show();
			iAnswersCount = iAnswersCount + 1;
		else
			CreateAnswerEditBox();
		end
	end

	UpdateScrollBar(answersScrollFrame, iAnswersCount * fTotalHeightOfEachAnswer);
end

--[[local]] RemoveAnswer = function(iIndex)

	if iIndex == iAnswersCount then
		local editBox = answerObjects[iIndex].editBoxScrollFrame.EditBox;
		editBox:SetText("");
		editBox:ClearFocus();
		editBox:HighlightText(0, 0);	-- Forces highlight removal
		return;
	end

	for i = iIndex, iAnswersCount - 1 do

		local nextObject = answerObjects[i + 1];
		answerObjects[i].editBoxScrollFrame.EditBox:SetText(nextObject.editBoxScrollFrame.EditBox:GetText());

		if i + 1 == iAnswersCount then
			nextObject.number:Hide();
			nextObject.editBoxScrollFrame:Hide();
			nextObject.deleteButton:Hide();
		end
	end

	iAnswersCount = iAnswersCount - 1;
	UpdateScrollBar(answersScrollFrame, iAnswersCount * fTotalHeightOfEachAnswer);
end


local function GeneratePollGUID()
	return MyGUID() .. tostring(math.random(1000000, 9999999));
end

function SendPollData(pollData)

	SendPollMessage({ poll = pollData }, "NewPoll", pollData.sPollType);
	LoadAndOpenVoteFrame(pollData, Me(), MyRealm());

	g_currentPollsMotherFrame.panel:ClearAllPoints();
	g_currentPollsMotherFrame.panel:SetPoint("TOPLEFT", g_createPollFrame.panel, "TOPRIGHT", 0, 0);
end

--[[local]] SendNewPollAway = function()

	local data = g_createPollFrame.panel;
	local newPollData =
	{
		sPollGUID = GeneratePollGUID(),
		sPollMasterFullName = Me(),
		sPollMasterRealm = MyRealm(),
		sPollType = UIDropDownMenu_GetSelectedValue(data.pollTypesDropDownList),
		bMultiVotes = data.allowMultipleVotesCheck:GetChecked(),
		bAllowNewAnswers = data.allowNewAnswersCheck:GetChecked(),
		question = data.questionEditBoxScrollFrame.EditBox:GetText(),
		answers = {}
	}

	for i = 1, iAnswersCount - 1 do
		local answerObject =
		{
			sText = answerObjects[i].editBoxScrollFrame.EditBox:GetText(),
			sGUID = tostring(i)
		}
		table.insert(newPollData.answers, answerObject);
	end

	if newPollData.question == nil or newPollData.question == ""
		or newPollData.answers == nil or #newPollData.answers < 2
		or newPollData.answers[2] == nil or newPollData.answers[2].sText == nil or newPollData.answers[2].sText == "" then
		return;
	end

	SendPollData(newPollData);
end
