
local innerFramesMargin = GetInnerFramesMargin();
local marginBetweenUpperBordersAndText = GetTextMarginFromUpperFramesBorders();

local listsFrames =
{
	["mine"] = nil,
	["theirs"] = nil
};

local UpdateLists = nil;
function RequestPollsListsUpdate()

	if g_currentPollsMotherFrame.pollsList ~= nil and g_currentPollsMotherFrame.pollsList:IsVisible() then
		UpdateLists();
	end
end


function InitPollsListFrame()

	if g_currentPollsMotherFrame.pollsList ~= nil then
		return;
	end


	local motherFrameSize = GetMotherFrameSize();
	local containingFrame = g_currentPollsMotherFrame.pollsListFrame;

	local mainFrame = CreateBackdropTitledInnerFrame("PollsListFrame", containingFrame, "PollCraft - All current polls");
	local innerFrameSize = GetFrameSizeAsTable(mainFrame);


	local listsFramesSize =
	{
		x = innerFrameSize.x - (innerFramesMargin * 2),
		y = ((innerFrameSize.y - innerFramesMargin) * 0.5) + (marginBetweenUpperBordersAndText * 2)
	}


		--[[      POLLS CREATED BY ME      ]]--
	local createdByMeListFrame = CreateScrollFrame("CreatedByMeListFrame", mainFrame, listsFramesSize);
	createdByMeListFrame:SetPoint("TOP", mainFrame, "TOP", 0, marginBetweenUpperBordersAndText * 2);
	listsFrames["mine"] = createdByMeListFrame.content;

	local createdByMeSectionLabel = CreateLabel(createdByMeListFrame, "Created by me:", 16);
	createdByMeSectionLabel:SetPoint("TOPLEFT", innerFramesMargin + 10, -marginBetweenUpperBordersAndText);


		--[[      POLLS CREATED BY OTHERS      ]]--
	local createdByOthersListFrame = CreateScrollFrame("CreatedByOthersListFrame", mainFrame, listsFramesSize);
	createdByOthersListFrame:SetPoint("TOP", createdByMeListFrame, "BOTTOM", 0, marginBetweenUpperBordersAndText * 2);
	listsFrames["theirs"] = createdByOthersListFrame.content;

	local createdByOthersSectionLabel = CreateLabel(createdByOthersListFrame, "Created by others:", 16);
	createdByOthersSectionLabel:SetPoint("TOPLEFT", innerFramesMargin + 10, -marginBetweenUpperBordersAndText);


	mainFrame:SetScript("OnShow", function() UpdateLists(); end);
	g_currentPollsMotherFrame.pollsList = mainFrame;
end


local itemsObjects =
{
	["mine"] = {},
	["mineCount"] = 0,
	["theirs"] = {},
	["theirsCount"] = 0
};
local itemsCount = 0;
local itemsSize =
{
	x = 0,
	y = 40
};
local totalHeightOfEachItem = itemsSize.y + (innerFramesMargin * 0.5);

local function AddItemToLists(pollData)

	local pollListType = "theirs";
	if pollData.pollMasterFullName == PollCraft_Me() then
		pollListType = "mine";
	end

	local associatedListFrame = listsFrames[pollListType];
	local itemsCountInThisList = #itemsObjects[pollListType];
	local activeItemsInList = itemsObjects[pollListType .. "Count"];

	if itemsCountInThisList > activeItemsInList then
		local item = itemsCountInThisList[activeItemsInList + 1];

	else
		if itemsSize.x == 0 then
			itemsSize.x = associatedListFrame:GetWidth() - (innerFramesMargin * 2) - associatedListFrame:GetParent().scrollbar:GetWidth();
		end

		local newItemFrame = CreateBackdroppedFrame("Poll" .. tostring(activeItemsInList + 1) .. "ContainingFrame", associatedListFrame, itemsSize);
		--newItemFrame:SetSize(itemsSize.x, itemsSize.y);
		local newItemPosY = -(totalHeightOfEachItem * activeItemsInList) - innerFramesMargin;
		newItemFrame:SetPoint("TOPLEFT", innerFramesMargin, newItemPosY);

		local item =
		{
			containingFrame = newItemFrame,
			questionText = nil,
			alreadyVotedCheck = nil,
		};

		table.insert(itemsObjects[pollListType], item);
	end

	itemsCount = itemsCount + 1;
	itemsObjects[pollListType .. "Count"] = activeItemsInList + 1;
end

local function HideAllItem()

	for _, table in pairs(itemsObjects) do
		if type(table) == "table" then

			for i = 1, #table do
				local currentItem = table[i];
				if currentItem.containingFrame:IsShown() then
					i = #table;
				end
				currentItem.containingFrame:Hide();
			end
		end
	end
end

UpdateLists = function()

	HideAllItem();

	local allPollsData = GetAllPolls();
	for pollGUID, pollData in pairs(allPollsData) do
		AddItemToLists(pollData);
	end

	UpdateScrollBar(listsFrames["mine"]:GetParent(), (itemsObjects["mineCount"] * totalHeightOfEachItem) - innerFramesMargin);
	UpdateScrollBar(listsFrames["theirs"]:GetParent(), (itemsObjects["theirsCount"] * totalHeightOfEachItem) - innerFramesMargin);
end
