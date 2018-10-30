
Cerberus_HookThisFile();

g_sargeras = g_soundLibrary:Inherit({ m_sDisplayName = "Sargeras", m_sDataName = "Sargeras" });
g_sargeras.m_generalSoundFilesList =
{
	"Sound/creature/voice_of_sargeras/vo_703_sargeras_01_m.ogg",	-- Behold... the Legion's power.
	"Sound/creature/voice_of_sargeras/vo_703_sargeras_02_m.ogg",	-- No matter how hard this world fights, it will fall.
	"Interface\\AddOns\\KillThemAll_Sargeras\\CustomSounds\\vo_73_voice_of_sargeras_custom_02_m_new.ogg",	-- End this incursion of the Light to ensure the victory of my crusade.
	"Interface\\AddOns\\KillThemAll_Sargeras\\CustomSounds\\vo_73_voice_of_sargeras_custom_05_m.ogg",	-- No power in the Universe will stand against the Legion!
	"Interface\\AddOns\\KillThemAll_Sargeras\\CustomSounds\\vo_73_voice_of_sargeras_custom_07_m.ogg",	-- Together, we will defeat the hungering void that would consume us all.
};                                            
g_sargeras.m_deathSoundFilesList =            
{                                             
	"Interface\\AddOns\\KillThemAll_Sargeras\\CustomSounds\\vo_73_voice_of_sargeras_custom_LOW_HEALTH_or_BG_RESURRECTION_TIMER.ogg",	-- The hour of rebirth draws near...
	"Interface\\AddOns\\KillThemAll_Sargeras\\CustomSounds\\wg_sargeras_custom_DEATH.ogg",	-- You have failed me!
};
g_sargeras.m_resurrection = "Interface\\AddOns\\KillThemAll_Sargeras\\CustomSounds\\wg_sargeras_custom_RESURRECTED.ogg",	-- Become the instrument of my wrath once again.

-- Combat sound files:
g_sargeras.m_killSoundFilesList = 
{
	"Interface\\AddOns\\ArtifactWhispers\\SoundFiles\\DestroLock Artifact\\vo_73_voice_of_sargeras_custom_KILL_ENEMY.ogg"	-- Might beyond measure!
	"Interface\\AddOns\\ArtifactWhispers\\SoundFiles\\DestroLock Artifact\\vo_73_voice_of_sargeras_custom_KILL_ENEMY_2.ogg"	-- Victory!
}
g_sargeras.m_enemy_vanish = "Interface\\AddOns\\ArtifactWhispers\\SoundFiles\\DestroLock Artifact\\vo_73_voice_of_sargeras_custom_ENEMY_VANISH.ogg",	-- One still eludes us...
g_sargeras.m_low_resource = "Interface\\AddOns\\ArtifactWhispers\\SoundFiles\\DestroLock Artifact\\vo_73_voice_of_sargeras_custom_LOW_RESOURCE.ogg" -- Essence is needed.

-- Spell sound files:
g_sargeras.m_soulstone = "Interface\\AddOns\\KillThemAll_Sargeras\\CustomSounds\\vo_73_voice_of_sargeras_custom_CAST_SOULSTONE.ogg",	-- The mortals must not disrupt the rebirth.
g_sargeras.m_levelup = "Interface\\AddOns\\ArtifactWhispers\\SoundFiles\\DestroLock Artifact\\vo_73_voice_of_sargeras_custom_LVLUP_or_LEARNING_SPELL.ogg"	-- Knowledge beyond imagining!
-- ^levelup or when learning new spell

-- Exploration sound files:
g_sargeras.m_capital_city = "Interface\\AddOns\\ArtifactWhispers\\SoundFiles\\DestroLock Artifact\\vo_73_voice_of_sargeras_custom_IN_CAPITAL_CITY.ogg"	-- Pledge the hearts of your people to my cause.
