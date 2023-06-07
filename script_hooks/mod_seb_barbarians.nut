::Const.Tactical.Actor.BarbarianMarauder.FatigueRecoveryRate = 17;		// Default is 20
::Const.Tactical.Actor.BarbarianMarauder.Bravery = 60;					// Default is 80
::Const.Tactical.Actor.BarbarianChampion.FatigueRecoveryRate = 17;		// Default is 20
::Const.Tactical.Actor.BarbarianChampion.Bravery = 75;					// Default is 90
::Const.World.Spawn.Troops.BarbarianChampion.Cost = 45;					// Default is 35
::Const.World.Spawn.Troops.BarbarianDrummer.Row = 1;					// Default is 2

::mods_hookExactClass("states/world_state", function(ws) {
	function onCostCompare(_t1, _t2) {
		if (_t1.Cost < _t2.Cost) 
			return -1;
		else if (_t1.Cost > _t2.Cost) 
			return 1;

		return 0;
	}

	function calculateCosts(_p) {
		foreach(p in _p) {
			p.Cost <- 0;

			foreach(t in p.Troops)
				p.Cost += t.Type.Cost * t.Num;

			if (!("MovementSpeedMult" in p))
				p.MovementSpeedMult <- 1.0;

			if (!("VisibilityMult" in p))
				p.VisibilityMult <- 1.0;

			if (!("VisionMult" in p))
				p.VisionMult <- 1.0;
		}

		_p.sort(onCostCompare);
	}

	local onInit = ws.onInit;

	ws.onInit = function() {
		onInit();

		calculateCosts(::Const.World.Spawn.Barbarians);
	}
});

::mods_hookExactClass("entity/tactical/humans/barbarian_thrall", function(bt) {
	local onInit = ::mods_getMember(bt, "onInit");

	::mods_override(bt, "onInit", function() {
		onInit();

		getSkills().removeByID("perk.brawny");
	});
});

::mods_hookExactClass("entity/tactical/humans/barbarian_marauder", function(bm) {
	local onInit = ::mods_getMember(bm, "onInit");

	::mods_override(bm, "onInit", function() {
		onInit();

		getSkills().removeByID("perk.brawny");
	});
});

::mods_hookExactClass("entity/tactical/humans/barbarian_champion", function(bc) {
	local onInit = ::mods_getMember(bc, "onInit");

	::mods_override(bc, "onInit", function() {
		onInit();

		getSkills().removeByID("perk.brawny");
	});
});

::mods_hookExactClass("entity/tactical/humans/barbarian_beastmaster", function(bb) {
	local onInit = ::mods_getMember(bb, "onInit");

	::mods_override(bb, "onInit", function() {
		onInit();

		getSkills().removeByID("effects.dodge");
	});
});

::mods_hookExactClass("entity/tactical/humans/barbarian_drummer", function(bd) {
	local onInit = ::mods_getMember(bd, "onInit");

	::mods_override(bd, "onInit", function() {
		onInit();

		getSkills().removeByID("perk.recover");
		getSkills().removeByID("perk.brawny");
		getSkills().removeByID("effects.dodge");
	});
});

::mods_hookExactClass("ai/tactical/agents/barbarian_drummer_agent", function(bda) {
	local onAddBehaviors = ::mods_getMember(bda, "onAddBehaviors");

	::mods_override(bda, "onAddBehaviors", function() {
		onAddBehaviors();

		addBehavior(new("scripts/ai/tactical/behaviors/ai_engage_melee"));
	});
});

::mods_hookExactClass("ai/tactical/agents/barbarian_drummer_agent", function(bda) {
	local onAddBehaviors = ::mods_getMember(bda, "onAddBehaviors");

	::mods_override(bda, "onAddBehaviors", function() {
		onAddBehaviors();

		addBehavior(new("scripts/ai/tactical/behaviors/ai_engage_melee"));
	});
});

::mods_hookExactClass("ai/tactical/behaviors/ai_boost_stamina", function (abs) {
	::mods_override(abs, "onEvaluate", function( _entity ) {
		m.Skill = null;
		local score = getProperties().BehaviorMult[m.ID];

		if (_entity.getActionPoints() < Const.Movement.AutoEndTurnBelowAP)
			return Const.AI.Behavior.Score.Zero;

		if (_entity.getMoraleState() == Const.MoraleState.Fleeing)
			return Const.AI.Behavior.Score.Zero;

		m.Skill = selectSkill(m.PossibleSkills);

		if (m.Skill == null)
			return Const.AI.Behavior.Score.Zero;

		score = score * getFatigueScoreMult(m.Skill);
		local actors = Tactical.Entities.getInstancesOfFaction(_entity.getFaction());
		local myTile = _entity.getTile();
		local useScore = 0.0;
		local numTargets = 0;

		foreach( a in actors ) {
			if (a.getID() == _entity.getID())
				continue;

			local thisScore = 0;
			local distance = a.getTile().getDistanceTo(myTile);

			if (distance > 8)
				continue;

			// if (a.getMoraleState() == Const.MoraleState.Ignore || a.getMoraleState() == Const.MoraleState.Fleeing)
			if (a.getMoraleState() == Const.MoraleState.Ignore)
				continue;

			// if (a.getFatigue() <= 20)
			// 	continue;

			// if (a.getSkills().hasSkill("effects.drums_of_war"))
			// 	continue;

			thisScore = 4;
			numTargets = ++numTargets;
			useScore = useScore + thisScore;
		}

		if (numTargets == 0)
			return Const.AI.Behavior.Score.Zero;

		score = score * (useScore * 0.1);
		return Const.AI.Behavior.Score.Rally * score;
	});
});

::mods_hookNewObject("skills/effects/drums_of_war_effect", function(dowe) {
	::mods_addField(dowe, "drums_of_war_effect" "IsHidden", false);
	::mods_addField(dowe, "drums_of_war_effect" "TurnsLeft", 2);

	dowe.onAdded = function() {
		m.TurnsLeft = 2;
	}

	dowe.onUpdate = function(_properties) {
		_properties.FatigueRecoveryRate += 3;
		_properties.Bravery += 15;
	}

	dowe.onRefresh = function() {
		m.TurnsLeft = 2;
		spawnIcon(m.Overlay, getContainer().getActor().getTile());
	}

	dowe.onTurnEnd = function() { }

	dowe.onRoundEnd = function() {
		if (--m.TurnsLeft <= 0)
			removeSelf();
	}
});

::mods_hookNewObject("skills/actives/drums_of_war_skill", function(dows) {
	dows.isUsable = function() {
		return m.IsUsable && getContainer().getActor().getCurrentProperties().IsAbleToUseSkills && (!m.IsWeaponSkill || getContainer().getActor().getCurrentProperties().IsAbleToUseWeaponSkills) && !isHidden() && !getContainer().getActor().getTile().hasZoneOfControlOtherThan(getContainer().getActor().getAlliedFactions());
	}

	dows.onUse = function( _user, _targetTile ) {
		local myTile = _user.getTile();
		local actors = Tactical.Entities.getInstancesOfFaction(_user.getFaction());

		foreach( a in actors ) {
			if (a.getID() == _user.getID())
				continue;

			if (a.getFaction() == _user.getFaction()) {
				if(a.getSkills().hasSkill("effects.drums_of_war")) {
					local s = a.getSkills().getSkillByID("effects.drums_of_war");
					s.onRefresh();
				} else
					a.getSkills().add(new("scripts/skills/effects/drums_of_war_effect"));
			}
		}

		getContainer().add(new("scripts/skills/effects/drums_of_war_effect"));
		return true;
	}
});
