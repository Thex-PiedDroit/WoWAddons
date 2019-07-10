
Cerberus_HookThisFile();

g_sargeras = g_soundLibrary:Inherit({ m_sDisplayName = "Sargeras", m_sDataName = "Sargeras" });
g_sargeras.m_generalSoundFilesList =
{
	1487375,--"Sound/creature/voice_of_sargeras/vo_703_sargeras_01_m.ogg",	-- Behold... the Legion's power.
	1487377,--"Sound/creature/voice_of_sargeras/vo_703_sargeras_02_m.ogg",	-- No matter how hard this world fights, it will fall.
	"Interface\\AddOns\\KillThemAll_Sargeras\\CustomSounds\\vo_73_voice_of_sargeras_custom_02_m_new.ogg",	-- End this incursion of the Light to ensure the victory of my crusade.
	"Interface\\AddOns\\KillThemAll_Sargeras\\CustomSounds\\vo_73_voice_of_sargeras_custom_05_m.ogg",	-- No power in the Universe will stand against the Legion!
	"Interface\\AddOns\\KillThemAll_Sargeras\\CustomSounds\\vo_73_voice_of_sargeras_custom_07_m.ogg",	-- Together, we will defeat the hungering void that would consume us all.
};
g_sargeras.m_deathSoundFilesList =
{
	"Interface\\AddOns\\KillThemAll_Sargeras\\CustomSounds\\vo_73_voice_of_sargeras_custom_LOW_HEALTH_or_BG_RESURRECTION_TIMER.ogg",	-- The hour of rebirth draws near...
	"Interface\\AddOns\\KillThemAll_Sargeras\\CustomSounds\\wg_sargeras_custom_DEATH.ogg",	-- You have failed me!
};
