
g_ktaOptions = {};

local PreviousVersionRecovered = nil;

function LoadOptions()

	if PreviousVersionRecovered() then
		return;
	end

	local defaultSoundChannel = (S_ktaOptions ~= nil and S_ktaOptions.default ~= nil and S_ktaOptions.default.soundChannel) or "Dialog";

	g_ktaOptions =
	{
		default =
		{
			gods = (S_ktaOptions ~= nil and S_ktaOptions.default ~= nil and S_ktaOptions.default.gods) or "YSHAARJ",
			soundChannel = defaultSoundChannel,
			minDelay = (S_ktaOptions ~= nil and S_ktaOptions.default ~= nil and S_ktaOptions.default.minDelay) or 300,
			maxDelay = (S_ktaOptions ~= nil and S_ktaOptions.default ~= nil and S_ktaOptions.default.maxDelay) or 1200,
		},

		deactivated = (S_ktaOptions ~= nil and S_ktaOptions.deactivated) or (S_ktaOptions == nil and false),
		muteDuringCombat = (S_ktaOptions ~= nil and S_ktaOptions.muteDuringCombat) or (S_ktaOptions == nil and false),
		soundChannel = (S_ktaOptions ~= nil and S_ktaOptions.soundChannel) or defaultSoundChannel,
	}

	SetGods(GetWords((S_ktaOptions ~= nil and S_ktaOptions.gods) or g_ktaOptions.default.gods), true);
	SetDelay((S_ktaOptions ~= nil and S_ktaOptions.minDelay) or g_ktaOptions.default.minDelay, (S_ktaOptions ~= nil and S_ktaOptions.maxDelay) or g_ktaOptions.default.maxDelay, true);
end

PreviousVersionRecovered = function()

	-- Previous versions recovery here

	S_AddonVersion = GetAddOnMetadata("KillThemAll", "Version");
	return false;
end
