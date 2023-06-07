::Const.World.Spawn.Troops.Lindwurm.Cost = 105;					// Default is 90

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

		calculateCosts(::Const.World.Spawn.Lindwurm);
	}
});

::mods_hookExactClass("skills/actives/gorge_skill", function(gs) {
	::mods_addField(gs, "gorge_skill", "DirectDamageMult", 0.25);	// Default 0.35
});
