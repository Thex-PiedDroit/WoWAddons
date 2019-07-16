
Cerberus_HookThisFile();

local l_sGodsSeparatedStringList = nil;
local function GetGodsSeparatedStringList()

	if l_sGodsSeparatedStringList == nil then
		l_sGodsSeparatedStringList = "";

		for i = 1, #g_allSoundLibraries, 1 do
			l_sGodsSeparatedStringList = l_sGodsSeparatedStringList .. "[" .. g_allSoundLibraries[i].m_sDataName .. "]";
		end
	end

	return l_sGodsSeparatedStringList;
end

g_allCommands =
{
	["SETDELAY"] =
	{
		sTooltip = "Will change the timespan between two whispers. Giving \"default\" or 0 as only parameter will reset to default values.\nExample: \"/kta SetDelay 300 600\"",
		sCommandSignature = "/kta SetDelay [<min:seconds> <max:seconds>] | [default|0]",
		m_Func = function(delayMinMax)
			SetDelay(delayMinMax[1], delayMinMax[2]);
		end,
	},

	["SETGODS"] =
	{
		sTooltip = "Will change the god(s) who whisper(s) to you. Multiple gods can be set at the same time by naming them one by one. Giving \"default\" will reset to default value. This won't affect whispers frequency.\nExample: \"/kta SetGods Cthun YoggSaron\"",
		sCommandSignature = "/kta SetGods [<GodNames:" .. GetGodsSeparatedStringList() .. ">] | [All] | [None] | [Default]",
		m_Func = function(godsToSet)
			SetGods(godsToSet);
		end,
	},

	["ADDGODS"] =
	{
		sTooltip = "Will add god(s) to the currently whispering gods. This won't affect whispers frequency.\nExample: \"/kta AddGods Cthun YoggSaron\"",
		sCommandSignature = "/kta AddGods [<GodName: " .. GetGodsSeparatedStringList() .. ">] | [All]",
		m_Func = function(godsToAdd)
			AddGods(godsToAdd);
		end,
	},

	["REMOVEGODS"] =
	{
		sTooltip = "Will remove god(s) from the currently whispering gods. If all removed, no god will whisper until new ones are added. This won't affect whispers frequency.\nExample: \"/kta RemoveGods Cthun YoggSaron\"",
		sCommandSignature = "/kta RemoveGods [<GodName:" .. GetGodsSeparatedStringList() .. ">] | [All]",
		m_Func = function(godsToRemove)
			RemoveGods(godsToRemove);
		end,
	},

	["SETSOUNDCHANNEL"] =
	{
		sTooltip = "Will change the sound channel the soundfiles will be played on.\nExample: \"/kta SetSoundChannel Dialog\"",
		sCommandSignature = "/kta SetSoundChannel <SoundChannel: [Master]|[Sound]|[Music]|[Ambience]|[Dialog]|[Default]>",
		m_Func = function(sSoundChannel)
			SetSoundChannel(sSoundChannel);
		end,
	},

	["SETDEFAULT"] =
	{
		sTooltip = "Will change the default values to set when using the \"/kta reset\" or \"/kta [setGods]|[setDelay]|[setSoundChannel] default\" commands. Using \"/kta debug clearMemory\" will revert to initial values as on clear addon install.",
		sCommandSignature = "/kta SetDefault [Delay] | [Gods] | [SoundChannel]",
		m_Func = function()
			KTA_Print("Invalid use of SetDefault command:");
			PrintCommandTooltip(g_allCommands["SETDEFAULT"], true);
		end,

		["GODS"] =
		{
			sTooltip = "Will change the default gods to set when using the \"/kta reset\" or \"/kta setGods default\" commands. Using \"/kta debug clearMemory\" will revert to initial values as on clear addon install.\nExample: \"/kta SetDefault Gods Cthun YoggSaron\"",
			sCommandSignature = "/kta SetDefault Gods [<GodName: " .. GetGodsSeparatedStringList() .. ">] | [All] | [None]",
			m_Func = function(godsToSetAsDefault)
				MakeGodsDefault(godsToSetAsDefault);
			end,
		},
		["DELAY"] =
		{
			sTooltip = "Will change the default delay to set when using the \"/kta reset\" or \"/kta setDelay default\" commands. Using \"/kta debug clearMemory\" will revert to initial values as on clear addon install.\nExample: \"/kta SetDefault Delay 300 600\"",
			sCommandSignature = "/kta SetDefault Delay [<min:seconds> <max:seconds>]",
			m_Func = function(delayMinMaxToSetAsDefault)
				SetDefaultDelay(delayMinMaxToSetAsDefault[1], delayMinMaxToSetAsDefault[2]);
			end,
		},
		["SOUNDCHANNEL"] =
		{
			sTooltip = "Will change the default sound channel to set when using the \"/kta reset\" or \"/kta SetSoundChannel default\" commands. Using \"/kta debug clearMemory\" will revert to initial values as on clear addon install.\nExample: \"/kta SetDefault SoundChannel Dialog\"",
			sCommandSignature = "/kta SetDefault SoundChannel <SoundChannel: [Master]|[Sound]|[Music]|[Ambience]|[Dialog]|[Default]>",
			m_Func = function(sSoundChannelToSetAsDefault)
				SetDefaultSoundChannel(sSoundChannelToSetAsDefault);
			end,
		},
	},

	["RESET"] =
	{
		sTooltip = "Will reset all gods and values to default ones. You can change the default values and gods by using the \"/kta SetDefault\" command.",
		sCommandSignature = "/kta Reset",
		m_Func = function()
			ResetValues();
		end,
	},

	["DISPLAY"] =
	{
		sTooltip = "Will display current parameters. If no parameter name is provided, all parameters will be listed. Example: \"/kta display default Gods Delay\"",
		sCommandSignature = "/kta Display (default) [Delay] | [Gods] | [SoundChannel]",
		m_Func = function()
			DisplayDelay();
			DisplayCurrentGods();
			DisplaySoundChannel();
		end,

		["DEFAULT"] =
		{
			sTooltip = "Will display the current default values to set when using the \"/kta reset\" or \"/kta [setGods]|[setDelay]|[setSoundChannel] default\" commands.",
			sCommandSignature = "/kta Display default [Delay] | [Gods] | [SoundChannel]",
			m_Func = function(valuesToDisplay)
				DisplayDefaultValues(valuesToDisplay);
			end,

			["GODS"] =
			{
				sTooltip = "Will display the current default god(s) to set when using the \"/kta reset\" or \"/kta setGods default\" commands.",
				sCommandSignature = "/kta Display default gods",
			},
			["DELAY"] =
			{
				sTooltip = "Will display the current default delay to set when using the \"/kta reset\" or \"/kta setDelay default\" commands.",
				sCommandSignature = "/kta Display default delay",
			},
			["SOUNDCHANNEL"] =
			{
				sTooltip = "Will display the default sound channel to set when using the \"/kta reset\" or \"/kta setSoundChannel default\" commands.",
				sCommandSignature = "/kta Display Default soundChannel",
			},
		},
		["GODS"] =
		{
			sTooltip = "Will display which gods are currently able to whisper to you.",
			sCommandSignature = "/kta Display gods",
			m_Func = function()
				DisplayCurrentGods();
			end,
		},
		["DELAY"] =
		{
			sTooltip = "Will display the timespan between which whispers might happen.",
			sCommandSignature = "/kta Display delay",
			m_Func = function()
				DisplayDelay();
			end,
		},
		["SOUNDCHANNEL"] =
		{
			sTooltip = "Will display the current sound channel the soundfiles will be played on.",
			sCommandSignature = "/kta Display soundChannel",
			m_Func = function()
				DisplaySoundChannel();
			end,
		},
	},

	["SETTINGS"] =
	{
		sTooltip = "Opens up the settings panel.",
		sCommandSignature = "/kta Settings",
		m_Func = function()
			OpenSettingsPanel();
		end,
	},

	["DEBUG"] =
	{
		sTooltip = "Several functions used for debugging purpose. In theory, you shouldn't need them.",
		sCommandSignature = "/kta Debug [ClearMemory] | [NoSave] | [Save]",
		m_Func = function()
			KTA_Print("Invalid use of Debug command:");
			PrintCommandTooltip(g_allCommands["DEBUG"], true);
		end,

		["CLEARMEMORY"] =
		{
			sTooltip = "Will erase all saved variables. This includes default variables values. They will be saved again when you log out. If you wish to clean your data as on fresh install, use the \"/kta Debug noSave\" command as well.",
			sCommandSignature = "/kta Debug ClearMemory",
			m_Func = function()
				ClearMemory();
			end,
		},
		["NOSAVE"] =
		{
			sTooltip = "Will prevent the addon from saving variables at the end of this session (default values are not affected).",
			sCommandSignature = "/kta Debug NoSave",
			m_Func = function()
				g_bShouldVariablesBeSaved = false;
				KTA_Print("Variables will not be saved on logout (once). This can be reverted with the \"/kta debug save\" command");
			end,
		},
		["SAVE"] =
		{
			sTooltip = "Will make the game save variables at the end of this session. This is only useful if you used the \"/kta Debug noSave\" command this session.",
			sCommandSignature = "/kta Debug Save",
			m_Func = function()
				g_bShouldVariablesBeSaved = true;
				KTA_Print("Variables will be saved on logout");
			end,
		},
	},
};

local l_aliases = setmetatable(
{
	["ADDGOD"] = g_allCommands["ADDGODS"],
	["ADD"] = g_allCommands["ADDGODS"],

	["SETGOD"] = g_allCommands["SETGODS"],

	["REMOVEGOD"] = g_allCommands["REMOVEGODS"],
	["REMOVE"] = g_allCommands["REMOVEGODS"],

	["SETCHANNEL"] = g_allCommands["SETSOUNDCHANNEL"],

	["OPTIONS"] = g_allCommands["SETTINGS"],

	["DBG"] = g_allCommands["DEBUG"],
}, { __index = function() return nil end });
setmetatable(g_allCommands, { __index = l_aliases });

local setDefaultAliases = setmetatable(
{
	["GOD"] = g_allCommands["SETDEFAULT"]["GODS"],
	["CHANNEL"] = g_allCommands["SETDEFAULT"]["SOUNDCHANNEL"],
}, { __index = function() return nil end });
setmetatable(g_allCommands["SETDEFAULT"], { __index = setDefaultAliases });

local displayAliases = setmetatable(
{
	["GOD"] = g_allCommands["DISPLAY"]["GODS"],
	["CHANNEL"] = g_allCommands["DISPLAY"]["SOUNDCHANNEL"],
}, { __index = function() return nil end });
setmetatable(g_allCommands["DISPLAY"], { __index = displayAliases });

local displayDefaultAliases = setmetatable(
{
	["GOD"] = g_allCommands["DISPLAY"]["DEFAULT"]["GODS"],
	["CHANNEL"] = g_allCommands["DISPLAY"]["DEFAULT"]["SOUNDCHANNEL"],
}, { __index = function() return nil end });
setmetatable(g_allCommands["DISPLAY"]["DEFAULT"], { __index = displayDefaultAliases });

local debugAliases = setmetatable(
{
	["CLEARMRY"] = g_allCommands["DEBUG"]["CLEARMEMORY"],
	["DONTSAVE"] = g_allCommands["DEBUG"]["NOSAVE"],
}, { __index = function() return nil end });
setmetatable(g_allCommands["DEBUG"], { __index = debugAliases });
