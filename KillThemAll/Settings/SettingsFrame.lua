
Cerberus_HookThisFile();

local l_interfaceSettingsFrame = {};
g_interfaceEventsListener = {};


local InitDelayEditBoxes = nil; --[[function(mainFrame, minDelayLabelAnchor)]]
local function SoundChannelDropDownListCheckButtonsVerifier(sValue)
	return g_ktaCurrentSettings.m_sSoundChannel == sValue;
end


function OpenSettingsPanel()

	InterfaceOptionsFrame_OpenToCategory("KillThemAll");
	InterfaceOptionsFrame_OpenToCategory("KillThemAll");	-- Twice because once only opens the menu, not the right category, for some reason
end


local l_fCheckButtonsSize = 20.0;
local l_fMarginBetweenButtonsAndLabels = 3.0;
local l_fMarginBetweenLabelsAndOverrideButton = 20.0;
local l_fMarginYBetweenElements = 10.0;

local l_overriddenValueLabelColor = { 0.9, 0.6, 0.3 };
local l_overrideButtonsSize = { x = 120.0, y = 30.0 };
local l_settingsOverrideStuff = {};

local l_testAudioButtonSize = { x = 120.0, y = 30.0 };

--[[global]] GetSettingGlobalValueTextForTooltip = nil; --[[function(sValue)]]

local CreateOverrideButtons = nil;	--[[function(sButtonName, sAssociatedVariableName, frame, sMyAnchor, anchorElement, sParentAnchor, fOffsetX, fOffsetY, bForAllValues)]]
local UpdateLabelColorAndButtonsVisibilityIfOverridden = nil; --[[function(sAssociatedVariableName)]]

local DrawTestAudioButton = nil;	--[[function(parentFrame)]]


function InitSettingsFrames()

	local mainFrame = CreateFrame("Frame", "KTA_InterfaceSettingsFrame", UIParent);
	mainFrame.name = "KillThemAll";

	l_settingsOverrideStuff =
	{
		["m_bDeactivated"] = { m_textLabel = nil, m_buttonsFrame = nil, m_hoverFrames = nil, },
		["m_bMuteDuringCombat"] = { m_textLabel = nil, m_buttonsFrame = nil, m_hoverFrames = nil, },
		["m_iMinDelay"] = { m_textLabel = nil, m_buttonsFrame = nil, m_hoverFrames = nil, },
		["m_iMaxDelay"] = { m_textLabel = nil, m_buttonsFrame = nil, m_hoverFrames = nil, },
		["m_sSoundChannel"] = { m_textLabel = nil, m_buttonsFrame = nil, m_hoverFrames = nil, },
		["m_sGods"] = { m_textLabel = nil, m_buttonsFrame = nil, m_hoverFrames = nil, },
	};


	-- DEACTIVATED
	local deactivatedCheckButtonPos = { x = 60.0, y = -45.0 };
	local deactivatedCheckButton = CreateCheckButton("DeactivateCheckButton", mainFrame, l_fCheckButtonsSize);
	deactivatedCheckButton:SetPoint("TOPLEFT", deactivatedCheckButtonPos.x, deactivatedCheckButtonPos.y);
	deactivatedCheckButton:SetChecked(g_ktaCurrentSettings.m_bDeactivated);

	local deactivatedLabel = CreateLabel(deactivatedCheckButton, "Deactivated");
	deactivatedLabel:SetPoint("LEFT", deactivatedCheckButton, "RIGHT", l_fMarginBetweenButtonsAndLabels, 0.0);
	HookTooltipToElement(deactivatedCheckButton, function() return GetSettingGlobalValueTextForTooltip(tostring(S_ktaGlobalSettings.m_bDeactivated)); end);


	deactivatedCheckButton:SetScript("OnClick", function()
		ToggleDeactivated();
	end);

	AddListenerEvent(g_interfaceEventsListener, "OnToggleDeactivated", function()
		deactivatedCheckButton:SetChecked(g_ktaCurrentSettings.m_bDeactivated);
	end);

	local deactivateOverrideFrame = CreateOverrideButtons("DeactivateKTA", "m_bDeactivated", mainFrame, "LEFT", deactivatedCheckButton, "RIGHT", 180.0, 0.0);
	l_settingsOverrideStuff["m_bDeactivated"].m_textLabel = deactivatedLabel;
	l_settingsOverrideStuff["m_bDeactivated"].m_buttonsFrame = deactivateOverrideFrame;
	l_settingsOverrideStuff["m_bDeactivated"].m_hoverFrames = { deactivatedCheckButton };
	UpdateLabelColorAndButtonsVisibilityIfOverridden("m_bDeactivated");


	-- MUTE DURING COMBAT
	local muteDuringCombatCheckButton = CreateCheckButton("MuteInCombatCheckButton", mainFrame, l_fCheckButtonsSize);
	muteDuringCombatCheckButton:SetPoint("TOP", deactivatedCheckButton, "BOTTOM", 0.0, -l_fMarginYBetweenElements);
	muteDuringCombatCheckButton:SetChecked(g_ktaCurrentSettings.m_bMuteDuringCombat);

	local muteDuringCombatLabel = CreateLabel(muteDuringCombatCheckButton, "Mute during Combat");
	muteDuringCombatLabel:SetPoint("LEFT", muteDuringCombatCheckButton, "RIGHT", l_fMarginBetweenButtonsAndLabels, 0.5);
	HookTooltipToElement(muteDuringCombatCheckButton, function() return GetSettingGlobalValueTextForTooltip(tostring(S_ktaGlobalSettings.m_bMuteDuringCombat)); end);

	muteDuringCombatCheckButton:SetScript("OnClick", function()
		SetOverrideValue("m_bMuteDuringCombat", not g_ktaCurrentSettings.m_bMuteDuringCombat);
	end);

	AddListenerEvent(g_interfaceEventsListener, "OnToggleMuteDuringCombat", function()
		muteDuringCombatCheckButton:SetChecked(g_ktaCurrentSettings.m_bMuteDuringCombat);
	end);

	local muteInCombatOverrideFrame = CreateOverrideButtons("MuteDuringCombat", "m_bMuteDuringCombat", mainFrame, "LEFT", muteDuringCombatCheckButton, "RIGHT", 180.0, 0.0);
	l_settingsOverrideStuff["m_bMuteDuringCombat"].m_textLabel = muteDuringCombatLabel;
	l_settingsOverrideStuff["m_bMuteDuringCombat"].m_buttonsFrame = muteInCombatOverrideFrame;
	l_settingsOverrideStuff["m_bMuteDuringCombat"].m_hoverFrames = { muteDuringCombatCheckButton };
	UpdateLabelColorAndButtonsVisibilityIfOverridden("m_bMuteDuringCombat");


	-- HIDE MINIMAP BUTTON
	InitMinimapButton(mainFrame);

	local hideMinimapCheckButton = CreateCheckButton("HideMinimapButtonCheckButton", mainFrame, l_fCheckButtonsSize);
	hideMinimapCheckButton:SetPoint("TOP", muteDuringCombatCheckButton, "BOTTOM", 0.0, -l_fMarginYBetweenElements);
	hideMinimapCheckButton:SetChecked(g_ktaCurrentSettings.m_minimapButton.hide);

	local hideMinimapLabel = CreateLabel(hideMinimapCheckButton, "Hide minimap button");
	hideMinimapLabel:SetPoint("LEFT", hideMinimapCheckButton, "RIGHT", l_fMarginBetweenButtonsAndLabels, 0.0);

	hideMinimapCheckButton:SetScript("OnClick", function()
		SetMinimapButtonHidden(not g_ktaCurrentSettings.m_minimapButton.hide);
	end);


	-- MIN MAX DELAY
	local soundChannelLabelAnchor = InitDelayEditBoxes(mainFrame, hideMinimapCheckButton);


	-- SOUND CHANNEL
	local soundChannelLabel = CreateLabel(mainFrame, "Sound channel", buttons);
	soundChannelLabel:SetPoint("TOPLEFT", soundChannelLabelAnchor, "BOTTOMLEFT", -5.0, -10.0 - l_fMarginYBetweenElements);

	local availableSoundChannels = table.Clone(GetAvailableSoundChannels());
	availableSoundChannels["DEFAULT"] = nil;
	local optionsForList = {};
	for sKey, sValue in pairs(availableSoundChannels) do
		table.insert(optionsForList, { m_sText = sValue, m_value = sKey });
	end
	local soundChannelsDropdownList = CreateDropDownList("SoundChannelsList", mainFrame, 100.0, optionsForList, g_ktaCurrentSettings.m_sSoundChannel, SetSoundChannel, { true, true }, SoundChannelDropDownListCheckButtonsVerifier);
	soundChannelsDropdownList:SetPoint("TOPLEFT", soundChannelLabel, "BOTTOMLEFT", -20.0, -5.0);
	AddListenerEvent(g_interfaceEventsListener, "OnSoundChannelChanged", function()
		UIDropDownMenu_SetText(soundChannelsDropdownList, g_ktaCurrentSettings.m_sSoundChannel);
	end);

	local soundChannelHoverFrame = CreateFrame("Frame", "KTA_SoundChannelHoverFrame", mainFrame);
	soundChannelHoverFrame:SetPoint("TOPLEFT", soundChannelLabel, "TOPLEFT");
	soundChannelHoverFrame:SetPoint("BOTTOMRIGHT", soundChannelsDropdownList, "BOTTOMRIGHT");
	HookTooltipToElement(soundChannelHoverFrame, function() return GetSettingGlobalValueTextForTooltip(tostring(S_ktaGlobalSettings.m_sSoundChannel)); end);

	local soundChannelOverrideFrame = CreateOverrideButtons("SoundChannel", "m_sSoundChannel", mainFrame, "LEFT", soundChannelsDropdownList, "RIGHT", 70.0, 2.5);
	l_settingsOverrideStuff["m_sSoundChannel"].m_textLabel = soundChannelLabel;
	l_settingsOverrideStuff["m_sSoundChannel"].m_buttonsFrame = soundChannelOverrideFrame;
	l_settingsOverrideStuff["m_sSoundChannel"].m_hoverFrames = { soundChannelHoverFrame };
	UpdateLabelColorAndButtonsVisibilityIfOverridden("m_sSoundChannel");


	-- GODS LIST
	InitGodsListSettings(mainFrame, soundChannelsDropdownList, { x = 20.0, y = -8.0 - l_fMarginYBetweenElements });

	local godsOverrideFrame = CreateOverrideButtons("Gods", "m_sGods", mainFrame, "TOP", g_godsListSettings, "BOTTOM", 0.0, 0.0);
	l_settingsOverrideStuff["m_sGods"].m_textLabel = g_godsListSettings.godsLabel;
	l_settingsOverrideStuff["m_sGods"].m_buttonsFrame = godsOverrideFrame;
	l_settingsOverrideStuff["m_sGods"].m_hoverFrames = g_godsListSettings.hoverFrames;
	UpdateLabelColorAndButtonsVisibilityIfOverridden("m_sGods");


	-- GLOBAL OVERRIDE BUTTONS
	CreateOverrideButtons("AllSettings", nil, mainFrame, "TOPLEFT", g_godsListSettings, "BOTTOMLEFT", 0.0, -50.0, true);

	DrawTestAudioButton(mainFrame);


	-- BIND PANEL TO INTERFACE SETTINGS
	InterfaceOptions_AddCategory(mainFrame);


	l_interfaceSettingsFrame.panel = mainFrame;


	AddListenerEvent(g_interfaceEventsListener, "OnVariableOverrideStateChanged", function(sVariableName)
		UpdateLabelColorAndButtonsVisibilityIfOverridden(sVariableName);
	end);
end


local SetDelayButtonCallback = nil; --[[function(self, minEditBox, maxEditBox)]]

-- MIN MAX DELAY FUNCTION
--[[local]] InitDelayEditBoxes = function(mainFrame, minDelayLabelAnchor)

	local editBoxesSize = { x = 60.0, y = 20.0 };
	local marginBetweenEditBoxesAndLabels = { x = 5.0, y = -5.0 };

	-- MIN DELAY
	local minDelayLabel = CreateLabel(mainFrame, "Min delay");
	minDelayLabel:SetPoint("TOPLEFT", minDelayLabelAnchor, "BOTTOMLEFT", 0.0, -10.0 - l_fMarginYBetweenElements);

	local minDelayEditBox = CreateEditBox("BoxMinDelay", mainFrame, editBoxesSize, true);
	minDelayEditBox:SetPoint("TOPLEFT", minDelayLabel, "BOTTOMLEFT", marginBetweenEditBoxesAndLabels.x, marginBetweenEditBoxesAndLabels.y);

	minDelayEditBox:SetScript("OnSizeChanged", function()	-- OnShow is called before setting the size, so setting a text then is useless; OnSizeChanged guarentees that the box has been initialized
		minDelayEditBox:SetText(g_ktaCurrentSettings.m_iMinDelay);
	end);

	minDelayEditBox:SetScript("OnShow", function()
		minDelayEditBox:SetText(g_ktaCurrentSettings.m_iMinDelay);
	end);

	local minDelayHoverFrame = CreateFrame("Frame", "KTA_MinDelayHoverFrame", mainFrame);
	minDelayHoverFrame:SetPoint("TOPLEFT", minDelayLabel, "TOPLEFT");
	minDelayHoverFrame:SetPoint("BOTTOMRIGHT", minDelayEditBox, "BOTTOMRIGHT");

	local function GetMinDelayText() return GetSettingGlobalValueTextForTooltip(tostring(S_ktaGlobalSettings.m_iMinDelay)); end;
	HookTooltipToElement(minDelayHoverFrame, GetMinDelayText);
	HookTooltipToElement(minDelayEditBox, GetMinDelayText, minDelayHoverFrame);


	-- MAX DELAY
	local maxDelayLabel = CreateLabel(mainFrame, "Max delay");
	maxDelayLabel:SetPoint("LEFT", minDelayLabel, "RIGHT", 15.0, 0.0);

	local maxDelayEditBox = CreateEditBox("BoxMaxDelay", mainFrame, editBoxesSize, true);
	maxDelayEditBox:SetPoint("TOPLEFT", maxDelayLabel, "BOTTOMLEFT", marginBetweenEditBoxesAndLabels.x, marginBetweenEditBoxesAndLabels.y);

	maxDelayEditBox:SetScript("OnSizeChanged", function()	-- OnShow is called before setting the size, so setting a text then is useless; OnSizeChanged guarentees that the box has been initialized
		maxDelayEditBox:SetText(g_ktaCurrentSettings.m_iMaxDelay);
	end);

	maxDelayEditBox:SetScript("OnShow", function()
		maxDelayEditBox:SetText(g_ktaCurrentSettings.m_iMaxDelay);
	end);

	local maxDelayHoverFrame = CreateFrame("Frame", "KTA_MinDelayHoverFrame", mainFrame);
	maxDelayHoverFrame:SetPoint("TOPLEFT", maxDelayLabel, "TOPLEFT");
	maxDelayHoverFrame:SetPoint("BOTTOMRIGHT", maxDelayEditBox, "BOTTOMRIGHT");

	local function GetMaxDelayText() return GetSettingGlobalValueTextForTooltip(tostring(S_ktaGlobalSettings.m_iMaxDelay)); end;
	HookTooltipToElement(maxDelayHoverFrame, GetMaxDelayText);
	HookTooltipToElement(maxDelayEditBox, GetMaxDelayText, maxDelayHoverFrame);


	-- TAB BEHAVIOUR
	minDelayEditBox:SetScript("OnTabPressed", function()
		minDelayEditBox:ClearFocus();
		minDelayEditBox:HighlightText(0, 0);

		maxDelayEditBox:SetFocus();
		maxDelayEditBox:HighlightText();
	end);
	maxDelayEditBox:SetScript("OnTabPressed", function()
		maxDelayEditBox:ClearFocus();
		maxDelayEditBox:HighlightText(0, 0);

		minDelayEditBox:SetFocus();
		minDelayEditBox:HighlightText();
	end);


	AddListenerEvent(g_interfaceEventsListener, "OnDelayChanged", function()
		minDelayEditBox:SetText(g_ktaCurrentSettings.m_iMinDelay);
		maxDelayEditBox:SetText(g_ktaCurrentSettings.m_iMaxDelay);
	end);


	-- OK BUTTON
	local setDelayButton = CreateButton("DelayOKButton", mainFrame, { x = 80.0, y = 30.0 }, "Set delay", SetDelayButtonCallback, { minDelayEditBox, maxDelayEditBox });
	setDelayButton:SetPoint("BOTTOMLEFT", maxDelayEditBox, "BOTTOMRIGHT", 15.0, 0.0);

	local minMaxDelayOverrideFrame = CreateOverrideButtons("MinMaxDelay", { "m_iMinDelay", "m_iMaxDelay" }, mainFrame, "LEFT", setDelayButton, "RIGHT", 10.5, 0.0);
	l_settingsOverrideStuff["m_iMinDelay"].m_textLabel = minDelayLabel;
	l_settingsOverrideStuff["m_iMinDelay"].m_buttonsFrame = minMaxDelayOverrideFrame;
	l_settingsOverrideStuff["m_iMinDelay"].m_hoverFrames = { minDelayHoverFrame, minDelayEditBox };
	UpdateLabelColorAndButtonsVisibilityIfOverridden("m_iMinDelay", "m_iMaxDelay");
	l_settingsOverrideStuff["m_iMaxDelay"].m_textLabel = maxDelayLabel;
	l_settingsOverrideStuff["m_iMaxDelay"].m_buttonsFrame = minMaxDelayOverrideFrame;
	l_settingsOverrideStuff["m_iMaxDelay"].m_hoverFrames = { maxDelayHoverFrame, maxDelayEditBox };
	UpdateLabelColorAndButtonsVisibilityIfOverridden("m_iMaxDelay", "m_iMinDelay");

	return minDelayEditBox;
end

--[[local]] SetDelayButtonCallback = function(self, minEditBox, maxEditBox)

	local iNewMin = minEditBox:GetNumber();
	local iNewMax = maxEditBox:GetNumber();

	if iNewMin == g_ktaCurrentSettings.m_iMinDelay and iNewMax == g_ktaCurrentSettings.m_iMaxDelay then
		return;
	end

	SetDelay(iNewMin, iNewMax);
end

local AddScriptToButtons = nil; --[[function(setGlobalButton, revertButton, sAssociatedVariableName, bForAllValues)]]

--[[local]] CreateOverrideButtons = function(sButtonName, sAssociatedVariableName, frame, sMyAnchor, anchorElement, sParentAnchor, fOffsetX, fOffsetY, bForAllValues)

	local overrideFrame = CreateFrame("Frame", sButtonName .. "_OverrideButtonsFrame", frame);
	overrideFrame:SetAllPoints(frame);

	local sMakeGlobalText = "Make global";
	local sMakeGlobalTooltip = "Share this value accross all characters (if they don't have a specific value of their own)";
	local sRevertText = "Revert to global";
	local sRevertTooltip = "Revert this value to the global settings";

	if bForAllValues then
		sMakeGlobalText = "Make all global";
		sMakeGlobalTooltip = "Save these settings as the new global ones (won't affect other characters' specific settings)";
		sRevertText = "Revert all";
		sRevertTooltip = "Revert all values to the global settings";
	end

	local setGlobalButton = CreateButton(sButtonName .. "_SetValueGlobalButton", overrideFrame, l_overrideButtonsSize, sMakeGlobalText);
	setGlobalButton:SetPoint(sMyAnchor, anchorElement, sParentAnchor, fOffsetX, fOffsetY);
	HookTooltipToElement(setGlobalButton, function() return sMakeGlobalTooltip; end);

	local revertButton = CreateButton(sButtonName .. "_RevertToGlobalButton", overrideFrame, l_overrideButtonsSize, sRevertText);
	revertButton:SetPoint("LEFT", setGlobalButton, "RIGHT", -2.0, 0.0);
	HookTooltipToElement(revertButton, function() return sRevertTooltip; end);


	AddScriptToButtons(setGlobalButton, revertButton, sAssociatedVariableName, bForAllValues);

	return overrideFrame;
end

--[[local]] AddScriptToButtons = function(setGlobalButton, revertButton, sAssociatedVariableName, bForAllValues)

	if bForAllValues then
		setGlobalButton:SetScript("OnClick", function(self)
			SaveCurrentProfileAsGlobal();
		end);

		revertButton:SetScript("OnClick", function(self)
			RevertAllSettingsToGlobals();
		end);
	else
		setGlobalButton:SetScript("OnClick", function(self)
			if type(sAssociatedVariableName) == "table" then
				for i = 1, #sAssociatedVariableName, 1 do
					SaveVariableAsGlobal(sAssociatedVariableName[i]);
				end
			else
				SaveVariableAsGlobal(sAssociatedVariableName);
			end
		end);

		revertButton:SetScript("OnClick", function(self)
			if type(sAssociatedVariableName) == "table" then
				for i = 1, #sAssociatedVariableName, 1 do
					RemoveVariableOverride(sAssociatedVariableName[i]);
				end
			else
				RemoveVariableOverride(sAssociatedVariableName);
			end
		end);
	end
end

--[[local]] DrawTestAudioButton = function(parentFrame)

	local testButton = CreateButton("TestAudioButton", parentFrame, l_testAudioButtonSize, "Test", TestAudio);
	testButton:SetPoint("BOTTOMRIGHT", parentFrame, "BOTTOMRIGHT", -20.0, 20.0);
	--testButton:SetScript("OnClick", function(self)
	--	TestAudio();
	--end);
end

--[[local]] UpdateLabelColorAndButtonsVisibilityIfOverridden = function(sAssociatedVariableName, sSecondAssociatedVariableName)

	local textLabel = l_settingsOverrideStuff[sAssociatedVariableName].m_textLabel;
	local buttonsFrame = l_settingsOverrideStuff[sAssociatedVariableName].m_buttonsFrame;
	local hoverFrames = l_settingsOverrideStuff[sAssociatedVariableName].m_hoverFrames;

	local bOverridden = g_ktaCurrentCharSettingsOverrides ~= nil and g_ktaCurrentCharSettingsOverrides[sAssociatedVariableName] ~= nil;

	if bOverridden then
		textLabel:SetTextColor(unpack(l_overriddenValueLabelColor));
		buttonsFrame:Show();

		for i = 1, #hoverFrames, 1 do
			hoverFrames[i].m_bShouldNotShowTooltip = false;
		end
	else
		textLabel:SetTextColor(1.0, 1.0, 1.0);
		buttonsFrame:Hide();

		for i = 1, #hoverFrames, 1 do
			hoverFrames[i].m_bShouldNotShowTooltip = true;
		end
	end

	if not bOverridden and sSecondAssociatedVariableName ~= nil and g_ktaCurrentCharSettingsOverrides ~= nil and g_ktaCurrentCharSettingsOverrides[sSecondAssociatedVariableName] ~= nil then
		buttonsFrame:Show();
	end
end

--[[global]] GetSettingGlobalValueTextForTooltip = function(sValue)

	return "This value has been changed for this character only.\nThe global value is \"" .. sValue .. "\"";
end
