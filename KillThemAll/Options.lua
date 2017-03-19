
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

		soundChannel = (S_ktaOptions ~= nil and S_ktaOptions.soundChannel) or defaultSoundChannel,
	}

	SetGods(GetWords((S_ktaOptions ~= nil and S_ktaOptions.gods) or g_ktaOptions.default.gods), true);
	SetDelay((S_ktaOptions ~= nil and S_ktaOptions.minDelay) or g_ktaOptions.default.minDelay, (S_ktaOptions ~= nil and S_ktaOptions.maxDelay) or g_ktaOptions.default.maxDelay, true);
end

PreviousVersionRecovered = function()

	local currentAddonVersion = GetAddOnMetadata("KillThemAll", "Version");

	if S_AddonVersion == nil then
		local defaultSoundChannel = "Dialog";

		g_ktaOptions =
		{
			default =
			{
				gods = DefaultGods or "YSHAARJ",
				soundChannel = defaultSoundChannel,
				minDelay = DefaultMinDelay or 300,
				maxDelay = DefaultMaxDelay or 1200,
			},

			soundChannel = SavedSoundChannel or defaultSoundChannel,
		}

		SetGods(GetWords(SavedGods or g_ktaOptions.default.gods), true);
		SetDelay(SavedMinDelay or g_ktaOptions.default.minDelay, SavedMaxDelay or g_ktaOptions.default.maxDelay, true);

		return true;
	end

	S_AddonVersion = currentAddonVersion;
	return false;
end
