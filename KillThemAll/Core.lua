
Cerberus_HookThisFile();

g_cAddonColor = "FFe899ff";
local KTA_PREFIX = "|c" .. g_cAddonColor .. "KTA: |r"
function KTA_Print(str)
	print(KTA_PREFIX .. str);
end

g_currentGods = {};
g_sCharacterNameAndRealm = UnitName("player") .. "-" .. GetRealmName();

local l_fTimeSinceLastSound = 0.0;
local l_fRandomTimeToWait = 0.0;
local l_bDead = UnitIsDeadOrGhost("Player");
local l_bLoading = true;
g_bShouldVariablesBeSaved = true;

function DisplayDelay()
	KTA_Print("Whispers are set to occur between " .. g_ktaCurrentSettings.m_iMinDelay .. " to " .. g_ktaCurrentSettings.m_iMaxDelay .. " seconds.");
end

function GodsToStringTable(godsList, bForDisplay)

	local godsNamesList = {};

	for i = 1, #godsList, 1 do
		if bForDisplay then
			table.insert(godsNamesList, godsList[i].m_sDisplayName);
		else
			table.insert(godsNamesList, godsList[i].m_sDataName);
		end
	end

	return godsNamesList;
end

function DisplayCurrentGods()

	if #g_currentGods == 0 then
		print("You feel no presence around you.");
		return;
	end

	local str = "You feel the presence of ";
	str = str .. GetPunctuatedString(GodsToStringTable(g_currentGods, true));
	KTA_Print(str .. ".");
end

function DisplaySoundChannel()

	KTA_Print("Current sound channel is " .. g_ktaCurrentSettings.m_sSoundChannel .. ".");
end

function DisplayDefaultValues(valuesToDisplay)

	local bDisplayAll = valuesToDisplay == nil or #valuesToDisplay == 0;

	if bDisplayAll or TableContains(valuesToDisplay, "DELAY") then
		KTA_Print("Default delay is set between " .. g_ktaCurrentSettings.m_default.m_iMinDelay .. " and " .. g_ktaCurrentSettings.m_default.m_iMaxDelay .. " seconds.");
	end

	if bDisplayAll or TableContains(valuesToDisplay, { "GOD", "GODS" }) then

		if g_ktaCurrentSettings.m_default.m_sGods == "ALL" then
			KTA_Print("Default gods are " .. GetPunctuatedString(GodsToStringTable(g_allSoundLibraries, true)) .. ".");
		elseif g_ktaCurrentSettings.m_default.m_sGods == "NONE" or g_ktaCurrentSettings.m_default.m_sGods == "" then
			KTA_Print("No default god.");
		else
			local godsNamesTable = GetWords(g_ktaCurrentSettings.m_default.m_sGods);
			for i = 1, #godsNamesTable, 1 do
				godsNamesTable[i] = GetGodByName(godsNamesTable[i]).m_sDisplayName;
			end

			local str = "Default god is ";
			if #godsNamesTable > 1 then
				str = "Default gods are ";
			end

			KTA_Print(str .. GetPunctuatedString(godsNamesTable) .. ".");
		end
	end

	if bDisplayAll or TableContains(valuesToDisplay, "SOUNDCHANNEL") then
		KTA_Print("Default sound channel is " .. g_ktaCurrentSettings.m_default.m_sSoundChannel .. ".");
	end
end

function PrintAvailableGods()

	KTA_Print("Available gods:");
	for i = 1, #g_allSoundLibraries, 1 do
		print("     " .. g_allSoundLibraries[i].m_sDataName);
	end
	print("     All");
end

function ToggleDeactivated()

	SetOverrideValue("m_bDeactivated", not g_ktaCurrentSettings.m_bDeactivated);
	CallEventListener(g_interfaceEventsListener, "OnToggleDeactivated");
end

function GetGodByName(sGodName)

	sGodName = string.upper(sGodName);

	for i = 1, #g_allSoundLibraries, 1 do
		if string.upper(g_allSoundLibraries[i].m_sDataName) == sGodName then
			return g_allSoundLibraries[i];
		end
	end

	return nil;
end

local function SetAllGods()

	g_currentGods = g_allSoundLibraries;
end

local function SetNoGods()

	g_currentGods = {};
end

local function SetDefaultGods(godsNames)

	local defaultGods = GetWords(string.upper(g_ktaCurrentSettings.m_default.m_sGods));
	local containsAll = TableContains(defaultGods, "ALL");

	SetGods(defaultGods, bSilent);
end

local function SetSpecificGods(godsNames, bSilent)

	local newGods = {};

	for i = 1, #godsNames, 1 do
		local currentGod = GetGodByName(godsNames[i]);

		if currentGod ~= nil and not TableContains(newGods, currentGod.m_sDataName) then
			table.insert(newGods, currentGod);

		elseif currentGod == nil and not bSilent then
			KTA_Print("Invalid god name: " .. godsNames[i] .. ".");
		end
	end

	if #newGods == 0 then
		if not bSilent then
			KTA_Print("No valid god name found.");
			PrintAvailableGods();
		end
		return;
	end

	g_currentGods = newGods;
end

local function SetGodsFromList(godsNames, bSilent)

	local bDefaultCall, iDefaultIndex = TableContains(godsNames, "DEFAULT");

	if bDefaultCall then
		table.remove(godsNames, iDefaultIndex);
		SetDefaultGods(godsNames);
	else
		SetSpecificGods(godsNames, bSilent);
	end
end

function SetGods(godsNames, bSilent, bFromLoading)

	bSilent = bSilent or false;


	if TableContains(godsNames, "ALL") then
		SetAllGods();
	elseif godsNames == nil or #godsNames == 0 or TableContains(godsNames, "NONE") then
		SetNoGods();
	else
		SetGodsFromList(godsNames, bSilent);
	end

	if not bFromLoading then
		CallEventListener(g_interfaceEventsListener, "OnGodsChanged");
	end

	if not bSilent then
		DisplayCurrentGods();
	end

	StartWaiting();
end

function AddGods(godsNames, bSilent)

	SetGods(TableCombine(GodsToStringTable(g_currentGods, false), godsNames), bSilent);
end

function MakeGodsDefault(godsNames, bSilent)

	bSilent = bSilent or false;

	local godsNamesNoDuplicate = {};

	if godsNames == nil then
		local sGodsNames = TableToString(GodsToStringTable(g_currentGods, false));

		SetOverrideDefaultValue("m_sGods", sGodsNames)

	else
		if TableContains(godsNames, "ALL") then
			SetOverrideDefaultValue("m_sGods", "ALL");
		elseif TableContains(godsNames, "NONE") then
			SetOverrideDefaultValue("m_sGods", "NONE");
		else
			for i = 1, #godsNames, 1 do
				if not TableContains(godsNamesNoDuplicate, godsNames[i]) then

					local bGodExists, iGodIndex = GodExists(godsNames[i]);
					if bGodExists then
						table.insert(godsNamesNoDuplicate, g_allSoundLibraries[iGodIndex].m_sDataName);
					end
				end
			end

			local sSanitizedGodsNames = TableToString(godsNamesNoDuplicate);

			if sSanitizedGodsNames == nil or sSanitizedGodsNames == "" then
				KTA_Print("No valid god name found.");
				PrintAvailableGods();
				return;
			end

			SetOverrideDefaultValue("m_sGods", sSanitizedGodsNames)
		end
	end

	if not bSilent then

		if g_ktaCurrentSettings.m_default.m_sGods == "" or g_ktaCurrentSettings.m_default.m_sGods == "NONE" then
			KTA_Print("Now there will be no god watching by default. Use \"/kta debug clearMemory\" then \"/reload\" to reset the default values.");
		elseif g_ktaCurrentSettings.m_default.m_sGods == "ALL" then
			KTA_Print("Now all gods will be watching you by default. Use \"/kta debug clearMemory\" then \"/reload\" to reset the default values.");
		else
			local godsNamesTable = GetWords(g_ktaCurrentSettings.m_default.m_sGods);
			for i = 1, #godsNamesTable, 1 do
				godsNamesTable[i] = GetGodByName(godsNamesTable[i]).m_sDisplayName;
			end

			local str = "Default god is now ";
			if #godsNamesTable > 1 then
				str = "Default gods are now ";
			end

			str = str .. GetPunctuatedString(godsNamesTable);
			KTA_Print(str .. ". Use \"/kta debug clearMemory\" then \"/reload\" to reset the default values.");
		end
	end
end

function RemoveGods(godsNames, bSilent)

	if TableContains(godsNames, "ALL") then
		g_currentGods = {};
	else
		for i = 1, #godsNames, 1 do

			local bGodsAreWatching, iGodIndex = TableContainsUniqueItem(g_currentGods, GetGodByName(godsNames[i]));
			if bGodsAreWatching then
				table.remove(g_currentGods, iGodIndex);
			end
		end
	end

	if not bSilent then
		DisplayCurrentGods();
	end

	CallEventListener(g_interfaceEventsListener, "OnGodsChanged");
	StartWaiting();
end

function SetSoundChannel(sSoundChannel, bSilent, bFromInterface)

	SetOverrideValue("m_sSoundChannel", TryParseSoundChannel(sSoundChannel, g_ktaCurrentSettings.m_sSoundChannel, bSilent));

	if not bSilent then
		KTA_Print("The soundfiles will now be played on the channel " .. g_ktaCurrentSettings.m_sSoundChannel .. ".");
	end

	if not bFromInterface then
		CallEventListener(g_interfaceEventsListener, "OnSoundChannelChanged");
	end
end

function SetDefaultSoundChannel(sSoundChannel)

	SetOverrideDefaultValue("m_sSoundChannel", TryParseSoundChannel(sSoundChannel, g_ktaCurrentSettings.m_default.m_sSoundChannel));
	KTA_Print("Default sound channel is now " .. g_ktaCurrentSettings.m_default.m_sSoundChannel .. ".");
end

function SetDelay(sMinDelayStr, sMaxDelayStr, bSilent)

	bSilent = bSilent or false;

	local iMinValue = tonumber(sMinDelayStr);
	local iMaxValue = tonumber(sMaxDelayStr);

	if sMinDelayStr == "DEFAULT" or (sMinDelayStr == "0" and (sMaxDelayStr == "" or sMaxDelayStr == nil)) then
		iMinValue = g_ktaCurrentSettings.m_default.m_iMinDelay;
		iMaxValue = g_ktaCurrentSettings.m_default.m_iMaxDelay;
	end

	if iMinValue == nil or iMaxValue == nil then
		KTA_Print("Invalid use of SetDelay command:");
		PrintHelp("SETDELAY", nil, "noToolTip");
		return false;
	elseif iMinValue < 0 then
		PrintInvalidParameters("Delay values cannot be negative.");
		return false;
	elseif iMinValue >= iMaxValue then
		PrintInvalidParameters("Max delay must be bigger than min delay.");
		return false;
	end

	SetOverrideValue("m_iMinDelay", iMinValue);
	SetOverrideValue("m_iMaxDelay", iMaxValue);

	if not bSilent then
		KTA_Print("Delay set between " .. iMinValue .. " and " .. iMaxValue .. " seconds.");
	end

	StartWaiting();
	CallEventListener(g_interfaceEventsListener, "OnDelayChanged");

	return true;
end

function SetDefaultDelay(sMinDelayStr, sMaxDelayStr)

	local iMinValue = tonumber(sMinDelayStr);
	local iMaxValue = tonumber(sMaxDelayStr);

	if iMinValue == nil or iMaxValue == nil then
		KTA_Print("Wrong use of setDefault delay command:");
		PrintHelp("SETDEFAULT", { "DELAY" }, "noToolTip");
		return;
	elseif iMinValue < 0 then
		PrintInvalidParameters("Delay values cannot be negative.");
		return;
	elseif iMinValue >= iMaxValue then
		PrintInvalidParameters("Max delay must be bigger than min delay.");
		return;
	end

	SetOverrideDefaultValue("m_iMinDelay", iMinValue);
	SetOverrideDefaultValue("m_iMaxDelay", iMaxValue);

	KTA_Print("Default delay set between " .. sMinDelayStr .. " and " .. sMaxDelayStr .. " seconds. Use \"/kta debug clearMemory\" then \"/reload\" to reset the default values.");
end

function ResetValues()

	KTA_Print("Resetting all settings to default ones.");
	SetDelay(g_ktaCurrentSettings.m_default.m_iMinDelay, g_ktaCurrentSettings.m_default.m_iMaxDelay);
	SetGods(GetWords(g_ktaCurrentSettings.m_default.m_sGods));
	SetSoundChannel(g_ktaCurrentSettings.m_default.m_sSoundChannel)
end


local l_eventsListener = CreateFrame("Frame");
local l_events = {};

function StartWaiting()

	if l_bLoading then
		return;
	end

	l_fRandomTimeToWait = math.random(g_ktaCurrentSettings.m_iMinDelay, g_ktaCurrentSettings.m_iMaxDelay);
	l_fTimeSinceLastSound = 0.0;
end

function PlayRandomSound(sSoundType)

	if l_bLoading or g_ktaCurrentSettings.m_bDeactivated then
		return;
	end

	local iRand = math.random(1, #g_currentGods);
	g_currentGods[iRand]:PlayRandomSound(sSoundType, g_ktaCurrentSettings.m_sSoundChannel);
end


local function TryStartWaiting()

	if not l_bDead and l_fRandomTimeToWait == 0.0 then
		StartWaiting();
	end
end

function l_events:PLAYER_ALIVE(...)

	l_bDead = UnitIsDeadOrGhost("Player");
	TryStartWaiting();
end

function l_events:PLAYER_UNGHOST(...)

	l_bDead = false;
	TryStartWaiting();
end

function l_events:PLAYER_DEAD(...)

	l_bDead = true;

	if l_bLoading or #g_currentGods == 0 then
		return;
	end

	PlayRandomSound("Death");
end

function l_events:ADDON_LOADED(sAddonName)

	if sAddonName ~= "KillThemAll" then
		return;
	end

	HookGodsChangedSettingsListener();
	LoadSettings();
	InitSettingsFrames();

	l_bLoading = false;
	StartWaiting();
end

function l_events:PLAYER_LOGOUT()

	if not g_bShouldVariablesBeSaved then
		return;
	end

	SaveSettings();
end

l_eventsListener:SetScript("OnEvent", function(self, sEvent, ...)
	l_events[sEvent](self, ...);
end);

for sEvent, _ in pairs(l_events) do
	l_eventsListener:RegisterEvent(sEvent);
end


local function KTAUpdate(self, fElapsed)

	if g_currentGods == nil then
		return;
	end

	if l_bDead or #g_currentGods == 0 or g_ktaCurrentSettings.m_bDeactivated or (g_ktaCurrentSettings.m_bMuteDuringCombat and InCombatLockdown()) then
		return;
	end

	l_fTimeSinceLastSound = l_fTimeSinceLastSound + fElapsed;

	if l_fTimeSinceLastSound >= l_fRandomTimeToWait then
		PlayRandomSound("General");
		StartWaiting();
	end
end

l_eventsListener:SetScript("OnUpdate", KTAUpdate);
