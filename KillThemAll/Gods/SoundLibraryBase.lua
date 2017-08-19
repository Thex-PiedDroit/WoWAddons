
Cerberus_HookThisFile();

g_soundLibrary =
{
	generalSoundFilesList = {},
	deathSoundFilesList = {},

	PlayRandomSound = function(self, sSoundType, sChannel)

		if sSoundType == "General" then
			local iRand = math.random(1, #self.generalSoundFilesList);
			PlaySoundFile(self.generalSoundFilesList[iRand], sChannel);

		elseif sSoundType == "Death" then
			local iRand = math.random(1, #self.deathSoundFilesList);
			PlaySoundFile(self.deathSoundFilesList[iRand], sChannel);
		end
	end,
};

g_allSoundLibraries = {};

local mtSoundLibrary = {};
mtSoundLibrary.__index =
{
	New = function(self, members)
		return setmetatable(members or {}, { __index = self });
	end,

	Inherit = function(self, members, methods)
		local newMetaTable = { __index = setmetatable(methods or {}, { __index = self }) };
		table.insert(g_allSoundLibraries, setmetatable(members or {}, newMetaTable));

		return g_allSoundLibraries[#g_allSoundLibraries];
	end,
};

setmetatable(g_soundLibrary, mtSoundLibrary);
