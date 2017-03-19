
function TableContains(tableRef, value)

	if type(value) == "string" then
		value = string.upper(value);
	end

	for i = 1, #tableRef, 1 do

		currValue = tableRef[i];

		if type(currValue) == "string" then
			currValue = string.upper(currValue);
		end

		if currValue == value then
			return true, i;
		end
	end

	return false;
end

function TableToString(tableRef)

	assert(type(tableRef) == "table", "Wrong argument type in TableToString. Expected a table");

	str = tableRef[1];

	for i = 2, #tableRef, 1 do
		assert(type(tableRef[i]), "Wrong table element's type in TableToString. Expected a table of strings only");
		str = str .. " " .. tableRef[i];
	end

	return str;
end

function GetFirstWordAndRest(str)
	return str:match("^(%S*)%s*(.-)$");
end

local function GetWordsNoTable(str)
	if str ~= nil and str ~= "" then
		local first, strCut = GetFirstWordAndRest(str);
		return first, GetWordsNoTable(strCut);
	end
end

function GetWords(str)
	return { GetWordsNoTable(str) };
end

function SubTable(superTable, from, to)

	if to == nil or to > #superTable then
		to = #superTable;
	end

	local subTable = {};

	for i = from, to, 1 do
		table.insert(subTable, superTable[i]);
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

function GetPunctuatedString(stringTable)

	local str = "";

	for i = 1, #stringTable, 1 do

		if i == 1 then
			str = str .. stringTable[i];
		elseif i == #stringTable then
			str = str .. " and "  .. stringTable[i];
		else
			str = str .. ", "  .. stringTable[i];
		end
	end

	return str;
end

function TrySetSoundChannel(soundChannel, defaultChannel)

	outSoundChannel = defaultChannel;

	if soundChannel == nil or soundChannel == "" then
		PrintInvalidParameters("Please provide a channel name. Available sound channels are: Master, Sound, Music, Ambience, Dialog and Default.");
		return defaultChannel;
	end

	soundChannel = string.upper(soundChannel);

	if soundChannel == "MASTER" then
		outSoundChannel = "Master";
	elseif soundChannel == "SOUND" then
		outSoundChannel = "Sound";
	elseif soundChannel == "MUSIC" then
		outSoundChannel = "Music";
	elseif soundChannel == "AMBIENCE" then
		outSoundChannel = "Ambience";
	elseif soundChannel == "DIALOG" then
		outSoundChannel = "Dialog";
	elseif soundChannel == "DEFAULT" then
		outSoundChannel = DefaultSoundChannel;
	else
		outSoundChannel = defaultChannel;
		PrintInvalidParameters("Available sound channels are: Master, Sound, Music, Ambience, Dialog and Default.");
	end

	return outSoundChannel;
end

function PrintInvalidParameters(str)

	KTA_Print("Invalid parameters: " .. str);
end
