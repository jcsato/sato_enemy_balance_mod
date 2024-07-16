::mods_registerMod("sato_enemy_balance", 1.4, "Sato's Enemy Balance");

::mods_queue("sato_enemy_balance", null, function() {
	::include("script_hooks/mod_seb_barbarians");
	::include("script_hooks/mod_seb_gilded");
	::include("script_hooks/mod_seb_lindwurms");
	::include("script_hooks/mod_seb_nobles");
	::include("script_hooks/mod_seb_nomads");
	::include("script_hooks/mod_seb_serpents");
});
