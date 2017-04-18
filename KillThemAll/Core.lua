
SLASH_RELOADUI1 = "/rl"
SlashCmdList.RELOADUI = ReloadUI

SLASH_FARMESTK1 = "/fs"
SlashCmdList.FRAMESTK = function()
	LoadAddon("Blizzard_DebugTools")
	FrameStackTooltip_Toggle()
end

---------------------------------

TEXT_COLOR = "FFe899ff";
local KTA_PREFIX = "|c" .. TEXT_COLOR .. "KTA: |r"
function KTA_Print(str)
	print(KTA_PREFIX .. str);
end

g_currentGods = { AllSoundLibraries[1] };

local g_timeSinceLastSound = 0.0;
local g_randomTimeToWait = 0.0;
local g_dead = UnitIsDeadOrGhost("Player");
local g_loading = true;
g_shouldVariablesBeSaved = true;

function PrintDelay()
	KTA_Print("Whispers are set to occur between " .. g_ktaOptions.minDelay .. " to " .. g_ktaOptions.maxDelay .. " seconds of intervales");
end

function GodsToStringTable(godsList, forDisplay)

	local godsNamesList = {};

	for i = 1, #godsList, 1 do
		if forDisplay then
			table.insert(godsNamesList, godsList[i].displayName);
		else
			table.insert(godsNamesList, godsList[i].dataName);
		end
	end

	return godsNamesList;
end

function DisplayCurrentGods()

	if #g_currentGods == 0 then
		print("You feel no presence around you");
		return;
	end

	local str = "You feel the presence of ";
	str = str .. GetPunctuatedString(GodsToStringTable(g_currentGods, true));
	KTA_Print(str);
end

function DisplaySoundChannel()

	KTA_Print("Current sound channel is " .. g_ktaOptions.soundChannel);
end

function DisplayDefaultValues(valuesToDisplay)

	local displayAll = valuesToDisplay == nil or #valuesToDisplay == 0;

	if displayAll or TableContains(valuesToDisplay, "DELAY") then
		KTA_Print("Default delay is set between " .. g_ktaOptions.default.minDelay .. " and " .. g_ktaOptions.default.maxDelay .. " seconds");
	end

	if displayAll or TableContains(valuesToDisplay, "GOD") or TableContains(valuesToDisplay, "GODS") then

		if g_ktaOptions.default.gods == "ALL" then
			KTA_Print("Default gods are " .. GetPunctuatedString(GodsToStringTable(AllSoundLibraries, true)));
		elseif g_ktaOptions.default.gods == "NONE" or g_ktaOptions.default.gods == "" then
			KTA_Print("No default god");
		else
			local godsNamesTable = GetWords(g_ktaOptions.default.gods);
			for i = 1, #godsNamesTable, 1 do
				godsNamesTable[i] = GetGodByName(godsNamesTable[i]).displayName;
			end

			local str = "Default god is ";
			if #godsNamesTable > 1 then
				str = "Default gods are ";
			end

			KTA_Print(str .. GetPunctuatedString(godsNamesTable));
		end
	end
	
	if displayAll or TableContains(valuesToDisplay, "SOUNDCHANNEL") then
	
		KTA_Print("Default sound channel is " .. g_ktaOptions.default.soundChannel);
	end
end

function PrintAvailableGods()

	KTA_Print("Available gods:");
	for i = 1, #AllSoundLibraries, 1 do
		print("     " .. AllSoundLibraries[i].dataName);
	end
	print("     All");
end

function ToggleDeactivated()

	g_ktaOptions.deactivated = not g_ktaOptions.deactivated;
	CallEventListener(g_interfaceEventsListener, "OnToggleDeactivated");
end

function GetGodByName(godName)

	godName = string.upper(godName);

	for i = 1, #AllSoundLibraries, 1 do
		if string.upper(AllSoundLibraries[i].dataName) == godName then
			return AllSoundLibraries[i];
		end
	end

	return nil;
end

function SetGods(godsNames, silent)

	silent = silent or false;


	if TableContains(godsNames, "ALL") then
		g_currentGods = AllSoundLibraries;

		if not silent then
			KTA_Print("You feel the presence of all gods around you");
		end

		CallEventListener(g_interfaceEventsListener, "OnGodsChanged");

		return;
	elseif godsNames == nil or #godsNames == 0 or TableContains(godsNames, "NONE") then
		g_currentGods = {};

		if not silent then
			DisplayCurrentGods();
		end

		CallEventListener(g_interfaceEventsListener, "OnGodsChanged");

		return;
	end


	local newGods = {};

	local defaultCall, defaultIndex = TableContains(godsNames, "DEFAULT");
	if defaultCall then
		table.remove(godsNames, defaultIndex);
		local defaultGods = GetWords(string.upper(g_ktaOptions.default.gods));
		local containsAll = TableContains(defaultGods, "ALL");
		SetGods(defaultGods, silent);

		return;
	end

	for i = 1, #godsNames, 1 do
		local currentGod = GetGodByName(godsNames[i]);

		if currentGod ~= nil and not TableContains(newGods, currentGod.dataName) then
			table.insert(newGods, currentGod);

		elseif currentGod == nil and not silent then
			KTA_Print("Invalid god name: " .. godsNames[i]);
		end
	end

	if #newGods == 0 and not defaultCall then
		if not silent then
			KTA_Print("No valid god name found.");
			PrintAvailableGods();
		end
		return;
	end

	g_currentGods = newGods;

	if not silent then
		DisplayCurrentGods();
	end

	CallEventListener(g_interfaceEventsListener, "OnGodsChanged");

	StartWaiting();
end

function AddGods(godsNames, silent)

	SetGods(TableCat(GodsToStringTable(g_currentGods, false), godsNames), silent);
end

function SetDefaultGods(godsNames, silent)

	silent = silent or false;

	local godsNamesNoDuplicate = {};

	if godsNames == nil then
		godsNames = TableToString(GodsToStringTable(g_currentGods, false));
		g_ktaOptions.default.gods = godsNames;

	else
		if TableContains(godsNames, "ALL") then
			g_ktaOptions.default.gods = "ALL";
		elseif TableContains(godsNames, "NONE") then
			g_ktaOptions.default.gods = "NONE";
		else
			for i = 1, #godsNames, 1 do
				if not TableContains(godsNamesNoDuplicate, godsNames[i]) then

					local godExists, godIndex = GodExists(godsNames[i]);
					if godExists then
						table.insert(godsNamesNoDuplicate, AllSoundLibraries[godIndex].dataName);
					end
				end
			end

			local sanitizedGodsNames = TableToString(godsNamesNoDuplicate);

			if sanitizedGodsNames == nil or sanitizedGodsNames == "" then
				KTA_Print("No valid god name found.");
				PrintAvailableGods();
				return;
			end

			g_ktaOptions.default.gods = sanitizedGodsNames;
		end
	end

	if not silent then

		if g_ktaOptions.default.gods == "" or g_ktaOptions.default.gods == "NONE" then
			KTA_Print("Now there will be no god watching by default. Use \"/kta debug clearMemory\" then \"/reload\" to reset the default values");
		elseif g_ktaOptions.default.gods == "ALL" then
			KTA_Print("Now all gods will be watching you by default. Use \"/kta debug clearMemory\" then \"/reload\" to reset the default values");
		else
			local godsNamesTable = GetWords(g_ktaOptions.default.gods);
			for i = 1, #godsNamesTable, 1 do
				godsNamesTable[i] = GetGodByName(godsNamesTable[i]).displayName;
			end

			local str = "Default god is now ";
			if #godsNamesTable > 1 then
				str = "Default gods are now ";
			end

			str = str .. GetPunctuatedString(godsNamesTable);
			KTA_Print(str .. ". Use \"/kta debug clearMemory\" then \"/reload\" to reset the default values");
		end
	end
end

function RemoveGods(godsNames, silent)

	if TableContains(godsNames, "ALL") then
		g_currentGods = {};
	else
		for i = 1, #godsNames, 1 do

			local godsIsWatching, godIndex = TableContains(g_currentGods, GetGodByName(godsNames[i]));
			if godsIsWatching then
				table.remove(g_currentGods, godIndex);
			end
		end
	end

	if not silent then
		DisplayCurrentGods();
	end

	CallEventListener(g_interfaceEventsListener, "OnGodsChanged");

	StartWaiting();
end

function SetSoundChannel(parSoundChannel, silent, fromInterface)

	g_ktaOptions.soundChannel = TrySetSoundChannel(parSoundChannel, g_ktaOptions.soundChannel);

	if not silent then
		KTA_Print("The soundfiles will now be played on the channel " .. g_ktaOptions.soundChannel);
	end

	if not fromInterface then
		CallEventListener(g_interfaceEventsListener, "OnSoundChannelChanged");
	end
end

function SetDefaultSoundChannel(parSoundChannel)

	g_ktaOptions.default.soundChannel = TrySetSoundChannel(parSoundChannel, g_ktaOptions.default.soundChannel);
	KTA_Print("Default sound channel is now " .. g_ktaOptions.default.soundChannel);
end

function SetDelay(minDelayStr, maxDelayStr, silent)

	silent = silent or false;

	local minValue = tonumber(minDelayStr);
	local maxValue = tonumber(maxDelayStr);

	if minDelayStr == "DEFAULT" or (minDelayStr == "0" and (maxDelayStr == "" or maxDelayStr == nil)) then
		minValue = g_ktaOptions.default.minDelay;
		maxValue = g_ktaOptions.default.maxDelay;
	end

	if minValue == nil or maxValue == nil then
		KTA_Print("Invalid use of SetDelay command:");
		PrintHelp("SETDELAY", nil, "noToolTip");
		return false;
	elseif minValue < 0 then
		PrintInvalidParameters("Delay values cannot be negative");
		return false;
	elseif minValue >= maxValue then
		PrintInvalidParameters("Max delay must be bigger than min delay");
		return false;
	end

	g_ktaOptions.minDelay = minValue;
	g_ktaOptions.maxDelay = maxValue;

	if not silent then
		KTA_Print("Delay set between " .. minValue .. " and " .. maxValue .. " seconds");
	end

	StartWaiting();
	CallEventListener(g_interfaceEventsListener, "OnDelayChanged");

	return true;
end

function SetDefaultDelay(minDelayStr, maxDelayStr)

	local minValue = tonumber(minDelayStr);
	local maxValue = tonumber(maxDelayStr);

	if minValue == nil or maxValue == nil then
		KTA_Print("Wrong use of setDefault delay command:");
		PrintHelp("SETDEFAULT", { "DELAY" }, "noToolTip");
		return;
	elseif minValue < 0 then
		PrintInvalidParameters("Delay values cannot be negative");
		return;
	elseif minValue >= maxValue then
		PrintInvalidParameters("Max delay must be bigger than min delay");
		return;
	end

	g_ktaOptions.default.minDelay = minValue;
	g_ktaOptions.default.maxDelay = maxValue;

	KTA_Print("Default delay set between " .. minDelayStr .. " and " .. maxDelayStr .. " seconds. Use \"/kta debug clearMemory\" then \"/reload\" to reset the default values");
end

function ResetValues()

	SetDelay(g_ktaOptions.default.minDelay, g_ktaOptions.default.maxDelay);
	SetGods(GetWords(g_ktaOptions.default.gods));
	g_ktaOptions.soundChannel = g_ktaOptions.default.soundChannel;
end

function ClearMemory()

	S_ktaOptions = nil;
	KTA_Print("All saved variables have been erased");
end


local eventsListener = CreateFrame("Frame");
local events = {};

function StartWaiting()

	if g_loading then
		return;
	end

	g_randomTimeToWait = math.random(g_ktaOptions.minDelay, g_ktaOptions.maxDelay);
	g_timeSinceLastSound = 0.0;
end

function PlayRandomSound(soundType)

	if g_loading or g_ktaOptions.deactivated then
		return;
	end

	rand = math.random(1, #g_currentGods);
	g_currentGods[rand]:PlayRandomSound(soundType, g_ktaOptions.soundChannel);
end


function AliveFunc()

	g_dead = UnitIsDeadOrGhost("Player");

	if g_randomTimeToWait == 0.0 then
		StartWaiting();
	end

end

function events:PLAYER_ALIVE(...)

	AliveFunc();

end

function events:PLAYER_ENTERING_WORLD(...)

	AliveFunc();

end

function events:PLAYER_UNGHOST(...)

	AliveFunc();

end

function events:PLAYER_DEAD(...)

	g_dead = true;

	if g_loading or #g_currentGods == 0 then
		return;
	end

	PlayRandomSound("OnDeath");

end

function events:ADDON_LOADED(arg)

	if arg ~= "KillThemAll" then
		return;
	end

	LoadOptions();
	InitSettingsFrames();
	g_loading = false;
end

function events:PLAYER_LOGOUT(...)

	if not g_shouldVariablesBeSaved then
		return;
	end

	S_ktaOptions = g_ktaOptions;
	S_ktaOptions.gods = TableToString(GodsToStringTable(g_currentGods, false)) or "NONE";
end

eventsListener:SetScript("OnEvent", function(self, event, ...)
										events[event](self, ...);
									end);

for k, v in pairs(events) do
	eventsListener:RegisterEvent(k);
end


local function MyUpdate(self, elapsed)

	if g_dead or #g_currentGods == 0 or g_ktaOptions.deactivated or (g_ktaOptions.muteDuringCombat and InCombatLockdown()) then
		return;
	end

	g_timeSinceLastSound = g_timeSinceLastSound + elapsed;

	if g_timeSinceLastSound >= g_randomTimeToWait then
		PlayRandomSound("General");
		StartWaiting();
	end
end

local updater = CreateFrame("Frame");
updater:SetScript("OnUpdate", MyUpdate);
