
Cerberus_HookThisFile();

local fInnerFramesMargin = GetInnerFramesMargin();
local fMarginBetweenUpperBordersAndText = GetTextMarginFromUpperFramesBorders();
local fSizeDifferenceBetweenFrameAndEditBox = GetSizeDifferenceBetweenFrameAndEditBox();

local answersParentFrame = nil;
local answersScrollFrame = nil;
local iAnswersCount = 0;

local RemoveAllAnswers = nil;


function InitResultsFrame()

	if g_currentPollsMotherFrame.resultsFrame ~= nil then
		RemoveAllAnswers();
		return;
	end

	local motherFrameSize = GetMotherFrameSize();
	local containingFrame = g_currentPollsMotherFrame.currentPollFrame;


	local mainFrame = CreateBackdropTitledInnerFrame("PollResultsFrame", containingFrame, "PollCraft - Poll results");
	local innerFrameSize = GetFrameSizeAsTable(mainFrame);


		--[[      CHANGE VOTE BUTTON      ]]--
	local changeVoteButton = CreateButton("SendVoteButton", mainFrame, { x = 120, y = 30 }, "Change vote");
	changeVoteButton:SetPoint("BOTTOM", mainFrame, "BOTTOM", 0, fInnerFramesMargin * 2);


		--[[      QUESTION FRAME      ]]--
	local questionFrameSize =
	{
		x = innerFrameSize.x - (fInnerFramesMargin * 2),
		y = 44 + fSizeDifferenceBetweenFrameAndEditBox;
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
	local answersFrame = CreateScrollFrame("AnswersFrame_PollResults", mainFrame, answersFrameSize);
	answersFrame:SetPoint("TOP", questionFrame, "BOTTOM", 0, fMarginBetweenUpperBordersAndText * 2);
	answersFrame:SetPoint("BOTTOM", changeVoteButton, "TOP", 0, (fInnerFramesMargin * 2) - 8);
	local answersFrameLabel = CreateLabel(answersFrame, "Answers:", 16);
	answersFrameLabel:SetPoint("TOPLEFT", 10, -fMarginBetweenUpperBordersAndText);

	answersFrame.content.answersBoxes = {};
	answersParentFrame = answersFrame.content;
	answersScrollFrame = answersFrame;

	changeVoteButton:SetFrameLevel(answersParentFrame:GetFrameLevel() + 10);


	g_currentPollsMotherFrame.resultsFrame = mainFrame;
	mainFrame:Hide();
end


local answerObjects = {};
local answerObjectsIndexList = {};
local answersFramesSize = { x = 0, y = 70 };
local answersTextFrameSize = table.clone(answersFramesSize);
local fTotalHeightOfEachAnswer = answersFramesSize.y + (fInnerFramesMargin * 0.5);

local function LoadAnswer(answerObject)

	local sAnswerText = answerObject.sText;
	local sAnswerGUID = answerObject.sGUID;

	local object = nil;

	if iAnswersCount < #answerObjects then
		object = answerObjects[answerObjectsIndexList[iAnswersCount + 1]];

		object.answerContainingFrame:Show();
		object.text:SetText(sAnswerText);
		object.text:Show();
		object.textFrame:Show();
		object.number:Show();
		object.sGUID = sAnswerGUID;
		object.iVotesCount = 0;
		object.votesCountLabel:SetText("0");
	else
		local sAnswerIndexStr = tostring(iAnswersCount + 1);

		if answersFramesSize.x == 0 then
			answersFramesSize.x = answersParentFrame:GetWidth() - (fInnerFramesMargin * 2) - answersParentFrame:GetParent().scrollbar:GetWidth();
			answersTextFrameSize.x = answersFramesSize.x - (fInnerFramesMargin * 2) - 54;
		end

		local answerContainingFrame = CreateFrame("Frame", "Answer" .. sAnswerIndexStr .. "ContainingFrame", answersParentFrame);
		answerContainingFrame:SetSize(answersFramesSize.x, answersFramesSize.y);
		local fTextFramePosY = -(fTotalHeightOfEachAnswer * iAnswersCount) - fInnerFramesMargin;
		answerContainingFrame:SetPoint("TOPLEFT", fInnerFramesMargin, fTextFramePosY);

		local textFrame = CreateBackdroppedFrame("Answer" .. sAnswerIndexStr .. "TextFrame", answerContainingFrame, answersTextFrameSize);
		textFrame:SetPoint("TOPLEFT", fInnerFramesMargin + 22, 0);
		local answerLabel = CreateLabel(textFrame, sAnswerText, 16, "LEFT");
		answerLabel:SetPoint("TOPLEFT", fInnerFramesMargin, -11);
		answerLabel:SetPoint("BOTTOMRIGHT", -fInnerFramesMargin, 11);

		local newNumber = CreateLabel(answerContainingFrame, sAnswerIndexStr .. '.', 16);
		newNumber:SetPoint("TOPRIGHT", textFrame, "TOPLEFT", -2, -8);

		local votesCountLabel = CreateLabel(answerContainingFrame, "0", 16);
		votesCountLabel:SetPoint("LEFT", textFrame, "RIGHT", fInnerFramesMargin, 0);

		object =
		{
			answerContainingFrame = answerContainingFrame,
			number = newNumber,
			textFrame = textFrame,
			text = answerLabel,
			votesCountLabel = votesCountLabel,
			iVotesCount = 0,
			sGUID = sAnswerGUID,
		}

		table.insert(answerObjects, object);
		table.insert(answerObjectsIndexList, iAnswersCount + 1);
	end

	iAnswersCount = iAnswersCount + 1;
	UpdateScrollBar(answersScrollFrame, (iAnswersCount * fTotalHeightOfEachAnswer) - fInnerFramesMargin);
end

local function InsertAnswerObject(iOldIndex, iNewIndex)

	if iNewIndex >= iOldIndex then
		PollCraft_Print("Error: Attempting to insert an answer object from top to bottom. This is unintended behaviour. If you really need to, you'll have to remake the InsertAnswerObject function.");
		return;
	end

	local sNewPoint, _, _, fNewX, fNewY = answerObjects[answerObjectsIndexList[iNewIndex]].answerContainingFrame:GetPoint();
	local iCachedIndex = answerObjectsIndexList[iOldIndex];

	for i = iNewIndex, iOldIndex - 1 do
		local sNextPoint, _, _, fNextX, fNextY = answerObjects[answerObjectsIndexList[i + 1]].answerContainingFrame:GetPoint();
		answerObjects[answerObjectsIndexList[i]].answerContainingFrame:SetPoint(sNextPoint, fNextX, fNextY);

		local iNewCurrentIndex = iCachedIndex;
		iCachedIndex = answerObjectsIndexList[i];
		answerObjectsIndexList[i] = iNewCurrentIndex;
	end

	answerObjects[answerObjectsIndexList[iOldIndex]].answerContainingFrame:SetPoint(sNewPoint, fNewX, fNewY);
	answerObjectsIndexList[iOldIndex] = iCachedIndex;
end


local function SortAnswer(iIndex, iVotesCount)

	local iNewIndex = 1;

	for i = iIndex - 1, 1, -1 do
		local currentAnswerObject = answerObjects[answerObjectsIndexList[i]];

		if currentAnswerObject.iVotesCount >= iVotesCount then
			iNewIndex = i + 1;
			break;
		end
	end

	if iNewIndex ~= iIndex then
		InsertAnswerObject(iIndex, iNewIndex);
	end
end

local function ReSortAnswers()

	for i = 1, #answerObjects do
		local currentAnswerObject = answerObjects[answerObjectsIndexList[i]];
		currentAnswerObject.number:SetText(i .. ".");
	end
end

RemoveAllAnswers = function()

	ReSortAnswers();

	for i = 1, #answerObjects do
		local answerObject = answerObjects[answerObjectsIndexList[i]];
		answerObject.answerContainingFrame:Hide();
		answerObject.sGUID = nil;
	end

	iAnswersCount = 0;
end


local function VoteForAnswer(iIndex, iPointsToAdd)

	iPointsToAdd = iPointsToAdd or 1;

	local answerObject = answerObjects[answerObjectsIndexList[iIndex]];
	local iNewCount = answerObject.iVotesCount + iPointsToAdd;
	answerObject.iVotesCount = iNewCount;
	answerObject.votesCountLabel:SetText(tostring(iNewCount));

	SortAnswer(iIndex, iNewCount);
end

local function FindAnswerIndexByGUID(sAnswerGUID)

	for i = 1, iAnswersCount do
		if answerObjects[answerObjectsIndexList[i]].sGUID == sAnswerGUID then
			return i;
		end
	end

	PollCraft_Print("Error: Could not find answer with GUID " .. sAnswerGUID .. " in function FindAnswerIndexByGUID()");
end

local function ProcessVotes(votes)

	local votesCopy = table.clone(votes);

	for i = 1, iAnswersCount do

		if #votesCopy == 0 then
			return;
		end

		for j = 1, #votesCopy do
			local currentAnswerObject = answerObjects[answerObjectsIndexList[i]];
			if votesCopy[j] == currentAnswerObject.sGUID then
				VoteForAnswer(i);
				table.remove(votesCopy, j);
				break;
			end
		end
	end
end


function LoadResults(results)

	for sAnswerGUID, result in pairs(results) do
		local iAnswerIndex = FindAnswerIndexByGUID(sAnswerGUID);
		VoteForAnswer(iAnswerIndex, result);
	end
end

function LoadAndOpenPollResultsFrame(pollData)

	InitResultsFrame();

	g_currentPollsMotherFrame.voteFrame:Hide();
	g_currentPollsMotherFrame.resultsFrame.questionLabel:SetText(pollData.question);

	for i = 1, #pollData.answers do
		LoadAnswer(pollData.answers[i]);
	end

	LoadResults(pollData.results);

	g_currentPollsMotherFrame.panel:Show();
	g_currentPollsMotherFrame.resultsFrame:Show();
	g_currentPollsMotherFrame.currentPollFrame:Show();
end

function AddVoteToResultsDisplay(voteData)

	local newAnswers = voteData.newAnswers;
	for i = 1, #newAnswers do
		LoadAnswer(newAnswers[i]);
	end
	ProcessVotes(voteData.vote);
end
