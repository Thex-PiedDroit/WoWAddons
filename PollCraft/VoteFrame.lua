
g_cerberus.HookThisFile();

local currentPollGUID = 0;

function GetPollCurrentlyVotingFor()
	return currentPollGUID;
end

local innerFramesMargin = GetInnerFramesMargin();
local marginBetweenUpperBordersAndText = GetTextMarginFromUpperFramesBorders();
local sizeDifferenceBetweenFrameAndEditBox = GetSizeDifferenceBetweenFrameAndEditBox();

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


	local motherFrameSize = GetMotherFrameSize();
	local containingFrame = g_currentPollsMotherFrame.currentPollFrame;

	local mainFrame = CreateBackdropTitledInnerFrame("VoteFrame", containingFrame, "PollCraft - Vote");
	local innerFrameSize = GetFrameSizeAsTable(mainFrame);


		--[[      VOTE BUTTON      ]]--
	local sendVoteButton = CreateButton("SendVoteButton", mainFrame, { x = 120, y = 30 }, "Send vote", SendVoteAway);
	sendVoteButton:SetPoint("BOTTOM", mainFrame, "BOTTOM", 0, innerFramesMargin * 2);


		--[[      QUESTION FRAME      ]]--
	local questionFrameSize =
	{
		x = innerFrameSize.x - (innerFramesMargin * 2),
		y = 44 + sizeDifferenceBetweenFrameAndEditBox
	}
	local questionFrame = CreateBackdroppedFrame("QuestionFrame", mainFrame, questionFrameSize);
	questionFrame:SetPoint("TOP", 0, marginBetweenUpperBordersAndText * 2);
	local questionSectionLabel = CreateLabel(questionFrame, "Question:", 16);
	questionSectionLabel:SetPoint("TOPLEFT", 10, -marginBetweenUpperBordersAndText);

	local questionLabel = CreateLabel(questionFrame, "Question here", 16, "LEFT");
	questionLabel:SetPoint("TOPLEFT", 13, -12);
	questionLabel:SetPoint("BOTTOMRIGHT", -13, 12);
	mainFrame.questionLabel = questionLabel;


		--[[      ANSWERS FRAME      ]]--
	local answersFrameSize =
	{
		x = questionFrameSize.x,
		y = 100		-- Placeholder before resizing
	}
	local answersFrame = CreateScrollFrame("AnswersFrame_InterfacePoll", mainFrame, answersFrameSize);
	answersFrame:SetPoint("TOP", questionFrame, "BOTTOM", 0, marginBetweenUpperBordersAndText * 2);
	answersFrame:SetPoint("BOTTOM", sendVoteButton, "TOP", 0, (innerFramesMargin * 2) - 8);
	local answersFrameLabel = CreateLabel(answersFrame, "Answers:", 16);
	answersFrameLabel:SetPoint("TOPLEFT", 10, -marginBetweenUpperBordersAndText);

	answersFrame.content.answersBoxes = {};
	answersParentFrame = answersFrame.content;
	answersScrollFrame = answersFrame;

	sendVoteButton:SetFrameLevel(answersParentFrame:GetFrameLevel() + 10);
	mainFrame.sendVoteButton = sendVoteButton;


	containingFrame:Hide();
	mainFrame:Hide();
	g_currentPollsMotherFrame.voteFrame = mainFrame;

	mainFrame:SetScript("OnHide", function(self) if not self:IsShown() then currentPollGUID = 0; end end);
end


local AddOrRemoveAdditionalAnswerEditBox = nil;
local RemoveAdditionalAnswer = nil;

local answerObjects = {};
local answersFramesSize = { x = 0, y = 70 };
local totalHeightOfEachAnswer = answersFramesSize.y + (innerFramesMargin * 0.5);	-- "+ (innerFramesMargin * 0.5)" because backdropped frames already have a 4 pixel margin because of the backdrop border thickness

local answersTextFramesSize = table.clone(answersFramesSize);
local additionalAnswerEditBoxSize = { x = 0, y = answersFramesSize.y - GetSizeDifferenceBetweenFrameAndEditBox() };

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
		object.containingFrame:Show();
		object.GUID = answerGUID;
	else
		local answerIndexStr = tostring(answersCount + 1);

		if answersFramesSize.x == 0 then
			answersFramesSize.x = answersParentFrame:GetWidth() - (innerFramesMargin * 2) - answersParentFrame:GetParent().scrollbar:GetWidth();
			answersTextFramesSize.x = answersFramesSize.x - (innerFramesMargin * 2) - 54;
			additionalAnswerEditBoxSize.x = answersTextFramesSize.x - sizeDifferenceBetweenFrameAndEditBox;
		end

		local answerContainingFrame = CreateFrame("Frame", "Answer" .. answerIndexStr .. "ContainingFrame", answersParentFrame);
		answerContainingFrame:SetSize(answersFramesSize.x, answersFramesSize.y);
		local textFramePosY = -(totalHeightOfEachAnswer * answersCount) - innerFramesMargin;
		answerContainingFrame:SetPoint("TOPLEFT", innerFramesMargin, textFramePosY);

		local answerFramePosX = 30;
		local textFrame = CreateBackdroppedFrame("Answer" .. answerIndexStr .. "TextFrame", answerContainingFrame, answersTextFramesSize);
		textFrame:SetPoint("TOPLEFT", answerFramePosX, 0);
		local answerLabel = CreateLabel(textFrame, answerText, 16, "LEFT");
		answerLabel:SetPoint("TOPLEFT", innerFramesMargin, -11);
		answerLabel:SetPoint("BOTTOMRIGHT", -innerFramesMargin, 11);

		local additionalAnswerEditBox = CreateEditBox("AdditionalAnswer" .. answerIndexStr .. "EditBox", answerContainingFrame, additionalAnswerEditBoxSize, false, AddOrRemoveAdditionalAnswerEditBox, answersCount + 1, 16);
		additionalAnswerEditBox:SetPoint("TOPLEFT", answerFramePosX + (sizeDifferenceBetweenFrameAndEditBox * 0.5), -(sizeDifferenceBetweenFrameAndEditBox * 0.5));

		local deleteButton = CreateIconButton("DeleteAdditionalAnswer" .. answerIndexStr .. "Button", answerContainingFrame, 20, "Interface/Buttons/Ui-grouploot-pass-up", "Interface/Buttons/Ui-grouploot-pass-down", nil, RemoveAdditionalAnswer, answersCount + 1);
		deleteButton:SetPoint("TOPLEFT", additionalAnswerEditBox, "TOPRIGHT", innerFramesMargin + sizeDifferenceBetweenFrameAndEditBox - 6, 0);

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

		local newNumber = CreateLabel(answerContainingFrame, answerIndexStr .. '.', 16);
		newNumber:SetPoint("TOPRIGHT", textFrame, "TOPLEFT", -2, - 8);

		local newCheck = CreateCheckButton(answerContainingFrame, "Answer" .. answerIndexStr .. "CheckButton");
		newCheck:SetPoint("RIGHT", textFrame, "RIGHT", innerFramesMargin + 20, 0);
		newCheck:Hide();

		local newTick = CreateRadioCheckButton(answerContainingFrame, "Answer" .. answerIndexStr .. "CheckButton");
		newTick:SetPoint("RIGHT", textFrame, "RIGHT", innerFramesMargin + 18, 0);
		newTick:Hide();

		object =
		{
			containingFrame = answerContainingFrame,
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
	answerObject.containingFrame:Hide();
	answerObject.textFrame:Hide();
	answerObject.text:Hide();
	answerObject.editBoxScrollFrame:Hide();
	answerObject.deleteButton:Hide();
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

	UpdateScrollBar(answersScrollFrame, (answersCountForUpdateScrollbar * totalHeightOfEachAnswer) - innerFramesMargin);
end


function LoadAndOpenVoteFrame(pollData)

	if pollData.pollType == "RAID" then

		if GetPollCurrentlyVotingFor() ~= 0 then
			if sender ~= nil and sender ~= Me() then
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

		currentPollGUID = pollData.pollGUID;
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
	return Me() .. index;
end

function GetVoteData()

	local voteObject =
	{
		pollGUID = currentPollGUID,
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