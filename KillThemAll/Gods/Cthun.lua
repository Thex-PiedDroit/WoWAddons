
Cerberus_HookThisFile();

g_cthun = g_soundLibrary:Inherit({ m_sDisplayName = "C'Thun", m_sDataName = "Cthun" });
g_cthun.m_generalSoundFilesList =
{
	546627,--"sound/Creature/CThun/CThunDeathIsClose.ogg",	-- "Death is close"
	546621,--"sound/Creature/CThun/CThunYouAreAlready.ogg",	-- "You are already dead"
	546623,--"sound/Creature/CThun/CThunYouWillBetray.ogg",	-- "You will betray your friends"
	546633,--"sound/Creature/CThun/CThunYouWillDie.ogg",		-- "You will die"
	546626,--"sound/Creature/CThun/CThunYourCourage.ogg",	-- "Your courage will fail"
	546620,--"sound/Creature/CThun/CThunYourFriends.ogg",	-- "Your friends will abandon you"
	546628,--"sound/Creature/CThun/YourHeartWill.ogg",		-- "Your heart will explode"
};
g_cthun.m_deathSoundFilesList =
{
	546636,--"sound/Creature/CThun/YouAreWeak.ogg",			-- "You are weak"
};
