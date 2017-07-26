
g_receivePollFrame = nil;

local mainFrameSize =
{
	x = 600,
	y = 700
}
local framesMargin = (mainFrameSize.x / 40);

local answersParentFrame = nil;
local answersScrollFrame = nil;
local answersCount = 0;
local additionalAnswersCount = 0;

local HideAllAnswers = nil;


function InitializeReceivePollFrame()

	g_receivePollFrame = {};

	local mainFrame = CreateBackdroppedFrame("ReceivePollFrame", UIParent, mainFrameSize.x, mainFrameSize.y, true);
	mainFrame:SetPoint("CENTER", 0, 0);

	local titleFrame = CreateBackdroppedFrame("ReceivePollFrameTitleBackdrop", mainFrame, 250, 35);
	titleFrame:SetPoint("TOP", 0, -20);
	local mainFrameTitle = CreateLabel(titleFrame, "PollCraft - Poll received", 20);
	mainFrameTitle:SetPoint("CENTER", 0, 0);


	local closeButton = CreateFrame("Button", "PollCraft_CloseReceivePollFrameButton", mainFrame, "UIPanelCloseButton");
	closeButton:SetPoint("TOPRIGHT", 0, 0);


	local innerFrameSize =
	{
		x = mainFrameSize.x - framesMargin,
		y = mainFrameSize.y - (framesMargin * 5)
	};

	local newPollFrame = CreateBackdroppedFrame("ReceivePollFrame", mainFrame, innerFrameSize.x, innerFrameSize.y);
	newPollFrame:SetPoint("BOTTOM", 0, mainFrameSize.x / 80);


	local questionPosY = -45;
	local questionSectionLabel = CreateLabel(newPollFrame, "Question:", 16);
	questionSectionLabel:SetPoint("TOPLEFT", framesMargin, questionPosY + 22);


	--[[      QUESTION FRAME      ]]--
	local questionFrameSize =
	{
		x = innerFrameSize.x - framesMargin,
		y = 56
	}
	local questionFrame = CreateBackdroppedFrame("QuestionFrame", newPollFrame, questionFrameSize.x, questionFrameSize.y);
	questionFrame:SetPoint("TOP", 0, questionPosY);
	local questionLabel = CreateLabel(questionFrame, "Question here", 16, questionFrameSize.x - 18, "LEFT");
	questionLabel:SetPoint("TOPLEFT", 13, -12);
	mainFrame.questionLabel = questionLabel;


		--[[      ANSWERS FRAME      ]]--
	local answersFrameLabel = CreateLabel(newPollFrame, "Answers:", 16);
	local answersFramePosY = questionPosY - questionFrameSize.y - 32;
	answersFrameLabel:SetPoint("TOPLEFT", framesMargin, answersFramePosY + 20);

	local answersFrameSize =
	{
		x = questionFrameSize.x,
		y = innerFrameSize.y - questionFrameSize.y + questionPosY - 80;
	}
	local answersFrame = CreateScrollFrame("AnswersFrame_InterfacePoll", newPollFrame, answersFrameSize.x, answersFrameSize.y);
	answersFrame:SetPoint("TOP", 0, answersFramePosY);

	answersFrame.content.answersBoxes = {};
	answersParentFrame = answersFrame.content;
	answersScrollFrame = answersFrame;


	local sendVoteButton = CreateButton("SendVoteButton", newPollFrame, 120, 30, "Send vote");
	sendVoteButton:SetPoint("TOP", 0, answersFramePosY - answersFrameSize.y - (framesMargin * 0.4));


	mainFrame:Hide();
	mainFrame:SetScript("OnShow", function() g_currentlyBusy = true; end);
	mainFrame:SetScript("OnHide", function() HideAllAnswers(); g_currentlyBusy = false; answersCount = 0; additionalAnswersCount = 0; end);
	g_receivePollFrame.panel = mainFrame;
end


local AddOrRemoveAdditionalAnswerEditBox = nil;
local RemoveAdditionalAnswer = nil;

local answerObjects = {};
local marginBetweenAnswers = 10;
local answersFramesHeight = 70;
local totalHeightOfEachAnswer = answersFramesHeight + (framesMargin * 0.25);

local additionalAnswerEditBoxHeight = answersFramesHeight - 12;

local allowAdditionalAnswers = false;
local allowMultipleVotes = false;

function LoadAnswer(answerText)

	local object = nil;

	local isAdditionalAnswer = answerText == nil or answerText == "";

	if answersCount < #answerObjects then
		object = answerObjects[answersCount + 1];

		if isAdditionalAnswer then
			object.text:Hide();
			object.textFrame:Hide();
			object.editBoxScrollFrame.EditBox:SetText("");
			object.editBoxScrollFrame:Show();
			object.deleteButton:Show();
		else
			object.text:SetText(answerText);
			object.text:Show();
			object.textFrame:Show();
			object.editBoxScrollFrame:Hide();
			object.deleteButton:Hide();
		end
		object.number:Show();
	else
		local answerIndexStr = tostring(answersCount + 1);

		local answerFrameWidth = answersParentFrame:GetWidth() - (framesMargin * 4) - 40;
		local textFramePosY = -((totalHeightOfEachAnswer * answersCount) + 10);
		local textFrame = CreateBackdroppedFrame("Answer" .. answerIndexStr .. "TextFrame", answersParentFrame, answerFrameWidth, answersFramesHeight);
		textFrame:SetPoint("TOPLEFT", framesMargin + 24, textFramePosY);
		local answerLabel = CreateLabel(textFrame, answerText, 16, answerFrameWidth - 20, "LEFT");
		answerLabel:SetPoint("TOPLEFT", framesMargin, -11);

		local additionalAnswerEditBoxWidth = answerFrameWidth - 12;
		local additionalAnswerEditBox = CreateEditBox("AdditionalAnswer" .. answerIndexStr .. "EditBox", answersParentFrame, additionalAnswerEditBoxWidth, additionalAnswerEditBoxHeight, false, AddOrRemoveAdditionalAnswerEditBox, answersCount + 1, 16);
		additionalAnswerEditBox:SetPoint("TOPLEFT", framesMargin + 30, textFramePosY - 7);

		local deleteButton = CreateIconButton("DeleteAdditionalAnswer" .. answerIndexStr .. "Button", answersParentFrame, 20, "Interface/Buttons/Ui-grouploot-pass-up", "Interface/Buttons/Ui-grouploot-pass-down", nil, RemoveAdditionalAnswer, answersCount + 1);
		deleteButton:SetPoint("TOPLEFT", framesMargin + 28.5 + additionalAnswerEditBoxWidth + 12, textFramePosY -2);

		if isAdditionalAnswer then
			textFrame:Hide();
			answerLabel:Hide();
			if not isAdditionalAnswer then
				deleteButton:Hide();
			end
		else
			additionalAnswerEditBox:Hide();
			deleteButton:Hide();
		end

		local newNumber = CreateLabel(answersParentFrame, answerIndexStr .. '.', 16);
		newNumber:SetPoint("TOPLEFT", framesMargin - 5, textFramePosY - 8);

		local newCheck = CreateCheckButton(answersParentFrame, "Answer" .. answerIndexStr .. "CheckButton");
		newCheck:SetPoint("RIGHT", textFrame, "RIGHT", framesMargin + 10, 0);
		newCheck:Hide();

		local newTick = CreateRadioCheckButton(answersParentFrame, "Answer" .. answerIndexStr .. "CheckButton");
		newTick:SetPoint("RIGHT", textFrame, "RIGHT", framesMargin + 8, 0);
		newTick:Hide();

		object =
		{
			textFrame = textFrame,
			text = answerLabel,
			editBoxScrollFrame = additionalAnswerEditBox,
			deleteButton = deleteButton;
			number = newNumber,
			voteCheck = newCheck,
			voteTick = newTick
		}

		table.insert(answerObjects, object);
		MakeAllTicksExclusive()
	end

	if not isAdditionalAnswer then
		if allowMultipleVotes then
			object.voteCheck:Show();
			object.voteCheck:SetChecked(false);
		else
			object.voteTick:Show();
			object.voteTick:SetChecked(false);
		end
	end

	if not isAdditionalAnswer then
		answersCount = answersCount + 1;
	end
	UpdateScrollBar(answersScrollFrame, answersCount * totalHeightOfEachAnswer);
end

AddOrRemoveAdditionalAnswerEditBox = function(currentlyModifiedAnswerIndex)

	if not allowAdditionalAnswers then
		return;
	end

	local object = answerObjects[currentlyModifiedAnswerIndex];
	local boxText = object.editBoxScrollFrame.EditBox:GetText();

	if boxText == nil or boxText == "" then
		RemoveAdditionalAnswer(currentlyModifiedAnswerIndex);

	elseif not allowMultipleVotes then
		if additionalAnswersCount > 0 then
			return;
		end
		answersCount = answersCount + 1;
		additionalAnswersCount = additionalAnswersCount + 1;

		object.voteTick:Show();
		object.voteTick:SetChecked(false);

	elseif currentlyModifiedAnswerIndex == answersCount + 1 then

		answersCount = answersCount + 1;
		additionalAnswersCount = additionalAnswersCount + 1;

		if answersCount < #answerObjects then
			local nextObject = answerObjects[currentlyModifiedAnswerIndex + 1];
			nextObject.number:Show();
			nextObject.editBoxScrollFrame.EditBox:SetText("");
			nextObject.editBoxScrollFrame:Show();

			nextObject.deleteButton:Show();
			nextObject.textFrame:Hide();
			nextObject.text:Hide();
		else
			LoadAnswer("");
		end

		object.voteCheck:Show();
		object.voteCheck:SetChecked(false);
	end

	UpdateScrollBar(answersScrollFrame, answersCount * totalHeightOfEachAnswer);
end

RemoveAdditionalAnswer = function(index)

	local editBox = answerObjects[index].editBoxScrollFrame.EditBox;
	local currentText = editBox:GetText();

	if currentText == nil or currentText == "" then
		return;
	end

	local lastAnswerIndex = answersCount;
	if allowMultipleVotes then	-- Difference comes from the fact that in one-vote policy, we increase the amount of answers without increasing the amount of answer boxes
		lastAnswerIndex = lastAnswerIndex + 1;
	end

	if index == lastAnswerIndex then

		editBox:SetText("");
		editBox:ClearFocus();
		editBox:HighlightText(0, 0);	-- Forces highlight removal
		answerObjects[index].voteCheck:Hide();
		answerObjects[index].voteTick:Hide();

	else
		for i = index, answersCount do

			local currentObject = answerObjects[i];
			local nextObject = answerObjects[i + 1];
			currentObject.editBoxScrollFrame.EditBox:SetText(nextObject.editBoxScrollFrame.EditBox:GetText());
			currentObject.voteCheck:SetChecked(nextObject.voteCheck:GetChecked());

			if i + 1 == lastAnswerIndex then
				nextObject.number:Hide();
				nextObject.editBoxScrollFrame:Hide();
				nextObject.deleteButton:Hide();
				nextObject.voteCheck:Hide();

				currentObject.voteCheck:Hide();
			end
		end
	end

	answersCount = answersCount - 1;
	additionalAnswersCount = additionalAnswersCount - 1;
	UpdateScrollBar(answersScrollFrame, answersCount * totalHeightOfEachAnswer);
end

local function HideAnswer(answerObject)
	answerObject.textFrame:Hide();
	answerObject.text:Hide();
	answerObject.editBoxScrollFrame:Hide();
	answerObject.deleteButton:Hide();
	answerObject.number:Hide();
	answerObject.voteCheck:Hide();
	answerObject.voteTick:Hide();
end

HideAllAnswers = function()
	for i = 1, #answerObjects do
		HideAnswer(answerObjects[i]);
	end
end


function MakeAllTicksExclusive()

	for i = 1, #answerObjects do
		local currentObjectTick = answerObjects[i].voteTick;
		currentObjectTick.index = i;

		currentObjectTick:SetScript("OnClick", function(self)
			for j = 1, #answerObjects do
				if j ~= currentObjectTick.index then
					answerObjects[j].voteTick:SetChecked(false);
				end
			end
		end);
	end
end


function LoadAndOpenReceivePollFrame(pollData, sender, senderRealm)

	if pollData.pollType == "RAID" then

		if g_currentlyBusy then
			if sender ~= nil and sender ~= Me() then
				SendPollMessage({}, "Busy", "WHISPER", sender, senderRealm);
			end

			return;
		end

		if g_receivePollFrame == nil then
			InitializeReceivePollFrame();
		end

		g_receivePollFrame.panel.questionLabel:SetText(pollData.question);

		allowMultipleVotes = pollData.multiVotes;
		allowAdditionalAnswers = pollData.allowNewAnswers;

		for i = 1, #pollData.answers do
			LoadAnswer(pollData.answers[i]);
		end
		if allowAdditionalAnswers then
			LoadAnswer("");
		end
	end

	g_receivePollFrame.panel:Show();
end
