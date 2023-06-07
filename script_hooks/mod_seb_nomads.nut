::Const.Tactical.Actor.NomadCutthroat.MeleeDefense = -5;	// Default 5
::Const.Tactical.Actor.NomadCutthroat.RangedDefense = -5;	// Default 5
::Const.Tactical.Actor.NomadOutlaw.MeleeDefense = 5; 		// Default 15
::Const.Tactical.Actor.NomadOutlaw.RangedDefense = 5; 		// Default 15

::mods_hookExactClass("entity/tactical/humans/nomad_cutthroat", function(nc) {
	local onInit				= ::mods_getMember(nc, "onInit");
	local onOtherActorDeath		= ::mods_getMember(nc, "onOtherActorDeath");
	local onOtherActorFleeing	= ::mods_getMember(nc, "onOtherActorFleeing");

	::mods_override(nc, "onInit", function() {
		onInit();

		if (!Tactical.State.isScenarioMode() && World.getTime().Days >= 70) {
			m.BaseProperties.MeleeDefense += 10;
			m.BaseProperties.RangedDefense += 10;

			m.CurrentProperties = clone m.BaseProperties;
		} else if (!Tactical.State.isScenarioMode() && World.getTime().Days >= 35) {
			m.BaseProperties.MeleeDefense += 5;
			m.BaseProperties.RangedDefense += 5;

			m.CurrentProperties = clone m.BaseProperties;
		}

		getSkills().add(new("scripts/skills/effects/dodge_effect"));
	});

	::mods_override(nc, "onOtherActorDeath", function(_killer, _victim, _skill) {
		actor.onOtherActorDeath(_killer, _victim, _skill);
	});

	::mods_override(nc, "onOtherActorFleeing", function(_actor) {
		actor.onOtherActorFleeing(_actor);
	});
});

::mods_hookExactClass("entity/tactical/humans/nomad_outlaw", function(no) {
	local onInit				= ::mods_getMember(no, "onInit");
	local onOtherActorDeath		= ::mods_getMember(no, "onOtherActorDeath");
	local onOtherActorFleeing	= ::mods_getMember(no, "onOtherActorFleeing");

	::mods_override(no, "onInit", function() {
		onInit();

		if (!Tactical.State.isScenarioMode() && World.getTime().Days >= 70) {
			m.BaseProperties.MeleeDefense += 10;
			m.BaseProperties.RangedDefense += 10;

			m.CurrentProperties = clone m.BaseProperties;
		} else if (!Tactical.State.isScenarioMode() && World.getTime().Days >= 35) {
			m.BaseProperties.MeleeDefense += 5;
			m.BaseProperties.RangedDefense += 5;

			m.CurrentProperties = clone m.BaseProperties;
		}

		getSkills().add(new("scripts/skills/effects/dodge_effect"));
	});

	::mods_override(no, "onOtherActorDeath", function(_killer, _victim, _skill) {
		actor.onOtherActorDeath(_killer, _victim, _skill);
	});

	::mods_override(no, "onOtherActorFleeing", function(_actor) {
		actor.onOtherActorFleeing(_actor);
	});
});

::mods_hookExactClass("entity/tactical/humans/nomad_slinger", function(ns) {
	local onOtherActorDeath		= ::mods_getMember(ns, "onOtherActorDeath");
	local onOtherActorFleeing	= ::mods_getMember(ns, "onOtherActorFleeing");

	::mods_override(ns, "onOtherActorDeath", function(_killer, _victim, _skill) {
		actor.onOtherActorDeath(_killer, _victim, _skill);
	});

	::mods_override(ns, "onOtherActorFleeing", function(_actor) {
		actor.onOtherActorFleeing(_actor);
	});
});

::mods_hookExactClass("entity/tactical/humans/nomad_archer", function(na) {
	local onOtherActorDeath		= ::mods_getMember(na, "onOtherActorDeath");
	local onOtherActorFleeing	= ::mods_getMember(na, "onOtherActorFleeing");

	::mods_override(na, "onOtherActorDeath", function(_killer, _victim, _skill) {
		actor.onOtherActorDeath(_killer, _victim, _skill);
	});

	::mods_override(na, "onOtherActorFleeing", function(_actor) {
		actor.onOtherActorFleeing(_actor);
	});
});

::mods_hookExactClass("entity/tactical/humans/nomad_leader", function(nl) {
	local onOtherActorDeath		= ::mods_getMember(nl, "onOtherActorDeath");
	local onOtherActorFleeing	= ::mods_getMember(nl, "onOtherActorFleeing");

	::mods_override(nl, "onOtherActorDeath", function(_killer, _victim, _skill) {
		actor.onOtherActorDeath(_killer, _victim, _skill);
	});

	::mods_override(nl, "onOtherActorFleeing", function(_actor) {
		actor.onOtherActorFleeing(_actor);
	});
});
