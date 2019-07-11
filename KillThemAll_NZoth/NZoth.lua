
Cerberus_HookThisFile();

g_nZoth = g_soundLibrary:Inherit({ m_sDisplayName = "N'Zoth", m_sDataName = "NZoth" });
g_nZoth.m_generalSoundFilesList =
{
	2529827,--"Sound/creature/nzoth/vo_815_nzoth_01_m.ogg",	-- Mere baubles decay beneath the gaze of a god.
	2529828,--"Sound/creature/nzoth/vo_815_nzoth_02_m.ogg",	-- Wither!
	2529829,--"Sound/creature/nzoth/vo_815_nzoth_03_m.ogg",	-- Kneel!
	2529830,--"Sound/creature/nzoth/vo_815_nzoth_04_m.ogg",	-- Obey!
	2529831,--"Sound/creature/nzoth/vo_815_nzoth_05_m.ogg",	-- Children... the depths are my domain.
	2529832,--"Sound/creature/nzoth/vo_815_nzoth_06_m.ogg",	-- Deeper, ever deeper.
	2529833,--"Sound/creature/nzoth/vo_815_nzoth_07_m.ogg",	-- Let the tides draw you into my dream...
	2529834,--"Sound/creature/nzoth/vo_815_nzoth_08_m.ogg",	-- Ahh... you think you know power.
	2529835,--"Sound/creature/nzoth/vo_815_nzoth_09_m.ogg",	-- The storm holds strength, but there is a price to be paid.
	2529836,--"Sound/creature/nzoth/vo_815_nzoth_10_m.ogg",	-- Harness your fury. Make your hatred a weapon.
	2529837,--"Sound/creature/nzoth/vo_815_nzoth_11_m.ogg",	-- At last... embrace the truth of shadow.
	2529838,--"Sound/creature/nzoth/vo_815_nzoth_12_m.ogg",	-- Yes, you draw closer... ever closer...
	2529839,--"Sound/creature/nzoth/vo_815_nzoth_13_m.ogg",	-- With ever choice, you become more my servant.
	2529841,--"Sound/creature/nzoth/vo_815_nzoth_15_m.ogg",	-- Yes, you are indeed the ones i seek. The ones to turn the tide.
	2529842,--"Sound/creature/nzoth/vo_815_nzoth_16_m.ogg",	-- Receive now the greatest of all gifts. My dream has become your own. The circle of stars made flesh.
	2529843,--"Sound/creature/nzoth/vo_815_nzoth_17_m.ogg",	-- She will show you the way. Come, come... The hour approaches when all eyes shall be opened.
	2529845,--"Sound/creature/nzoth/vo_815_nzoth_19_m.ogg",	-- I have dreamed your destiny, mortal.
	2529846,--"Sound/creature/nzoth/vo_815_nzoth_20_m.ogg",	-- The hour is close at hand.
	2564962,--"Sound/creature/nzoth/vo_815_nzoth_21_m.ogg",	-- The Light has struck a bargain with the enemy of all.
	2564963,--"Sound/creature/nzoth/vo_815_nzoth_22_m.ogg",	-- Six seats at the high table. Six mouths that hunger. One will consume all others.
	2564964,--"Sound/creature/nzoth/vo_815_nzoth_23_m.ogg",	-- The veil wanes. His crown will open the way.
	2564965,--"Sound/creature/nzoth/vo_815_nzoth_24_m.ogg",	-- The fall of night reveals her true face. She will bring only ruin.
	2564966,--"Sound/creature/nzoth/vo_815_nzoth_25_m.ogg",	-- When the arrow finds its mark, the last fetter will fall away.
	2564967,--"Sound/creature/nzoth/vo_815_nzoth_26_m.ogg",	-- I alone can save you from what is to come.
	2564968,--"Sound/creature/nzoth/vo_815_nzoth_27_m.ogg",	-- It grows hungrier... bolder. Alas, your eyes are closed.
	2564969,--"Sound/creature/nzoth/vo_815_nzoth_28_m.ogg",	-- He gave himself to the deep places. He gave himself to me.
	2564970,--"Sound/creature/nzoth/vo_815_nzoth_29_m.ogg",	-- She is not the last, but the first. Drown her and you will see.
	2618480,--"Sound/creature/nzoth/vo_815_nzoth_35_m.ogg",	-- Receive my gift and see all truths before you.
	2618483,--"Sound/creature/nzoth/vo_815_nzoth_36_m.ogg",	-- That which was sunken shall rise.
	2618486,--"Sound/creature/nzoth/vo_815_nzoth_37_m.ogg",	-- All that is sleeping shall be awakened.
	2958657,--"Sound/creature/nzoth/vo_82_nzoth_11_m.ogg",	-- *Breath*
	2959162,--"Sound/creature/nzoth/vo_82_nzoth_12_m.ogg",	-- The tide rises.
	2959163,--"Sound/creature/nzoth/vo_82_nzoth_13_m.ogg",	-- The breaker of chains comes.
	2959164,--"Sound/creature/nzoth/vo_82_nzoth_14_m.ogg",	-- Your eyes open.
	2959165,--"Sound/creature/nzoth/vo_82_nzoth_15_m.ogg",	-- Closer, closer...
	2959166,--"Sound/creature/nzoth/vo_82_nzoth_16_m.ogg",	-- All paths open.
	2959167,--"Sound/creature/nzoth/vo_82_nzoth_17_m.ogg",	-- All truths reveiled.
	2959168,--"Sound/creature/nzoth/vo_82_nzoth_18_m.ogg",	-- Our fates are one.
	2959169,--"Sound/creature/nzoth/vo_82_nzoth_19_m.ogg",	-- Your heart, your offering...
	2959170,--"Sound/creature/nzoth/vo_82_nzoth_20_m.ogg",	-- All dreams made real.
	2959189,--"Sound/creature/nzoth/vo_82_nzoth_21_m.ogg",	-- Such a heavy burden you carry. Soon, you will be free of it.
	2959190,--"Sound/creature/nzoth/vo_82_nzoth_22_m.ogg",	-- Your crimes are terrible, numberless, glorious..
	2959191,--"Sound/creature/nzoth/vo_82_nzoth_23_m.ogg",	-- Thief, renegade, murderer, servant.
	2959192,--"Sound/creature/nzoth/vo_82_nzoth_24_m.ogg",	-- All alone in the depths...
	2959193,--"Sound/creature/nzoth/vo_82_nzoth_25_m.ogg",	-- Let go.
	2959194,--"Sound/creature/nzoth/vo_82_nzoth_26_m.ogg",	-- Your wakening draws near.
	2960030,--"Sound/creature/nzoth/vo_82_nzoth_27_m.ogg",	-- *Long breath*
};
