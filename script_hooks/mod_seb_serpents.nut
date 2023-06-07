::Const.Tactical.Actor.Serpent.Bravery = 60;  // Default 80

::mods_hookNewObject("skills/actives/serpent_bite_skill", function(sbs) {
	sbs.onUpdate = function( _properties )
	{
		// Default is 50-70 @ 75%
		_properties.DamageRegularMin += 40;
		_properties.DamageRegularMax += 60;
		_properties.DamageArmorMult *= 0.9;
	}
});

::mods_hookExactClass("entity/tactical/enemies/serpent", function(s) {
	local onInit = ::mods_getMember(s, "onInit");

	::mods_override(s, "onInit", function() {
		onInit();

		getSkills().add(new("scripts/skills/perks/perk_coup_de_grace"));
	});
});
