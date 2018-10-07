
Cerberus_HookThisFile();

local g_interfaceSettingsFrame = {};
g_interfaceEventsListener = {};


local InitDelayEditBoxes = nil; --[[function(mainFrame, minDelayLabelAnchor)]]
local function SoundChannelDropDownListCheckButtonsVerifier(sValue)
	return g_ktaCurrentSettings.m_sSoundChannel == sValue;
end


function OpenSettingsPanel()

	InterfaceOptionsFrame_OpenToCategory("KillThemAll");
	InterfaceOptionsFrame_OpenToCategory("KillThemAll");	-- Twice because once only opens the menu, not the right category, for some reason
end


local fCheckButtonsSize = 20.0;
local fMarginBetweenButtonsAndLabels = 3.0;
local fMarginBetweenLabelsAndOverrideButton = 20.0;
local fMarginYBetweenElements = 10.0;

local overriddenValueLabelColor = { 0.9, 0.6, 0.3 };
local overrideButtonsSize = { x = 120.0, y = 30.0 };
local settingsOverrideStuff = {};

local CreateOverrideButtons = nil;	--[[function(sButtonName, sAssociatedVariableName, frame, sMyAnchor, anchorElement, sParentAnchor, fOffsetX, fOffsetY, bForAllValues)]]
local UpdateLabelColorAndButtonsVisibilityIfOverridden = nil; --[[function(sAssociatedVariableName)]]


function InitSettingsFrames()

	local mainFrame = CreateFrame("Frame", "KTA_InterfaceSettingsFrame", UIParent);
	mainFrame.name = "KillThemAll";

	settingsOverrideStuff =
	{
		["m_bDeactivated"] = { textLabel = nil, buttonsFrame = nil, },
		["m_bMuteDuringCombat"] = { textLabel = nil, buttonsFrame = nil, },
		["m_iMinDelay"] = { textLabel = nil, buttonsFrame = nil, },
		["m_iMaxDelay"] = { textLabel = nil, buttonsFrame = nil, },
		["m_sSoundChannel"] = { textLabel = nil, buttonsFrame = nil, },
		["m_sGods"] = { textLabel = nil, buttonsFrame = nil, },
	};


	-- DEACTIVATED
	local deactivatedCheckButtonPos = { x = 60.0, y = -45.0 };
	local deactivatedCheckButton = CreateCheckButton("DeactivateCheckButton", mainFrame, fCheckButtonsSize);
	deactivatedCheckButton:SetPoint("TOPLEFT", deactivatedCheckButtonPos.x, deactivatedCheckButtonPos.y);
	deactivatedCheckButton:SetChecked(g_ktaCurrentSettings.m_bDeactivated);

	local deactivatedLabel = CreateLabel(deactivatedCheckButton, "Deactivated");
	deactivatedLabel:SetPoint("LEFT", deactivatedCheckButton, "RIGHT", fMarginBetweenButtonsAndLabels, 0.0);

	deactivatedCheckButton:SetScript("OnClick", function()
		ToggleDeactivated();
	end);

	AddListenerEvent(g_interfaceEventsListener, "OnToggleDeactivated", function()
		deactivatedCheckButton:SetChecked(g_ktaCurrentSettings.m_bDeactivated);
	end);

	local deactivateOverrideFrame = CreateOverrideButtons("DeactivateKTA", mainFrame, "LEFT", deactivatedCheckButton, "RIGHT", 180.0, 0.0);
	settingsOverrideStuff["m_bDeactivated"].textLabel = deactivatedLabel;
	settingsOverrideStuff["m_bDeactivated"].buttonsFrame = deactivateOverrideFrame;
	UpdateLabelColorAndButtonsVisibilityIfOverridden("m_bDeactivated");


	-- MUTE DURING COMBAT
	local muteDuringCombatCheckButton = CreateCheckButton("MuteInCombatCheckButton", mainFrame, fCheckButtonsSize);
	muteDuringCombatCheckButton:SetPoint("TOP", deactivatedCheckButton, "BOTTOM", 0.0, -fMarginYBetweenElements);
	muteDuringCombatCheckButton:SetChecked(g_ktaCurrentSettings.m_bMuteDuringCombat);

	local muteDuringCombatLabel = CreateLabel(muteDuringCombatCheckButton, "Mute during Combat");
	muteDuringCombatLabel:SetPoint("LEFT", muteDuringCombatCheckButton, "RIGHT", fMarginBetweenButtonsAndLabels, 0.5);

	muteDuringCombatCheckButton:SetScript("OnClick", function()
		SetOverrideValue("m_bMuteDuringCombat", not g_ktaCurrentSettings.m_bMuteDuringCombat);
	end);

	local muteInCombatOverrideFrame = CreateOverrideButtons("MuteDuringCombat", mainFrame, "LEFT", muteDuringCombatCheckButton, "RIGHT", 180.0, 0.0);
	settingsOverrideStuff["m_bMuteDuringCombat"].textLabel = muteDuringCombatLabel;
	settingsOverrideStuff["m_bMuteDuringCombat"].buttonsFrame = muteInCombatOverrideFrame;
	UpdateLabelColorAndButtonsVisibilityIfOverridden("m_bMuteDuringCombat");


	-- HIDE MINIMAP BUTTON
	local hideMinimapCheckButton = CreateCheckButton("HideMinimapButtonCheckButton", mainFrame, fCheckButtonsSize);
	hideMinimapCheckButton:SetPoint("TOP", muteDuringCombatCheckButton, "BOTTOM", 0.0, -fMarginYBetweenElements);
	hideMinimapCheckButton:SetChecked(g_ktaCurrentSettings.m_minimapButton.hide);

	local hideMinimapLabel = CreateLabel(hideMinimapCheckButton, "Hide minimap button");
	hideMinimapLabel:SetPoint("LEFT", hideMinimapCheckButton, "RIGHT", fMarginBetweenButtonsAndLabels, 0.0);

	hideMinimapCheckButton:SetScript("OnClick", function()
		SetMinimapButtonHidden(not g_ktaCurrentSettings.m_minimapButton.hide);
	end);


	-- MIN MAX DELAY
	local soundChannelLabelAnchor = InitDelayEditBoxes(mainFrame, hideMinimapCheckButton);


	-- SOUND CHANNEL
	local soundChannelLabel = CreateLabel(mainFrame, "Sound channel", buttons);
	soundChannelLabel:SetPoint("TOPLEFT", soundChannelLabelAnchor, "BOTTOMLEFT", -5.0, -10.0 - fMarginYBetweenElements);

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

	local soundChannelOverrideFrame = CreateOverrideButtons("SoundChannel", mainFrame, "LEFT", soundChannelsDropdownList, "RIGHT", 70.0, 2.5);
	settingsOverrideStuff["m_sSoundChannel"].textLabel = soundChannelLabel;
	settingsOverrideStuff["m_sSoundChannel"].buttonsFrame = soundChannelOverrideFrame;
	UpdateLabelColorAndButtonsVisibilityIfOverridden("m_sSoundChannel");


	-- GODS LIST
	InitGodsListSettings(mainFrame, soundChannelsDropdownList, { x = 20.0, y = -8.0 - fMarginYBetweenElements });

	local godsOverrideFrame = CreateOverrideButtons("Gods", mainFrame, "TOP", g_godsListSettings, "BOTTOM", 0.0, 0.0);
	settingsOverrideStuff["m_sGods"].textLabel = g_godsListSettings.godsLabel;
	settingsOverrideStuff["m_sGods"].buttonsFrame = godsOverrideFrame;
	UpdateLabelColorAndButtonsVisibilityIfOverridden("m_sGods");


	-- GLOBAL OVERRIDE BUTTONS
	CreateOverrideButtons("AllSettings", mainFrame, "TOPLEFT", g_godsListSettings, "BOTTOMLEFT", 0.0, -50.0, true);


	-- BIND PANEL TO INTERFACE SETTINGS
	InterfaceOptions_AddCategory(mainFrame);


	InitMinimapButton(mainFrame);
	g_interfaceSettingsFrame.panel = mainFrame;


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
	minDelayLabel:SetPoint("TOPLEFT", minDelayLabelAnchor, "BOTTOMLEFT", 0.0, -10.0 - fMarginYBetweenElements);

	local minDelayEditBox = CreateEditBox("BoxMinDelay", mainFrame, editBoxesSize, true);
	minDelayEditBox:SetPoint("TOPLEFT", minDelayLabel, "BOTTOMLEFT", marginBetweenEditBoxesAndLabels.x, marginBetweenEditBoxesAndLabels.y);

	minDelayEditBox:SetScript("OnSizeChanged", function()	-- OnShow is called before setting the size, so setting a text then is useless; OnSizeChanged guarentees that the box has been initialized
		minDelayEditBox:SetText(g_ktaCurrentSettings.m_iMinDelay);
	end);

	minDelayEditBox:SetScript("OnShow", function()
		minDelayEditBox:SetText(g_ktaCurrentSettings.m_iMinDelay);
	end);


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

	local minMaxDelayOverrideFrame = CreateOverrideButtons("MinMaxDelay", mainFrame, "LEFT", setDelayButton, "RIGHT", 10.5, 0.0);
	settingsOverrideStuff["m_iMinDelay"].textLabel = minDelayLabel;
	settingsOverrideStuff["m_iMinDelay"].buttonsFrame = minMaxDelayOverrideFrame;
	UpdateLabelColorAndButtonsVisibilityIfOverridden("m_iMinDelay");
	settingsOverrideStuff["m_iMaxDelay"].textLabel = maxDelayLabel;
	settingsOverrideStuff["m_iMaxDelay"].buttonsFrame = minMaxDelayOverrideFrame;
	UpdateLabelColorAndButtonsVisibilityIfOverridden("m_iMaxDelay");

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

--[[local]] CreateOverrideButtons = function(sButtonName, frame, sMyAnchor, anchorElement, sParentAnchor, fOffsetX, fOffsetY, bForAllValues)

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

	local setGlobalButton = CreateButton(sButtonName .. "_SetValueGlobalButton", overrideFrame, overrideButtonsSize, sMakeGlobalText);
	setGlobalButton.m_sTooltipText = sMakeGlobalTooltip;
	HookTooltipToElement(setGlobalButton);

	setGlobalButton:SetPoint(sMyAnchor, anchorElement, sParentAnchor, fOffsetX, fOffsetY);

	local revertButton = CreateButton(sButtonName .. "_RevertToGlobalButton", overrideFrame, overrideButtonsSize, sRevertText);
	revertButton.m_sTooltipText = sRevertTooltip;
	HookTooltipToElement(revertButton);

	revertButton:SetPoint("LEFT", setGlobalButton, "RIGHT", -2.0, 0.0);

	return overrideFrame;
end

--[[local]] UpdateLabelColorAndButtonsVisibilityIfOverridden = function(sAssociatedVariableName)

	local textLabel = settingsOverrideStuff[sAssociatedVariableName].textLabel;
	local buttonsFrame = settingsOverrideStuff[sAssociatedVariableName].buttonsFrame;

	if g_ktaCurrentCharSettingsOverrides ~= nil and g_ktaCurrentCharSettingsOverrides[sAssociatedVariableName] ~= nil then
		textLabel:SetTextColor(unpack(overriddenValueLabelColor));
		buttonsFrame:Show();
	else
		textLabel:SetTextColor(1.0, 1.0, 1.0);
		buttonsFrame:Hide();
	end
end
