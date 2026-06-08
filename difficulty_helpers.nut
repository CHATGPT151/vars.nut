// Difficulty System Helper Functions

/**
 * Get display name untuk difficulty
 * @param difficultyKey: difficulty key (e.g. "Nightmare", "Expert-")
 * @returns: Display name untuk HUD
 */
function GetDifficultyDisplayName(difficultyKey) {
	if (difficultyKey in DifficultyDisplayNames) {
		return DifficultyDisplayNames[difficultyKey];
	}
	return difficultyKey;
}

/**
 * Get numeric difficulty level
 * @param difficultyKey: difficulty key
 * @returns: Numeric representation (e.g. "5" untuk Nightmare)
 */
function GetDifficultyNumber(difficultyKey) {
	if (difficultyKey in DifficultyMapping) {
		return DifficultyMapping[difficultyKey];
	}
	return "0";
}

/**
 * Check if difficulty has zombie buffs enabled
 * @param difficultyKey: difficulty key
 * @returns: true jika ada speed buffs untuk zombie
 */
function HasZombieBuffs(difficultyKey) {
	if (difficultyKey in DifficultyConfigs) {
		local config = DifficultyConfigs[difficultyKey];
		if ("infected" in config) {
			local infected = config.infected;
			return (infected.z_tank_speed_enabled == 1 || 
					infected.z_spitter_speed_enabled == 1 ||
					infected.z_witch_speed_enabled == 1);
		}
	}
	return false;
}

/**
 * List semua available difficulties
 * @returns: Array of difficulty names
 */
function GetAvailableDifficulties() {
	local difficulties = [];
	foreach (key, value in DifficultyConfigs) {
		difficulties.push(key);
	}
	return difficulties;
}

/**
 * Get full config untuk difficulty tertentu
 * @param difficultyKey: difficulty key
 * @returns: Config table atau null
 */
function GetDifficultyConfig(difficultyKey) {
	if (difficultyKey in DifficultyConfigs) {
		return DifficultyConfigs[difficultyKey];
	}
	return null;
}

/**
 * Get specific convar value dari difficulty config
 * @param difficultyKey: difficulty key
 * @param convarName: nama convar (e.g. "z_tank_health")
 * @returns: value atau null
 */
function GetDifficultyConvarValue(difficultyKey, convarName) {
	if (difficultyKey in DifficultyConfigs) {
		local config = DifficultyConfigs[difficultyKey];
		if ("convars" in config) {
			local convars = config.convars;
			if (convarName in convars) {
				return convars[convarName];
			}
		}
	}
	return null;
}

/**
 * Compare dua difficulty untuk melihat perbedaan
 * @param diff1: difficulty key 1
 * @param diff2: difficulty key 2
 * @returns: Table dengan perbedaan
 */
function CompareDifficulties(diff1, diff2) {
	local config1 = GetDifficultyConfig(diff1);
	local config2 = GetDifficultyConfig(diff2);
	
	local differences = {
		survivor_changes = {},
		infected_changes = {},
		director_changes = {},
		convar_changes = {}
	};
	
	if (config1 == null || config2 == null) {
		return null;
	}
	
	// Compare survivor settings
	if ("survivor" in config1 && "survivor" in config2) {
		foreach (key, value1 in config1.survivor) {
			local value2 = config2.survivor[key];
			if (value1 != value2) {
				differences.survivor_changes[key] <- {
					old = value1,
					new = value2
				};
			}
		}
	}
	
	// Compare infected settings
	if ("infected" in config1 && "infected" in config2) {
		foreach (key, value1 in config1.infected) {
			local value2 = config2.infected[key];
			if (value1 != value2) {
				differences.infected_changes[key] <- {
					old = value1,
					new = value2
				};
			}
		}
	}
	
	// Compare director options
	if ("director" in config1 && "director" in config2) {
		foreach (key, value1 in config1.director) {
			local value2 = config2.director[key];
			if (value1 != value2) {
				differences.director_changes[key] <- {
					old = value1,
					new = value2
				};
			}
		}
	}
	
	return differences;
}

/**
 * Print difficulty info ke console
 * @param difficultyKey: difficulty key
 */
function PrintDifficultyInfo(difficultyKey) {
	Msg("=== Difficulty: " + difficultyKey + " ===\n");
	Msg("Display Name: " + GetDifficultyDisplayName(difficultyKey) + "\n");
	Msg("Numeric Level: " + GetDifficultyNumber(difficultyKey) + "\n");
	Msg("Has Zombie Buffs: " + (HasZombieBuffs(difficultyKey) ? "YES" : "NO") + "\n");
	
	local config = GetDifficultyConfig(difficultyKey);
	if (config != null) {
		if ("infected" in config) {
			local infected = config.infected;
			Msg("--- Infected Stats ---\n");
			Msg("  Tank Speed: " + infected.z_tank_speed + " (enabled: " + infected.z_tank_speed_enabled + ")\n");
			Msg("  Spitter Speed: " + infected.z_spitter_speed + " (enabled: " + infected.z_spitter_speed_enabled + ")\n");
			Msg("  Witch Speed: " + infected.z_witch_speed + " (enabled: " + infected.z_witch_speed_enabled + ")\n");
			Msg("  Common Zombie Speed: " + infected.z_speed + " (enabled: " + infected.z_speed_enabled + ")\n");
		}
		
		if ("director" in config) {
			local director = config.director;
			Msg("--- Director Options ---\n");
			Msg("  Common Damage: " + director.cm_BaseCommonAttackDamage + "\n");
			Msg("  Max Specials: " + director.cm_MaxSpecials + "\n");
			Msg("  Tank Damage Multiplier: " + director.TankHitDamageModifierCoop + "\n");
		}
	}
	Msg("\n");
}
