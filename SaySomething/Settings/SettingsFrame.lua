
g_SaySomethingSettingsFrame = {};


function InitSaySomethingSettingsFrame()

	-- CONTAINING FRAME
	g_SaySomethingSettingsFrame.panel = CreateFrame("Frame", "SaySomethingSettingsFrame", UIParent);
	g_SaySomethingSettingsFrame.panel.name = "SaySomething";

	g_SaySomethingSettingsFrame.panel:SetScript("OnSizeChanged", function()
		InterfaceOptionsFrame_OpenToCategory("SaySomething");	-- Doing that to fix the tabs size, which make weird stuff otherwise
	end);


	-- MAIN CONTAINING WINDOW

	local mainWindowTabs = {};
	local settingsWindow = CreateTabbedWindow(g_SaySomethingSettingsFrame.panel, "SaySomething_SettingsFrame", 580, 510, 2, mainWindowTabs, { "Spells", "SpellNameHere" }, 20);
	settingsWindow:SetPoint("TOPLEFT", 20, -40);
	mainWindowTabs[2]:Hide();	-- This one is created beforehand but will be filled and shown when needed. When not active as the current tab, it should not be visible


	-- BIND PANEL TO INTERFACE SETTINGS
	InterfaceOptions_AddCategory(g_SaySomethingSettingsFrame.panel);
end
