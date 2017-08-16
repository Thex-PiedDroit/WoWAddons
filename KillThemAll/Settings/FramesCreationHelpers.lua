
g_cerberus.HookThisFile();

local sPrefix = "KillThemAll_";


function GetFrameSizeAsTable(frame)

	local fWidth, fHeight = frame:GetSize();
	return { x = fWidth, y = fHeight };
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

function CreateBackdroppedFrame(sName, parent, size)

	local newFrame = CreateFrame("Frame", sPrefix .. sName, parent);
	newFrame:SetSize(size.x, size.y);

	CreateBackdrop(newFrame, 0.5);

	return newFrame;
end

function CreateButton(sName, parent, size, sText, OnClickCallback, callbackArguments)

	local button = CreateFrame("Button", sPrefix .. sName, parent, "UIPanelButtonTemplate");
	button:SetSize(size.x, size.y);
	button:SetText(sText);

	if OnClickCallback ~= nil then
		button:SetScript("OnClick", function(self) OnClickCallback(self, unpack(callbackArguments)) end);
	end

	return button;
end

function CreateCheckButton(sName, parent, fSize, OnCheckCallback, callbackArguments)
	local checkButton = CreateFrame("CheckButton", sPrefix .. sName, parent, "OptionsCheckButtonTemplate");
	fSize = fSize or 20;
	checkButton:SetSize(fSize, fSize);

	if OnCheckCallback ~= nil then
		button:SetScript("OnClick", function(self) OnCheckCallback(self, unpack(callbackArguments)) end);
	end

	return checkButton;
end

function CreateEditBox(sName, parent, size, bOnlyNumeric, OnEnterPressedCallback, callbackArguments, fFontSize)
	local editBox = CreateFrame("EditBox", sPrefix .. sName, parent, "InputBoxTemplate");
	editBox:SetSize(size.x, size.y);
	editBox:SetAutoFocus(false);
	editBox:SetNumeric(bOnlyNumeric);
	editBox:SetMaxLetters(125);

	editBox:SetScript("OnEnterPressed", function()

		if OnEnterPressedCallback ~= nil then
			OnEnterPressedCallback(unpack(callbackArguments));
		end

		editBox:ClearFocus();
		editBox:HighlightText(0, 0);	-- Forces highlight removal
	end);
	editBox:SetScript("OnEscapePressed", function()

		if OnEnterPressedCallback ~= nil then
			OnEnterPressedCallback(unpack(callbackArguments));
		end

		editBox:ClearFocus();
		editBox:HighlightText(0, 0);	-- Forces highlight removal
	end);

	return editBox;
end

function CreateDropDownList(sName, parent, fWidth, options, sCurrentValue, OnButtonSelectedCallback, callbackArguments, IsCheckedVerifier)
	local dropDownList = CreateFrame("Frame", sPrefix .. sName, parent, "UIDropDownMenuTemplate");
	UIDropDownMenu_SetWidth(dropDownList, fWidth);

	local iSelectedItemIndex = 0;

	UIDropDownMenu_Initialize(dropDownList, function(self)

		local buttons = UIDropDownMenu_CreateInfo();
		buttons.func = function(self)
			UIDropDownMenu_SetSelectedValue(dropDownList, self.value, false);
			if OnButtonSelectedCallback ~= nil then
				OnButtonSelectedCallback(self.value, unpack(callbackArguments));
			end
			CloseDropDownMenus();
		end;

		for i = 1, #options do
			if options[i].sText == sCurrentValue then
				iSelectedItemIndex = i;
			end
			buttons.text = options[i].sText;
			buttons.value = options[i].value;
			buttons.checked = IsCheckedVerifier(buttons.value);
			UIDropDownMenu_AddButton(buttons);
		end
	end);

	UIDropDownMenu_SetSelectedID(dropDownList, iSelectedItemIndex, false);

	return dropDownList;
end