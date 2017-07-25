

local playerGUID = UnitGUID("player");
function MyGUID()
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


function GetNameForPrint(targetName, targetRealm)

	if targetRealm ~= MyRealm() then
		targetName = targetName .. "-" .. targetRealm;
	end

	return targetName;
end

function math.Clamp(number, min, max)

	return math.min(max, math.max(number, min));
end
