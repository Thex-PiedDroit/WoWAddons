
g_receivePollFrame = nil;

local mainFrameSize =
{
	x = 600,
	y = 700
}
local framesMargin = (mainFrameSize.x / 40);

local answersParentFrame = nil;
local answersCount = 0;


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


	local sendVoteButton = CreateButton("SendVoteButton", newPollFrame, 120, 30, "Send vote");
	sendVoteButton:SetPoint("TOP", 0, answersFramePosY - answersFrameSize.y - (framesMargin * 0.4));


	mainFrame:Hide();
	mainFrame:SetScript("OnShow", function() g_currentlyBusy = true; end);
	mainFrame:SetScript("OnHide", function() g_currentlyBusy = false; answersCount = 0; end);
	g_receivePollFrame.panel = mainFrame;
end


local answersObjects = {};
local answersFramesHeight = 70;

function LoadAnswer(answerText, trueCheckFalseTickButton)

	local object = nil;

	if answersCount < #answersObjects then
		object = answersObjects[answersCount + 1];
		object.text:SetText(answerText);
		object.number:Show();
		object.text:Show();
	else
		local answerIndexStr = tostring(answersCount + 1);

		local answerFrameWidth = answersParentFrame:GetWidth() - (framesMargin * 4) - 40;
		local textFramePosY = -10 - ((answersFramesHeight + (framesMargin * 0.25)) * answersCount);
		local textFrame = CreateBackdroppedFrame("Answer" .. answerIndexStr .. "TextFrame", answersParentFrame, answerFrameWidth, answersFramesHeight);
		textFrame:SetPoint("TOPLEFT", framesMargin + 24, textFramePosY);
		local newText = CreateLabel(textFrame, answerText, 16, answerFrameWidth - 20, "LEFT");
		newText:SetPoint("TOPLEFT", framesMargin, -11);

		local newNumber = CreateLabel(answersParentFrame, answerIndexStr .. '.', 16);
		newNumber:SetPoint("TOPLEFT", framesMargin - 5, textFramePosY - 8);

		local newCheck = CreateCheckButton(answersParentFrame, "Answer" .. answerIndexStr .. "CheckButton");
		newCheck:SetPoint("RIGHT", textFrame, "RIGHT", framesMargin + 10, 0);

		local newTick = CreateRadioCheckButton(answersParentFrame, "Answer" .. answerIndexStr .. "CheckButton");
		newTick:SetPoint("RIGHT", textFrame, "RIGHT", framesMargin + 8, 0);

		object =
		{
			text = newText,
			number = newNumber,
			voteCheck = newCheck,
			voteTick = newTick
		}

		table.insert(answersObjects, object);
	end

	if trueCheckFalseTickButton then
		object.voteCheck:Show();
		object.voteTick:Hide();
	else
		object.voteCheck:Hide();
		object.voteTick:Show();
	end

	answersCount = answersCount + 1;
end

function MakeAllTicksExclusive()

	for i = 1, #answersObjects do
		local currentObjectTick = answersObjects[i].voteTick;
		currentObjectTick.index = i;

		currentObjectTick:SetScript("OnClick", function(self)
			for j = 1, #answersObjects do
				if j ~= currentObjectTick.index then
					answersObjects[j].voteTick:SetChecked(false);
				end
			end
		end);
	end
end


function LoadAndOpenReceivePollFrame(pollData, sender)

	if pollData.pollType == "RAID" then

		if g_currentlyBusy then
			return;
		end

		if g_receivePollFrame == nil then
			InitializeReceivePollFrame();
		end

		g_receivePollFrame.panel.questionLabel:SetText(pollData.question);

		local multipleVotesAllowed = pollData.multiVotes;

		for i = 1, #pollData.answers do
			LoadAnswer(pollData.answers[i], multipleVotesAllowed);
		end
		if not multipleVotesAllowed then
			MakeAllTicksExclusive();
		end
	end

	g_receivePollFrame.panel:Show();
end
