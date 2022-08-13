::mods_queue("sato_enemy_balance", "", function() {
	::Const.Tactical.Actor.NomadCutthroat.MeleeDefense = -5;	// Default 5
	::Const.Tactical.Actor.NomadCutthroat.RangedDefense = -5;	// Default 5
	::Const.Tactical.Actor.NomadOutlaw.MeleeDefense = 5; 		// Default 15
	::Const.Tactical.Actor.NomadOutlaw.RangedDefense = 5; 		// Default 15

	::mods_hookExactClass("entity/tactical/humans/nomad_cutthroat", function(nc) {
		local onInit = ::mods_getMember(nc, "onInit");

		::mods_override(nc, "onInit", function() {
			onInit();

			if(!Tactical.State.isScenarioMode() && World.getTime().Days >= 35) {
				m.BaseProperties.MeleeDefense += 5;
				m.BaseProperties.RangedDefense += 5;

				m.CurrentProperties = clone m.BaseProperties;
			}

			getSkills().add(new("scripts/skills/effects/dodge_effect"));
		});
	});

	::mods_hookExactClass("entity/tactical/humans/nomad_outlaw", function(no) {
		local onInit = ::mods_getMember(no, "onInit");

		::mods_override(no, "onInit", function() {
			onInit();

			if(!Tactical.State.isScenarioMode() && World.getTime().Days >= 40) {
				m.BaseProperties.MeleeDefense += 5;
				m.BaseProperties.RangedDefense += 5;
				m.BaseProperties.Initiative += 15;

				m.CurrentProperties = clone m.BaseProperties;
			}

			getSkills().add(new("scripts/skills/effects/dodge_effect"));
		});
	});
});
