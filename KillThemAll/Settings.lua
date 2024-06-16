
Cerberus_HookThisFile();

g_ktaCurrentCharSettingsOverrides = nil;
g_ktaCurrentSettings = {};
--[[
g_ktaCurrentSettings =
{
	m_default =
	{
		string m_sGods,
		string m_sSoundChannel,
		int m_iMinDelay,
		int m_iMaxDelay,
	},

	string m_sGods,
	string m_sSoundChannel,
	int m_iMinDelay,
	int m_iMaxDelay,

	bool m_bDeactivated,
	bool m_bMuteDuringCombat,
	string m_sSoundChannel,

	m_minimapButton =
	{
		bool hide,
		vec2 minimapPos,
	},
}
]]

local l_ktaDefaultSettings =
{
	m_default =
	{
		m_sGods = g_allSoundLibraries[1].m_sDataName,
		m_sSoundChannel = "Dialog",
		m_iMinDelay = 300,
		m_iMaxDelay = 1200,
	},

	m_sGods = g_allSoundLibraries[1].m_sDataName,
	m_sSoundChannel = "Dialog",
	m_iMinDelay = 300,
	m_iMaxDelay = 1200,

	m_bDeactivated = false,
	m_bMuteDuringCombat = false,

	m_minimapButton =
	{
		hide = false,
		minimapPos = nil,
	},
}


function SaveSettings()

	if g_ktaCurrentCharSettingsOverrides ~= nil and g_ktaCurrentCharSettingsOverrides.m_sGods ~= nil then
		g_ktaCurrentCharSettingsOverrides.m_sGods = TableToString(GodsToStringTable(g_currentGods, false)) or "NONE";
	end

	S_ktaCharSpecificOverrides[g_sCharacterNameAndRealm] = g_ktaCurrentCharSettingsOverrides;
	S_ktaGlobalSettings.m_minimapButton = g_ktaCurrentSettings.m_minimapButton;
end

function SaveCurrentProfileAsGlobal()

	if g_ktaCurrentCharSettingsOverrides == nil then
		return;
	end

	local variablesToSave = {};
	for sKey, _ in pairs(g_ktaCurrentCharSettingsOverrides) do
		table.insert(variablesToSave, sKey);
	end

	for i = 1, #variablesToSave, 1 do
		SaveVariableAsGlobal(variablesToSave[i]);
	end
end

function RevertAllSettingsToGlobals()

	if g_ktaCurrentCharSettingsOverrides == nil then
		return;
	end

	local variablesToRevert = {};
	for sKey, _ in pairs(g_ktaCurrentCharSettingsOverrides) do
		table.insert(variablesToRevert, sKey);
	end

	for i = 1, #variablesToRevert, 1 do
		RemoveVariableOverride(variablesToRevert[i]);
	end
end

local function SetOverrideValue(sVariableName, value)

	local hardValue = value;
	if sVariableName == "m_sGods" then
		hardValue = TableToString(hardValue) or "NONE";	-- I hate this but i can't be bothered
	end

	if (g_ktaCurrentCharSettingsOverrides == nil or g_ktaCurrentCharSettingsOverrides[sVariableName] == nil) and g_ktaCurrentSettings[sVariableName] == hardValue then
		return;		-- This happens on load, when we're setting the gods and delay for the first time
	end

	g_ktaCurrentCharSettingsOverrides = g_ktaCurrentCharSettingsOverrides or {};

	g_ktaCurrentCharSettingsOverrides[sVariableName] = hardValue;
	g_ktaCurrentSettings[sVariableName] = hardValue;

	CallEventListener(g_interfaceEventsListener, "OnVariableOverrideStateChanged", sVariableName);

	if sVariableName == "m_sGods" then
		SetGods(value, true);
	elseif sVariableName ==  "m_iMinDelay" or sVariableName ==  "m_iMaxDelay" then
		SetDelay(g_ktaCurrentSettings.m_iMinDelay, g_ktaCurrentSettings.m_iMaxDelay, true);
	elseif sVariableName == "m_sSoundChannel" then
		SetSoundChannel(g_ktaCurrentSettings.m_sSoundChannel, true, false);
	elseif sVariableName ==  "m_bDeactivated" then
		CallEventListener(g_interfaceEventsListener, "OnToggleDeactivated");
	elseif sVariableName ==  "m_bMuteDuringCombat" then
		CallEventListener(g_interfaceEventsListener, "OnToggleMuteDuringCombat");
	end
end

function SetOverrideDefaultValue(sVariableName, value)

	g_ktaCurrentCharSettingsOverrides = g_ktaCurrentCharSettingsOverrides or {};
	g_ktaCurrentCharSettingsOverrides.m_default = g_ktaCurrentCharSettingsOverrides.m_default or {};

	g_ktaCurrentCharSettingsOverrides.m_default[sVariableName] = value;
	g_ktaCurrentSettings.m_default[sVariableName] = value;
end

function SaveVariableAsGlobal(sVariableName)

	if g_ktaCurrentCharSettingsOverrides == nil then
		return;
	end

	S_ktaGlobalSettings[sVariableName] = g_ktaCurrentCharSettingsOverrides[sVariableName];
	g_ktaCurrentSettings[sVariableName] = g_ktaCurrentCharSettingsOverrides[sVariableName];
	g_ktaCurrentCharSettingsOverrides[sVariableName] = nil;

	if table.Len(g_ktaCurrentCharSettingsOverrides) == 0 then
		g_ktaCurrentCharSettingsOverrides = nil;
	end

	CallEventListener(g_interfaceEventsListener, "OnVariableOverrideStateChanged", sVariableName);
end

function SaveDefaultVariableAsGlobal(sVariableName)

	if g_ktaCurrentCharSettingsOverrides == nil or g_ktaCurrentCharSettingsOverrides.m_default == nil then
		return;
	end

	S_ktaGlobalSettings.m_default[sVariableName] = g_ktaCurrentCharSettingsOverrides[sVariableName];
	g_ktaCurrentSettings.m_default[sVariableName] = g_ktaCurrentCharSettingsOverrides.m_default[sVariableName];
	g_ktaCurrentCharSettingsOverrides.m_default[sVariableName] = nil;

	if table.Len(g_ktaCurrentCharSettingsOverrides.m_default) == 0 then

		g_ktaCurrentCharSettingsOverrides.m_default = nil;

		if table.Len(g_ktaCurrentCharSettingsOverrides) == 0 then
			g_ktaCurrentCharSettingsOverrides = nil;
		end
	end

	g_ktaCurrentCharSettingsOverrides = g_ktaCurrentCharSettingsOverrides or {};
	g_ktaCurrentCharSettingsOverrides.m_default = g_ktaCurrentCharSettingsOverrides.m_default or {};

	g_ktaCurrentCharSettingsOverrides.m_default[sVariableName] = value;
	g_ktaCurrentSettings.m_default[sVariableName] = value;
end

function RemoveVariableOverride(sVariableName)

	if g_ktaCurrentCharSettingsOverrides == nil or g_ktaCurrentCharSettingsOverrides[sVariableName] == nil then
		return;
	end

	g_ktaCurrentCharSettingsOverrides[sVariableName] = nil;
	g_ktaCurrentSettings[sVariableName] = S_ktaGlobalSettings[sVariableName];

	if table.Len(g_ktaCurrentCharSettingsOverrides) == 0 then
		g_ktaCurrentCharSettingsOverrides = nil;
	end

	CallEventListener(g_interfaceEventsListener, "OnVariableOverrideStateChanged", sVariableName);

	if sVariableName == "m_sGods" then
		SetGods(GetWords(g_ktaCurrentSettings.m_sGods), true);
	elseif sVariableName ==  "m_iMinDelay" or sVariableName ==  "m_iMaxDelay" then
		SetDelay(g_ktaCurrentSettings.m_iMinDelay, g_ktaCurrentSettings.m_iMaxDelay, true);
	elseif sVariableName == "m_sSoundChannel" then
		SetSoundChannel(g_ktaCurrentSettings.m_sSoundChannel, true, false);
	elseif sVariableName ==  "m_bDeactivated" then
		CallEventListener(g_interfaceEventsListener, "OnToggleDeactivated");
	elseif sVariableName ==  "m_bMuteDuringCombat" then
		CallEventListener(g_interfaceEventsListener, "OnToggleMuteDuringCombat");
	end
end

function RemoveDefaultVariableOverride(sVariableName)

	if g_ktaCurrentCharSettingsOverrides == nil or g_ktaCurrentCharSettingsOverrides.m_default == nil then
		return;
	end

	g_ktaCurrentCharSettingsOverrides.m_default[sVariableName] = nil;
	g_ktaCurrentSettings.m_default[sVariableName] = S_ktaGlobalSettings.m_default[sVariableName];

	if table.Len(g_ktaCurrentCharSettingsOverrides.m_default) == 0 then

		g_ktaCurrentCharSettingsOverrides.m_default = nil;

		if table.Len(g_ktaCurrentCharSettingsOverrides) == 0 then
			g_ktaCurrentCharSettingsOverrides = nil;
		end
	end
end

function UpdateValue(sVariableName, value)

	local hardValue = value;
	if sVariableName == "m_sGods" then
		hardValue = TableToString(hardValue) or "NONE";	-- I hate this but i can't be bothered
	end

	if hardValue ~= S_ktaGlobalSettings[sVariableName] then
		SetOverrideValue(sVariableName, value);
	else
		RemoveVariableOverride(sVariableName, value);
	end
end

function ClearMemory()

	if S_ktaGlobalSettings ~= nil then
		wipe(S_ktaGlobalSettings);
		S_ktaGlobalSettings = nil;
	end

	if S_ktaCharSpecificOverrides ~= nil then
		wipe(S_ktaCharSpecificOverrides);
		S_ktaCharSpecificOverrides = nil;
	end

	S_sAddonVersion = nil;

	KTA_Print("All saved settings have been erased.");
end


local TryRecoverPreviousVersion = nil; --[[function()]]
local GetCombinedGlobalSettingsWithCharOverrides = nil; --[[function()]]


function LoadSettings()

	TryRecoverPreviousVersion();
	S_ktaCharSpecificOverrides = S_ktaCharSpecificOverrides or {};

	local settings = GetCombinedGlobalSettingsWithCharOverrides();
	g_ktaCurrentSettings = settings;

	SetGods(GetWords(settings.m_sGods), true, true);
	SetDelay(settings.m_iMinDelay, settings.m_iMaxDelay, true);
end


local RecoverFromVersion1_3 = nil; --[[function()]]
local RecoverFromEarlierVersion = nil; --[[function()]]


--[[local]] TryRecoverPreviousVersion = function()

	local sCurrentAddonVersion = GetAddOnMetadata("KillThemAll", "Version");
	local sCurrentlySavedAddonVersion = S_sAddonVersion or S_AddonVersion;
	S_sAddonVersion = sCurrentAddonVersion;

	sCurrentAddonVersion = string.match(sCurrentAddonVersion, "%d+%.%d+");	-- Transforms (for example) "1.12.4" into "1.12"
	if sCurrentlySavedAddonVersion ~= nil then
		sCurrentlySavedAddonVersion = string.match(sCurrentlySavedAddonVersion, "%d+%.%d+");
	end

	if sCurrentlySavedAddonVersion == nil or sCurrentlySavedAddonVersion == sCurrentAddonVersion then
		S_ktaGlobalSettings = S_ktaGlobalSettings or table.Clone(l_ktaDefaultSettings);
		return;
	end


	if sCurrentlySavedAddonVersion == "1.3" then
		RecoverFromVersion1_3();
	elseif sCurrentlySavedAddonVersion == "1.2" or sCurrentlySavedAddonVersion == "1.1" or sCurrentlySavedAddonVersion == "1.0" then
		RecoverFromEarlierVersion();
	else
		S_ktaGlobalSettings = S_ktaGlobalSettings or table.Clone(l_ktaDefaultSettings);
	end

	S_AddonVersion = nil;
end

--[[local]] RecoverFromVersion1_3 = function()

	local settings = table.Clone(l_ktaDefaultSettings);

	if S_ktaOptions ~= nil then

		if S_ktaOptions.default ~= nil then

			settings.m_default =
			{
				m_sGods = S_ktaOptions.default.sGods or settings.default.m_sGods,
				m_sSoundChannel = S_ktaOptions.default.sSoundChannel or settings.default.m_sSoundChannel,
				m_iMinDelay = S_ktaOptions.default.iMinDelay or settings.default.m_iMinDelay,
				m_iMaxDelay = S_ktaOptions.default.iMaxDelay or settings.default.m_iMaxDelay,
			};
		end

		if S_ktaOptions.minimapButton ~= nil then

			settings.m_minimapButton =
			{
				hide = (S_ktaOptions.minimapButton.hide ~= nil and S_ktaOptions.minimapButton.hide) or (S_ktaOptions.minimapButton.hide == nil and settings.m_minimapButton.hide),
				minimapPos = S_ktaOptions.minimapButton.minimapPos or settings.m_minimapButton.minimapPos,
			};
		end

		settings =
		{
			m_default = settings.default,

			m_sGods = S_ktaOptions.sGods or settings.m_sGods,
			m_sSoundChannel = S_ktaOptions.sSoundChannel or settings.m_sSoundChannel,
			m_iMinDelay = S_ktaOptions.iMinDelay or settings.m_iMinDelay,
			m_iMaxDelay = S_ktaOptions.iMaxDelay or settings.m_iMaxDelay,

			m_bDeactivated = (S_ktaOptions.bDeactivated ~= nil and S_ktaOptions.bDeactivated) or (S_ktaOptions.bDeactivated == nil and settings.m_bDeactivated),
			m_bMuteDuringCombat = (S_ktaOptions.bMuteDuringCombat ~= nil and S_ktaOptions.bMuteDuringCombat) or (S_ktaOptions.bMuteDuringCombat == nil and settings.m_bMuteDuringCombat),

			m_minimapButton = settings.m_minimapButton,
		};

		wipe(S_ktaOptions);
		S_ktaOptions = nil;
	end

	S_ktaGlobalSettings = settings;
end

--[[local]] RecoverFromEarlierVersion = function()

	local settings = table.Clone(l_ktaDefaultSettings);

	if S_ktaOptions ~= nil then

		if S_ktaOptions.default ~= nil then

			settings.m_default =
			{
				m_sGods = S_ktaOptions.default.gods or settings.default.m_sGods,
				m_sSoundChannel = S_ktaOptions.default.soundChannel or settings.default.m_sSoundChannel,
				m_iMinDelay = S_ktaOptions.default.minDelay or settings.default.m_iMinDelay,
				m_iMaxDelay = S_ktaOptions.default.maxDelay or settings.default.m_iMaxDelay,
			};
		end

		if S_ktaOptions.minimapButton ~= nil then

			settings.m_minimapButton =
			{
				hide = (S_ktaOptions.minimapButton.hide ~= nil and S_ktaOptions.minimapButton.hide) or (S_ktaOptions.minimapButton.hide == nil and settings.m_minimapButton.hide),
				minimapPos = S_ktaOptions.minimapButton.minimapPos or settings.m_minimapButton.minimapPos,
			};
		end

		settings =
		{
			m_default = settings.m_default,

			m_sGods = S_ktaOptions.gods or settings.m_sGods,
			m_sSoundChannel = S_ktaOptions.soundChannel or settings.m_sSoundChannel,
			m_iMinDelay = S_ktaOptions.minDelay or settings.m_iMinDelay,
			m_iMaxDelay = S_ktaOptions.maxDelay or settings.m_iMaxDelay,

			m_bDeactivated = (S_ktaOptions.deactivated ~= nil and S_ktaOptions.deactivated) or (S_ktaOptions.deactivated == nil and settings.m_bDeactivated),
			m_bMuteDuringCombat = (S_ktaOptions.muteDuringCombat ~= nil and S_ktaOptions.muteDuringCombat) or (S_ktaOptions.muteDuringCombat == nil and settings.m_bMuteDuringCombat),

			m_minimapButton = settings.m_minimapButton,
		};

		wipe(S_ktaOptions);
		S_ktaOptions = nil;
	end

	S_ktaGlobalSettings = settings;
end

--[[local]] GetCombinedGlobalSettingsWithCharOverrides = function()

	local settings = table.Clone(S_ktaGlobalSettings);
	local charOverrides = (S_ktaCharSpecificOverrides ~= nil and S_ktaCharSpecificOverrides[g_sCharacterNameAndRealm]) or nil;

	if charOverrides ~= nil then

		if charOverrides.m_default ~= nil then

			settings.m_default =
			{
				m_sGods = charOverrides.m_default.m_sGods or settings.m_default.m_sGods,
				m_sSoundChannel = charOverrides.m_default.m_sSoundChannel or settings.m_default.m_sSoundChannel,
				m_iMinDelay = charOverrides.m_default.m_iMinDelay or settings.m_default.m_iMinDelay,
				m_iMaxDelay = charOverrides.m_default.m_iMaxDelay or settings.m_default.m_iMaxDelay,
			};
		end

		settings =
		{
			m_default = settings.m_default,

			m_sGods = charOverrides.m_sGods or settings.m_sGods,
			m_sSoundChannel = charOverrides.m_sSoundChannel or settings.m_sSoundChannel,
			m_iMinDelay = charOverrides.m_iMinDelay or settings.m_iMinDelay,
			m_iMaxDelay = charOverrides.m_iMaxDelay or settings.m_iMaxDelay,

			m_bDeactivated = (charOverrides.m_bDeactivated ~= nil and charOverrides.m_bDeactivated) or (charOverrides.m_bDeactivated == nil and settings.m_bDeactivated),
			m_bMuteDuringCombat = (charOverrides.m_bMuteDuringCombat ~= nil and charOverrides.m_bMuteDuringCombat) or (charOverrides.m_bMuteDuringCombat == nil and settings.m_bMuteDuringCombat),

			m_minimapButton = settings.m_minimapButton,
		};

		g_ktaCurrentCharSettingsOverrides = table.Clone(charOverrides);
	end

	return settings;
end
