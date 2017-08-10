
g_createPollFrame = {};

local mainFrameSize =
{
	x = 800,
	y = 600
};
local innerFramesMargin = mainFrameSize.x / 80;
local sizeDifferenceBetweenFrameAndEditBox = 0;

local CreatePollTypesDropdownList = nil;
local answersParentFrame = nil;
local answersScrollFrame = nil;
local CreateAnswerEditBox = nil;

local SendNewPollAway = nil;


function InitCreatePollFrame()

	if g_createPollFrame.createPollFrame ~= nil then
		return;
	end

	sizeDifferenceBetweenFrameAndEditBox = GetSizeDifferenceBetweenFrameAndEditBox();

	local mainFrame = CreateBackdroppedFrame("CreatePollFrame", UIParent, mainFrameSize, true);
	mainFrame:SetPoint("CENTER", 0, 0);

	local titleFrame = CreateBackdroppedTitle("CreatePollFrameTitle", mainFrame, "PollCraft - Create Poll")
	titleFrame:SetPoint("TOP", 0, -20);



	local optionsFrameSize =
	{
		x = mainFrameSize.x - (innerFramesMargin * 2),
		y = mainFrameSize.y - (innerFramesMargin * 8)
	};

	local newPollFrame = CreateBackdroppedFrame("CreatePollFrame", mainFrame, optionsFrameSize);
	newPollFrame:SetPoint("BOTTOM", 0, mainFrameSize.x / 80);

	local pollTypesListPosY = -50;
	CreatePollTypesDropdownList(newPollFrame, pollTypesListPosY);
	mainFrame.pollTypesDropDownList = newPollFrame.pollTypesDropDownList;

	local allowNewAnswersLabel = CreateLabel(newPollFrame, "Allow users to add answers", 16);
	allowNewAnswersLabel:SetPoint("TOPLEFT", innerFramesMargin + 220, pollTypesListPosY + 22);
	local allowNewAnswersCheck = CreateCheckButton(newPollFrame, "AllowNewAnswersCheckButton");
	allowNewAnswersCheck:SetPoint("TOPLEFT", innerFramesMargin + 195, pollTypesListPosY + 25);
	mainFrame.allowNewAnswersCheck = allowNewAnswersCheck;

	local allowMultipleVotesLabel = CreateLabel(newPollFrame, "Allow multiple votes", 16);
	allowMultipleVotesLabel:SetPoint("TOPLEFT", innerFramesMargin + 220, pollTypesListPosY - 5);
	local allowMultipleVotesCheck = CreateCheckButton(newPollFrame, "AllowMultipleVotesCheckButton");
	allowMultipleVotesCheck:SetPoint("TOPLEFT", innerFramesMargin + 195, pollTypesListPosY - 2);
	mainFrame.allowMultipleVotesCheck = allowMultipleVotesCheck;



	--[[      QUESTION EDITBOX      ]]--
	local questionEditBoxPosY = pollTypesListPosY - 80;

	local questionEditBoxLabel = CreateLabel(newPollFrame, "Question:", 16);
	questionEditBoxLabel:SetPoint("TOPLEFT", innerFramesMargin, questionEditBoxPosY + 26);

	local questionEditBoxSize =
	{
		x = optionsFrameSize.x - (innerFramesMargin * 2) - sizeDifferenceBetweenFrameAndEditBox,
		y = 44
	}
	local newQuestionEditBox = CreateEditBox("QuestionEditBox", newPollFrame, questionEditBoxSize, false, nil, nil, 16);
	newQuestionEditBox:SetPoint("TOP", 0, questionEditBoxPosY);
	mainFrame.questionEditBoxScrollFrame = newQuestionEditBox;


	--[[      ANSWERS FRAME      ]]--
	local answersEditBoxLabel = CreateLabel(newPollFrame, "Answers:", 16);
	local answersFramePosY = questionEditBoxPosY - questionEditBoxSize.y - 58;
	answersEditBoxLabel:SetPoint("TOPLEFT", innerFramesMargin, answersFramePosY + 20);

	local answersFrameSize =
	{
		x = questionEditBoxSize.x + sizeDifferenceBetweenFrameAndEditBox,
		y = optionsFrameSize.y - questionEditBoxSize.y + questionEditBoxPosY - 120;
	}
	local answersFrame = CreateScrollFrame("AnswersFrame_InterfacePoll", newPollFrame, answersFrameSize);
	answersFrame:SetPoint("TOP", 0, answersFramePosY);

	answersFrame.content.answersBoxes = {};
	answersParentFrame = answersFrame.content;
	answersScrollFrame = answersFrame;
	CreateAnswerEditBox();
	local answersFrameLevel = answersFrame.content:GetFrameLevel();
	allowNewAnswersCheck:SetFrameLevel(answersFrameLevel + 10);
	allowMultipleVotesCheck:SetFrameLevel(answersFrameLevel + 10);
	newQuestionEditBox:SetFrameLevel(answersFrameLevel + 10);


	local createPollButton = CreateButton("CreatePollButton", newPollFrame, { x = 120, y = 30 }, "Create Poll", SendNewPollAway);
	createPollButton:SetPoint("BOTTOM", newPollFrame, "BOTTOM", 0, innerFramesMargin * 2);
	createPollButton:SetFrameLevel(answersFrameLevel + 10);


	g_createPollFrame.createPollFrame = newPollFrame;
	g_createPollFrame.panel = mainFrame;
end


CreatePollTypesDropdownList = function(parentFrame, posY)

	local listLabel = CreateLabel(parentFrame, "Poll Type", 16);
	listLabel:SetPoint("TOPLEFT", innerFramesMargin + 3, posY + 22);

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
local answerEditBoxSize = { x = 0, y = 44 };
local totalHeightOfEachAnswer = answerEditBoxSize.y + marginBetweenAnswers;
local AddOrRemoveAnswerEditBox = nil;
local RemoveAnswer = nil;
local answerObjects = {};

CreateAnswerEditBox = function()

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
	return PollCraft_MyGUID() .. tostring(math.random(1000000, 9999999));
end

SendNewPollAway = function()

	local data = g_createPollFrame.panel;
	local newPoll =
	{
		pollGUID = GeneratePollGUID(),
		pollMasterFullName = PollCraft_Me(),
		pollMasterRealm = PollCraft_MyRealm(),
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
		table.insert(newPoll.answers, answerObject);
	end

	if newPoll.question == nil or newPoll.question == ""
		or newPoll.answers == nil or #newPoll.answers < 2
		or newPoll.answers[2] == nil or newPoll.answers[2].text == nil or newPoll.answers[2].text == "" then
		return;
	end

	SendPollMessage({ poll = newPoll }, "NewPoll", newPoll.pollType);
	LoadAndOpenVoteFrame(newPoll, PollCraft_Me(), PollCraft_MyRealm());
	g_currentPollsMotherFrame.panel:ClearAllPoints();
	g_currentPollsMotherFrame.panel:SetPoint("TOPLEFT", g_createPollFrame.panel, "TOPRIGHT", 0, 0);
end
