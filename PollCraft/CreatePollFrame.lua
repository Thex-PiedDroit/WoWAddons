
g_createPollFrame = {};

local mainFrameSize =
{
	x = 800,
	y = 600
};
local framesMargin = (mainFrameSize.x / 40);

local CreatePollTypesDropdownList = nil;
local answersParentFrame = nil;
local answersScrollFrame = nil;
local CreateAnswerEditBox = nil;

local SendNewPollAway = nil;


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
	mainFrame.pollTypesDropDownList = newPollFrame.pollTypesDropDownList;

	local allowNewAnswersLabel = CreateLabel(newPollFrame, "Allow users to add answers", 16);
	allowNewAnswersLabel:SetPoint("TOPLEFT", framesMargin + 220, pollTypesListPosY + 22);
	local allowNewAnswersCheck = CreateCheckButton(newPollFrame, "AllowNewAnswersCheckButton");
	allowNewAnswersCheck:SetPoint("TOPLEFT", framesMargin + 195, pollTypesListPosY + 25);
	mainFrame.allowNewAnswersCheck = allowNewAnswersCheck;

	local allowMultipleVotesLabel = CreateLabel(newPollFrame, "Allow multiple votes", 16);
	allowMultipleVotesLabel:SetPoint("TOPLEFT", framesMargin + 220, pollTypesListPosY - 5);
	local allowMultipleVotesCheck = CreateCheckButton(newPollFrame, "AllowMultipleVotesCheckButton");
	allowMultipleVotesCheck:SetPoint("TOPLEFT", framesMargin + 195, pollTypesListPosY - 2);
	mainFrame.allowMultipleVotesCheck = allowMultipleVotesCheck;



	--[[      QUESTION EDITBOX      ]]--
	local questionEditBoxPosY = pollTypesListPosY - 80;

	local questionEditBoxLabel = CreateLabel(newPollFrame, "Question:", 16);
	questionEditBoxLabel:SetPoint("TOPLEFT", framesMargin, questionEditBoxPosY + 26);

	local questionEditBoxSize =
	{
		x = optionsFrameSize.x - (framesMargin * 2),
		y = 44
	}
	local newQuestionEditBox = CreateEditBox("QuestionEditBox", newPollFrame, questionEditBoxSize.x, questionEditBoxSize.y, false, nil, nil, 16);
	newQuestionEditBox:SetPoint("TOP", 0, questionEditBoxPosY);
	mainFrame.questionEditBoxScrollFrame = newQuestionEditBox;


	--[[      ANSWERS FRAME      ]]--
	local answersEditBoxLabel = CreateLabel(newPollFrame, "Answers:", 16);
	local answersFramePosY = questionEditBoxPosY - questionEditBoxSize.y - 58;
	answersEditBoxLabel:SetPoint("TOPLEFT", framesMargin, answersFramePosY + 20);

	local answersFrameSize =
	{
		x = questionEditBoxSize.x + 12,
		y = optionsFrameSize.y - questionEditBoxSize.y + questionEditBoxPosY - 120;
	}
	local answersFrame = CreateScrollFrame("AnswersFrame_InterfacePoll", newPollFrame, answersFrameSize.x, answersFrameSize.y);
	answersFrame:SetPoint("TOP", 0, answersFramePosY);

	answersFrame.content.answersBoxes = {};
	answersParentFrame = answersFrame.content;
	answersScrollFrame = answersFrame;
	CreateAnswerEditBox();
	local answersFrameLevel = answersFrame.content:GetFrameLevel();
	allowNewAnswersCheck:SetFrameLevel(answersFrameLevel + 10);
	allowMultipleVotesCheck:SetFrameLevel(answersFrameLevel + 10);
	newQuestionEditBox:SetFrameLevel(answersFrameLevel + 10);


	local createPollButton = CreateButton("CreatePollButton", newPollFrame, 120, 30, "Create Poll", SendNewPollAway);
	createPollButton:SetPoint("TOP", 0, answersFramePosY - answersFrameSize.y - (framesMargin * 0.5));
	createPollButton:SetFrameLevel(answersFrameLevel + 10);


	g_createPollFrame.createPollFrame = newPollFrame;
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


local answersCount = 0;
local marginBetweenAnswers = 20;
local answerEditBoxHeight = 44;
local totalHeightOfEachAnswer = answerEditBoxHeight + marginBetweenAnswers;
local AddOrRemoveAnswerEditBox = nil;
local RemoveAnswer = nil;
local answerObjects = {};

CreateAnswerEditBox = function()

	local answerObject = {};

	local answerNumberStr = tostring(answersCount + 1);

	local answerEditBoxWidth = answersParentFrame:GetWidth() - (framesMargin * 4) - 40;

	local boxPosY = -((totalHeightOfEachAnswer * answersCount) + marginBetweenAnswers);

	local answerNumber = CreateLabel(answersParentFrame, answerNumberStr .. ".", 16);
	answerNumber:SetPoint("TOPLEFT", framesMargin - 5, boxPosY - 5);

	local newAnswerEditBox = CreateEditBox("AnswerEditBox", answersParentFrame, answerEditBoxWidth, answerEditBoxHeight, false, AddOrRemoveAnswerEditBox, answersCount + 1, 16);
	newAnswerEditBox:SetPoint("TOPLEFT", framesMargin + 30, boxPosY);

	local deleteButton = CreateIconButton("DeleteAnswer" .. answerNumberStr .. "Button", answersParentFrame, 20, "Interface/Buttons/Ui-grouploot-pass-up", "Interface/Buttons/Ui-grouploot-pass-down", nil, RemoveAnswer, answersCount + 1);
	deleteButton:SetPoint("TOPLEFT", framesMargin + 30 + answerEditBoxWidth + 12, boxPosY);

	answersCount = answersCount + 1;

	answerObject.number = answerNumber;
	answerObject.editBoxScrollFrame = newAnswerEditBox;
	answerObject.deleteButton = deleteButton;

	table.insert(answersParentFrame.answersBoxes, newAnswerEditBox);
	table.insert(answerObjects, answerObject);
end

AddOrRemoveAnswerEditBox = function(currentlyModifiedAnswerIndex)

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

RemoveAnswer = function(index)

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
	return MyGUID() .. tostring(random(1000000, 9999999));
end

SendNewPollAway = function()

	local data = g_createPollFrame.panel;
	local newPoll =
	{
		pollID = GeneratePollGUID(),
		pollType = UIDropDownMenu_GetSelectedValue(data.pollTypesDropDownList),
		multiVotes = data.allowMultipleVotesCheck:GetChecked(),
		allowNewAnswers = data.allowNewAnswersCheck:GetChecked(),
		question = data.questionEditBoxScrollFrame.EditBox:GetText(),
		answers = {}
	}

	for i = 1, answersCount - 1 do
		table.insert(newPoll.answers, answerObjects[i].editBoxScrollFrame.EditBox:GetText());
	end

	if newPoll.question == nil or newPoll.question == ""
		or newPoll.answers == nil or #newPoll.answers == 0
		or newPoll.answers[1] == nil or newPoll.answers[1] == "" then
		return;
	end

	local newMessage =
	{
		messageType = "NewPoll",
		poll = newPoll
	}

	g_pollCraftComm:SendMessage(newMessage, newPoll.pollType);
	LoadAndOpenReceivePollFrame(newPoll, Me());
	g_receivePollFrame.panel:ClearAllPoints();
	g_receivePollFrame.panel:SetPoint("TOPLEFT", g_createPollFrame.panel, "TOPRIGHT", 0, 0);
end
