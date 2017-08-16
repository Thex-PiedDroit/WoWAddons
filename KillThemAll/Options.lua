
g_cerberus.RegisterAddon("KillThemAll");
g_cerberus.HookThisFile();

g_ktaOptions = {};

local RecoverPreviousVersion = nil;

function LoadOptions()

	if RecoverPreviousVersion() then
		return;
	end

	local bDefaultOptionsIsNotNil = S_ktaOptions ~= nil and S_ktaOptions.default ~= nil;
	local sDefaultSoundChannel = (bDefaultOptionsIsNotNil and S_ktaOptions.default.sSoundChannel) or "Dialog";
	local bMinimapOptionIsNotNil = S_ktaOptions ~= nil and S_ktaOptions.minimapButton ~= nil;

	g_ktaOptions =
	{
		default =
		{
			sGods = (bDefaultOptionsIsNotNil and S_ktaOptions.default.sGods) or "YSHAARJ",
			sSoundChannel = sDefaultSoundChannel,
			iMinDelay = (bDefaultOptionsIsNotNil and S_ktaOptions.default.iMinDelay) or 300,
			iMaxDelay = (bDefaultOptionsIsNotNil and S_ktaOptions.default.iMaxDelay) or 1200,
		},

		bDeactivated = (S_ktaOptions ~= nil and S_ktaOptions.bDeactivated) or (S_ktaOptions == nil and false),
		bMuteDuringCombat = (S_ktaOptions ~= nil and S_ktaOptions.bMuteDuringCombat) or (S_ktaOptions == nil and false),
		sSoundChannel = (S_ktaOptions ~= nil and S_ktaOptions.sSoundChannel) or sDefaultSoundChannel,

		minimapButton =
		{
			hide = (bMinimapOptionIsNotNil and S_ktaOptions.minimapButton.hide) or (bMinimapOptionIsNotNil and false),
		}
	};

	SetGods(GetWords((S_ktaOptions ~= nil and S_ktaOptions.sGods) or g_ktaOptions.default.sGods), true);
	SetDelay((S_ktaOptions ~= nil and S_ktaOptions.iMinDelay) or g_ktaOptions.default.iMinDelay, (S_ktaOptions ~= nil and S_ktaOptions.iMaxDelay) or g_ktaOptions.default.iMaxDelay, true);
end

RecoverPreviousVersion = function()

	-- Previous versions recovery here

	S_AddonVersion = GetAddOnMetadata("KillThemAll", "Version");
	return false;
end
