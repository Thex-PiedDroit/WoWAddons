
Cerberus_HookThisFile();

g_createPollFrame = {};

local containingFrameSize =
{
	x = 800,
	y = 600
};
local innerFramesMargin = GetInnerFramesMargin();
local marginBetweenUpperBordersAndText = GetTextMarginFromUpperFramesBorders();
local sizeDifferenceBetweenFrameAndEditBox = GetSizeDifferenceBetweenFrameAndEditBox();

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
	createPollButton:SetPoint("BOTTOM", mainFrame, "BOTTOM", 0, innerFramesMargin * 2);


		--[[      POLL OPTIONS      ]]--
	CreatePollTypesDropdownList(mainFrame);
	containingFrame.pollTypesDropDownList = mainFrame.pollTypesDropDownList;

	local checksPosX = innerFramesMargin + 195;
	local allowNewAnswersLabel = CreateLabel(mainFrame, "Allow users to add answers", 16);
	allowNewAnswersLabel:SetPoint("TOPLEFT", checksPosX + 25, marginBetweenUpperBordersAndText);
	local allowNewAnswersCheck = CreateCheckButton(mainFrame, "AllowNewAnswersCheckButton");
	allowNewAnswersCheck:SetPoint("TOPLEFT", checksPosX, marginBetweenUpperBordersAndText + 3);
	containingFrame.allowNewAnswersCheck = allowNewAnswersCheck;

	local allowMultipleVotesLabel = CreateLabel(mainFrame, "Allow multiple votes", 16);
	allowMultipleVotesLabel:SetPoint("TOPLEFT", allowNewAnswersLabel, "TOPLEFT", 0, marginBetweenUpperBordersAndText * 1.5);
	local allowMultipleVotesCheck = CreateCheckButton(mainFrame, "AllowMultipleVotesCheckButton");
	allowMultipleVotesCheck:SetPoint("TOPLEFT", allowNewAnswersCheck, "TOPLEFT", 0, marginBetweenUpperBordersAndText * 1.5);
	containingFrame.allowMultipleVotesCheck = allowMultipleVotesCheck;



		--[[      QUESTION EDITBOX      ]]--
	local questionEditBoxPosY = marginBetweenUpperBordersAndText * 6;
	local questionEditBoxSize =
	{
		x = innerFrameSize.x - (innerFramesMargin * 2) - sizeDifferenceBetweenFrameAndEditBox,
		y = 44
	}
	local newQuestionEditBox = CreateEditBox("QuestionEditBox", mainFrame, questionEditBoxSize, false, nil, nil, 16);
	newQuestionEditBox:SetPoint("TOPLEFT", mainFrame.pollTypesDropDownList, "BOTTOMLEFT", innerFramesMargin + (sizeDifferenceBetweenFrameAndEditBox * 0.5), marginBetweenUpperBordersAndText * 2);
	local questionEditBoxLabel = CreateLabel(newQuestionEditBox, "Question:", 16);
	questionEditBoxLabel:SetPoint("TOPLEFT", 10 - (sizeDifferenceBetweenFrameAndEditBox * 0.5), (sizeDifferenceBetweenFrameAndEditBox * 0.5) - marginBetweenUpperBordersAndText);

	containingFrame.questionEditBoxScrollFrame = newQuestionEditBox;


		--[[      ANSWERS FRAME      ]]--
	local answersFrameSize =
	{
		x = questionEditBoxSize.x + sizeDifferenceBetweenFrameAndEditBox,
		y = 100		-- Placeholder before resizing
	}
	local answersFrame = CreateScrollFrame("AnswersFrame_InterfacePoll", mainFrame, answersFrameSize);
	answersFrame:SetPoint("TOP", newQuestionEditBox, "BOTTOM", 0, marginBetweenUpperBordersAndText * 2);
	answersFrame:SetPoint("BOTTOM", createPollButton, "TOP", 0, (innerFramesMargin * 2) - 8);
	local answersEditBoxLabel = CreateLabel(answersFrame, "Answers:", 16);
	answersEditBoxLabel:SetPoint("TOPLEFT", 10, -marginBetweenUpperBordersAndText);

	answersFrame.content.answersBoxes = {};
	answersParentFrame = answersFrame.content;
	answersScrollFrame = answersFrame;
	CreateAnswerEditBox();
	local answersFrameLevel = answersFrame.content:GetFrameLevel();
	allowNewAnswersCheck:SetFrameLevel(answersFrameLevel + 10);
	allowMultipleVotesCheck:SetFrameLevel(answersFrameLevel + 10);
	newQuestionEditBox:SetFrameLevel(answersFrameLevel + 10);

	createPollButton:SetFrameLevel(answersFrameLevel + 10);


	g_createPollFrame.createPollFrame = mainFrame;
	g_createPollFrame.panel = containingFrame;
end


--[[local]] CreatePollTypesDropdownList = function(parentFrame)

	local listLabel = CreateLabel(parentFrame, "Poll Type", 16);
	listLabel:SetPoint("TOPLEFT", innerFramesMargin + 10, marginBetweenUpperBordersAndText);

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
	pollTypesList:SetPoint("TOPLEFT", 0, marginBetweenUpperBordersAndText * 2);
	UIDropDownMenu_SetSelectedValue(pollTypesList, availableOptions[1].value, false);
	parentFrame.pollTypesDropDownList = pollTypesList;
end


local answersCount = 0;
local marginBetweenAnswers = 20;
local answerEditBoxSize = { x = 0, y = 44 };
local totalHeightOfEachAnswer = answerEditBoxSize.y + marginBetweenAnswers;
local AddOrRemoveAnswerEditBox = nil;
local RemoveAnswer = nil;
local answerObjects = {};

--[[local]] CreateAnswerEditBox = function()

	local answerObject = {};

	local answerNumberStr = tostring(answersCount + 1);

	if answerEditBoxSize.x == 0 then
		answerEditBoxSize.x = answersParentFrame:GetWidth() - (innerFramesMargin * 2) - 90;
	end

	local boxPosY = -((totalHeightOfEachAnswer * answersCount) + marginBetweenAnswers);

	local newAnswerEditBox = CreateEditBox("AnswerEditBox", answersParentFrame, answerEditBoxSize, false, AddOrRemoveAnswerEditBox, answersCount + 1, 16);
	newAnswerEditBox:SetPoint("TOPLEFT", innerFramesMargin + 40, boxPosY);

	local answerNumber = CreateLabel(answersParentFrame, answerNumberStr .. ".", 16);
	answerNumber:SetPoint("TOPRIGHT", newAnswerEditBox, "TOPLEFT", -innerFramesMargin, 0);

	local deleteButton = CreateIconButton("DeleteAnswer" .. answerNumberStr .. "Button", answersParentFrame, 20, "Interface/Buttons/Ui-grouploot-pass-up", "Interface/Buttons/Ui-grouploot-pass-down", nil, RemoveAnswer, answersCount + 1);
	deleteButton:SetPoint("TOPLEFT", newAnswerEditBox, "TOPRIGHT", innerFramesMargin, 0);

	answersCount = answersCount + 1;

	answerObject.number = answerNumber;
	answerObject.editBoxScrollFrame = newAnswerEditBox;
	answerObject.deleteButton = deleteButton;

	table.insert(answersParentFrame.answersBoxes, newAnswerEditBox);
	table.insert(answerObjects, answerObject);
end

--[[local]] AddOrRemoveAnswerEditBox = function(currentlyModifiedAnswerIndex)

	local object = answerObjects[currentlyModifiedAnswerIndex];
	local boxText = object.editBoxScrollFrame.EditBox:GetText();

	if boxText == nil or boxText == "" then
		RemoveAnswer(currentlyModifiedAnswerIndex);

	elseif currentlyModifiedAnswerIndex == answersCount then
		if answersCount < #answerObjects then
			local nextObject = answerObjects[currentlyModifiedAnswerIndex + 1];
			nextObject.number:Show();
			nextObject.editBoxScrollFrame:Show();
			nextObject.deleteButton:Show();
			answersCount = answersCount + 1;
		else
			CreateAnswerEditBox();
		end
	end

	UpdateScrollBar(answersScrollFrame, answersCount * totalHeightOfEachAnswer);
end

--[[local]] RemoveAnswer = function(index)

	if index == answersCount then
		local editBox = answerObjects[index].editBoxScrollFrame.EditBox;
		editBox:SetText("");
		editBox:ClearFocus();
		editBox:HighlightText(0, 0);	-- Forces highlight removal
		return;
	end

	for i = index, answersCount - 1 do

		local nextObject = answerObjects[i + 1];
		answerObjects[i].editBoxScrollFrame.EditBox:SetText(nextObject.editBoxScrollFrame.EditBox:GetText());

		if i + 1 == answersCount then
			nextObject.number:Hide();
			nextObject.editBoxScrollFrame:Hide();
			nextObject.deleteButton:Hide();
		end
	end

	answersCount = answersCount - 1;
	UpdateScrollBar(answersScrollFrame, answersCount * totalHeightOfEachAnswer);
end


local function GeneratePollGUID()
	return MyGUID() .. tostring(math.random(1000000, 9999999));
end

function SendPollData(pollData)

	SendPollMessage({ poll = pollData }, "NewPoll", pollData.pollType);
	LoadAndOpenVoteFrame(pollData, Me(), MyRealm());

	g_currentPollsMotherFrame.panel:ClearAllPoints();
	g_currentPollsMotherFrame.panel:SetPoint("TOPLEFT", g_createPollFrame.panel, "TOPRIGHT", 0, 0);
end

--[[local]] SendNewPollAway = function()

	local data = g_createPollFrame.panel;
	local newPollData =
	{
		pollGUID = GeneratePollGUID(),
		pollMasterFullName = Me(),
		pollMasterRealm = MyRealm(),
		pollType = UIDropDownMenu_GetSelectedValue(data.pollTypesDropDownList),
		multiVotes = data.allowMultipleVotesCheck:GetChecked(),
		allowNewAnswers = data.allowNewAnswersCheck:GetChecked(),
		question = data.questionEditBoxScrollFrame.EditBox:GetText(),
		answers = {}
	}

	for i = 1, answersCount - 1 do
		local answerObject =
		{
			text = answerObjects[i].editBoxScrollFrame.EditBox:GetText(),
			GUID = tostring(i)
		}
		table.insert(newPollData.answers, answerObject);
	end

	if newPollData.question == nil or newPollData.question == ""
		or newPollData.answers == nil or #newPollData.answers < 2
		or newPollData.answers[2] == nil or newPollData.answers[2].text == nil or newPollData.answers[2].text == "" then
		return;
	end

	SendPollData(newPollData);
end
