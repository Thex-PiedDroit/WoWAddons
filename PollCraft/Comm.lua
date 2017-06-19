
pollCraftComm = LibStub("AceComm-3.0");
local serializer = LibStub("AceSerializer-3.0");


local playerGUID = UnitGUID("player");
local playerName = UnitName("player") .. "-" .. GetRealmName();


local function ReceiveMessage(prefix, message)

	local success, messageObject = serializer:Deserialize(message);

	if not success or (messageObject.senderGUID ~= nil and messageObject.senderGUID == playerGUID) then
		return;
	end

	-- Do stuff here
end

pollCraftComm:RegisterComm("PollCraft", ReceiveMessage);


function pollCraftComm:SendMessage(msg, channel, target)

	local messageObject =
	{
		senderGUID = playerGUID;
		senderName = playerName;
		message = msg;
	};

	pollCraftComm:SendCommMessage("PollCraft", serializer:Serialize(messageObject), channel, target);
end
