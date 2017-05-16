
function CreateLabel(panel, name)
	local label = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlight");
	label:SetText(name);
	return label;
end

local prefix = "SaySomething_";

function CreateCheck(panel, name, width, height)
	local chkOpt = CreateFrame("CheckButton", prefix .. name, panel, "OptionsCheckButtonTemplate");
	chkOpt:SetWidth(width);
	chkOpt:SetHeight(height);
	return chkOpt;
end

function CreateEditBox(panel, name, width, height, onlyNumeric, onEnterPressedCallback)
	local editBox = CreateFrame("EditBox", prefix .. name, panel, "InputBoxTemplate");
	editBox:SetAutoFocus(false);
	editBox:SetWidth(width);
	editBox:SetHeight(height);
	editBox:SetNumeric(onlyNumeric);

	editBox:SetScript("OnEnterPressed", function()

		if onEnterPressedCallback ~= nil then
			onEnterPressedCallback();
		end

		editBox:ClearFocus();
		editBox:HighlightText(100, 100);	-- Force highlight removal
	end);
	editBox:SetScript("OnEscapePressed", function()
		editBox:ClearFocus();
		editBox:HighlightText(100, 100);	-- Force highlight removal
	end);

	return editBox;
end

function CreateButton(panel, name, width, text)

	local button = CreateFrame("Button", prefix .. name, panel, "UIPanelButtonTemplate");
	button:SetWidth(width);
	button:SetText(text);

	return button;
end

function CreateTab(panel, width, text, id)

	local tab = CreateFrame("Button", panel:GetName() .. "Tab" .. id, panel, "OptionsFrameTabButtonTemplate");
	tab:SetText(text);
	local newWidth = tab:GetTextWidth();
	--tab:SetWidth(newWidth);
	tab.id = id;
	PanelTemplates_TabResize(tab, newWidth);

	tab:SetScript("OnClick", function()

		for i = 1, #panel.tabFrames do
			if i == id then
				panel.tabFrames[i]:Show();
			else
				panel.tabFrames[i]:Hide();
			end
		end

		PanelTemplates_SetTab(panel, id);
	end);

	return tab;
end

function CreateTabbedWindow(panel, name, width, height, tabsCount, tabsList, tabsNamesList, tabsWidth)

	local mainFrame = CreateFrame("Frame", name, panel);
	mainFrame:SetSize(width, height);

	mainFrame:SetBackdrop(
	{
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		tile = true,
		tileSize = 16,
		edgeSize = 16,
		insets = { left = 4, right = 4, top = 4, bottom = 4 },
	});
	mainFrame:SetBackdropColor(0,0,0,0.5);

	local previousTextSize = 0;

	for i = 1, tabsCount do
		local newTab = CreateTab(mainFrame, tabsWidth, tabsNamesList[i], i);
		newTab:SetPoint("TOPLEFT", previousTextSize, 23);
		previousTextSize = previousTextSize + newTab:GetTextWidth() + 31;
		tabsList[i] = newTab;
	end

	PanelTemplates_SetNumTabs(mainFrame, tabsCount);
	PanelTemplates_SetTab(mainFrame, 1);

	mainFrame.tabFrames = {};
	return mainFrame;
end
