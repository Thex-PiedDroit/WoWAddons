
g_createPollFrame = {};

local mainFrameSize =
{
	x = 800,
	y = 600
};
local framesMargin = (mainFrameSize.x / 40);

local CreatePollTypesDropdownList = nil;
local answersParentFrame = nil;
local CreateAnswerEditBox = nil;


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
	newPollFrame.questionEditBox = newQuestionEditBox;


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
	CreateAnswerEditBox();


	local createPollButton = CreateButton("CreatePollButton", newPollFrame, 120, 30, "Create Poll");
	createPollButton:SetPoint("TOP", 0, answersFramePosY - answersFrameSize.y - (framesMargin * 0.5));


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
local marginBetweenAnswers = 30;
local AddOrRemoveAnswerEditBox = nil;
local RemoveAnswer = nil;
local answerObjects = {};

CreateAnswerEditBox = function()

	local answerObject = {};

	local answerNumberStr = tostring(answersCount + 1);

	local editBoxWidth = answersParentFrame:GetWidth() - (framesMargin * 4) - 40;
	local editBoxHeight = 44;

	local boxPosY = ((-marginBetweenAnswers - editBoxHeight) * answersCount) - 30;

	local answerNumber = CreateLabel(answersParentFrame, answerNumberStr .. ".", 16);
	answerNumber:SetPoint("TOPLEFT", framesMargin - 5, boxPosY - 5);

	local newAnswerEditBox = CreateEditBox("QuestionEditBox", answersParentFrame, editBoxWidth, editBoxHeight, false, AddOrRemoveAnswerEditBox, answersCount + 1, 16);
	newAnswerEditBox:SetPoint("TOPLEFT", framesMargin + 30, boxPosY);

	local deleteButton = CreateIconButton("DeleteAnswer" .. answerNumberStr .. "Button", answersParentFrame, 20, "Interface/Buttons/Ui-grouploot-pass-up", "Interface/Buttons/Ui-grouploot-pass-down", nil, RemoveAnswer, answersCount + 1);
	deleteButton:SetPoint("TOPLEFT", framesMargin + 30 + editBoxWidth + 12, boxPosY);

	answersCount = answersCount + 1;

	answerObject.number = answerNumber;
	answerObject.editBoxScrollFrame = newAnswerEditBox;
	answerObject.deleteButton = deleteButton;

	table.insert(answersParentFrame.answersBoxes, newAnswerEditBox);
	table.insert(answerObjects, answerObject);
end

AddOrRemoveAnswerEditBox = function(index)

	local object = answerObjects[index];
	local boxText = object.editBoxScrollFrame.EditBox:GetText();

	if boxText == nil or boxText == "" then
		RemoveAnswer(index);

	elseif index == answersCount then
		if answersCount < #answerObjects then
			local nextObject = answerObjects[index + 1];
			nextObject.number:Show();
			nextObject.editBoxScrollFrame:Show();
			nextObject.deleteButton:Show();
			answersCount = answersCount + 1;
		else
			CreateAnswerEditBox();
		end
	end
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
end