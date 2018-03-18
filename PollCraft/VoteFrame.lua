
Cerberus_HookThisFile();

function IsCurrentlyVotingForSomething()
	return g_currentPollsMotherFrame.voteFrame:IsVisible() and g_currentPollsMotherFrame.voteFrame:IsShown() and g_currentPollsMotherFrame.sCurrentPollGUID ~= nil;
end
function IsCurrentlyVotingForPoll(sPollGUID)
	return g_currentPollsMotherFrame.voteFrame:IsVisible() and g_currentPollsMotherFrame.voteFrame:IsShown() and g_currentPollsMotherFrame.sCurrentPollGUID == sPollGUID;
end

local fInnerFramesMargin = GetInnerFramesMargin();
local fMarginBetweenUpperBordersAndText = GetTextMarginFromUpperFramesBorders();
local fSizeDifferenceBetweenFrameAndEditBox = GetSizeDifferenceBetweenFrameAndEditBox();

local answersParentFrame = nil;
local answersScrollFrame = nil;
local iAnswersCount = 0;
local function GetAnswersCount()
	return iAnswersCount;
end
local iAdditionalAnswersCount = 0;

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
	sendVoteButton:SetPoint("BOTTOM", mainFrame, "BOTTOM", 0, fInnerFramesMargin * 2);


		--[[      QUESTION FRAME      ]]--
	local questionFrameSize =
	{
		x = innerFrameSize.x - (fInnerFramesMargin * 2),
		y = 44 + fSizeDifferenceBetweenFrameAndEditBox
	}
	local questionFrame = CreateBackdroppedFrame("QuestionFrame", mainFrame, questionFrameSize);
	questionFrame:SetPoint("TOP", 0, fMarginBetweenUpperBordersAndText * 2);
	local questionSectionLabel = CreateLabel(questionFrame, "Question:", 16);
	questionSectionLabel:SetPoint("TOPLEFT", 10, -fMarginBetweenUpperBordersAndText);

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
	answersFrame:SetPoint("TOP", questionFrame, "BOTTOM", 0, fMarginBetweenUpperBordersAndText * 2);
	answersFrame:SetPoint("BOTTOM", sendVoteButton, "TOP", 0, (fInnerFramesMargin * 2) - 8);
	local answersFrameLabel = CreateLabel(answersFrame, "Answers:", 16);
	answersFrameLabel:SetPoint("TOPLEFT", 10, -fMarginBetweenUpperBordersAndText);

	answersFrame.content.answersBoxes = {};
	answersParentFrame = answersFrame.content;
	answersScrollFrame = answersFrame;

	sendVoteButton:SetFrameLevel(answersParentFrame:GetFrameLevel() + 10);
	mainFrame.sendVoteButton = sendVoteButton;


	containingFrame:Hide();
	mainFrame:Hide();
	g_currentPollsMotherFrame.voteFrame = mainFrame;
end


local AddOrRemoveAdditionalAnswerEditBox = nil;
local RemoveAdditionalAnswer = nil;

local answerObjects = {};
local answersFramesSize = { x = 0, y = 70 };
local fTotalHeightOfEachAnswer = answersFramesSize.y + (fInnerFramesMargin * 0.5);	-- "+ (fInnerFramesMargin * 0.5)" because backdropped frames already have a 4 pixel margin because of the backdrop border thickness

local answersTextFramesSize = table.clone(answersFramesSize);
local additionalAnswerEditBoxSize = { x = 0, y = answersFramesSize.y - GetSizeDifferenceBetweenFrameAndEditBox() };

local bAllowAdditionalAnswers = false;
local bAllowMultipleVotes = false;
local UpdateAnswersScrollbar = nil;

local function LoadAnswer(answerObject)

	local sAnswerText = "";
	local sAnswerGUID = nil;

	if answerObject ~= nil then
		sAnswerText = answerObject.sText;
		sAnswerGUID = answerObject.sGUID;
	end

	local object = nil;

	local bIsAdditionalAnswer = sAnswerText == nil or sAnswerText == "";

	if iAnswersCount < #answerObjects then
		object = answerObjects[iAnswersCount + 1];

		if bIsAdditionalAnswer then
			object.answerLabel:Hide();
			object.answerLabelFrame:Hide();
			object.editBoxScrollFrame.EditBox:SetText("");
			object.editBoxScrollFrame:Show();
			object.deleteButton:Show();
		else
			object.answerLabel:SetText(sAnswerText);
			object.answerLabel:Show();
			object.answerLabelFrame:Show();
			object.editBoxScrollFrame:Hide();
			object.deleteButton:Hide();
		end

		object.containingFrame:Show();
		object.sGUID = sAnswerGUID;

	else
		local sAnswerIndexStr = tostring(iAnswersCount + 1);

		if answersFramesSize.x == 0 then
			answersFramesSize.x = answersParentFrame:GetWidth() - (fInnerFramesMargin * 2) - answersParentFrame:GetParent().scrollbar:GetWidth();
			answersTextFramesSize.x = answersFramesSize.x - (fInnerFramesMargin * 2) - 54;
			additionalAnswerEditBoxSize.x = answersTextFramesSize.x - fSizeDifferenceBetweenFrameAndEditBox;
		end

		local answerContainingFrame = CreateFrame("Frame", "Answer" .. sAnswerIndexStr .. "ContainingFrame", answersParentFrame);
		answerContainingFrame:SetSize(answersFramesSize.x, answersFramesSize.y);
		local fTextFramePosY = -(fTotalHeightOfEachAnswer * iAnswersCount) - fInnerFramesMargin;
		answerContainingFrame:SetPoint("TOPLEFT", fInnerFramesMargin, fTextFramePosY);

		local fAnswerFramePosX = 30;
		local answerLabelFrame = CreateBackdroppedFrame("Answer" .. sAnswerIndexStr .. "TextFrame", answerContainingFrame, answersTextFramesSize);
		answerLabelFrame:SetPoint("TOPLEFT", fAnswerFramePosX, 0);
		local answerLabel = CreateLabel(answerLabelFrame, sAnswerText, 16, "LEFT");
		answerLabel:SetPoint("TOPLEFT", fInnerFramesMargin, -11);
		answerLabel:SetPoint("BOTTOMRIGHT", -fInnerFramesMargin, 11);

		local additionalAnswerEditBox = CreateEditBox("AdditionalAnswer" .. sAnswerIndexStr .. "EditBox", answerContainingFrame, additionalAnswerEditBoxSize, false, AddOrRemoveAdditionalAnswerEditBox, GetAnswersCount() + 1, 16);
		additionalAnswerEditBox:SetPoint("TOPLEFT", fAnswerFramePosX + (fSizeDifferenceBetweenFrameAndEditBox * 0.5), -(fSizeDifferenceBetweenFrameAndEditBox * 0.5));

		local deleteButton = CreateIconButton("DeleteAdditionalAnswer" .. sAnswerIndexStr .. "Button", answerContainingFrame, 20, "Interface/Buttons/Ui-grouploot-pass-up", "Interface/Buttons/Ui-grouploot-pass-down", nil, RemoveAdditionalAnswer, GetAnswersCount() + 1);
		deleteButton:SetPoint("TOPLEFT", additionalAnswerEditBox, "TOPRIGHT", fInnerFramesMargin + fSizeDifferenceBetweenFrameAndEditBox - 6, 0);

		if bIsAdditionalAnswer then
			answerLabelFrame:Hide();
			answerLabel:Hide();
			if not bIsAdditionalAnswer then
				deleteButton:Hide();
			end
		else
			additionalAnswerEditBox:Hide();
			deleteButton:Hide();
		end

		local newNumber = CreateLabel(answerContainingFrame, sAnswerIndexStr .. '.', 16);
		newNumber:SetPoint("TOPRIGHT", answerLabelFrame, "TOPLEFT", -2, - 8);

		local newCheck = CreateCheckButton("Answer" .. sAnswerIndexStr .. "CheckButton", answerContainingFrame);
		newCheck:SetPoint("RIGHT", answerLabelFrame, "RIGHT", fInnerFramesMargin + 20, 0);
		newCheck:Hide();

		local newTick = CreateRadioCheckButton("Answer" .. sAnswerIndexStr .. "CheckButton", answerContainingFrame);
		newTick:SetPoint("RIGHT", answerLabelFrame, "RIGHT", fInnerFramesMargin + 18, 0);
		newTick:Hide();

		object =
		{
			containingFrame = answerContainingFrame,
			answerLabelFrame = answerLabelFrame,
			answerLabel = answerLabel,
			editBoxScrollFrame = additionalAnswerEditBox,
			deleteButton = deleteButton;
			number = newNumber,
			voteCheck = newCheck,
			voteTick = newTick,
			sGUID = sAnswerGUID,

			IsSelected = function(self)
				return (self.voteCheck:IsVisible() and self.voteCheck:GetChecked()) or (self.voteTick:IsVisible() and self.voteTick:GetChecked());
			end,

			GetAnswerText = function(self)
				if self.answerLabel:IsVisible() then
					return self.answerLabel:GetText();
				elseif self.editBoxScrollFrame:IsVisible() then
					return self.editBoxScrollFrame.EditBox:GetText();
				end
			end,
		};

		table.insert(answerObjects, object);
		MakeAllTicksExclusive();
	end

	if not bIsAdditionalAnswer then
		if bAllowMultipleVotes then
			object.voteCheck:Show();
			object.voteCheck:SetChecked(false);
		else
			object.voteTick:Show();
			object.voteTick:SetChecked(false);
		end
	end

	if not bIsAdditionalAnswer then
		iAnswersCount = iAnswersCount + 1;
	end
	UpdateAnswersScrollbar();
end

AddOrRemoveAdditionalAnswerEditBox = function(iCurrentlyModifiedAnswerIndex)

	if not bAllowAdditionalAnswers then
		return;
	end

	local object = answerObjects[iCurrentlyModifiedAnswerIndex];
	local sBoxText = object.editBoxScrollFrame.EditBox:GetText();

	if sBoxText == nil or sBoxText == "" then
		RemoveAdditionalAnswer(iCurrentlyModifiedAnswerIndex);

	elseif not bAllowMultipleVotes then
		if iAdditionalAnswersCount > 0 then
			return;
		end
		iAnswersCount = iAnswersCount + 1;
		iAdditionalAnswersCount = iAdditionalAnswersCount + 1;

		object.voteTick:Show();
		object.voteTick:SetChecked(false);

	elseif iCurrentlyModifiedAnswerIndex == iAnswersCount + 1 then
		iAnswersCount = iAnswersCount + 1;
		iAdditionalAnswersCount = iAdditionalAnswersCount + 1;

		if iAnswersCount < #answerObjects then
			local nextObject = answerObjects[iCurrentlyModifiedAnswerIndex + 1];
			nextObject.containingFrame:Show();
			nextObject.number:Show();
			nextObject.editBoxScrollFrame.EditBox:SetText("");
			nextObject.editBoxScrollFrame:Show();

			nextObject.deleteButton:Show();
			nextObject.answerLabelFrame:Hide();
			nextObject.answerLabel:Hide();
		else
			LoadAnswer(nil);
		end

		object.voteCheck:Show();
		object.voteCheck:SetChecked(false);
	end

	UpdateAnswersScrollbar();
end

RemoveAdditionalAnswer = function(iIndex)

	local editBox = answerObjects[iIndex].editBoxScrollFrame.EditBox;
	local sCurrentText = editBox:GetText();

	if sCurrentText == nil or sCurrentText == "" then
		return;
	end

	local iLastAnswerIndex = iAnswersCount;
	if bAllowMultipleVotes then	-- Difference comes from the fact that in one-vote policy, we increase the amount of answers without increasing the amount of answer boxes
		iLastAnswerIndex = iLastAnswerIndex + 1;
	end

	if iIndex == iLastAnswerIndex then

		editBox:SetText("");
		editBox:ClearFocus();
		editBox:HighlightText(0, 0);	-- Forces highlight removal
		answerObjects[iIndex].voteCheck:Hide();
		answerObjects[iIndex].voteTick:Hide();

	else
		for i = iIndex, iAnswersCount do

			local currentObject = answerObjects[i];
			local nextObject = answerObjects[i + 1];
			currentObject.editBoxScrollFrame.EditBox:SetText(nextObject.editBoxScrollFrame.EditBox:GetText());
			currentObject.voteCheck:SetChecked(nextObject.voteCheck:GetChecked());

			if i + 1 == iLastAnswerIndex then
				nextObject.number:Hide();
				nextObject.editBoxScrollFrame:Hide();
				nextObject.deleteButton:Hide();
				nextObject.voteCheck:Hide();

				currentObject.voteCheck:Hide();
			end
		end
	end

	iAnswersCount = iAnswersCount - 1;
	iAdditionalAnswersCount = iAdditionalAnswersCount - 1;
	UpdateAnswersScrollbar();
end

local function ChangeAnswerObjectToStaticAnswer(answerObject)
	answerObject.answerLabelFrame:Show();
	answerObject.answerLabel:Show();
	answerObject.editBoxScrollFrame:Hide();
	answerObject.deleteButton:Hide();

	if bAllowMultipleVotes then
		answerObject.voteCheck:Show();
	else
		answerObject.voteTick:Show();
	end
end

local function HideAnswer(answerObject)
	answerObject.containingFrame:Hide();
	answerObject.answerLabelFrame:Hide();
	answerObject.answerLabel:Hide();
	answerObject.editBoxScrollFrame:Hide();
	answerObject.deleteButton:Hide();
	answerObject.voteCheck:Hide();
	answerObject.voteTick:Hide();
	answerObject.sGUID = nil;
end

RemoveAllAnswers = function()
	for i = 1, #answerObjects do
		HideAnswer(answerObjects[i]);
	end

	iAnswersCount = 0;
	iAdditionalAnswersCount = 0;
end

local function InsertAdditionalAnswer(newAnswer)

	iAnswersCount = iAnswersCount + 1;
	if bAllowMultipleVotes or iAdditionalAnswersCount == 0 then
		LoadAnswer(nil);	-- Create empty answer at the end of the list
	end
	local iNewIndex = iAnswersCount - iAdditionalAnswersCount;
	for i = iAnswersCount, iNewIndex + 1, -1 do
		local currentObject = answerObjects[i];
		local previousObject = answerObjects[i - 1];
		currentObject.editBoxScrollFrame.EditBox:SetText(previousObject:GetAnswerText());
		currentObject.voteCheck:SetChecked(previousObject.voteCheck:GetChecked());
		currentObject.voteTick:SetChecked(previousObject.voteTick:GetChecked());
	end

	local newObject = answerObjects[iNewIndex];
	ChangeAnswerObjectToStaticAnswer(newObject);
	newObject.answerLabel:SetText(newAnswer.sText);
	newObject.voteCheck:SetChecked(false);
	newObject.voteTick:SetChecked(false);
	newObject.sGUID = newAnswer.sGUID;
end


function MakeAllTicksExclusive()

	for i = 1, #answerObjects do
		local currentObjectTick = answerObjects[i].voteTick;
		currentObjectTick.iIndex = i;

		currentObjectTick:SetScript("OnClick", function(self)
			for j = 1, #answerObjects do
				if j ~= currentObjectTick.iIndex then
					answerObjects[j].voteTick:SetChecked(false);
				end
			end
		end);
	end
end

UpdateAnswersScrollbar = function()

	local iAnswersCountForUpdateScrollbar = iAnswersCount;

	if bAllowAdditionalAnswers then
		local iAddition = 1;
		if not bAllowMultipleVotes and iAdditionalAnswersCount > 0 then
			iAddition = 0;
		end
		iAnswersCountForUpdateScrollbar = iAnswersCount + iAddition;
	end

	UpdateScrollBar(answersScrollFrame, (iAnswersCountForUpdateScrollbar * fTotalHeightOfEachAnswer) - fInnerFramesMargin);
end


function LoadAndOpenVoteFrame(pollData)

	if pollData.sPollType == "RAID" then

		local sSender = pollData.sPollMasterFullName;
		if IsCurrentlyVotingForSomething() then
			if sSender ~= nil and sSender ~= Me() then
				SendPollMessage({}, "Busy", "WHISPER", sSender, pollData.sPollMasterRealm);
			end

			return;
		end

		g_currentPollsMotherFrame.voteFrame.sendVoteButton:Enable();
		g_currentPollsMotherFrame.noPollFrame:Hide();
		g_currentPollsMotherFrame.resultsFrame:Hide();
		RemoveAllAnswers();

		g_currentPollsMotherFrame.voteFrame.questionLabel:SetText(pollData.sQuestion);

		bAllowMultipleVotes = pollData.bMultiVotes;
		bAllowAdditionalAnswers = pollData.bAllowNewAnswers;

		for i = 1, #pollData.answers do
			LoadAnswer(pollData.answers[i]);
		end
		if bAllowAdditionalAnswers then
			LoadAnswer(nil);
		end

		g_currentPollsMotherFrame.sCurrentPollGUID = pollData.sPollGUID;
		OpenCurrentPollsFrameTab(g_currentPollsMotherFrame.currentPollFrame);
		g_currentPollsMotherFrame.voteFrame:Show();
	end
end

function LoadAdditionalAnswersForVoting(newAnswers)

	for i = 1, #newAnswers do
		InsertAdditionalAnswer(newAnswers[i]);
	end
end


local function CreateAnswerGUID(iIndex)
	return Me() .. iIndex;
end

function GetVoteData()

	local voteObject =
	{
		sPollGUID = g_currentPollsMotherFrame.sCurrentPollGUID,
		sVoterBTag = MyBTag(),
		sVoterFullName = Me(),
		newAnswers = {},
		vote = {}
	}

	for i = 1, iAdditionalAnswersCount do
		local answerObject = answerObjects[iAnswersCount - iAdditionalAnswersCount + i];

		local sNewAnswerGUID = CreateAnswerGUID(i);
		answerObject.sGUID = sNewAnswerGUID;

		local additionalAnswerData =
		{
			sText = answerObject.editBoxScrollFrame.EditBox:GetText(),
			sGUID = sNewAnswerGUID
		}

		table.insert(voteObject.newAnswers, additionalAnswerData);
	end

	for i = 1, iAnswersCount do
		local currentAnswer = answerObjects[i];
		if currentAnswer:IsSelected() then
			table.insert(voteObject.vote, currentAnswer.sGUID);
		end
	end

	return voteObject;
end
