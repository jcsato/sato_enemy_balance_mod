::mods_queue("sato_enemy_balance", ">sato_additional_equipment", function() {
	::Const.Tactical.Actor.Billman.RangedDefense = 15;		// Default is 5
	::Const.Tactical.Actor.StandardBearer.Bravery = 130;	// Default is 90

	local equipShield = function(items, banner) {
		local r = Math.rand(1, 2);
		local shield;

		if (r == 1)
			shield = new("scripts/items/shields/faction_heater_shield");
		else if (r == 2)
			shield = new("scripts/items/shields/faction_kite_shield");

		shield.setFaction(banner);
		items.equip(shield);
	};

	local assignFootmanEquipment = function() {
		local r;
		local banner = 3;

		local shouldUpgradeEquipment = World.FactionManager.isGreaterEvil();

		if (!Tactical.State.isScenarioMode())
			banner = World.FactionManager.getFaction(getFaction()).getBanner();
		else {
			banner = getFaction();
			shouldUpgradeEquipment = true;
		}


		m.Surcoat = banner;

		if (Math.rand(1, 100) <= 90)
			getSprite("surcoat").setBrush("surcoat_" + (banner < 10 ? "0" + banner : banner));

		r = Math.rand(1, 4);

		if (r == 1)
			m.Items.equip(new("scripts/items/weapons/military_pick"));
		else if (r == 2)
			m.Items.equip(new("scripts/items/weapons/arming_sword"));
		else if (r == 3)
			m.Items.equip(new("scripts/items/weapons/falchion"));
		else if (r == 4)
			m.Items.equip(new("scripts/items/weapons/morning_star"));

		if (Const.DLC.Unhold && shouldUpgradeEquipment && Math.rand(1, 6) == 1)
			m.Items.equip(new("scripts/items/weapons/three_headed_flail"));

		equipShield(m.Items, banner);

		local armorList = [
			"scripts/items/armor/mail_hauberk",
			"scripts/items/armor/mail_shirt"
		];

		if (shouldUpgradeEquipment) {
			armorList.extend([
				"scripts/items/armor/mail_shirt",
				"scripts/items/armor/mail_shirt",
				"scripts/items/armor/mail_hauberk",
				"scripts/items/armor/mail_hauberk",
				"scripts/items/armor/reinforced_mail_hauberk"
			]);

			if (Const.DLC.Unhold) {
				armorList.extend([
					"scripts/items/armor/footman_armor",
					"scripts/items/armor/footman_armor",
					"scripts/items/armor/footman_armor"
				]);
			}
		} else {
			armorList.push("scripts/items/armor/basic_mail_shirt");
		}

		r = Math.rand(0, armorList.len() - 1);
		local armor = new(armorList[r]);
		if (armorList[r] == "scripts/items/armor/mail_hauberk")
			armor.setVariant(28);
		else if (armorList[r] == "scripts/items/armor/footman_armor")
			armor.setVariant(84);

		m.Items.equip(armor);

		local helmet;

		if (banner <= 4) {
			r = Math.rand(1, 4);

			if (r == 1)
				helmet = new("scripts/items/helmets/kettle_hat");
			else if (r == 2)
				helmet = new("scripts/items/helmets/padded_kettle_hat");
			else if (r == 3)
				helmet = new("scripts/items/helmets/kettle_hat_with_mail");
			else {
				if (shouldUpgradeEquipment)
					helmet = new("scripts/items/helmets/kettle_hat_with_closed_mail");
				else
					helmet = new("scripts/items/helmets/mail_coif");
			}
		}
		else if (banner <= 7) {
			r = Math.rand(1, 4);

			if (r == 1) {
				if (shouldUpgradeEquipment && Math.rand(1, 10) == 1)
					helmet = new("scripts/items/helmets/closed_flat_top_helmet");
				else
					helmet = new("scripts/items/helmets/flat_top_helmet");
			}
			else if (r == 2) {
				if (shouldUpgradeEquipment && Math.rand(1, 10) == 1)
					helmet = new("scripts/items/helmets/closed_flat_top_with_neckguard");
				else
					helmet = new("scripts/items/helmets/padded_flat_top_helmet");
			}
			else if (r == 3)
				helmet = new("scripts/items/helmets/flat_top_with_mail");
			else {
				if (shouldUpgradeEquipment) {
					if (Math.rand(1, 10) == 1)
						helmet = new("scripts/items/helmets/closed_flat_top_with_mail");
					else
						helmet = new("scripts/items/helmets/flat_top_with_closed_mail");
				} else {
					helmet = new("scripts/items/helmets/mail_coif");
				}
			}
		}
		else {
			r = Math.rand(1, 4);

			if (r == 1) {
				if (::mods_getRegisteredMod("sato_additional_equipment") != null && shouldUpgradeEquipment && Math.rand(1, 10) == 1)
					helmet = new("scripts/items/helmets/closed_conic_helmet");
				else
					helmet = new("scripts/items/helmets/nasal_helmet");
			}
			else if (r == 2) {
				if (::mods_getRegisteredMod("sato_additional_equipment") != null && shouldUpgradeEquipment && Math.rand(1, 10) == 1)
					helmet = new("scripts/items/helmets/closed_conic_helmet_with_neckguard");
				else
					helmet = new("scripts/items/helmets/padded_nasal_helmet");
			}
			else if (r == 3)
				helmet = new("scripts/items/helmets/nasal_helmet_with_mail");
			else {
				if (shouldUpgradeEquipment) {
					if (::mods_getRegisteredMod("sato_additional_equipment") != null && Math.rand(1, 10) == 1)
						helmet = new("scripts/items/helmets/closed_conic_helmet_with_mail");
					else
						helmet = new("scripts/items/helmets/nasal_helmet_with_closed_mail");
				} else {
					helmet = new("scripts/items/helmets/mail_coif");
				}
			}
		}

		if (helmet != null) {
			if (helmet.getID() == "armor.head.flat_top_with_closed_mail")
				helmet.setVariant(15);

			helmet.setPlainVariant();
			m.Items.equip(helmet);
		}
	};

	local getKnightWeaponForFaction = function(faction, canEquipTwoHanders) {
		local oneHandedWeapons = [];
		local twoHandedWeapons = [];

		if (faction.hasTrait(Const.FactionTrait.Marauder)) {
			// (Warmonger, Marauder) (Tyrant, Marauder) (Schemer, Marauder)
			oneHandedWeapons.extend([ "scripts/items/weapons/warhammer" ]);
			twoHandedWeapons.extend([ "scripts/items/weapons/two_handed_hammer" ]);
			if (Const.DLC.Unhold) {
				oneHandedWeapons.extend([ "scripts/items/weapons/three_headed_flail" ]);
				twoHandedWeapons.extend([ "scripts/items/weapons/two_handed_flail" ]);
			}
		}

		if (faction.hasTrait(Const.FactionTrait.Warmonger)) {
			// (Warmonger, Man of the People) (Warmonger, Tyrant) (Warmonger, Marauder)
			oneHandedWeapons.extend([ "scripts/items/weapons/warhammer", "scripts/items/weapons/warhammer", "scripts/items/weapons/winged_mace" ]);
			twoHandedWeapons.extend([ "scripts/items/weapons/two_handed_hammer" ]);
			if (Const.DLC.Unhold)
				twoHandedWeapons.extend([ "scripts/items/weapons/two_handed_flanged_mace" ]);
		}

		if (faction.hasTrait(Const.FactionTrait.ManOfThePeople)) {
			// (Warmonger, Man of the People) (Sheriff, Man of the People) (Collector, Man of the People)
			oneHandedWeapons.extend([ "scripts/items/weapons/noble_sword" ]);
			twoHandedWeapons.extend([ "scripts/items/weapons/greatsword" ]);
		}

		if (faction.hasTrait(Const.FactionTrait.Tyrant)) {
			// (Tyrant, Marauder) (Warmonger, Tyrant) (Schemer, Tyrant)
			oneHandedWeapons.extend([ "scripts/items/weapons/fighting_axe" ]);
			twoHandedWeapons.extend([ "scripts/items/weapons/greataxe" ]);
		}

		if (faction.hasTrait(Const.FactionTrait.Sheriff)) {
			// (Sheriff, Man of the People) (Sheriff, Collector)
			oneHandedWeapons.extend([
				"scripts/items/weapons/noble_sword",
				"scripts/items/weapons/noble_sword",
				"scripts/items/weapons/winged_mace",
				"scripts/items/weapons/winged_mace"
			]);
			if (Const.DLC.Unhold) {
				twoHandedWeapons.extend(["scripts/items/weapons/two_handed_flanged_mace"]);
			}
		}

		if (faction.hasTrait(Const.FactionTrait.Collector)) {
			// (Sheriff, Collector) (Collector, Man of the People) (Schemer, Collector)
			oneHandedWeapons.extend([ "scripts/items/weapons/noble_sword" ]);
			if (Const.DLC.Wildmen) {
				twoHandedWeapons.extend([ "scripts/items/weapons/bardiche" ]);
			}
		}

		if (faction.hasTrait(Const.FactionTrait.Schemer)) {
			// (Schemer, Collector) (Schemer, Tyrant) (Schemer, Marauder)
			oneHandedWeapons.extend([ "scripts/items/weapons/noble_sword", "scripts/items/weapons/warhammer" ]);
			twoHandedWeapons.extend([ "scripts/items/weapons/two_handed_hammer" ]);
		}

		local weaponList = [];
		weaponList.extend(oneHandedWeapons);
		if (canEquipTwoHanders)
			weaponList.extend(twoHandedWeapons);

		local weapon = new(weaponList[Math.rand(0, weaponList.len() - 1)]);
		return weapon;
	};

	local getKnightArmorForFaction = function(faction) {
		local armorList = [];

		if (faction.hasTrait(Const.FactionTrait.Marauder)) {
			// (Warmonger, Marauder) (Tyrant, Marauder) (Schemer, Marauder)
			armorList.extend([ "scripts/items/armor/reinforced_mail_hauberk", "scripts/items/armor/lamellar_harness", "scripts/items/armor/heavy_lamellar_armor" ]);
		}

		if (faction.hasTrait(Const.FactionTrait.Warmonger)) {
			// (Warmonger, Man of the People) (Warmonger, Tyrant) (Warmonger, Marauder)
			armorList.extend([ "scripts/items/armor/coat_of_plates", "scripts/items/armor/coat_of_scales", "scripts/items/armor/heavy_lamellar_armor" ]);
		}

		if (faction.hasTrait(Const.FactionTrait.ManOfThePeople)) {
			// (Warmonger, Man of the People) (Sheriff, Man of the People) (Collector, Man of the People)
			armorList.extend([ "scripts/items/armor/coat_of_plates", "scripts/items/armor/coat_of_scales", "scripts/items/armor/scale_armor" ]);
		}

		if (faction.hasTrait(Const.FactionTrait.Tyrant)) {
			// (Tyrant, Marauder) (Warmonger, Tyrant) (Schemer, Tyrant)
			armorList.extend([ "scripts/items/armor/coat_of_plates", "scripts/items/armor/lamellar_harness" ]);
		}

		if (faction.hasTrait(Const.FactionTrait.Sheriff)) {
			// (Sheriff, Man of the People) (Sheriff, Collector)
			armorList.extend([ "scripts/items/armor/lamellar_harness", "scripts/items/armor/scale_armor" ]);
		}

		if (faction.hasTrait(Const.FactionTrait.Collector)) {
			// (Sheriff, Collector) (Collector, Man of the People) (Schemer, Collector)
			armorList.extend([ "scripts/items/armor/coat_of_plates", "scripts/items/armor/coat_of_scales" ]);
		}

		if (faction.hasTrait(Const.FactionTrait.Schemer)) {
			// (Schemer, Collector) (Schemer, Tyrant) (Schemer, Marauder)
			armorList.extend([ "scripts/items/armor/coat_of_plates", "scripts/items/armor/reinforced_mail_hauberk" ]);
		}

		local r = Math.rand(0, armorList.len() - 1);
		local armor = new(armorList[r]);
		if (armorList[r] == "scripts/items/armor/scale_armor")
			armor.setVariant(33);
		else if (armorList[r] == "scripts/items/armor/coat_of_scales")
			armor.setVariant(38);
		else if (armorList[r] == "scripts/items/armor/coat_of_plates")
			armor.setVariant(37);
		return armor;
	};

	// Return an array of extra perks (e.g. duelist, underdog) available for different factions
	local getKnightPerkListForFaction = function(faction) {
		local perkList = [];

		if (faction.hasTrait(Const.FactionTrait.Marauder)) {
			// (Warmonger, Marauder) (Tyrant, Marauder) (Schemer, Marauder)
			perkList.extend(["scripts/skills/perks/perk_backstabber"]);
		}
		if (faction.hasTrait(Const.FactionTrait.Warmonger)) {
			// (Warmonger, Man of the People) (Warmonger, Tyrant) (Warmonger, Marauder)
			perkList.extend(["scripts/skills/perks/perk_duelist"]);
		}
		if (faction.hasTrait(Const.FactionTrait.ManOfThePeople)) {
			// (Warmonger, Man of the People) (Sheriff, Man of the People) (Collector, Man of the People)
			perkList.extend(["scripts/skills/perks/perk_fortified_mind"]);
		}
		if (faction.hasTrait(Const.FactionTrait.Tyrant)) {
			// (Tyrant, Marauder) (Warmonger, Tyrant) (Schemer, Tyrant)
			perkList.extend(["scripts/skills/perks/perk_fearsome"]);
		}
		if (faction.hasTrait(Const.FactionTrait.Sheriff)) {
			// (Sheriff, Man of the People) (Sheriff, Collector)
			perkList.extend(["scripts/skills/perks/perk_lone_wolf"]);
		}
		if (faction.hasTrait(Const.FactionTrait.Collector)) {
			// (Sheriff, Collector) (Collector, Man of the People) (Schemer, Collector)
			perkList.extend(["scripts/skills/perks/perk_head_hunter"]);
		}
		if (faction.hasTrait(Const.FactionTrait.Schemer)) {
			// (Schemer, Collector) (Schemer, Tyrant) (Schemer, Marauder)
			perkList.extend(["scripts/skills/perks/perk_anticipation"]);
		}

		local perk = perkList[Math.rand(0, perkList.len() - 1)];
		return perk;
	};

	local assignKnightEquipment = function() {
		local r;
		local banner = 4;

		local useFactionTraits = ("State" in Tactical) && Tactical.State != null && !Tactical.State.isScenarioMode();
		local canEquipTwoHanders = m.Items.hasEmptySlot(Const.ItemSlot.Offhand);
		local shouldEquipShield = true;
		local weapon;
		local armor;
		local perk;

		if (useFactionTraits) {
			local faction = World.FactionManager.getFaction(getFaction());
			armor = getKnightArmorForFaction(faction);
			perk = getKnightPerkListForFaction(faction);
			if (perk == "scripts/skills/perks/perk_duelist") {
				canEquipTwoHanders = false;
				shouldEquipShield = false;
			}
			banner = faction.getBanner();
			weapon = getKnightWeaponForFaction(faction, canEquipTwoHanders);
		}
		else {
			banner = getFaction();

			local perkList = [
				"scripts/skills/perks/perk_anticipation",
				"scripts/skills/perks/perk_backstabber",
				"scripts/skills/perks/perk_duelist",
				"scripts/skills/perks/perk_fearsome",
				"scripts/skills/perks/perk_fortified_mind",
				"scripts/skills/perks/perk_head_hunter",
				"scripts/skills/perks/perk_lone_wolf"
			];
			perk = perkList[Math.rand(0, perkList.len() - 1)];
			if (perk == "scripts/skills/perks/perk_duelist") {
				canEquipTwoHanders = false;
				shouldEquipShield = false;
			}

			local weaponList = [
				"scripts/items/weapons/fighting_axe",
				"scripts/items/weapons/noble_sword",
				"scripts/items/weapons/winged_mace",
				"scripts/items/weapons/warhammer"
			];
			if (canEquipTwoHanders) {
				weaponList.extend([
					"scripts/items/weapons/greatsword",
					"scripts/items/weapons/greataxe",
					"scripts/items/weapons/two_handed_hammer"
				]);

				if (Const.DLC.Unhold) {
					weaponList.extend([
						"scripts/items/weapons/two_handed_flail",
						"scripts/items/weapons/two_handed_flanged_mace"
					]);
				}

				if (Const.DLC.Wildmen) {
					weaponList.extend([
						"scripts/items/weapons/bardiche",
					]);
				}
			}
			weapon = new(weaponList[Math.rand(0, weaponList.len() - 1)]);

			local armorList = [
				"scripts/items/armor/coat_of_plates",
				"scripts/items/armor/coat_of_scales",
				"scripts/items/armor/scale_armor",
				"scripts/items/armor/reinforced_mail_hauberk",
				"scripts/items/armor/lamellar_harness",
				"scripts/items/armor/heavy_lamellar_armor"
			];

			r = Math.rand(0, armorList.len() - 1);
			armor = new(armorList[r]);
			if (armorList[r] == "scripts/items/armor/scale_armor")
				armor.setVariant(33);
			else if (armorList[r] == "scripts/items/armor/coat_of_scales")
				armor.setVariant(38);
			else if (armorList[r] == "scripts/items/armor/coat_of_plates")
				armor.setVariant(37);
		}

		m.Skills.add(new(perk));
		m.Surcoat = banner;

		if (Math.rand(1, 100) <= 90)
			getSprite("surcoat").setBrush("surcoat_" + (banner < 10 ? "0" + banner : banner));

		m.Items.equip(weapon);
		m.Items.equip(armor);

		if (shouldEquipShield && m.Items.hasEmptySlot(Const.ItemSlot.Offhand))
			equipShield(m.Items, banner);

		if (m.Items.hasEmptySlot(Const.ItemSlot.Head)) {
			r = Math.rand(1, 2);

			if (r == 1) {
				local helmet = new("scripts/items/helmets/full_helm");
				helmet.setPlainVariant();
				m.Items.equip(helmet);
			}
			else if (r == 2) {
				local helm = new("scripts/items/helmets/faction_helm");
				helm.setVariant(banner);
				m.Items.equip(helm);
			}
		}
	};

	local assignZweihanderEquipment = function() {
		local r;
		local banner = 3;

		if (!Tactical.State.isScenarioMode())
			banner = World.FactionManager.getFaction(getFaction()).getBanner();
		else
			banner = getFaction();

		m.Surcoat = banner;

		if (Math.rand(1, 100) <= 50)
			getSprite("surcoat").setBrush("surcoat_" + (banner < 10 ? "0" + banner : banner));

		r = Math.rand(1, 1);

		if (r == 1)
			m.Items.equip(new("scripts/items/weapons/greatsword"));

		local armorList = [
			"scripts/items/armor/mail_hauberk",
			"scripts/items/armor/mail_hauberk",
			"scripts/items/armor/scale_armor",
			"scripts/items/armor/reinforced_mail_hauberk"
		];

		if (Const.DLC.Unhold) {
			armorList.extend([
				"scripts/items/armor/footman_armor",
				"scripts/items/armor/noble_mail_armor"
			]);
		}

		r = Math.rand(0, armorList.len() - 1);
		local armor = new(armorList[r]);
		if (armorList[r] == "scripts/items/armor/mail_hauberk")
			armor.setVariant(28);
		else if (::mods_getRegisteredMod("sato_additional_equipment") != null) {
			if (armorList[r] == "scripts/items/armor/footman_armor")
				armor.setVariant(84);
			else if (armorList[r] == "scripts/items/armor/noble_mail_armor") {
				if (banner == 1)
					armor.setVariant(215); // Blue-Red
				else if (banner == 2)
					armor.setVariant(219); // Blue
				else if (banner == 3)
					armor.setVariant(210); // White
				else if (banner == 4)
					armor.setVariant(216); // Red
				else if (banner == 5)
					armor.setVariant(218); // Green-White
				else if (banner == 6)
					armor.setVariant(212); // Blue-White
				else if (banner == 7)
					armor.setVariant(213); // Green-Yellow-Blue
				else if (banner == 8)
					armor.setVariant(211); // Black
				else if (banner == 9)
					armor.setVariant(214); // Red-Yellow
				else if (banner == 10)
					armor.setVariant(217); // Green-Yellow
			}
		}
		m.Items.equip(armor);

		r = Math.rand(1, 2);

		if (r == 1)
			m.Items.equip(new("scripts/items/helmets/greatsword_hat"));
		else if (r == 2) {
			local helm = new("scripts/items/helmets/greatsword_faction_helm");
			helm.setVariant(banner);
			m.Items.equip(helm);
		}
	};

	::mods_hookBaseClass("entity/tactical/human", function(h) {
		while(!("assignRandomEquipment" in h)) h = h[h.SuperName];

		local assignRandomEquipment = h.assignRandomEquipment;

		h.assignRandomEquipment = function() {
			if (m.Type == Const.EntityType.Footman)
				assignFootmanEquipment();
			else if (m.Type == Const.EntityType.Knight && m.XP == Const.Tactical.Actor.Knight.XP)
				// The XP check is a gross hack around running this on Nobles, i.e. the units on the faction screen
				assignKnightEquipment();
			else if (m.Type == Const.EntityType.Greatsword)
				assignZweihanderEquipment();
			else
				assignRandomEquipment();
		}
	});
});
