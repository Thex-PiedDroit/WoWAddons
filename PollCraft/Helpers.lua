
g_cerberus.RegisterAddon("PollCraft");


local _, sPlayerBTag = BNGetInfo();
function MyBTag()
	if sPlayerBTag == nil then
		local _, sNewBTag = BNGetInfo();
		sPlayerBTag = sNewBTag;
	end
	return sPlayerBTag;
end
local sPlayerGUID = UnitGUID("player");
function MyGUID()
	if sPlayerGUID == nil then
		sPlayerGUID = UnitGUID("player");
	end
	return sPlayerGUID;
end
local sPlayerName = UnitName("player");
function MyName()
	return sPlayerName;
end
local sPlayerRealm = GetRealmName();
function MyRealm()
	return sPlayerRealm;
end
local playerFullName = sPlayerName .. "-" .. sPlayerRealm;
function Me()
	return playerFullName;
end


local cAddonTextColour = "ff25de32";
local sPollCraftPrefix = "|c" .. cAddonTextColour .. "PollCraft: |r"
function PollCraft_Print(sMessage)
	print(sPollCraftPrefix .. sMessage);
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


function GetNameForPrint(sTargetName, sTargetRealm)

	if sTargetRealm ~= MyRealm() then
		sTargetName = sTargetName .. "-" .. sTargetRealm;
	end

	return sTargetName;
end

function math.Clamp(fNumber, fMin, fMax)

	return math.min(fMax, math.max(fNumber, fMin));
end

function table.Len(T)
	local iCount = 0;
	for _ in pairs(T) do
		iCount = iCount + 1;
	end
	return iCount;
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
