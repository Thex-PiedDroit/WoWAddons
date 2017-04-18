
lichking = SoundLibrary:inherit({ displayName = "The Lich King", dataName = "LichKing" }, {});
lichking.general =
{
	"Sound/creature/LichKing/EH_LichKing_Chapter1Whisper01.ogg",	-- No mercy
	"Sound/creature/LichKing/EH_LichKing_Chapter1Whisper02.ogg",	-- Kill them all
	"Sound/creature/LichKing/EH_LichKing_Chapter1Whisper03.ogg",	-- Mercy is for the weak
	"Sound/creature/LichKing/EH_LichKing_Chapter1Whisper07.ogg",	-- Kill or be killed
	"Sound/creature/LichKing/EH_LichKing_Chapter1Whisper16.ogg",	-- Living or dead, you will serve me
	"Sound/creature/LichKing/EH_LichKing_Chapter3Shout05.ogg",	-- There is nowhere to run
	"Sound/creature/LichKing/EH_LichKing_Chapter3Shout11.ogg",	-- Bow before your king
	"Sound/creature/LichKing/EH_LichKing_Chapter3Shout13.ogg",	-- There is no light, only darkness
	"Sound/creature/LichKing/EH_LichKing_Farewell3.ogg",	-- All must die
	"Sound/creature/LichKing/EH_LichKing_Greeting2.ogg",	-- Your will is not your own
	"Sound/creature/LichKing/EH_LichKing_Greeting4.ogg",	-- All life must end
	"Sound/creature/LichKing/EH_LichKing_Greeting5.ogg",	-- Bow to your master
	"Sound/creature/LichKing/HR_Lich King_Icewall01.ogg",	-- There is no escape
};
lichking.onDeath =
{
	"Sound/creature/LichKing/EH_LichKing_Chapter1Whisper16.ogg",	-- Living or dead, you will serve me
	"Sound/creature/LichKing/EH_LichKing_Chapter3Shout12.ogg",	-- The light has abandonned you
	"Sound/creature/LichKing/IC_Lich King_FMC01.ogg",	-- So predictable
	"Sound/creature/LichKing/IC_Lich King_FMC05.ogg",	-- Die well, fool
	"Sound/creature/LichKing/PE_LichKing_LaughingEmote.ogg",	-- Lol
};
