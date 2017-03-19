
SLASH_RELOADUI1 = "/rl"
SlashCmdList.RELOADUI = ReloadUI

SLASH_FARMESTK1 = "/fs"
SlashCmdList.FRAMESTK = function()
	LoadAddon("Blizzard_DebugTools")
	FrameStackTooltip_Toggle()
end

---------------------------------

TEXT_COLOR = "FFe899ff";
KTA_PREFIX = "|c" .. TEXT_COLOR .. "KTA: |r"
function KTA_Print(str)
	print(KTA_PREFIX .. str);
end


currentGods = { AllSoundLibraries[1] };

minDelay = 300.0;
maxDelay = 1200.0;
soundChannel = "Dialog"

timeSinceLastSound = 0.0;
randomTimeToWait = 0.0;
dead = UnitIsDeadOrGhost("Player");
loading = true;
shouldVariablesBeSaved = true;

function PrintDelay()
	KTA_Print("Whispers are set to occur between " .. minDelay .. " to " .. maxDelay .. " seconds of intervales");
end

function GodsToStringTable(godsList, forDisplay)

	godsNamesList = {};

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

	if #currentGods == 0 then
		print("You feel no presence around you");
		return;
	end

	local str = "You feel the presence of ";
	str = str .. GetPunctuatedString(GodsToStringTable(currentGods, true));
	KTA_Print(str);
end

function DisplaySoundChannel()

	KTA_Print("Current sound channel is " .. soundChannel);
end

function DisplayDefaultValues(valuesToDisplay)

	displayAll = valuesToDisplay == nil or #valuesToDisplay == 0;

	if displayAll or TableContains(valuesToDisplay, "DELAY") then
		KTA_Print("Default delay is set between " .. DefaultMinDelay .. " and " .. DefaultMaxDelay .. " seconds");
	end

	if displayAll or TableContains(valuesToDisplay, "GOD") or TableContains(valuesToDisplay, "GODS") then

		if DefaultGods == "ALL" then
			KTA_Print("Default gods are " .. GetPunctuatedString(GodsToStringTable(AllSoundLibraries, true)));
		elseif DefaultGods == "NONE" or DefaultGods == "" then
			KTA_Print("No default god");
		else
			local godsNamesTable = GetWords(DefaultGods);

			local str = "Default god is ";
			if #godsNamesTable > 1 then
				str = "Default gods are ";
			end

			KTA_Print(str .. GetPunctuatedString(godsNamesTable));
		end
	end
	
	if displayAll or TableContains(valuesToDisplay, "SOUNDCHANNEL") then
	
		KTA_Print("Default sound channel is " .. DefaultSoundChannel);
	end
end

function PrintAvailableGods()

	KTA_Print("Available gods:");
	for i = 1, #AllSoundLibraries, 1 do
		print("     " .. AllSoundLibraries[i].dataName);
	end
	print("     All");
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
		currentGods = AllSoundLibraries;

		if not silent then
			KTA_Print("You feel the presence of all gods around you");
		end

		return;
	elseif TableContains(godsNames, "NONE") then
		currentGods = {};

		if not silent then
			DisplayCurrentGods();
		end

		return;
	end


	local newGods = {};

	local defaultCall, defaultIndex = TableContains(godsNames, "DEFAULT");
	if defaultCall then
		table.remove(godsNames, defaultIndex);
		local defaultGods = GetWords(string.upper(DefaultGods));
		local containsAll = TableContains(defaultGods, "ALL");
		SetGods(defaultGods, not containsAll);

		if TableContains(defaultGods, "ALL") then
			return;
		end
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
		end

		PrintAvailableGods();
		return;
	end

	currentGods = newGods;

	if not silent then
		DisplayCurrentGods();
	end
end

function SetDefaultGods(godsNames, silent)

	silent = silent or false;

	local godsNamesNoDuplicate = {};
	local sanitizedGodsNames = "";

	if godsNames == nil then
		godsNames = TableToString(GodsToStringTable(currentGods, false));
		DefaultGods = godsNames;

	else
		if TableContains(godsNames, "ALL") then
			DefaultGods = "ALL";
		elseif TableContains(godsNames, "NONE") then
			DefaultGods = "NONE";
		else
			for i = 1, #godsNames, 1 do
				if TableContains(godsNamesNoDuplicate, godsNames[i]) then

					local godExists, godIndex = TableContains(AllSoundLibraries, godsNames[i]);
					if godExists then
						table.insert(godsNamesNoDuplicate, AllSoundLibraries[godIndex].dataName);
					end
				end
			end

			sanitizedGodsNames = TableToString(godsNamesNoDuplicate);

			if sanitizedGodsNames == nil or sanitizedGodsNames == "" then
				KTA_Print("No valid god name found.");
				PrintAvailableGods();
				return;
			end

			DefaultGods = sanitizedGodsNames;
		end
	end

	if not silent then

		if DefaultGods == "" or DefaultGods == "NONE" then
			KTA_Print("Now there will be no god watching by default. Use \"/kta debug clearMemory\" then \"/reload\" to reset the default values");
		elseif DefaultGods == "ALL" then
			KTA_Print("Now all gods will be watching you by default. Use \"/kta debug clearMemory\" then \"/reload\" to reset the default values");
		else
			local godsNamesTable = GetWords(DefaultGods);

			local str = "Default god is now ";
			if #godsNamesTable > 1 then
				str = "Default gods are now ";
			end

			str = str .. GetPunctuatedString(godsNamesTable);
			KTA_Print(str .. ". Use \"/kta debug clearMemory\" then \"/reload\" to reset the default values");
		end
	end
end

function RemoveGods(godsNames)

	if TableContains(godsNames, "ALL") then
		currentGods = {};
	else
		for i = 1, #godsNames, 1 do

			local godsIsWatching, godIndex = TableContains(currentGods, GetGodByName(godsNames[i]));
			if godsIsWatching then
				table.remove(currentGods, godIndex);
			end
		end
	end

	DisplayCurrentGods();
end

function SetSoundChannel(parSoundChannel)

	soundChannel = TrySetSoundChannel(parSoundChannel, soundChannel);
	KTA_Print("The soundfiles will now be played on the channel " .. soundChannel);
end

function SetDefaultSoundChannel(parSoundChannel)

	DefaultSoundChannel = TrySetSoundChannel(parSoundChannel, DefaultSoundChannel);
	KTA_Print("Default sound channel is now " .. DefaultSoundChannel);
end

function SetDelay(minDelayStr, maxDelayStr, silent)

	silent = silent or false;

	local minValue = tonumber(minDelayStr);
	local maxValue = tonumber(maxDelayStr);

	if minDelayStr == "DEFAULT" or (minDelayStr == "0" and (maxDelayStr == "" or maxDelayStr == nil)) then
		minValue = DefaultMinDelay;
		maxValue = DefaultMaxDelay;
	end

	if minValue == nil or maxValue == nil then
		KTA_Print("Invalid use of SetDelay command:");
		PrintHelp("SETDELAY", nil, "noToolTip");
		return;
	elseif minDelay < 0 then
		PrintInvalidParameters("Delay values cannot be negative");
		return;
	elseif minDelay >= maxDelay then
		PrintInvalidParameters("Max delay must be bigger than min delay");
		return;
	end

	minDelay = minValue;
	maxDelay = maxValue;

	if not silent then
		KTA_Print("Delay set between " .. minDelay .. " and " .. maxDelay .. " seconds");
	end

	StartWaiting();
end

function SetDefaultDelay(minDelayStr, maxDelayStr)

	local minDelay = tonumber(minDelayStr);
	local maxDelay = tonumber(maxDelayStr);

	if minDelay == nil or maxDelay == nil then
		KTA_Print("Wrong use of setDefault delay command:");
		PrintHelp("SETDEFAULT", "DELAY", "noToolTip");
		return;
	elseif minDelay < 0 then
		PrintInvalidParameters("Delay values cannot be negative");
		return;
	elseif minDelay >= maxDelay then
		PrintInvalidParameters("Max delay must be bigger than min delay");
		return;
	end

	DefaultMinDelay = minDelay;
	DefaultMaxDelay = maxDelay;

	KTA_Print("Default delay set between " .. minDelayStr .. " and " .. maxDelayStr " seconds. Use \"/kta debug clearMemory\" then \"/reload\" to reset the default values");
end

function ResetValues()

	SetDelay(DefaultMinDelay, DefaultMaxDelay);
	SetGods(GetWords(DefaultGods));
	soundChannel = DefaultSoundChannel;
end

function ClearMemory()

	SavedGods = nil;
	SavedMinDelay = nil;
	SavedMaxDelay = nil;
	SavedSoundChannel = nil;
	DefaultGods = nil;
	DefaultMinDelay = nil;
	DefaultMaxDelay = nil;
	DefaultSoundChannel = "Master";
	KTA_Print("All saved variables have been erased");
end


local eventsListener = CreateFrame("Frame");
local events = {};

function StartWaiting()

	if loading then
		return;
	end

	randomTimeToWait = math.random(minDelay,maxDelay);
	timeSinceLastSound = 0.0;
end

function PlayRandomSound(soundType)

	if loading then
		return;
	end

	rand = math.random(1, #currentGods);
	currentGods[rand]:PlayRandomSound(soundType, soundChannel);
end


function AliveFunc()

	dead = UnitIsDeadOrGhost("Player");

	if randomTimeToWait == 0.0 then
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

	dead = true;

	if loading or #currentGods == 0 then
		return;
	end

	PlayRandomSound("OnDeath");

end

function events:ADDON_LOADED(arg)

	if arg ~= "KillThemAll" then
		return;
	end
	

	if type(SavedGods) ~= "string" then
		SavedGods = nil;
	end

	if DefaultGods == nil or type(DefaultGods) ~= "string" then
		DefaultGods = string.upper(TableToString(GodsToStringTable(currentGods, false)));
	end

	if SavedGods == nil or type(SavedGods) ~= "string" then
		SavedGods = string.upper(TableToString(GodsToStringTable(DefaultGods, false)));
	end

	SetGods(GetWords(SavedGods), true);


	DefaultMinDelay = DefaultMinDelay or minDelay;
	DefaultMaxDelay = DefaultMaxDelay or maxDelay;

	SetDelay(SavedMinDelay or minDelay, SavedMaxDelay or maxDelay, true);

	DefaultSoundChannel = DefaultSoundChannel or "Master";
	SavedSoundChannel = SavedSoundChannel or "Master";
	soundChannel = TrySetSoundChannel(SavedSoundChannel);

	loading = false;
end

function events:PLAYER_LOGOUT(...)

	if not shouldVariablesBeSaved then
		return;
	end

	SavedMinDelay = minDelay;
	SavedMaxDelay = maxDelay;

	SavedGods = TableToString(GodsToStringTable(currentGods, false)) or "NONE";

	SavedSoundChannel = soundChannel;
end

eventsListener:SetScript("OnEvent", function(self, event, ...)
										events[event](self, ...);
									end);

for k, v in pairs(events) do
	eventsListener:RegisterEvent(k);
end


local function MyUpdate(self, elapsed)

	if dead or #currentGods == 0 then
		return;
	end

	timeSinceLastSound = timeSinceLastSound + elapsed;

	if timeSinceLastSound >= randomTimeToWait then
		PlayRandomSound("General");
		StartWaiting();
	end
end

local updater = CreateFrame("Frame");
updater:SetScript("OnUpdate", MyUpdate);
