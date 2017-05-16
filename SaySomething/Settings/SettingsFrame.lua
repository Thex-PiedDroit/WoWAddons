
g_SaySomethingSettingsFrame = {};


local InitializeSpellsItems = nil;

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


	-- SPECS TABBED WINDOW

	local specsTabs = {};

	local specsCount = GetNumSpecializations();
	local specsNames = {};
	for i = 1, specsCount do
		local _, tabName = GetSpecializationInfo(i);
		table.insert(specsNames, tabName);
	end
	local specsWindow = CreateTabbedWindow(settingsWindow, "SaySomething_SpecsWindow", 540, 450, specsCount, specsTabs, specsNames, 60);
	specsWindow:SetPoint("TOPLEFT", 20, -40);
	settingsWindow.tabFrames[1] = specsWindow;

	for i = 1, specsCount do
		local currentSpecWindow = CreateScrollFrame(specsWindow, "SaySomething_SpecsWindow_Spec" .. i, 540, 450);
		currentSpecWindow:SetPoint("TOPLEFT", 0, -4);
		currentSpecWindow.specName = specsNames[i];
		currentSpecWindow.spellsList = {};
		specsWindow.tabFrames[i] = currentSpecWindow;

		if i ~= 1 then
			currentSpecWindow:Hide();
		end
	end


	InitializeSpellsItems(specsWindow.tabFrames);


	-- BIND PANEL TO INTERFACE SETTINGS
	InterfaceOptions_AddCategory(g_SaySomethingSettingsFrame.panel);
end


InitializeSpellsItems = function(specsWindows)

	local playerName = GetUnitName("player", true);
	local specsListData = S_settings.charactersList[playerName] or {};

	local columnsCount = 2;
	local itemSizeX = 150;
	local itemSizeY = g_iconSize;
	local offset = 20;		-- Vertical and horizontal
	local itemsMarginHorizontal = 100;
	local itemsMarginVertical = 20;


		-- INIT ALL SPECS TABS
	for i = 1, #specsWindows do

		local currentWindow = specsWindows[i];
		local specSpellsListData = specsListData[currentWindow.specName] or {};
		local spellsCount = #specSpellsListData;

			-- INIT ALL SPELLS ITEMS
		for j = 1, spellsCount do
			local newGraphicalItem = CreateGraphicalSpellSayingItem(currentWindow.content, specSpellsListData[j]);

			local x = (j - 1) % columnsCount;
			local y = -math.floor((j - 1) / columnsCount);
			newGraphicalItem.mainFrame:SetPoint("TOPLEFT", offset + (x * (itemSizeX + itemsMarginHorizontal)), (y * (itemSizeY + itemsMarginVertical)) - offset);
			currentWindow.spellsList[j] = newGraphicalItem.mainFrame;
		end

			-- LAST ITEM (PLUS SIGN)
		local plusItem = CreateGraphicalSpellSayingItem(currentWindow.content, nil);	-- Create "plus" item

		local x = spellsCount % columnsCount;
		local y = -math.floor(spellsCount / columnsCount);

		plusItem.mainFrame:SetPoint("TOPLEFT", offset + (x * (itemSizeX + itemsMarginHorizontal)), (y * (itemSizeY + itemsMarginVertical)) - offset);
		currentWindow.spellsList[spellsCount + 1] = plusItem.mainFrame;
	end
end
