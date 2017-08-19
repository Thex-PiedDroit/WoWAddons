
g_cerberus.RegisterAddon("KillThemAll", { "S_ktaOptions", "S_sAddonVersion" });

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
			minimapPos = (bMinimapOptionIsNotNil and S_ktaOptions.minimapButton.minimapPos),
		}
	};

	SetGods(GetWords((S_ktaOptions ~= nil and S_ktaOptions.sGods) or g_ktaOptions.default.sGods), true);
	SetDelay((S_ktaOptions ~= nil and S_ktaOptions.iMinDelay) or g_ktaOptions.default.iMinDelay, (S_ktaOptions ~= nil and S_ktaOptions.iMaxDelay) or g_ktaOptions.default.iMaxDelay, true);
end

RecoverPreviousVersion = function()

	local sCurrentAddonVersion = GetAddOnMetadata("KillThemAll", "Version");
	local sCurrentlySavedAddonVersion = S_sAddonVersion or S_AddonVersion;
	S_sAddonVersion = sCurrentAddonVersion;

	if sCurrentlySavedAddonVersion == nil or sCurrentlySavedAddonVersion == sCurrentAddonVersion then
		return false;
	end


	local bDefaultOptionsIsNotNil = S_ktaOptions ~= nil and S_ktaOptions.default ~= nil;
	local sDefaultSoundChannel = (bDefaultOptionsIsNotNil and S_ktaOptions.default.soundChannel) or "Dialog";
	local bMinimapOptionIsNotNil = S_ktaOptions ~= nil and S_ktaOptions.minimapButton ~= nil;

	g_ktaOptions =
	{
		default =
		{
			sGods = (bDefaultOptionsIsNotNil and S_ktaOptions.default.gods) or "YSHAARJ",
			sSoundChannel = sDefaultSoundChannel,
			iMinDelay = (bDefaultOptionsIsNotNil and S_ktaOptions.default.minDelay) or 300,
			iMaxDelay = (bDefaultOptionsIsNotNil and S_ktaOptions.default.maxDelay) or 1200,
		},

		bDeactivated = (S_ktaOptions ~= nil and S_ktaOptions.deactivated) or (S_ktaOptions == nil and false),
		bMuteDuringCombat = (S_ktaOptions ~= nil and S_ktaOptions.muteDuringCombat) or (S_ktaOptions == nil and false),
		sSoundChannel = (S_ktaOptions ~= nil and S_ktaOptions.soundChannel) or sDefaultSoundChannel,

		minimapButton =
		{
			hide = (bMinimapOptionIsNotNil and S_ktaOptions.minimapButton.hide) or (bMinimapOptionIsNotNil and false),
		}
	};

	SetGods(GetWords((S_ktaOptions ~= nil and S_ktaOptions.gods) or g_ktaOptions.default.gods), true);
	SetDelay((S_ktaOptions ~= nil and S_ktaOptions.minDelay) or g_ktaOptions.default.iMinDelay, (S_ktaOptions ~= nil and S_ktaOptions.maxDelay) or g_ktaOptions.default.iMaxDelay, true);

	wipe(S_ktaOptions);
	S_ktaOptions = g_ktaOptions;
	S_AddonVersion = nil;
	return true;
end
