
g_ktaOptions = {};

function LoadOptions()

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
