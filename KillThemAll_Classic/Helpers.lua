
Cerberus_HookThisFile();

function TableContains(tableRef, values)

	if type(values) ~= "table" then
		values = { values };
	end

	for i = 1, #values do
		if type(values[i]) == "string" then
			values[i] = string.upper(values[i]);
		end
	end

	for i = 1, #tableRef, 1 do

		currValue = tableRef[i];

		if type(currValue) == "string" then
			currValue = string.upper(currValue);
		end

		for j = 1, #values do
			if currValue == values[j] then
				return true, i;
			end
		end
	end

	return false;
end

function TableContainsUniqueItem(tableRef, item)

	if type(item) == "string" then
			item = string.upper(item);
		end

	for i = 1, #tableRef, 1 do

		currValue = tableRef[i];

		if type(currValue) == "string" then
			currValue = string.upper(currValue);
		end

		if currValue == item then
			return true, i;
		end
	end

	return false;
end

function TableToString(tableRef)

	assert(type(tableRef) == "table", "Wrong argument type in TableToString. Expected a table.");

	local str = tableRef[1];

	for i = 2, #tableRef, 1 do
		assert(type(tableRef[i]), "Wrong table element's type in TableToString. Expected a table of strings only.");
		str = str .. " " .. tableRef[i];
	end

	return str;
end

function GetFirstWordAndRest(str)
	return str:match("^(%S*)%s*(.-)$");
end

local function GetWordsNoTable(str)
	if str ~= nil and str ~= "" then
		local sFirst, sStrCut = GetFirstWordAndRest(str);
		return sFirst, GetWordsNoTable(sStrCut);
	end
end

function GetWords(str)
	return { GetWordsNoTable(str) };
end

function SubTable(T, iFrom, iTo)

	if iTo == nil or iTo > #T then
		iTo = #T;
	end

	local subTable = {};

	for i = iFrom, iTo, 1 do
		table.insert(subTable, T[i]);
	end

	return subTable;
end

function TableCat(table1, table2)

	local newTable = table1 or {};
	for i = 1, #table2, 1 do
		table.insert(newTable, table2[i]);
	end

	return newTable;
end

function TableCombine(table1, table2)

	local newTable = {};
	for i = 1, #table1, 1 do
		if not TableContainsUniqueItem(newTable, table1[i]) then
			table.insert(newTable, table1[i]);
		end
	end
	for i = 1, #table2, 1 do
		if not TableContainsUniqueItem(newTable, table2[i]) then
			table.insert(newTable, table2[i]);
		end
	end

	return newTable;
end

function GetPunctuatedString(sStringTable)

	local str = "";

	for i = 1, #sStringTable, 1 do

		if i == 1 then
			str = str .. sStringTable[i];
		elseif i == #sStringTable then
			str = str .. " and "  .. sStringTable[i];
		else
			str = str .. ", "  .. sStringTable[i];
		end
	end

	return str;
end

function AddListenerEvent(eventListener, sEventType, Callback)

	eventListener[sEventType] = eventListener[sEventType] or {};
	table.insert(eventListener[sEventType], Callback);
end

function CallEventListener(eventListener, sEventType, ...)

	local listeners = eventListener[sEventType] or {};
	for i = 1, #listeners, 1 do
		listeners[i](...);
	end
end

function GodExists(sGodName)

	sGodName = string.upper(sGodName);

	for i = 1, #g_allSoundLibraries, 1 do
		if string.upper(g_allSoundLibraries[i].m_sDataName) == sGodName then
			return true, i;
		end
	end

	return false;
end

local l_soundChannels =
{
	["MASTER"] = "Master",
	["SOUND"] = "Sound",
	["MUSIC"] = "Music",
	["AMBIENCE"] = "Ambience",
	["DIALOG"] = "Dialog"
};
function GetAvailableSoundChannels()
	return l_soundChannels;
end

function TryParseSoundChannel(sSoundChannel, sDefaultChannel, bSilent)

	local sOutSoundChannel = sDefaultChannel;

	if sSoundChannel == nil or sSoundChannel == "" then
		if not bSilent then
			PrintInvalidParameters("Please provide a channel name. Available sound channels are: Master, Sound, Music, Ambience, Dialog and Default.");
		end
		return sDefaultChannel;
	end

	sSoundChannel = string.upper(sSoundChannel);

	if soundChannel == "DEFAULT" and l_soundChannels["DEFAULT"] == nil then
		l_soundChannels["DEFAULT"] = g_ktaCurrentSettings.m_default.m_sSoundChannel;
	end

	sOutSoundChannel = l_soundChannels[sSoundChannel];
	if sOutSoundChannel == nil then
		sOutSoundChannel = sDefaultChannel;
		if not bSilent then
			PrintInvalidParameters("Sound channel not found. Available sound channels are: Master, Sound, Music, Ambience, Dialog and Default.");
		end
	end

	return sOutSoundChannel;
end

function PrintInvalidParameters(str)

	KTA_Print("Invalid parameters: " .. str);
end


function table.Clone(T)

	local copy = {};
	for sKey, value in pairs(T) do

		if type(value) == "table" then
			value = table.Clone(value);
		end

		copy[sKey] = value;
	end

	return copy;
end

function table.Len(T)

	local iCount = 0;
	for _, value in pairs(T) do

		if type(value) == "table" then
			iCount = iCount + table.Len(value);
		else
			iCount = iCount + 1;
		end
	end
	return iCount;
end

function table.PrintMembers(T)

	for sKey, value in pairs(T) do

		if type(value) == "table" then
			print(sKey .. " = {");
			table.PrintMembers(value);
			print("}");
		else
			print(tostring(sKey) .. " = " .. tostring(value));
		end
	end
end

string.StartsWith = function(self, sStart)

	return self:find("^" .. sStart) ~= nil;
end

function TestAudio()

	PlayRandomSound("General");
end
