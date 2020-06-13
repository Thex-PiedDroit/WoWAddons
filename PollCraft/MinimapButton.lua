
Cerberus_HookThisFile();

local minimapButton = LibStub("LibDBIcon-1.0");

function SetMinimapButtonHidden(bHidden)

	g_pollCraftData.minimapButton.hide = bHidden;

	if bHidden then
		minimapButton:Hide("PollCraft");
	else
		minimapButton:Show("PollCraft");
	end
end


function InitMinimapButton(settingsPanel)

	local ldb = LibStub:GetLibrary("LibDataBroker-1.1");
	local minimapLDB = ldb:NewDataObject("PollCraft",
	{
		type = "launcher",
		icon = "Interface/Icons/Achievement_Reputation_01",
		OnClick = function(clickedframe, button)

			if button == "LeftButton" then
				OpenPollsListFrame();
			elseif button == "RightButton" then
				OpenCreatePollFrame();
			end
		end,
	});

	function minimapLDB:OnTooltipShow()
		self:AddLine(g_sPollCraftPrefix);
		self:AddLine(ColoriseText("Left click: open current polls list", "ffffff"));
		self:AddLine(ColoriseText("Right click: create poll", "ffffff"));
	end
	function minimapLDB:OnEnter()
		GameTooltip:SetOwner(self, "ANCHOR_NONE");
		GameTooltip:SetPoint("TOPLEFT", self, "BOTTOMLEFT");
		GameTooltip:ClearLines();
		dataobj.OnTooltipShow(GameTooltip);
		GameTooltip:Show();
		dataobj.hide = true;
		dataobj:Hide();
	end
	function minimapLDB:OnLeave()
		GameTooltip:Hide();
	end

	minimapButton:Register("PollCraft", minimapLDB, g_pollCraftData.minimapButton);
	SetMinimapButtonHidden(g_pollCraftData.minimapButton.hide);
end
