
g_cerberus.RegisterAddon("PollCraft", { "S_sPollCraftSavedAddonVersion", "S_pollCraftData" });


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


function ColoriseText(sMessage, sColorCode)
	return "|cff" .. sColorCode .. sMessage .. "|r";
end

g_cRedWarningColor = "f00606";

g_cAddonTextColor = "25de32";
g_sPollCraftPrefix = ColoriseText("PollCraft: ", g_cAddonTextColor);
function PollCraft_Print(sMessage)
	print(g_sPollCraftPrefix .. sMessage);
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

function OpenTab(panel, tabContent)

	local iTabToSet = -1;

	for i = 1, #panel.tabFrames do

		if panel.tabFrames[i] == tabContent then
			panel.tabFrames[i]:Show();
			iTabToSet = i;
		else
			panel.tabFrames[i]:Hide();
		end
	end

	PanelTemplates_SetTab(panel, iTabToSet);
	return iTabToSet;
end
