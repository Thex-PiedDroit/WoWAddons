
g_cerberus.HookThisFile();

cthun = SoundLibrary:inherit({ displayName = "C'Thun", dataName = "Cthun" }, {});
cthun.general =
{
	"sound/Creature/CThun/CThunDeathIsClose.ogg",	-- "Death is close"
	"sound/Creature/CThun/CThunYouAreAlready.ogg",	-- "You are already dead"
	"sound/Creature/CThun/CThunYouWillBetray.ogg",	-- "You will betray your friends"
	"sound/Creature/CThun/CThunYouWillDIe.ogg",		-- "You will die"
	"sound/Creature/CThun/CThunYourCourage.ogg",	-- "Your courage will fail"
	"sound/Creature/CThun/CThunYourFriends.ogg",	-- "Your friends will abandon you"
	"sound/Creature/CThun/YourHeartWill.ogg",		-- "Your heart will explode"
};
cthun.onDeath =
{
	"sound/Creature/CThun/YouAreWeak.ogg",			-- "You are weak"
};
