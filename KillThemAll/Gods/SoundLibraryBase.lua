
g_cerberus.HookThisFile();

SoundLibrary =
{
	general = {},
	onDeath = {},

	PlayRandomSound = function(self, soundType, channel)

		if soundType == "General" then
			rand = math.random(1, #self.general);
			PlaySoundFile(self.general[rand], channel);

		elseif soundType == "OnDeath" then
			rand = math.random(1, #self.onDeath);
			PlaySoundFile(self.onDeath[rand], channel);
		end
	end,
}

AllSoundLibraries = {};

mtSoundLibrary = {};
mtSoundLibrary.__index =
{
	new = function(self, t)
		return setmetatable(t or {}, {__index = self });
	end,

	inherit = function(self, t, methods)
		local newMetaTable = {__index = setmetatable(methods, {__index = self})};
		table.insert(AllSoundLibraries, setmetatable(t or {}, newMetaTable));
		return AllSoundLibraries[#AllSoundLibraries];
	end,
}

setmetatable(SoundLibrary, mtSoundLibrary);
