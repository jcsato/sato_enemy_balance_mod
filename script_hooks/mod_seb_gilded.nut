::mods_hookExactClass("entity/tactical/humans/conscript_polearm", function(cp) {
	local onInit = ::mods_getMember(cp, "onInit");

	::mods_override(cp, "onInit", function() {
		onInit();

		getSkills().removeByID("perk.nimble");
	});
});

::mods_hookExactClass("entity/tactical/humans/slave", function(s) {
	local onInit = ::mods_getMember(s, "onInit");

	::mods_override(s, "onInit", function() {
		onInit();

		getSkills().add(new("scripts/skills/perks/perk_nine_lives"));
	});
});
