
local g_interfaceSettingsFrame = {};
g_interfaceEventsListener = {};


local InitDelayEditBoxes = nil;	-- Forward declaration
local InitSoundChannelDropDownList = nil;


function InitSettingsFrames()
	g_interfaceSettingsFrame.panel = CreateFrame("Frame", "KTA_InterfaceSettingsFrame", UIParent);
	g_interfaceSettingsFrame.panel.name = "KillThemAll Settings";


	-- DEACTIVATED
	g_interfaceSettingsFrame.lab = CreateLabel(g_interfaceSettingsFrame.panel, "Deactivated");
	g_interfaceSettingsFrame.lab:SetPoint("TOPLEFT", 80, -48);
	g_interfaceSettingsFrame.chkDeact = CreateCheck(g_interfaceSettingsFrame.panel, "chkDeactivate", 20, 20);
	g_interfaceSettingsFrame.chkDeact:SetPoint("TOPLEFT", 60, -45);
	g_interfaceSettingsFrame.chkDeact:SetChecked(g_ktaOptions.deactivated);

	g_interfaceSettingsFrame.chkDeact:SetScript("OnClick", function()
		ToggleDeactivated();
	end);

	AddListenerEvent(g_interfaceEventsListener, "OnToggleDeactivated", function()
		g_interfaceSettingsFrame.chkDeact:SetChecked(g_ktaOptions.deactivated);
	end);


	-- MUTE DURING COMBAT
	g_interfaceSettingsFrame.lab = CreateLabel(g_interfaceSettingsFrame.panel, "Mute during Combat");
	g_interfaceSettingsFrame.lab:SetPoint("TOPLEFT", 80, -68);
	g_interfaceSettingsFrame.chkCombat = CreateCheck(g_interfaceSettingsFrame.panel, "chkMuteInCombat", 20, 20);
	g_interfaceSettingsFrame.chkCombat:SetPoint("TOPLEFT", 60, -65);
	g_interfaceSettingsFrame.chkCombat:SetChecked(g_ktaOptions.muteDuringCombat);

	g_interfaceSettingsFrame.chkCombat:SetScript("OnClick", function()
		g_ktaOptions.muteDuringCombat = not g_ktaOptions.muteDuringCombat;
	end);


	-- HIDE MINIMAP BUTTON
	g_interfaceSettingsFrame.lab = CreateLabel(g_interfaceSettingsFrame.panel, "Hide minimap button");
	g_interfaceSettingsFrame.lab:SetPoint("TOPLEFT", 80, -88);
	g_interfaceSettingsFrame.chkMiniMapButton = CreateCheck(g_interfaceSettingsFrame.panel, "chkHideMinimapButton", 20, 20);
	g_interfaceSettingsFrame.chkMiniMapButton:SetPoint("TOPLEFT", 60, -85);
	g_interfaceSettingsFrame.chkMiniMapButton:SetChecked(g_ktaOptions.minimapButton.hide);

	g_interfaceSettingsFrame.chkMiniMapButton:SetScript("OnClick", function()
		SetMinimapButtonHidden(not g_ktaOptions.minimapButton.hide);
	end);


	-- MIN MAX DELAY
	g_interfaceSettingsFrame.lab = CreateLabel(g_interfaceSettingsFrame.panel, "Min delay");
	g_interfaceSettingsFrame.lab:SetPoint("TOPLEFT", 60, -118);
	g_interfaceSettingsFrame.lab = CreateLabel(g_interfaceSettingsFrame.panel, "Max delay");
	g_interfaceSettingsFrame.lab:SetPoint("TOPLEFT", 140, -118);
	InitDelayEditBoxes();


	-- SOUND CHANNEL
	g_interfaceSettingsFrame.lab = CreateLabel(g_interfaceSettingsFrame.panel, "Sound channel", buttons);
	g_interfaceSettingsFrame.lab:SetPoint("TOPLEFT", 60, -165);
	g_interfaceSettingsFrame.listSoundChan = CreateDropDownList(g_interfaceSettingsFrame.panel, "listSoundChannel", 100);
	g_interfaceSettingsFrame.listSoundChan:SetPoint("TOPLEFT", 40, -180);
	InitSoundChannelDropDownList(g_interfaceSettingsFrame.listSoundChan);


	-- GODS LIST
	InitGodsListSettings(g_interfaceSettingsFrame);


	-- BIND PANEL TO INTERFACE SETTINGS
	InterfaceOptions_AddCategory(g_interfaceSettingsFrame.panel);

	InitMinimapButton(g_interfaceSettingsFrame.panel);
end


-- MIN MAX DELAY FUNCTION
InitDelayEditBoxes = 	function()

	-- MIN DELAY
	g_interfaceSettingsFrame.boxMin = CreateEditBox(g_interfaceSettingsFrame.panel, "boxMinDelay", 60, 20, true);
	g_interfaceSettingsFrame.boxMin:SetPoint("TOPLEFT", 65, -135);

	g_interfaceSettingsFrame.boxMin:SetScript("OnSizeChanged", function()	-- OnShow is called before setting the size, so setting a text then is useless; OnSizeChanged guarentees that the box has been initialized
		g_interfaceSettingsFrame.boxMin:SetText(g_ktaOptions.minDelay);
	end);

	g_interfaceSettingsFrame.boxMin:SetScript("OnShow", function()
		g_interfaceSettingsFrame.boxMin:SetText(g_ktaOptions.minDelay);
	end);

	-- MAX DELAY
	g_interfaceSettingsFrame.boxMax = CreateEditBox(g_interfaceSettingsFrame.panel, "boxMaxDelay", 60, 20, true, onMaxDelayEnterPressedCallback);
	g_interfaceSettingsFrame.boxMax:SetPoint("TOPLEFT", 145, -135);

	g_interfaceSettingsFrame.boxMax:SetScript("OnSizeChanged", function()	-- OnShow is called before setting the size, so setting a text then is useless; OnSizeChanged guarentees that the box has been initialized
		g_interfaceSettingsFrame.boxMax:SetText(g_ktaOptions.maxDelay);
	end);

		g_interfaceSettingsFrame.boxMax:SetScript("OnShow", function()
		g_interfaceSettingsFrame.boxMax:SetText(g_ktaOptions.maxDelay);
	end);


	-- TAB BEHAVIOUR
	g_interfaceSettingsFrame.boxMin:SetScript("OnTabPressed", function()
		g_interfaceSettingsFrame.boxMin:ClearFocus();
		g_interfaceSettingsFrame.boxMin:HighlightText(100, 100);	-- Force highlight removal

		g_interfaceSettingsFrame.boxMax:SetFocus();
		g_interfaceSettingsFrame.boxMax:HighlightText();
	end);
	g_interfaceSettingsFrame.boxMax:SetScript("OnTabPressed", function()
		g_interfaceSettingsFrame.boxMax:ClearFocus();
		g_interfaceSettingsFrame.boxMax:HighlightText(100, 100);	-- Force highlight removal

		g_interfaceSettingsFrame.boxMin:SetFocus();
		g_interfaceSettingsFrame.boxMin:HighlightText();
	end);


	AddListenerEvent(g_interfaceEventsListener, "OnDelayChanged", function()
		g_interfaceSettingsFrame.boxMin:SetText(g_ktaOptions.minDelay);
		g_interfaceSettingsFrame.boxMax:SetText(g_ktaOptions.maxDelay);
	end);


	-- OK BUTTON
	g_interfaceSettingsFrame.buttonDelay = CreateButton(g_interfaceSettingsFrame.panel, "delayOKButton", 80, "Set delay");
	g_interfaceSettingsFrame.buttonDelay:SetPoint("TOPLEFT", 215, -134);

	g_interfaceSettingsFrame.buttonDelay:SetScript("OnClick", function()

		local newMin = g_interfaceSettingsFrame.boxMin:GetNumber();
		local newMax = g_interfaceSettingsFrame.boxMax:GetNumber();

		if newMin == g_ktaOptions.minDelay and newMax == g_ktaOptions.maxDelay then
			return;
		end

		SetDelay(newMin, newMax);
	end);
end

-- INIT SOUNDCHANNEL DROPDOWN LIST FUNCTION
InitSoundChannelDropDownList = function(list)

	UIDropDownMenu_Initialize(list, function(self)

		local buttons = UIDropDownMenu_CreateInfo();
		buttons.func = function(self)
			UIDropDownMenu_SetText(list, self.value);
			SetSoundChannel(self.value, true, true);
			CloseDropDownMenus();
		end;
		buttons.text = "Master";
		buttons.value = "Master";
		buttons.checked = g_ktaOptions.soundChannel == buttons.text;
		UIDropDownMenu_AddButton(buttons);
		buttons.text = "Sound";
		buttons.value = "Sound";
		buttons.checked = g_ktaOptions.soundChannel == buttons.text;
		UIDropDownMenu_AddButton(buttons);
		buttons.text = "Music";
		buttons.value = "Music";
		buttons.checked = g_ktaOptions.soundChannel == buttons.text;
		UIDropDownMenu_AddButton(buttons);
		buttons.text = "Ambience";
		buttons.value = "Ambience";
		buttons.checked = g_ktaOptions.soundChannel == buttons.text;
		UIDropDownMenu_AddButton(buttons);
		buttons.text = "Dialog";
		buttons.value = "Dialog";
		buttons.checked = g_ktaOptions.soundChannel == buttons.text;
		UIDropDownMenu_AddButton(buttons);
	end);

	UIDropDownMenu_SetText(g_interfaceSettingsFrame.listSoundChan, g_ktaOptions.soundChannel);
	AddListenerEvent(g_interfaceEventsListener, "OnSoundChannelChanged", function()
		UIDropDownMenu_SetText(g_interfaceSettingsFrame.listSoundChan, g_ktaOptions.soundChannel);
	end);
end
