
Cerberus_HookThisFile();

g_lichking = g_soundLibrary:Inherit({ m_sDisplayName = "The Lich King", m_sDataName = "LichKing" });
g_lichking.m_generalSoundFilesList =
{
	554107,--"Sound/creature/LichKing/EH_LichKing_Chapter1Whisper01.ogg",	-- No mercy
	554160,--"Sound/creature/LichKing/EH_LichKing_Chapter1Whisper02.ogg",	-- Kill them all
	554122,--"Sound/creature/LichKing/EH_LichKing_Chapter1Whisper03.ogg",	-- Mercy is for the weak
	554135,--"Sound/creature/LichKing/EH_LichKing_Chapter1Whisper07.ogg",	-- Kill or be killed
	554064,--"Sound/creature/LichKing/EH_LichKing_Chapter1Whisper16.ogg",	-- Living or dead, you will serve me
	554005,--"Sound/creature/LichKing/EH_LichKing_Chapter3Shout05.ogg",		-- There is nowhere to run
	554033,--"Sound/creature/LichKing/EH_LichKing_Chapter3Shout11.ogg",		-- Bow before your king
	554083,--"Sound/creature/LichKing/EH_LichKing_Chapter3Shout13.ogg",		-- There is no light, only darkness
	554159,--"Sound/creature/LichKing/EH_LichKing_Farewell3.ogg",			-- All must die
	554123,--"Sound/creature/LichKing/EH_LichKing_Greeting2.ogg",			-- Your will is not your own
	554099,--"Sound/creature/LichKing/EH_LichKing_Greeting4.ogg",			-- All life must end
	554181,--"Sound/creature/LichKing/EH_LichKing_Greeting5.ogg",			-- Bow to your master
	554020,--"Sound/creature/LichKing/HR_Lich King_Icewall01.ogg",			-- There is no escape
};
g_lichking.m_deathSoundFilesList =
{
	554064,--"Sound/creature/LichKing/EH_LichKing_Chapter1Whisper16.ogg",	-- Living or dead, you will serve me
	554117,--"Sound/creature/LichKing/EH_LichKing_Chapter3Shout12.ogg",		-- The light has abandonned you
	554152,--"Sound/creature/LichKing/IC_Lich King_FMC01.ogg",				-- So predictable
	554080,--"Sound/creature/LichKing/IC_Lich King_FMC05.ogg",				-- Die well, fool
	554078,--"Sound/creature/LichKing/PE_LichKing_LaughingEmote.ogg",		-- Lol
};
