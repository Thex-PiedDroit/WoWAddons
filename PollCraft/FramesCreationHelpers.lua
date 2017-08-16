
Cerberus_HookThisFile();

local sPrefix = "PollCraft_";


function GetFrameSizeAsTable(frame)

	local fWidth, fHeight = frame:GetSize();
	return { x = fWidth, y = fHeight };
end

local function MakeFrameMovable(frame)

	frame:SetMovable(true);

	frame:SetScript("OnMouseDown", function(self) self:StartMoving() end);
	frame:SetScript("OnMouseUp", function(self) self:StopMovingOrSizing() end);
end

function MakeFrameClosable(frame, sName, OnCloseCallback)

	local closeButton = CreateFrame("Button", sPrefix .. sName, frame, "UIPanelCloseButton");
	closeButton:SetPoint("TOPRIGHT", 0, 0);

	if OnCloseCallback ~= nil then
		closeButton:SetScript("OnClick", OnCloseCallback);
	end
end

local function CreateBackdrop(frame, fAlpha)

	frame:SetBackdrop(
	{
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		tile = true,
		tileSize = 16,
		edgeSize = 16,
		insets = { left = 4, right = 4, top = 4, bottom = 4 },
	});
	frame:SetBackdropColor(0, 0, 0, fAlpha);
end


function CreateLabel(parent, sText, fFontSize, sAlignment)
	local label = parent:CreateFontString(nil, "ARTWORK", "GameFontHighlight");
	label:SetText(sText);

	if sAlignment ~= nil then
		label:SetJustifyH(sAlignment);
		label:SetJustifyV("TOP");
	end

	if fFontSize ~= nil then
		label:SetFont("Fonts\\FRIZQT__.TTF", fFontSize);
	end

	return label;
end

function CreateCheckButton(sName, parent, OnCheckCallback, callbackArguments, fSize)
	local checkButton = CreateFrame("CheckButton", sPrefix .. sName, parent, "OptionsCheckButtonTemplate");
	fSize = fSize or 22;
	checkButton:SetSize(fSize, fSize);

	if OnCheckCallback ~= nil then
		button:SetScript("OnClick", function(self) OnCheckCallback(self, callbackArguments) end);
	end

	return checkButton;
end

function CreateRadioCheckButton(sName, parent, OnCheckCallback, callbackArguments, fSize)
	local checkButton = CreateFrame("CheckButton", sPrefix .. sName, parent, "UIRadioButtonTemplate");
	fSize = fSize or 18;
	checkButton:SetSize(fSize, fSize);

	if OnCheckCallback ~= nil then
		button:SetScript("OnClick", function(self) OnCheckCallback(self, callbackArguments) end);
	end

	return checkButton;
end

function CreateEditBox(sName, parent, size, bOnlyNumeric, OnEnterPressedCallback, callbackArguments, fFontSize)
	local scrollFrame = CreateFrame("ScrollFrame", sPrefix .. sName .. "_Scrollframe", parent, "InputScrollFrameTemplate");
	scrollFrame:SetSize(size.x, size.y);

	local editBox = scrollFrame.EditBox;
	editBox:SetMultiLine(true);
	editBox:SetAutoFocus(false);
	editBox:SetSize(size.x, size.y);
	editBox:SetNumeric(bOnlyNumeric);
	editBox:SetMaxLetters(125);
	if fFontSize ~= nil then
		editBox:SetFont("Fonts\\FRIZQT__.TTF", fFontSize);
	end

	editBox:SetScript("OnEnterPressed", function()

		if OnEnterPressedCallback ~= nil then
			OnEnterPressedCallback(callbackArguments);
		end

		editBox:ClearFocus();
		editBox:HighlightText(0, 0);	-- Forces highlight removal
	end);
	editBox:SetScript("OnEscapePressed", function()

		if OnEnterPressedCallback ~= nil then
			OnEnterPressedCallback(callbackArguments);
		end

		editBox:ClearFocus();
		editBox:HighlightText(0, 0);	-- Forces highlight removal
	end);

	return scrollFrame;
end

function CreateDropDownList(sName, parent, fWidth, options, OnButtonSelectedCallback)
	local dropDownList = CreateFrame("Frame", sPrefix .. sName, parent, "UIDropDownMenuTemplate");
	UIDropDownMenu_SetWidth(dropDownList, fWidth);

	UIDropDownMenu_Initialize(dropDownList, function(self)

		local buttons = UIDropDownMenu_CreateInfo();
		buttons.func = function(self)
			UIDropDownMenu_SetSelectedValue(dropDownList, self.value, false);
			if OnButtonSelectedCallback ~= nil then
				OnButtonSelectedCallback(self.value);
			end
			CloseDropDownMenus();
		end;

		for i = 1, #options do
			buttons.text = options[i].sText;
			buttons.value = options[i].value;
			buttons.checked = false;
			UIDropDownMenu_AddButton(buttons);
		end
	end);

	return dropDownList;
end

function CreateButton(sName, parent, size, sText, OnClickCallback, callbackArguments, sTemplate)

	sTemplate = sTemplate or "UIPanelButtonTemplate";
	local button = CreateFrame("Button", sPrefix .. sName, parent, sTemplate);
	button:SetSize(size.x, size.y);
	button:SetText(sText);

	if OnClickCallback ~= nil then
		button:SetScript("OnClick", function(self) OnClickCallback(self, callbackArguments) end);
	end

	return button;
end

function CreateIconButton(sName, parent, size, iconUp, iconDown, iconHighlight, OnClickCallback, callbackArguments)

	local button = CreateFrame("Button", sPrefix .. sName, parent);
	button:SetSize(size, size);
	button:SetNormalTexture(iconUp);
	button:SetPushedTexture(iconDown);
	button:SetHighlightTexture(iconHighlight);

	if OnClickCallback ~= nil then
		button:SetScript("OnClick", function() OnClickCallback(callbackArguments) end);
	end

	return button;
end

function CreateBackdroppedFrame(sName, parent, size, bMovable)

	local newFrame = CreateFrame("Frame", sPrefix .. sName, parent);
	newFrame:SetSize(size.x, size.y);

	CreateBackdrop(newFrame, 0.5);

	if bMovable then
		MakeFrameMovable(newFrame);
	end

	return newFrame;
end

local fTitleFramesMargin = 0;
local fTitleFontSize = 20;
local fInnerFramesMargin = GetInnerFramesMargin();

function CreateBackdroppedTitle(sName, parent, sTitle)

	if fTitleFramesMargin == 0 then
		fTitleFramesMargin = fInnerFramesMargin * 2;
	end

	local titleFrame = CreateBackdroppedFrame(sName, parent, { x = 300, y = 35 });	-- '300' is placeholder before resizing with text size
	local mainFrameTitle = CreateLabel(titleFrame, sTitle, fTitleFontSize);
	titleFrame:SetWidth(mainFrameTitle:GetWidth() + fTitleFramesMargin);
	mainFrameTitle:SetPoint("CENTER", 0, 0);

	return titleFrame;
end

function CreateBackdropTitledInnerFrame(sName, parent, sTitle)

	local fParentFrameSizeX, fParentFrameSizeY = parent:GetSize();
	local innerFrameSize =
	{
		x = fParentFrameSizeX - (fInnerFramesMargin * 2),
		y = fParentFrameSizeY - (fInnerFramesMargin * 10)
	};

	local innerFrame = CreateBackdroppedFrame(sName, parent, innerFrameSize);
	innerFrame:SetPoint("BOTTOM", 0, fInnerFramesMargin);

	local titleFrame = CreateBackdroppedTitle(sName .. "Title", innerFrame, sTitle);
	titleFrame:SetPoint("TOP", parent, "TOP", 0, -fTitleFontSize);

	return innerFrame;
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

	scrollbar:SetScript("OnValueChanged", function(self, value)
		scrollFrame:SetVerticalScroll(value);
	end);

	local scrollBarBG = scrollbar:CreateTexture(nil, "BACKGROUND");
	scrollBarBG:SetAllPoints(scrollbar);
	scrollBarBG:SetTexture(0, 0, 0, 0.4);

	CreateBackdrop(scrollbar, 0.5);

	return scrollbar;
end

function UpdateScrollBar(scrollFrame, fContentHeight)

	scrollbar = scrollFrame.scrollbar;
	local fScrollFrameHeight = scrollFrame:GetHeight() - 20;
	scrollbar:SetMinMaxValues(0, math.max(1, fContentHeight - fScrollFrameHeight));
	if fContentHeight <= fScrollFrameHeight then
		scrollbar:Hide();
	else
		scrollbar:Show();
	end
end

function CreateScrollFrame(sName, parent, size)

	local scrollableFrame = CreateFrame("ScrollFrame", sPrefix .. sName, parent);
	CreateBackdrop(scrollableFrame, 0.5);
	scrollableFrame:SetSize(size.x, size.y);
	scrollableFrame:SetHitRectInsets(4, 4, 4, 4);

	scrollableFrame.scrollbar = CreateScrollbar(scrollableFrame);
	scrollableFrame.scrollbar:Hide();
	scrollableFrame.content = CreateFrame("Frame", sPrefix .. sName .. "_Content", scrollableFrame);
	scrollableFrame.content:SetSize(size.x, size.y);
	scrollableFrame:SetScrollChild(scrollableFrame.content);

	local mouseWheelFrameCapture = CreateFrame("Frame", sPrefix .. sName .. "_MouseWheelCapture", scrollableFrame);
	mouseWheelFrameCapture:SetSize(size.x, size.y);
	mouseWheelFrameCapture:SetAllPoints(true);
	mouseWheelFrameCapture:SetFrameLevel(scrollableFrame:GetFrameLevel() + 2);
	mouseWheelFrameCapture:EnableMouseWheel(true);

	mouseWheelFrameCapture:SetScript("OnMouseWheel", function(self, fDelta)

		local scrollFrame = self:GetParent();
		if not scrollFrame.scrollbar:IsVisible() then
			return;
		end

		local fNewValue = math.Clamp(scrollFrame:GetVerticalScroll() - (fDelta * 40), scrollFrame.scrollbar:GetMinMaxValues());
		scrollFrame.scrollbar:SetValue(fNewValue);
	end);

	scrollableFrame.mouseWheelFrameCapture = mouseWheelFrameCapture;

	return scrollableFrame;
end


local function CreateTab(parent, fWidth, sText, iId)

	local tab = CreateFrame("Button", parent:GetName() .. "Tab" .. iId, parent, "OptionsFrameTabButtonTemplate");
	tab:SetText(sText);
	tab.iId = iId;
	PanelTemplates_TabResize(tab, tab:GetTextWidth());

	tab:SetScript("OnClick", function()

		for i = 1, #parent.tabFrames do
			if i == iId then
				parent.tabFrames[i]:Show();
			else
				parent.tabFrames[i]:Hide();
			end
		end

		PanelTemplates_SetTab(parent, iId);
	end);

	return tab;
end

function CreateTabbedFrame(sName, parent, size, bMovable, tabsNamesList)

	local mainFrame = CreateBackdroppedFrame(sName, parent, size, bMovable);
	mainFrame.tabsButtons = {};

	local fPreviousTextSize = 0;

	for i = 1, #tabsNamesList do
		local newTab = CreateTab(mainFrame, 10, tabsNamesList[i], i);	-- '10' is placeholder fWidth for tabs, before they get automatically resized
		newTab:SetPoint("TOPLEFT", fPreviousTextSize, 23);
		fPreviousTextSize = fPreviousTextSize + newTab:GetTextWidth() + 31;
		table.insert(mainFrame.tabsButtons, newTab);
	end

	PanelTemplates_SetNumTabs(mainFrame, #tabsNamesList);
	PanelTemplates_SetTab(mainFrame, 1);

	mainFrame.tabFrames = {};

	mainFrame:Hide();	-- Workaround to update tabs sizes
	mainFrame:Show();
	return mainFrame;
end
