
g_cerberus.HookThisFile();

local comm = LibStub("AceComm-3.0");
local serializer = LibStub("AceSerializer-3.0");


g_currentlyBusy = false;


local function ReceiveMessage(prefix, message)

	local success, messageObject = serializer:Deserialize(message);

	if not success then
		PollCraft_Print("Could not deserialize a message. Error message:");
		print(messageObject);
		return;
	end

	local actualMessage = messageObject.message;

	if actualMessage.specificTarget ~= nil and actualMessage.specificTarget ~= Me() then
		return;		-- Because for some reason, blizzard decided that cross-realm WHISPERS do not work in parties and raid groups
	end

	local messageType = actualMessage.messageType;

	if messageType == "NewPoll" then
		if messageObject.senderFullName ~= nil and messageObject.senderFullName == Me() then
			return;
		end

		LoadAndOpenReceivePollFrame(actualMessage.poll, messageObject.senderFullName, messageObject.senderRealm);

	elseif messageType == "Busy" then
		PollCraft_Print(GetNameForPrint(messageObject.senderName, messageObject.senderRealm) .. " could not receive your poll because they were busy.");

	elseif messageType == "Vote" then
		HandleVoteMessageReception(actualMessage, messageObject.senderFullName, messageObject.senderRealm);

	elseif messageType == "Results" then
		local resultsData = actualMessage.resultsData;
		RegisterResults(resultsData);
		LoadAndOpenPollResultsFrame(GetPollData(resultsData.pollGUID));
	end
end

comm:RegisterComm("PollCraft", ReceiveMessage);


function comm:SendMessage(msg, channel, target)

	local messageObject =
	{
		senderBTag = MyBTag();
		senderName = MyName();
		senderRealm = MyRealm();
		senderFullName = Me();
		message = msg;
	};

	local serializedMessage = serializer:Serialize(messageObject);

	if target == Me() then
		ReceiveMessage("PollCraft", serializedMessage);
	else
		self:SendCommMessage("PollCraft", serializedMessage, channel, target);
	end
end

function SendPollMessage(message, messageType, channel, target, targetRealm)

	message.messageType = messageType;

	if channel == "WHISPER" and targetRealm ~= MyRealm() then
		message.specificTarget = target;	-- Because for some reason, blizzard decided that cross-realm WHISPERS do not work in parties and raid groups
		channel = "RAID";
	end

	comm:SendMessage(message, channel, target);
end
