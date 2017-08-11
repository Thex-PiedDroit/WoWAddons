

local _, playerBTag = BNGetInfo();
function PollCraft_MyBTag()
	if playerBTag == nil then
		local _, newBTag = BNGetInfo();
		playerBTag = newBTag;
	end
	return playerBTag;
end
local playerGUID = UnitGUID("player");
function PollCraft_MyGUID()
	if playerGUID == nil then
		playerGUID = UnitGUID("player");
	end
	return playerGUID;
end
local playerName = UnitName("player");
function PollCraft_MyName()
	return playerName;
end
local playerRealm = GetRealmName();
function PollCraft_MyRealm()
	return playerRealm;
end
local playerFullName = playerName .. "-" .. playerRealm;
function PollCraft_Me()
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


function PollCraft_GetNameForPrint(targetName, targetRealm)

	if targetRealm ~= PollCraft_MyRealm() then
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

function table.LenRecursive(T)

	local count = 0;
	for key, value in pairs(T) do
		if type(value) == "table" then
			count = count + table.LenRecursive(value);
		else
			count = count + 1;
		end
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
