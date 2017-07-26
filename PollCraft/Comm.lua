
g_pollCraftComm = LibStub("AceComm-3.0");
local serializer = LibStub("AceSerializer-3.0");


g_currentlyBusy = false;


local function ReceiveMessage(prefix, message)

	local success, messageObject = serializer:Deserialize(message);

	if not success or (messageObject.senderGUID ~= nil and messageObject.senderGUID == MyGUID()) then
		return;
	end

	local actualMessage = messageObject.message;

	if actualMessage.specificTarget ~= nil and actualMessage.specificTarget ~= Me() then	-- Because for some reason, blizzard decided that cross-realm WHISPERS do not work in parties and raid groups
		return;
	end


	if actualMessage.messageType == "NewPoll" then
		LoadAndOpenReceivePollFrame(actualMessage.poll, messageObject.senderFullName, messageObject.senderRealm);

	elseif actualMessage.messageType == "Busy" then
		PollCraft_Print(GetNameForPrint(actualMessage.senderName, actualMessage.senderRealm) .. " could not receive your poll because they were busy.");

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

	self:SendCommMessage("PollCraft", serializer:Serialize(messageObject), channel, target);
end
