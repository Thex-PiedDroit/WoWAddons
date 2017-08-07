
local innerFramesMargin = 0;

local answersParentFrame = nil;
local answersScrollFrame = nil;
local answersCount = 0;
local additionalAnswersCount = 0;

local RemoveAllAnswers = nil;


function InitVoteFrame()

	if g_currentPollsMotherFrame.voteFrame ~= nil then
		g_currentPollsMotherFrame.voteFrame.sendVoteButton:Enable();

		if g_currentPollsMotherFrame.resultsFrame ~= nil then
			g_currentPollsMotherFrame.resultsFrame:Hide();
		end

		RemoveAllAnswers();
		return;
	end

	innerFramesMargin = GetInnerFramesMargin();
	local motherFrameSize = GetMotherFrameSize();

	local containingFrame = g_currentPollsMotherFrame.currentPollFrame;


	local innerFrameSize =
	{
		x = motherFrameSize.x - innerFramesMargin,
		y = motherFrameSize.y - (innerFramesMargin * 5)
	};

	local voteFrame = CreateBackdroppedFrame("VoteFrame", containingFrame, innerFrameSize.x, innerFrameSize.y);
	voteFrame:SetPoint("BOTTOM", 0, motherFrameSize.x / 80);

	local titleFrame = CreateBackdroppedFrame("VoteFrameTitleBackdrop", voteFrame, 250, 35);
	titleFrame:SetPoint("TOP", containingFrame, "TOP", 0, -20);
	local mainFrameTitle = CreateLabel(titleFrame, "PollCraft - Poll received", 20);
	mainFrameTitle:SetPoint("CENTER", 0, 0);


		--[[      QUESTION FRAME      ]]--
	local questionPosY = -45;
	local questionSectionLabel = CreateLabel(voteFrame, "Question:", 16);
	questionSectionLabel:SetPoint("TOPLEFT", innerFramesMargin, questionPosY + 22);

	local questionFrameSize =
	{
		x = innerFrameSize.x - innerFramesMargin,
		y = 56
	}
	local questionFrame = CreateBackdroppedFrame("QuestionFrame", voteFrame, questionFrameSize.x, questionFrameSize.y);
	questionFrame:SetPoint("TOP", 0, questionPosY);
	local questionLabel = CreateLabel(questionFrame, "Question here", 16, "LEFT");
	questionLabel:SetPoint("TOPLEFT", 13, -12);
	questionLabel:SetPoint("BOTTOMRIGHT", -13, 12);
	voteFrame.questionLabel = questionLabel;


		--[[      ANSWERS FRAME      ]]--
	local answersFrameLabel = CreateLabel(voteFrame, "Answers:", 16);
	local answersFramePosY = questionPosY - questionFrameSize.y - 32;
	answersFrameLabel:SetPoint("TOPLEFT", innerFramesMargin, answersFramePosY + 20);

	local answersFrameSize =
	{
		x = questionFrameSize.x,
		y = innerFrameSize.y - questionFrameSize.y + questionPosY - 80;
	}
	local answersFrame = CreateScrollFrame("AnswersFrame_InterfacePoll", voteFrame, answersFrameSize.x, answersFrameSize.y);
	answersFrame:SetPoint("TOP", 0, answersFramePosY);

	answersFrame.content.answersBoxes = {};
	answersParentFrame = answersFrame.content;
	answersScrollFrame = answersFrame;


	local sendVoteButton = CreateButton("SendVoteButton", voteFrame, 120, 30, "Send vote", SendVoteAway);
	sendVoteButton:SetPoint("TOP", 0, answersFramePosY - answersFrameSize.y - (innerFramesMargin * 0.4));
	sendVoteButton:SetFrameLevel(answersParentFrame:GetFrameLevel() + 10);
	voteFrame.sendVoteButton = sendVoteButton;


	containingFrame:Hide();
	voteFrame:Hide();
	g_currentPollsMotherFrame.voteFrame = voteFrame;
end


local AddOrRemoveAdditionalAnswerEditBox = nil;
local RemoveAdditionalAnswer = nil;

local answerObjects = {};
local answersFramesHeight = 70;
local totalHeightOfEachAnswer = answersFramesHeight + (innerFramesMargin * 0.25);

local additionalAnswerEditBoxHeight = answersFramesHeight - 12;

local allowAdditionalAnswers = false;
local allowMultipleVotes = false;
local UpdateAnswersScrollbar = nil;

local function LoadAnswer(answerObject)

	local answerText = "";
	local answerGUID = nil;

	if answerObject ~= nil then
		answerText = answerObject.text;
		answerGUID = answerObject.GUID;
	end

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
		object.GUID = answerGUID;
	else
		local answerIndexStr = tostring(answersCount + 1);

		local answerFrameWidth = answersParentFrame:GetWidth() - (innerFramesMargin * 4) - 40;
		local textFramePosY = -((totalHeightOfEachAnswer * answersCount) + 10);
		local textFrame = CreateBackdroppedFrame("Answer" .. answerIndexStr .. "TextFrame", answersParentFrame, answerFrameWidth, answersFramesHeight);
		textFrame:SetPoint("TOPLEFT", innerFramesMargin + 24, textFramePosY);
		local answerLabel = CreateLabel(textFrame, answerText, 16, "LEFT");
		answerLabel:SetPoint("TOPLEFT", innerFramesMargin, -11);
		answerLabel:SetPoint("BOTTOMRIGHT", -innerFramesMargin, 11);

		local additionalAnswerEditBoxWidth = answerFrameWidth - 12;
		local additionalAnswerEditBox = CreateEditBox("AdditionalAnswer" .. answerIndexStr .. "EditBox", answersParentFrame, additionalAnswerEditBoxWidth, additionalAnswerEditBoxHeight, false, AddOrRemoveAdditionalAnswerEditBox, answersCount + 1, 16);
		additionalAnswerEditBox:SetPoint("TOPLEFT", innerFramesMargin + 30, textFramePosY - 7);

		local deleteButton = CreateIconButton("DeleteAdditionalAnswer" .. answerIndexStr .. "Button", answersParentFrame, 20, "Interface/Buttons/Ui-grouploot-pass-up", "Interface/Buttons/Ui-grouploot-pass-down", nil, RemoveAdditionalAnswer, answersCount + 1);
		deleteButton:SetPoint("TOPLEFT", innerFramesMargin + 28.5 + additionalAnswerEditBoxWidth + 12, textFramePosY -2);

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
		newNumber:SetPoint("TOPRIGHT", textFrame, "TOPLEFT", 14 - innerFramesMargin, - 8);

		local newCheck = CreateCheckButton(answersParentFrame, "Answer" .. answerIndexStr .. "CheckButton");
		newCheck:SetPoint("RIGHT", textFrame, "RIGHT", innerFramesMargin + 10, 0);
		newCheck:Hide();

		local newTick = CreateRadioCheckButton(answersParentFrame, "Answer" .. answerIndexStr .. "CheckButton");
		newTick:SetPoint("RIGHT", textFrame, "RIGHT", innerFramesMargin + 8, 0);
		newTick:Hide();

		object =
		{
			textFrame = textFrame,
			text = answerLabel,
			editBoxScrollFrame = additionalAnswerEditBox,
			deleteButton = deleteButton;
			number = newNumber,
			voteCheck = newCheck,
			voteTick = newTick,
			GUID = answerGUID,

			IsSelected = function(self)
				return (self.voteCheck:IsVisible() and self.voteCheck:GetChecked()) or (self.voteTick:IsVisible() and self.voteTick:GetChecked());
			end,

			GetText = function(self)
				if self.text:IsVisible() then
					return self.text:GetText();
				elseif self.editBoxScrollFrame:IsVisible() then
					return self.editBoxScrollFrame.EditBox:GetText();
				end
			end,
		};

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
	UpdateAnswersScrollbar();
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
			LoadAnswer(nil);
		end

		object.voteCheck:Show();
		object.voteCheck:SetChecked(false);
	end

	UpdateAnswersScrollbar();
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
	UpdateAnswersScrollbar();
end

local function ChangeAnswerObjectToStaticAnswer(answerObject)
	answerObject.textFrame:Show();
	answerObject.text:Show();
	answerObject.editBoxScrollFrame:Hide();
	answerObject.deleteButton:Hide();

	if allowMultipleVotes then
		answerObject.voteCheck:Show();
	else
		answerObject.voteTick:Show();
	end
end

local function HideAnswer(answerObject)
	answerObject.textFrame:Hide();
	answerObject.text:Hide();
	answerObject.editBoxScrollFrame:Hide();
	answerObject.deleteButton:Hide();
	answerObject.number:Hide();
	answerObject.voteCheck:Hide();
	answerObject.voteTick:Hide();
	answerObject.GUID = nil;
end

RemoveAllAnswers = function()
	for i = 1, #answerObjects do
		HideAnswer(answerObjects[i]);
	end

	answersCount = 0;
	additionalAnswersCount = 0;
end

local function InsertAdditionalAnswer(newAnswer)

	answersCount = answersCount + 1;
	if allowMultipleVotes or additionalAnswersCount == 0 then
		LoadAnswer(nil);	-- Create empty answer at the end of the list
	end
	local newIndex = answersCount - additionalAnswersCount;

	for i = answersCount, newIndex + 1, -1 do
		local currentObject = answerObjects[i];
		local previousObject = answerObjects[i - 1];
		currentObject.editBoxScrollFrame.EditBox:SetText(previousObject:GetText());
		currentObject.voteCheck:SetChecked(previousObject.voteCheck:GetChecked());
		currentObject.voteTick:SetChecked(previousObject.voteTick:GetChecked());
	end

	local newObject = answerObjects[newIndex];
	ChangeAnswerObjectToStaticAnswer(newObject);
	newObject.text:SetText(newAnswer.text);
	newObject.voteCheck:SetChecked(false);
	newObject.voteTick:SetChecked(false);
	newObject.GUID = newAnswer.GUID;
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

UpdateAnswersScrollbar = function()

	local answersCountForUpdateScrollbar = answersCount;

	if allowAdditionalAnswers then
		local addition = 1;
		if not allowMultipleVotes and additionalAnswersCount > 0 then
			addition = 0;
		end
		answersCountForUpdateScrollbar = answersCount + addition;
	end

	UpdateScrollBar(answersScrollFrame, answersCountForUpdateScrollbar * totalHeightOfEachAnswer);
end

local pollGUID = 0;

function LoadAndOpenVoteFrame(pollData)

	if pollData.pollType == "RAID" then

		if g_currentlyBusy then
			if sender ~= nil and sender ~= PollCraft_Me() then
				SendPollMessage({}, "Busy", "WHISPER", pollData.pollMasterFullName, pollData.pollMasterRealm);
			end

			return;
		end

		InitVoteFrame();

		g_currentPollsMotherFrame.voteFrame.questionLabel:SetText(pollData.question);

		allowMultipleVotes = pollData.multiVotes;
		allowAdditionalAnswers = pollData.allowNewAnswers;

		for i = 1, #pollData.answers do
			LoadAnswer(pollData.answers[i]);
		end
		if allowAdditionalAnswers then
			LoadAnswer(nil);
		end

		pollGUID = pollData.pollGUID;
		g_currentPollsMotherFrame.voteFrame:Show();
		g_currentPollsMotherFrame.panel:Show();
		g_currentPollsMotherFrame.currentPollFrame:Show();

		AddPollDataToMemory(pollData);
	end
end

function LoadAdditionalAnswersForVoting(newAnswers)

	for i = 1, #newAnswers do
		InsertAdditionalAnswer(newAnswers[i]);
	end
end


local function CreateAnswerGUID(index)
	return PollCraft_Me() .. index;
end

function GetVoteData()

	local voteObject =
	{
		pollGUID = pollGUID,
		newAnswers = {},
		vote = {}
	}

	for i = 1, additionalAnswersCount do
		local answerObject = answerObjects[answersCount - additionalAnswersCount + i];

		local newAnswerGUID = CreateAnswerGUID(i);
		answerObject.GUID = newAnswerGUID;

		local additionalAnswerData =
		{
			text = answerObject.editBoxScrollFrame.EditBox:GetText(),
			GUID = newAnswerGUID
		}

		table.insert(voteObject.newAnswers, additionalAnswerData);
	end

	for i = 1, answersCount do
		local currentAnswer = answerObjects[i];
		if currentAnswer:IsSelected() then
			table.insert(voteObject.vote, currentAnswer.GUID);
		end
	end

	return voteObject;
end
