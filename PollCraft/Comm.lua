
Cerberus_HookThisFile();

local comm = LibStub("AceComm-3.0");
local serializer = LibStub("AceSerializer-3.0");


local function ReceiveMessage(_, sMessage)

	local bSuccess, messageObject = serializer:Deserialize(sMessage);

	if not bSuccess then
		PollCraft_Print("Could not deserialize a message. Error message:");
		print(messageObject);
		return;
	end

	local actualMessage = messageObject.message;

	if actualMessage.sSpecificTarget ~= nil and actualMessage.sSpecificTarget ~= Me() then
		return;		-- Because for some reason, blizzard decided that cross-realm WHISPERS do not work in parties and raid groups
	end

	local sMessageType = actualMessage.sMessageType;

	if sMessageType == "NewPoll" then
		AddPollDataToMemory(actualMessage.poll);
		LoadAndOpenVoteFrame(actualMessage.poll, messageObject.sSenderFullName, messageObject.sSenderRealm);

	elseif sMessageType == "Busy" then
		PollCraft_Print(GetNameForPrint(messageObject.sSenderName, messageObject.sSenderRealm) .. " could not receive your poll because they were busy.");

	elseif sMessageType == "Vote" then
		HandleVoteMessageReception(actualMessage, messageObject.sSenderFullName, messageObject.sSenderRealm);

	elseif sMessageType == "Results" or sMessageType == "PollAbort" then
		local resultsData = actualMessage.resultsData;
		local pollData = GetPollData(resultsData.sPollGUID);
		if pollData == nil then
			return;
		end

		RegisterResults(resultsData);

		if sMessageType == "PollAbort" then
			if g_currentPollsMotherFrame.sCurrentPollGUID == resultsData.sPollGUID then
				LoadPollResultsFrame(pollData);
				g_currentPollsMotherFrame.voteFrame:Hide();
				g_currentPollsMotherFrame.resultsFrame:Show();
				g_currentPollsMotherFrame.resultsFrame.pollAbortedLabel:Show();
			end

			RemovePollDataFromMemory(resultsData.sPollGUID, messageObject.sSenderFullName ~= Me());
		else
			LoadAndOpenPollResultsFrame(pollData);
		end
	end
end

comm:RegisterComm("PollCraft", ReceiveMessage);


function comm:SendMessage(message, sChannel, sTarget)

	local messageObject =
	{
		sSenderBTag = MyBTag(),
		sSenderName = MyName(),
		sSenderRealm = MyRealm(),
		sSenderFullName = Me(),
		message = message
	};

	local sSerializedMessage = serializer:Serialize(messageObject);

	if sTarget == Me() then
		ReceiveMessage(nil, sSerializedMessage);
	else
		self:SendCommMessage("PollCraft", sSerializedMessage, sChannel, sTarget);
	end
end

function SendPollMessage(message, sMessageType, sChannel, sTarget, sTargetRealm)

	message.sMessageType = sMessageType;

	if sChannel == "WHISPER" and sTargetRealm ~= MyRealm() then
		message.sSpecificTarget = sTarget;	-- Because for some reason, blizzard decided that cross-realm WHISPERS do not work in parties and raid groups
		sChannel = "RAID";
	end

	comm:SendMessage(message, sChannel, sTarget);
end
