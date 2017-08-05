
local prefix = "PollCraft_";


function MakeFrameMovable(frame)

	frame:SetMovable(true);

	frame:SetScript("OnMouseDown", function(self) self:StartMoving() end);
	frame:SetScript("OnMouseUp", function(self) self:StopMovingOrSizing() end);
end

function MakeFrameClosable(frame, name)

	local closeButton = CreateFrame("Button", prefix .. name, frame, "UIPanelCloseButton");
	closeButton:SetPoint("TOPRIGHT", 0, 0);
end

local function CreateBackdrop(frame, alpha)

	frame:SetBackdrop(
	{
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		tile = true,
		tileSize = 16,
		edgeSize = 16,
		insets = { left = 4, right = 4, top = 4, bottom = 4 },
	});
	frame:SetBackdropColor(0, 0, 0, alpha);
end


function CreateLabel(parent, text, fontSize, alignment)
	local label = parent:CreateFontString(nil, "ARTWORK", "GameFontHighlight");
	label:SetText(text);

	if alignment ~= nil then
		label:SetJustifyH(alignment);
		label:SetJustifyV("TOP");
	end

	if fontSize ~= nil then
		label:SetFont("Fonts\\FRIZQT__.TTF", fontSize);
	end

	return label;
end

function CreateCheckButton(parent, name, onCheckCallback, callbackArguments)
	local checkButton = CreateFrame("CheckButton", prefix .. name, parent, "OptionsCheckButtonTemplate");
	checkButton:SetSize(22, 22);

	if onCheckCallback ~= nil then
		button:SetScript("OnClick", function(self) onCheckCallback(self, callbackArguments) end);
	end

	return checkButton;
end

function CreateRadioCheckButton(parent, name, onCheckCallback, callbackArguments)
	local checkButton = CreateFrame("CheckButton", prefix .. name, parent, "UIRadioButtonTemplate");
	checkButton:SetSize(18, 18);

	if onCheckCallback ~= nil then
		button:SetScript("OnClick", function(self) onCheckCallback(self, callbackArguments) end);
	end

	return checkButton;
end

function CreateEditBox(name, parent, width, height, onlyNumeric, onEnterPressedCallback, callbackArguments, fontSize)
	local scrollFrame = CreateFrame("ScrollFrame", prefix .. name .. "_Scrollframe", parent, "InputScrollFrameTemplate");
	scrollFrame:SetSize(width, height);

	local editBox = scrollFrame.EditBox;
	editBox:SetMultiLine(true);
	editBox:SetAutoFocus(false);
	editBox:SetSize(width, height);
	editBox:SetNumeric(onlyNumeric);
	editBox:SetMaxLetters(125);
	if fontSize ~= nil then
		editBox:SetFont("Fonts\\FRIZQT__.TTF", fontSize);
	end

	editBox:SetScript("OnEnterPressed", function()

		if onEnterPressedCallback ~= nil then
			onEnterPressedCallback(callbackArguments);
		end

		editBox:ClearFocus();
		editBox:HighlightText(0, 0);	-- Forces highlight removal
	end);
	editBox:SetScript("OnEscapePressed", function()

		if onEnterPressedCallback ~= nil then
			onEnterPressedCallback(callbackArguments);
		end

		editBox:ClearFocus();
		editBox:HighlightText(0, 0);	-- Forces highlight removal
	end);

	return scrollFrame;
end

function CreateDropDownList(name, parent, width, options, buttonSelectedCallback)
	local dropDownList = CreateFrame("Frame", prefix .. name, parent, "UIDropDownMenuTemplate");
	UIDropDownMenu_SetWidth(dropDownList, width);

	UIDropDownMenu_Initialize(dropDownList, function(self)

		local buttons = UIDropDownMenu_CreateInfo();
		buttons.func = function(self)
			UIDropDownMenu_SetSelectedValue(dropDownList, self.value, false);
			if buttonSelectedCallback ~= nil then
				buttonSelectedCallback(self.value);
			end
			CloseDropDownMenus();
		end;

		for i = 1, #options do
			buttons.text = options[i].text;
			buttons.value = options[i].value;
			buttons.checked = false;
			UIDropDownMenu_AddButton(buttons);
		end
	end);

	return dropDownList;
end

function CreateButton(name, parent, width, height, text, onClickCallback, callbackArguments)

	local button = CreateFrame("Button", prefix .. name, parent, "UIPanelButtonTemplate");
	button:SetSize(width, height);
	button:SetText(text);

	if onClickCallback ~= nil then
		button:SetScript("OnClick", function(self) onClickCallback(self, callbackArguments) end);
	end

	return button;
end

function CreateIconButton(name, parent, size, iconUp, iconDown, iconHighlight, onClickCallback, callbackArguments)

	local button = CreateFrame("Button", prefix .. name, parent);
	button:SetSize(size, size);
	button:SetNormalTexture(iconUp);
	button:SetPushedTexture(iconDown);
	button:SetHighlightTexture(iconHighlight);

	if onClickCallback ~= nil then
		button:SetScript("OnClick", function() onClickCallback(callbackArguments) end);
	end

	return button;
end

function CreateBackdroppedFrame(name, parent, width, height, movable)

	local newFrame = CreateFrame("Frame", prefix .. name, parent);
	newFrame:SetSize(width, height);

	CreateBackdrop(newFrame, 0.5);

	if movable then
		MakeFrameMovable(newFrame);
	end

	return newFrame;
end

local function CreateScrollbar(scrollFrame)

	scrollbar = CreateFrame("Slider", nil, scrollFrame, "UIPanelScrollBarTemplate");
	scrollbar:SetPoint("TOPLEFT", scrollFrame, "TOPRIGHT", -22, -22);
	scrollbar:SetPoint("BOTTOMLEFT", scrollFrame, "BOTTOMRIGHT", -22, 22);
	scrollbar:SetMinMaxValues(0, 200);
	scrollbar:SetValueStep(1);
	scrollbar.scrollStep = 1;
	scrollbar:SetValue(0);
	scrollbar:SetWidth(16);

	scrollbar:SetScript("OnValueChanged", function (self, value)
		scrollFrame:SetVerticalScroll(value);
	end);

	local scrollBarBG = scrollbar:CreateTexture(nil, "BACKGROUND");
	scrollBarBG:SetAllPoints(scrollbar);
	scrollBarBG:SetTexture(0, 0, 0, 0.4);

	CreateBackdrop(scrollbar, 0.5);

	return scrollbar;
end

function UpdateScrollBar(scrollFrame, contentHeight)

	scrollbar = scrollFrame.scrollbar;
	local scrollFrameHeight = scrollFrame:GetHeight() - 20;
	scrollbar:SetMinMaxValues(0, math.max(1, contentHeight - scrollFrameHeight));
	if contentHeight <= scrollFrameHeight then
		scrollbar:Hide();
	else
		scrollbar:Show();
	end
end

function CreateScrollFrame(name, parent, width, height)

	local scrollableFrame = CreateFrame("ScrollFrame", prefix .. name, parent);
	CreateBackdrop(scrollableFrame, 0.5);
	scrollableFrame:SetSize(width, height);
	scrollableFrame:SetHitRectInsets(4, 4, 4, 4);

	scrollableFrame.scrollbar = CreateScrollbar(scrollableFrame);
	scrollableFrame.scrollbar:Hide();
	scrollableFrame.content = CreateFrame("Frame", prefix .. name .. "_Content", scrollableFrame);
	scrollableFrame.content:SetSize(width, height);
	scrollableFrame:SetScrollChild(scrollableFrame.content);

	local mouseWheelFrameCapture = CreateFrame("Frame", prefix .. name .. "_MouseWheelCapture", scrollableFrame);
	mouseWheelFrameCapture:SetSize(width, height);
	mouseWheelFrameCapture:SetAllPoints(true);
	mouseWheelFrameCapture:SetFrameLevel(scrollableFrame:GetFrameLevel() + 2);
	mouseWheelFrameCapture:EnableMouseWheel(true);

	mouseWheelFrameCapture:SetScript("OnMouseWheel", function(self, delta)

		local scrollFrame = self:GetParent();
		if not scrollFrame.scrollbar:IsVisible() then
			return;
		end

		local newValue = math.Clamp(scrollFrame:GetVerticalScroll() - (delta * 40), scrollFrame.scrollbar:GetMinMaxValues());
		scrollFrame.scrollbar:SetValue(newValue);
	end);

	scrollableFrame.mouseWheelFrameCapture = mouseWheelFrameCapture;

	return scrollableFrame;
end


local function CreateTab(parent, width, text, id)

	local tab = CreateFrame("Button", parent:GetName() .. "Tab" .. id, parent, "OptionsFrameTabButtonTemplate");
	tab:SetText(text);
	local newWidth = tab:GetTextWidth();
	tab.id = id;
	PanelTemplates_TabResize(tab, newWidth);

	tab:SetScript("OnClick", function()

		for i = 1, #parent.tabFrames do
			if i == id then
				parent.tabFrames[i]:Show();
			else
				parent.tabFrames[i]:Hide();
			end
		end

		PanelTemplates_SetTab(parent, id);
	end);

	return tab;
end

function CreateTabbedFrame(name, parent, width, height, tabsList, tabsNamesList)

	local mainFrame = CreateBackdroppedFrame(name, parent, width, height);

	local previousTextSize = 0;

	for i = 1, #tabsNamesList do
		local newTab = CreateTab(mainFrame, 10, tabsNamesList[i], i);	-- '10' is placeholder width for tabs, before they get resized
		newTab:SetPoint("TOPLEFT", previousTextSize, 23);
		previousTextSize = previousTextSize + newTab:GetTextWidth() + 31;
		tabsList[i] = newTab;
	end

	PanelTemplates_SetNumTabs(mainFrame, #tabsNamesList);
	PanelTemplates_SetTab(mainFrame, 1);

	mainFrame.tabFrames = {};

	mainFrame:Hide();	-- Workaround to update tabs sizes
	mainFrame:Show();
	return mainFrame;
end
