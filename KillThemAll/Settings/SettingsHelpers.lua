
g_cerberus.HookThisFile();

function CreateLabel(panel, name)
	local label = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlight");
	label:SetText(name);
	return label;
end

function CreateCheck(panel, key, width, height)
	local chkOpt = CreateFrame("CheckButton", "KTA_" .. key, panel, "OptionsCheckButtonTemplate");
	chkOpt:SetWidth(width);
	chkOpt:SetHeight(height);
	return chkOpt;
end

function CreateEditBox(panel, name, width, height, onlyNumeric, onEnterPressedCallback)
	local editBox = CreateFrame("EditBox", "KTA_" .. name, panel, "InputBoxTemplate");
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

function CreateDropDownList(panel, name, width, options)
	local dropDownList = CreateFrame("Frame", "KTA_" .. name, panel, "UIDropDownMenuTemplate");
	UIDropDownMenu_SetWidth(dropDownList, width);

	return dropDownList;
end

function CreateButton(panel, name, width, text)

	local button = CreateFrame("Button", "KTA_" .. name, panel, "UIPanelButtonTemplate");
	button:SetWidth(width);
	button:SetText(text);

	return button;
end
