
Cerberus_HookThisFile();

local innerFramesMargin = GetInnerFramesMargin();
local marginBetweenUpperBordersAndText = GetTextMarginFromUpperFramesBorders();
local sizeDifferenceBetweenFrameAndEditBox = GetSizeDifferenceBetweenFrameAndEditBox();

local answersParentFrame = nil;
local answersScrollFrame = nil;
local answersCount = 0;

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
	changeVoteButton:SetPoint("BOTTOM", mainFrame, "BOTTOM", 0, innerFramesMargin * 2);


		--[[      QUESTION FRAME      ]]--
	local questionFrameSize =
	{
		x = innerFrameSize.x - (innerFramesMargin * 2),
		y = 44 + sizeDifferenceBetweenFrameAndEditBox;
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
	local answersFrame = CreateScrollFrame("AnswersFrame_PollResults", mainFrame, answersFrameSize);
	answersFrame:SetPoint("TOP", questionFrame, "BOTTOM", 0, marginBetweenUpperBordersAndText * 2);
	answersFrame:SetPoint("BOTTOM", changeVoteButton, "TOP", 0, (innerFramesMargin * 2) - 8);
	local answersFrameLabel = CreateLabel(answersFrame, "Answers:", 16);
	answersFrameLabel:SetPoint("TOPLEFT", 10, -marginBetweenUpperBordersAndText);

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
local totalHeightOfEachAnswer = answersFramesSize.y + (innerFramesMargin * 0.5);

local function LoadAnswer(answerObject)

	local answerText = answerObject.text;
	local answerGUID = answerObject.GUID;

	local object = nil;

	if answersCount < #answerObjects then
		object = answerObjects[answerObjectsIndexList[answersCount + 1]];

		object.answerContainingFrame:Show();
		object.text:SetText(answerText);
		object.text:Show();
		object.textFrame:Show();
		object.number:Show();
		object.GUID = answerGUID;
		object.votesCount = 0;
		object.votesCountLabel:SetText("0");
	else
		local answerIndexStr = tostring(answersCount + 1);

		if answersFramesSize.x == 0 then
			answersFramesSize.x = answersParentFrame:GetWidth() - (innerFramesMargin * 2) - answersParentFrame:GetParent().scrollbar:GetWidth();
			answersTextFrameSize.x = answersFramesSize.x - (innerFramesMargin * 2) - 54;
		end

		local answerContainingFrame = CreateFrame("Frame", "Answer" .. answerIndexStr .. "ContainingFrame", answersParentFrame);
		answerContainingFrame:SetSize(answersFramesSize.x, answersFramesSize.y);
		local textFramePosY = -(totalHeightOfEachAnswer * answersCount) - innerFramesMargin;
		answerContainingFrame:SetPoint("TOPLEFT", innerFramesMargin, textFramePosY);

		local textFrame = CreateBackdroppedFrame("Answer" .. answerIndexStr .. "TextFrame", answerContainingFrame, answersTextFrameSize);
		textFrame:SetPoint("TOPLEFT", innerFramesMargin + 22, 0);
		local answerLabel = CreateLabel(textFrame, answerText, 16, "LEFT");
		answerLabel:SetPoint("TOPLEFT", innerFramesMargin, -11);
		answerLabel:SetPoint("BOTTOMRIGHT", -innerFramesMargin, 11);

		local newNumber = CreateLabel(answerContainingFrame, answerIndexStr .. '.', 16);
		newNumber:SetPoint("TOPRIGHT", textFrame, "TOPLEFT", -2, -8);

		local votesCountLabel = CreateLabel(answerContainingFrame, "0", 16);
		votesCountLabel:SetPoint("LEFT", textFrame, "RIGHT", innerFramesMargin, 0);

		object =
		{
			answerContainingFrame = answerContainingFrame,
			number = newNumber,
			textFrame = textFrame,
			text = answerLabel,
			votesCountLabel = votesCountLabel,
			votesCount = 0,
			GUID = answerGUID,
		}

		table.insert(answerObjects, object);
		table.insert(answerObjectsIndexList, answersCount + 1);
	end

	answersCount = answersCount + 1;
	UpdateScrollBar(answersScrollFrame, (answersCount * totalHeightOfEachAnswer) - innerFramesMargin);
end

local function InsertAnswerObject(oldIndex, newIndex)

	if newIndex >= oldIndex then
		PollCraft_Print("Error: Attempting to insert an answer object from top to bottom. This is unintended behaviour. If you really need to, you'll have to remake the InsertAnswerObject function.");
		return;
	end

	local newPoint, _, _, newX, newY = answerObjects[answerObjectsIndexList[newIndex]].answerContainingFrame:GetPoint();
	local cachedIndex = answerObjectsIndexList[oldIndex];

	for i = newIndex, oldIndex - 1 do
		local nextPoint, _, _, nextX, nextY = answerObjects[answerObjectsIndexList[i + 1]].answerContainingFrame:GetPoint();
		answerObjects[answerObjectsIndexList[i]].answerContainingFrame:SetPoint(nextPoint, nextX, nextY);

		local newCurrentIndex = cachedIndex;
		cachedIndex = answerObjectsIndexList[i];
		answerObjectsIndexList[i] = newCurrentIndex;
	end

	answerObjects[answerObjectsIndexList[oldIndex]].answerContainingFrame:SetPoint(newPoint, newX, newY);
	answerObjectsIndexList[oldIndex] = cachedIndex;
end


local function SortAnswer(index, votesCount)

	local newIndex = 1;

	for i = index - 1, 1, -1 do
		local currentAnswerObject = answerObjects[answerObjectsIndexList[i]];

		if currentAnswerObject.votesCount >= votesCount then
			newIndex = i + 1;
			break;
		end
	end

	if newIndex ~= index then
		InsertAnswerObject(index, newIndex);
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
		answerObject.GUID = nil;
	end

	answersCount = 0;
end


local function VoteForAnswer(index, pointsToAdd)

	pointsToAdd = pointsToAdd or 1;

	local answerObject = answerObjects[answerObjectsIndexList[index]];
	local newCount = answerObject.votesCount + pointsToAdd;
	answerObject.votesCount = newCount;
	answerObject.votesCountLabel:SetText(tostring(newCount));

	SortAnswer(index, newCount);
end

local function FindAnswerIndexByGUID(answerGUID)

	for i = 1, answersCount do
		if answerObjects[answerObjectsIndexList[i]].GUID == answerGUID then
			return i;
		end
	end

	PollCraft_Print("Error: Could not find answer with GUID " .. answerGUID .. " in function FindAnswerIndexByGUID()");
end

local function ProcessVotes(votes)

	local votesCopy = table.clone(votes);

	for i = 1, answersCount do

		if #votesCopy == 0 then
			return;
		end

		for j = 1, #votesCopy do
			local currentAnswerObject = answerObjects[answerObjectsIndexList[i]];
			if votesCopy[j] == currentAnswerObject.GUID then
				VoteForAnswer(i);
				table.remove(votesCopy, j);
				break;
			end
		end
	end
end


function LoadResults(results)

	for answerGUID, result in pairs(results) do
		local answerIndex = FindAnswerIndexByGUID(answerGUID);
		VoteForAnswer(answerIndex, result);
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

	pollGUID = pollData.pollGUID;
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
