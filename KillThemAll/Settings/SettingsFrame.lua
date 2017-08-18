
g_cerberus.HookThisFile();

local g_interfaceSettingsFrame = {};
g_interfaceEventsListener = {};


local InitDelayEditBoxes = nil;
local function SoundChannelDropDownListCheckButtonsVerifier(sValue)
	return g_ktaOptions.sSoundChannel == sValue;
end


function OpenSettingsPanel()

	InterfaceOptionsFrame_OpenToCategory("KillThemAll");
	InterfaceOptionsFrame_OpenToCategory("KillThemAll");	-- Twice because once only opens the menu, not the right category, for some reason
end


function InitSettingsFrames()

	local mainFrame = CreateFrame("Frame", "KTA_InterfaceSettingsFrame", UIParent);
	mainFrame.name = "KillThemAll";


	local fCheckButtonsSize = 20;
	local fMarginBetweenButtonsAndLabels = 3;

	-- DEACTIVATED
	local deactivatedCheckButtonPos = { x = 60, y = -45 };
	local deactivatedCheckButton = CreateCheckButton("DeactivateCheckButton", mainFrame, fCheckButtonsSize);
	deactivatedCheckButton:SetPoint("TOPLEFT", deactivatedCheckButtonPos.x, deactivatedCheckButtonPos.y);
	deactivatedCheckButton:SetChecked(g_ktaOptions.bDeactivated);

	local deactivatedLabel = CreateLabel(deactivatedCheckButton, "Deactivated");
	deactivatedLabel:SetPoint("LEFT", deactivatedCheckButton, "RIGHT", fMarginBetweenButtonsAndLabels, 0);

	deactivatedCheckButton:SetScript("OnClick", function()
		ToggleDeactivated();
	end);

	AddListenerEvent(g_interfaceEventsListener, "OnToggleDeactivated", function()
		deactivatedCheckButton:SetChecked(g_ktaOptions.bDeactivated);
	end);


	-- MUTE DURING COMBAT
	local muteDuringCombatCheckButton = CreateCheckButton("MuteInCombatCheckButton", mainFrame, fCheckButtonsSize);
	muteDuringCombatCheckButton:SetPoint("TOP", deactivatedCheckButton, "BOTTOM", 0, 0);
	muteDuringCombatCheckButton:SetChecked(g_ktaOptions.bMuteDuringCombat);

	local muteDuringCombatLabel = CreateLabel(muteDuringCombatCheckButton, "Mute during Combat");
	muteDuringCombatLabel:SetPoint("LEFT", muteDuringCombatCheckButton, "RIGHT", fMarginBetweenButtonsAndLabels, 0.5);

	muteDuringCombatCheckButton:SetScript("OnClick", function()
		g_ktaOptions.bMuteDuringCombat = not g_ktaOptions.bMuteDuringCombat;
	end);


	-- HIDE MINIMAP BUTTON
	local hideMinimapCheckButton = CreateCheckButton("HideMinimapButtonCheckButton", mainFrame, fCheckButtonsSize);
	hideMinimapCheckButton:SetPoint("TOP", muteDuringCombatCheckButton, "BOTTOM", 0, 0);
	hideMinimapCheckButton:SetChecked(g_ktaOptions.minimapButton.hide);

	local hideMinimapLabel = CreateLabel(hideMinimapCheckButton, "Hide minimap button");
	hideMinimapLabel:SetPoint("LEFT", hideMinimapCheckButton, "RIGHT", fMarginBetweenButtonsAndLabels, 0);

	hideMinimapCheckButton:SetScript("OnClick", function()
		SetMinimapButtonHidden(not g_ktaOptions.minimapButton.hide);
	end);


	-- MIN MAX DELAY
	local soundChannelLabelAnchor = InitDelayEditBoxes(mainFrame, hideMinimapCheckButton);


	-- SOUND CHANNEL
	local soundChannelLabel = CreateLabel(mainFrame, "Sound channel", buttons);
	soundChannelLabel:SetPoint("TOPLEFT", soundChannelLabelAnchor, "BOTTOMLEFT", -5, -10);

	local availableSoundChannels = table.Clone(GetAvailableSoundChannels());
	availableSoundChannels["DEFAULT"] = nil;
	local optionsForList = {};
	for sKey, sValue in pairs(availableSoundChannels) do
		table.insert(optionsForList, { sText = sValue, value = sKey });
	end
	local soundChannelsDropdownList = CreateDropDownList("SoundChannelsList", mainFrame, 100, optionsForList, g_ktaOptions.sSoundChannel, SetSoundChannel, { true, true }, SoundChannelDropDownListCheckButtonsVerifier);
	soundChannelsDropdownList:SetPoint("TOPLEFT", soundChannelLabel, "BOTTOMLEFT", -20, -5);
	AddListenerEvent(g_interfaceEventsListener, "OnSoundChannelChanged", function()
		UIDropDownMenu_SetText(soundChannelsDropdownList, g_ktaOptions.sSoundChannel);
	end);


	-- GODS LIST
	InitGodsListSettings(mainFrame, soundChannelsDropdownList, { x = 20, y = -8 });


	-- BIND PANEL TO INTERFACE SETTINGS
	InterfaceOptions_AddCategory(mainFrame);


	InitMinimapButton(mainFrame);
	g_interfaceSettingsFrame.panel = mainFrame;
end


local SetDelayButtonCallback = nil;

-- MIN MAX DELAY FUNCTION
--[[local]] InitDelayEditBoxes = function(mainFrame, minDelayLabelAnchor)

	local editBoxesSize = { x = 60, y = 20 };
	local marginBetweenEditBoxesAndLabels = { x = 5, y = -5 };

	-- MIN DELAY
	local minDelayLabel = CreateLabel(mainFrame, "Min delay");
	minDelayLabel:SetPoint("TOPLEFT", minDelayLabelAnchor, "BOTTOMLEFT", 0, -10);

	local minDelayEditBox = CreateEditBox("BoxMinDelay", mainFrame, editBoxesSize, true);
	minDelayEditBox:SetPoint("TOPLEFT", minDelayLabel, "BOTTOMLEFT", marginBetweenEditBoxesAndLabels.x, marginBetweenEditBoxesAndLabels.y);

	minDelayEditBox:SetScript("OnSizeChanged", function()	-- OnShow is called before setting the size, so setting a text then is useless; OnSizeChanged guarentees that the box has been initialized
		minDelayEditBox:SetText(g_ktaOptions.iMinDelay);
	end);

	minDelayEditBox:SetScript("OnShow", function()
		minDelayEditBox:SetText(g_ktaOptions.iMinDelay);
	end);


	-- MAX DELAY
	local maxDelayLabel = CreateLabel(mainFrame, "Max delay");
	maxDelayLabel:SetPoint("LEFT", minDelayLabel, "RIGHT", 15, 0);

	local maxDelayEditBox = CreateEditBox("BoxMaxDelay", mainFrame, editBoxesSize, true);
	maxDelayEditBox:SetPoint("TOPLEFT", maxDelayLabel, "BOTTOMLEFT", marginBetweenEditBoxesAndLabels.x, marginBetweenEditBoxesAndLabels.y);

	maxDelayEditBox:SetScript("OnSizeChanged", function()	-- OnShow is called before setting the size, so setting a text then is useless; OnSizeChanged guarentees that the box has been initialized
		maxDelayEditBox:SetText(g_ktaOptions.iMaxDelay);
	end);

		maxDelayEditBox:SetScript("OnShow", function()
		maxDelayEditBox:SetText(g_ktaOptions.iMaxDelay);
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
		minDelayEditBox:SetText(g_ktaOptions.iMinDelay);
		maxDelayEditBox:SetText(g_ktaOptions.iMaxDelay);
	end);


	-- OK BUTTON
	local setDelayButton = CreateButton("DelayOKButton", mainFrame, { x = 80, y = 30 }, "Set delay", SetDelayButtonCallback, { minDelayEditBox, maxDelayEditBox });
	setDelayButton:SetPoint("BOTTOMLEFT", maxDelayEditBox, "BOTTOMRIGHT", 15, 0);

	return minDelayEditBox;
end

--[[local]] SetDelayButtonCallback = function(self, minEditBox, maxEditBox)

	local iNewMin = minEditBox:GetNumber();
	local iNewMax = maxEditBox:GetNumber();

	if iNewMin == g_ktaOptions.iMinDelay and iNewMax == g_ktaOptions.iMaxDelay then
		return;
	end

	SetDelay(iNewMin, iNewMax);
end
