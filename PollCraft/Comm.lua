
g_pollCraftComm = LibStub("AceComm-3.0");
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


	if actualMessage.messageType == "NewPoll" then
		if messageObject.senderGUID ~= nil and messageObject.senderGUID == MyGUID() then
			return;
		end

		LoadAndOpenReceivePollFrame(actualMessage.poll, messageObject.senderFullName, messageObject.senderRealm);

	elseif actualMessage.messageType == "Busy" then
		PollCraft_Print(GetNameForPrint(messageObject.senderName, messageObject.senderRealm) .. " could not receive your poll because they were busy.");

	--elseif actualMessage.messageType == "Vote" then

	end
end

g_pollCraftComm:RegisterComm("PollCraft", ReceiveMessage);


function g_pollCraftComm:SendMessage(msg, channel, target)

	local messageObject =
	{
		senderGUID = MyGUID();
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

	g_pollCraftComm:SendMessage(message, channel, target);
end
