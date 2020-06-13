
Cerberus_HookThisFile();

g_pollCraftData = nil;

local OutDatedDataRecovered = nil;

function LoadData()

	if OutDatedDataRecovered() then
		return;
	end

	local bMinimapDataExists = S_pollCraftData ~= nil and S_pollCraftData.minimapButton ~= nil;

	g_pollCraftData =
	{
		savedPollsData = (S_pollCraftData ~= nil and S_pollCraftData.savedPollsData) or {},
		savedPollsGUIDs = (S_pollCraftData ~= nil and S_pollCraftData.savedPollsGUIDs) or {},

		minimapButton =
		{
			hide = (bMinimapDataExists and S_pollCraftData.minimapButton.hide) or false,
			minimapPos = (bMinimapDataExists and S_pollCraftData.minimapButton.minimapPos) or nil,
		};
	};
end

OutDatedDataRecovered = function()

	local sPreviouslySavedAddonVersion = S_sPollCraftSavedAddonVersion;
	S_sPollCraftSavedAddonVersion = GetAddOnMetadata("PollCraft", "Version");

	if sPreviouslySavedAddonVersion == nil or sPreviouslySavedAddonVersion == S_sPollCraftSavedAddonVersion then
		return false;
	end


	-- Recover data here
	return true;
end


function SaveData()

	S_pollCraftData = g_pollCraftData;
end
