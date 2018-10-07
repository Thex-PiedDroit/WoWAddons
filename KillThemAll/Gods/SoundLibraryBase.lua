
Cerberus_HookThisFile();

g_soundLibrary =
{
	m_generalSoundFilesList = {},
	m_deathSoundFilesList = {},

	PlayRandomSound = function(self, sSoundType, sChannel)

		if sSoundType == "General" then
			local iRand = math.random(1, #self.m_generalSoundFilesList);
			PlaySoundFile(self.m_generalSoundFilesList[iRand], sChannel);

		elseif sSoundType == "Death" then
			local iRand = math.random(1, #self.m_deathSoundFilesList);
			PlaySoundFile(self.m_deathSoundFilesList[iRand], sChannel);
		end
	end,
};

g_allSoundLibraries = {};

local l_mtSoundLibrary = {};
l_mtSoundLibrary.__index =
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

setmetatable(g_soundLibrary, l_mtSoundLibrary);
