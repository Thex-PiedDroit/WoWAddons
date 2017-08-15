
g_cerberus.RegisterAddon("PollCraft");


local _, playerBTag = BNGetInfo();
function MyBTag()
	if playerBTag == nil then
		local _, newBTag = BNGetInfo();
		playerBTag = newBTag;
	end
	return playerBTag;
end
local playerGUID = UnitGUID("player");
function MyGUID()
	if playerGUID == nil then
		playerGUID = UnitGUID("player");
	end
	return playerGUID;
end
local playerName = UnitName("player");
function MyName()
	return playerName;
end
local playerRealm = GetRealmName();
function MyRealm()
	return playerRealm;
end
local playerFullName = playerName .. "-" .. playerRealm;
function Me()
	return playerFullName;
end


local addonTextColour = "ff25de32";
local pollCraftPrefix = "|c" .. addonTextColour .. "PollCraft: |r"
function PollCraft_Print(message)
	print(pollCraftPrefix .. message);
end

function GetInnerFramesMargin()
	return 8;
end

function GetTextMarginFromUpperFramesBorders()
	return -22;
end

function GetSizeDifferenceBetweenFrameAndEditBox()
	return 12;
end


function GetNameForPrint(targetName, targetRealm)

	if targetRealm ~= MyRealm() then
		targetName = targetName .. "-" .. targetRealm;
	end

	return targetName;
end

function math.Clamp(number, min, max)

	return math.min(max, math.max(number, min));
end

function table.Len(T)
	local count = 0;
	for _ in pairs(T) do
		count = count + 1;
	end
	return count;
end

function table.clone(T)

	local copy = {};
	for key, value in pairs(T) do
		copy[key] = value;
	end
	return copy;
end
