IncludeScript("difficulty");
IncludeScript("tacticalMovement");
IncludeScript("commands");

var1 <- 0
game_time <- 0
round_started <- false
tank_spawn_time <- 1000
tank_spawned <- false
difficulty <- Convars.GetStr( "z_difficulty" );
::should_update <- true;

// ========== DIFFICULTY CONFIGURATION DATABASE ==========
// Difficulty Configuration System
// Semua buff zombie dikombinasikan ke Nightmare

DifficultyConfigs <- {
    "easy" = {
        survivor = {
            RunSpeed = 220.0,
            WalkSpeed = 195.0,
            CrouchSpeed = 195.0,
            RunSpeedEnabled = 0,
            WalkSpeedEnabled = 0,
            CrouchSpeedEnabled = 0,
        },
        infected = {
            z_tank_speed = 210.0,
            z_spitter_speed = 210.0,
            z_witch_speed = 300.0,
            z_witch_speed_inured = 300.0,
            z_charge_start_speed = 271.0,
            z_jockey_speed = 265.0,
            z_hunter_speed = 307.5,
            z_boomer_speed = 183,
            z_smoker_speed = 216.0,
            z_speed = 250,
            z_tank_speed_enabled = 0,
            z_spitter_speed_enabled = 0,
            z_witch_speed_enabled = 0,
            z_witch_speed_inured_enabled = 0,
            z_charge_start_speed_enabled = 0,
            z_jockey_speed_enabled = 0,
            z_hunter_speed_enabled = 0,
            z_boomer_speed_enabled = 0,
            z_smoker_speed_enabled = 0,
            z_speed_enabled = 1,
        },
        director = {
            ActiveChallenge = 1,
            cm_BaseCommonAttackDamage = 1,
            cm_MaxSpecials = 3,
            cm_BaseSpecialLimit = 1,
            DominatorLimit = 3,
            cm_WanderingZombieDensityModifier = 0.015,
            ShouldAllowSpecialsWithTank = true,
            TankHitDamageModifierCoop = 1,
            TempHealthDecayRate = 0.2,
            cm_SpecialRespawnInterval = 45,
            cm_CommonLimit = 30,
            SpecialInitialSpawnDelayMin = 30,
            SpecialInitialSpawnDelayMax = 60,
            MobSpawnMaxTime = 180,
            MobSpawnMinTime = 90,
            IntensityRelaxAllowWanderersThreshold = 0.8,
            ZombieSpawnRange = 1500,
        },
        convars = {
            sv_consistency = 0,
            sv_pure_kick_clients = 0,
            z_hit_from_behind_factor = 0.5,
            z_charge_max_speed = 500,
            z_charger_health = 600,
            z_charge_interval = 12,
            z_charger_pound_dmg = 15,
            z_charge_impact_radius = 120,
            z_charge_prop_damage = 20,
            z_health = 50,
            survivor_burn_factor_normal = 0.2,
            z_tank_health = 4000,
            z_tank_throw_force = 800,
            z_tank_throw_health = 50,
            z_tank_footstep_shake_radius = 750,
            z_tank_footstep_shake_amplitude = 5,
            z_spitter_health = 100,
            z_jockey_ride_damage_delay = 1,
            hunter_pz_claw_dmg = 6,
            z_jockey_health = 325,
            tank_burn_duration = 100,
            z_non_head_damage_factor_normal = 1,
            z_witch_speed = 300,
            z_witch_anger_rate = 0.2,
            survivor_friendly_fire_factor_normal = 0.1,
            z_spitter_max_wait_time = 30,
            survivor_incap_decay_rate = 3,
            boomer_exposed_time_tolerance = 1,
            sb_vomit_blind_time = 5,
            z_exploding_splat = 50,
            z_exploding_splat_radius = 200,
            z_exploding_force = 5000,
            z_exploding_health = 50,
            z_hunter_health = 250,
            z_exploding_inner_radius = 130,
            z_exploding_outer_radius = 200,
            boomer_vomit_delay = 1,
            tongue_choke_damage_amount = 10,
            tongue_choke_damage_interval = 1,
            tongue_health = 100,
            z_pounce_damage = 5,
            z_pounce_damage_delay = 1,
            z_pounce_damage_interrupt = 50,
            z_pounce_damage_interval = 0.5,
            z_jockey_ride_damage = 4,
            z_jockey_ride_damage_delay = 1,
            z_jockey_ride_damage_interval = 1,
            z_charge_max_damage = 10,
            z_witch_always_kills = 0,
            z_witch_burn_time = 15,
            hunter_pounce_air_speed = 700,
            z_hunter_lunge_distance = 750,
            boomer_pz_claw_dmg = 4,
            charger_pz_claw_dmg = 10,
            jockey_pz_claw_dmg = 4,
            tank_swing_duration = 0.2,
            tank_windup_time = 0.5,
            tank_swing_interval = 1.5,
            tank_swing_miss_interval = 1,
            smoker_tongue_delay = 1.5,
            director_convert_pills = 1,
            director_intensity_relax_allow_wanderers_threshold = 0.3,
            sb_friend_immobilized_reaction_time_normal = 2,
            survivor_revive_duration = 5,
            z_special_spawn_interval = 45,
            tongue_range = 750,
            tongue_hit_delay = 20,
            tongue_miss_delay = 15,
            z_spitter_range = 850,
            z_gas_health = 250,
            pain_pills_health_value = 50,
            first_aid_heal_percent = 0.8,
            first_aid_kit_max_heal = 100,
            first_aid_kit_use_duration = 5,
            survivor_max_incapacitated_count = 2,
            z_survivor_respawn_health = 50,
            pain_pills_health_threshold = 99,
            sb_temp_health_consider_factor = 0.5,
            adrenaline_run_speed = 260,
            adrenaline_duration = 15,
            adrenaline_health_buffer = 25,
            survivor_incap_health = 300,
            survivor_ledge_grab_health = 300,
            survivor_limp_health = 40,
            survivor_revive_health = 30,
            z_mega_mob_spawn_min_interval = 420,
            z_mega_mob_spawn_max_interval = 900,
            z_mega_mob_size = 50,
            z_mob_spawn_max_interval_normal = 180,
            z_mob_spawn_min_size = 10,
            z_mob_spawn_max_size = 30,
        }
    },
    "normal" = {
        survivor = {
            RunSpeed = 220.0,
            WalkSpeed = 195.0,
            CrouchSpeed = 195.0,
            RunSpeedEnabled = 0,
            WalkSpeedEnabled = 0,
            CrouchSpeedEnabled = 0,
        },
        infected = {
            z_tank_speed = 210.0,
            z_spitter_speed = 210.0,
            z_witch_speed = 300.0,
            z_witch_speed_inured = 300.0,
            z_charge_start_speed = 271.0,
            z_jockey_speed = 265.0,
            z_hunter_speed = 307.5,
            z_boomer_speed = 183,
            z_smoker_speed = 216.0,
            z_speed = 250,
            z_tank_speed_enabled = 0,
            z_spitter_speed_enabled = 0,
            z_witch_speed_enabled = 0,
            z_witch_speed_inured_enabled = 0,
            z_charge_start_speed_enabled = 0,
            z_jockey_speed_enabled = 0,
            z_hunter_speed_enabled = 0,
            z_boomer_speed_enabled = 0,
            z_smoker_speed_enabled = 0,
            z_speed_enabled = 1,
        },
        director = {
            ActiveChallenge = 1,
            cm_BaseCommonAttackDamage = 1,
            cm_MaxSpecials = 3,
            cm_BaseSpecialLimit = 1,
            DominatorLimit = 3,
            cm_WanderingZombieDensityModifier = 0.015,
            ShouldAllowSpecialsWithTank = true,
            TankHitDamageModifierCoop = 1,
            TempHealthDecayRate = 0.2,
            cm_SpecialRespawnInterval = 45,
            cm_CommonLimit = 30,
            SpecialInitialSpawnDelayMin = 30,
            SpecialInitialSpawnDelayMax = 60,
            MobSpawnMaxTime = 180,
            MobSpawnMinTime = 90,
            IntensityRelaxAllowWanderersThreshold = 0.8,
            ZombieSpawnRange = 1500,
        },
        convars = {
            sv_consistency = 0,
            sv_pure_kick_clients = 0,
            z_hit_from_behind_factor = 0.5,
            z_charge_max_speed = 500,
            z_charger_health = 600,
            z_charge_interval = 12,
            z_charger_pound_dmg = 15,
            z_charge_impact_radius = 120,
            z_charge_prop_damage = 20,
            z_health = 50,
            survivor_burn_factor_normal = 0.2,
            z_tank_health = 4000,
            z_tank_throw_force = 800,
            z_tank_throw_health = 50,
            z_tank_footstep_shake_radius = 750,
            z_tank_footstep_shake_amplitude = 5,
            z_spitter_health = 100,
            z_jockey_ride_damage_delay = 1,
            hunter_pz_claw_dmg = 6,
            z_jockey_health = 325,
            tank_burn_duration = 100,
            z_non_head_damage_factor_normal = 1,
            z_witch_speed = 300,
            z_witch_anger_rate = 0.2,
            survivor_friendly_fire_factor_normal = 0.1,
            z_spitter_max_wait_time = 30,
            survivor_incap_decay_rate = 3,
            boomer_exposed_time_tolerance = 1,
            sb_vomit_blind_time = 5,
            z_exploding_splat = 50,
            z_exploding_splat_radius = 200,
            z_exploding_force = 5000,
            z_exploding_health = 50,
            z_hunter_health = 250,
            z_exploding_inner_radius = 130,
            z_exploding_outer_radius = 200,
            boomer_vomit_delay = 1,
            tongue_choke_damage_amount = 10,
            tongue_choke_damage_interval = 1,
            tongue_health = 100,
            z_pounce_damage = 5,
            z_pounce_damage_delay = 1,
            z_pounce_damage_interrupt = 50,
            z_pounce_damage_interval = 0.5,
            z_jockey_ride_damage = 4,
            z_jockey_ride_damage_delay = 1,
            z_jockey_ride_damage_interval = 1,
            z_charge_max_damage = 10,
            z_witch_always_kills = 0,
            z_witch_burn_time = 15,
            hunter_pounce_air_speed = 700,
            z_hunter_lunge_distance = 750,
            boomer_pz_claw_dmg = 4,
            charger_pz_claw_dmg = 10,
            jockey_pz_claw_dmg = 4,
            tank_swing_duration = 0.2,
            tank_windup_time = 0.5,
            tank_swing_interval = 1.5,
            tank_swing_miss_interval = 1,
            smoker_tongue_delay = 1.5,
            director_convert_pills = 1,
            director_intensity_relax_allow_wanderers_threshold = 0.3,
            sb_friend_immobilized_reaction_time_normal = 2,
            survivor_revive_duration = 5,
            z_special_spawn_interval = 45,
            tongue_range = 750,
            tongue_hit_delay = 20,
            tongue_miss_delay = 15,
            z_spitter_range = 850,
            z_gas_health = 250,
            pain_pills_health_value = 50,
            first_aid_heal_percent = 0.8,
            first_aid_kit_max_heal = 100,
            first_aid_kit_use_duration = 5,
            survivor_max_incapacitated_count = 2,
            z_survivor_respawn_health = 50,
            pain_pills_health_threshold = 99,
            sb_temp_health_consider_factor = 0.5,
            adrenaline_run_speed = 260,
            adrenaline_duration = 15,
            adrenaline_health_buffer = 25,
            survivor_incap_health = 300,
            survivor_ledge_grab_health = 300,
            survivor_limp_health = 40,
            survivor_revive_health = 30,
            z_mega_mob_spawn_min_interval = 420,
            z_mega_mob_spawn_max_interval = 900,
            z_mega_mob_size = 50,
            z_mob_spawn_max_interval_normal = 180,
            z_mob_spawn_min_size = 10,
            z_mob_spawn_max_size = 30,
        }
    },
    "hard" = {
        survivor = {
            RunSpeed = 220.0,
            WalkSpeed = 195.0,
            CrouchSpeed = 195.0,
            RunSpeedEnabled = 0,
            WalkSpeedEnabled = 0,
            CrouchSpeedEnabled = 0,
        },
        infected = {
            z_tank_speed = 210.0,
            z_spitter_speed = 210.0,
            z_witch_speed = 300.0,
            z_witch_speed_inured = 300.0,
            z_charge_start_speed = 271.0,
            z_jockey_speed = 265.0,
            z_hunter_speed = 307.5,
            z_boomer_speed = 183,
            z_smoker_speed = 216.0,
            z_speed = 250,
            z_tank_speed_enabled = 0,
            z_spitter_speed_enabled = 0,
            z_witch_speed_enabled = 0,
            z_witch_speed_inured_enabled = 0,
            z_charge_start_speed_enabled = 0,
            z_jockey_speed_enabled = 0,
            z_hunter_speed_enabled = 0,
            z_boomer_speed_enabled = 0,
            z_smoker_speed_enabled = 0,
            z_speed_enabled = 1,
        },
        director = {
            ActiveChallenge = 1,
            cm_BaseCommonAttackDamage = 1,
            cm_MaxSpecials = 3,
            cm_BaseSpecialLimit = 1,
            DominatorLimit = 3,
            cm_WanderingZombieDensityModifier = 0.015,
            ShouldAllowSpecialsWithTank = true,
            TankHitDamageModifierCoop = 1,
            TempHealthDecayRate = 0.2,
            cm_SpecialRespawnInterval = 45,
            cm_CommonLimit = 30,
            SpecialInitialSpawnDelayMin = 30,
            SpecialInitialSpawnDelayMax = 60,
            MobSpawnMaxTime = 180,
            MobSpawnMinTime = 90,
            IntensityRelaxAllowWanderersThreshold = 0.8,
            ZombieSpawnRange = 1500,
        },
        convars = {
            sv_consistency = 0,
            sv_pure_kick_clients = 0,
            z_hit_from_behind_factor = 0.5,
            z_charge_max_speed = 500,
            z_charger_health = 600,
            z_charge_interval = 12,
            z_charger_pound_dmg = 15,
            z_charge_impact_radius = 120,
            z_charge_prop_damage = 20,
            z_health = 50,
            survivor_burn_factor_normal = 0.2,
            z_tank_health = 4000,
            z_tank_throw_force = 800,
            z_tank_throw_health = 50,
            z_tank_footstep_shake_radius = 750,
            z_tank_footstep_shake_amplitude = 5,
            z_spitter_health = 100,
            z_jockey_ride_damage_delay = 1,
            hunter_pz_claw_dmg = 6,
            z_jockey_health = 325,
            tank_burn_duration = 100,
            z_non_head_damage_factor_normal = 1,
            z_witch_speed = 300,
            z_witch_anger_rate = 0.2,
            survivor_friendly_fire_factor_normal = 0.1,
            z_spitter_max_wait_time = 30,
            survivor_incap_decay_rate = 3,
            boomer_exposed_time_tolerance = 1,
            sb_vomit_blind_time = 5,
            z_exploding_splat = 50,
            z_exploding_splat_radius = 200,
            z_exploding_force = 5000,
            z_exploding_health = 50,
            z_hunter_health = 250,
            z_exploding_inner_radius = 130,
            z_exploding_outer_radius = 200,
            boomer_vomit_delay = 1,
            tongue_choke_damage_amount = 10,
            tongue_choke_damage_interval = 1,
            tongue_health = 100,
            z_pounce_damage = 5,
            z_pounce_damage_delay = 1,
            z_pounce_damage_interrupt = 50,
            z_pounce_damage_interval = 0.5,
            z_jockey_ride_damage = 4,
            z_jockey_ride_damage_delay = 1,
            z_jockey_ride_damage_interval = 1,
            z_charge_max_damage = 10,
            z_witch_always_kills = 0,
            z_witch_burn_time = 15,
            hunter_pounce_air_speed = 700,
            z_hunter_lunge_distance = 750,
            boomer_pz_claw_dmg = 4,
            charger_pz_claw_dmg = 10,
            jockey_pz_claw_dmg = 4,
            tank_swing_duration = 0.2,
            tank_windup_time = 0.5,
            tank_swing_interval = 1.5,
            tank_swing_miss_interval = 1,
            smoker_tongue_delay = 1.5,
            director_convert_pills = 1,
            director_intensity_relax_allow_wanderers_threshold = 0.3,
            sb_friend_immobilized_reaction_time_normal = 2,
            survivor_revive_duration = 5,
            z_special_spawn_interval = 45,
            tongue_range = 750,
            tongue_hit_delay = 20,
            tongue_miss_delay = 15,
            z_spitter_range = 850,
            z_gas_health = 250,
            pain_pills_health_value = 50,
            first_aid_heal_percent = 0.8,
            first_aid_kit_max_heal = 100,
            first_aid_kit_use_duration = 5,
            survivor_max_incapacitated_count = 2,
            z_survivor_respawn_health = 50,
            pain_pills_health_threshold = 99,
            sb_temp_health_consider_factor = 0.5,
            adrenaline_run_speed = 260,
            adrenaline_duration = 15,
            adrenaline_health_buffer = 25,
            survivor_incap_health = 300,
            survivor_ledge_grab_health = 300,
            survivor_limp_health = 40,
            survivor_revive_health = 30,
            z_mega_mob_spawn_min_interval = 420,
            z_mega_mob_spawn_max_interval = 900,
            z_mega_mob_size = 50,
            z_mob_spawn_max_interval_normal = 180,
            z_mob_spawn_min_size = 10,
            z_mob_spawn_max_size = 30,
        }
    },
    "Expert-" = {
        survivor = {
            RunSpeed = 220.0,
            WalkSpeed = 195.0,
            CrouchSpeed = 195.0,
            RunSpeedEnabled = 0,
            WalkSpeedEnabled = 0,
            CrouchSpeedEnabled = 0,
        },
        infected = {
            z_tank_speed = 210.0,
            z_spitter_speed = 210.0,
            z_witch_speed = 300.0,
            z_witch_speed_inured = 300.0,
            z_charge_start_speed = 271.0,
            z_jockey_speed = 265.0,
            z_hunter_speed = 307.5,
            z_boomer_speed = 183,
            z_smoker_speed = 216.0,
            z_speed = 250,
            z_tank_speed_enabled = 0,
            z_spitter_speed_enabled = 0,
            z_witch_speed_enabled = 0,
            z_witch_speed_inured_enabled = 0,
            z_charge_start_speed_enabled = 0,
            z_jockey_speed_enabled = 0,
            z_hunter_speed_enabled = 0,
            z_boomer_speed_enabled = 0,
            z_smoker_speed_enabled = 0,
            z_speed_enabled = 1,
        },
        director = {
            ActiveChallenge = 1,
            cm_BaseCommonAttackDamage = 5,
            cm_MaxSpecials = 3,
            cm_BaseSpecialLimit = 1,
            DominatorLimit = 3,
            cm_WanderingZombieDensityModifier = 0.015,
            ShouldAllowSpecialsWithTank = true,
            TankHitDamageModifierCoop = 2.5,
            TempHealthDecayRate = 0.2,
            cm_SpecialRespawnInterval = 45,
            cm_CommonLimit = 30,
            SpecialInitialSpawnDelayMin = 30,
            SpecialInitialSpawnDelayMax = 60,
            MobSpawnMaxTime = 180,
            MobSpawnMinTime = 90,
            IntensityRelaxAllowWanderersThreshold = 0.8,
            ZombieSpawnRange = 1500,
        },
        convars = {
            sv_consistency = 0,
            sv_pure_kick_clients = 0,
            z_hit_from_behind_factor = 0.5,
            z_charge_max_speed = 500,
            z_charger_health = 600,
            z_charge_interval = 12,
            z_charger_pound_dmg = 15,
            z_charge_impact_radius = 120,
            z_charge_prop_damage = 20,
            z_health = 50,
            survivor_burn_factor_normal = 0.2,
            z_tank_health = 8000,
            z_tank_throw_force = 800,
            z_tank_throw_health = 50,
            z_tank_footstep_shake_radius = 750,
            z_tank_footstep_shake_amplitude = 5,
            z_spitter_health = 100,
            z_jockey_ride_damage_delay = 1,
            hunter_pz_claw_dmg = 12,
            z_jockey_health = 325,
            tank_burn_duration = 100,
            z_non_head_damage_factor_normal = 1,
            z_witch_speed = 300,
            z_witch_anger_rate = 0.2,
            survivor_friendly_fire_factor_normal = 0.1,
            z_spitter_max_wait_time = 30,
            survivor_incap_decay_rate = 3,
            boomer_exposed_time_tolerance = 0.5,
            sb_vomit_blind_time = 5,
            z_exploding_splat = 50,
            z_exploding_splat_radius = 200,
            z_exploding_force = 5000,
            z_exploding_health = 50,
            z_hunter_health = 250,
            z_exploding_inner_radius = 130,
            z_exploding_outer_radius = 200,
            boomer_vomit_delay = 0.5,
            tongue_choke_damage_amount = 25,
            tongue_choke_damage_interval = 1,
            tongue_health = 100,
            z_pounce_damage = 12,
            z_pounce_damage_delay = 1,
            z_pounce_damage_interrupt = 50,
            z_pounce_damage_interval = 0.5,
            z_jockey_ride_damage = 10,
            z_jockey_ride_damage_delay = 1,
            z_jockey_ride_damage_interval = 1,
            z_charge_max_damage = 10,
            z_witch_always_kills = 0,
            z_witch_burn_time = 15,
            hunter_pounce_air_speed = 700,
            z_hunter_lunge_distance = 750,
            boomer_pz_claw_dmg = 10,
            charger_pz_claw_dmg = 10,
            jockey_pz_claw_dmg = 10,
            tank_swing_duration = 0.2,
            tank_windup_time = 0.5,
            tank_swing_interval = 1.5,
            tank_swing_miss_interval = 1,
            smoker_tongue_delay = 0,
            director_convert_pills = 1,
            director_intensity_relax_allow_wanderers_threshold = 0.3,
            sb_friend_immobilized_reaction_time_normal = 2,
            survivor_revive_duration = 5,
            z_special_spawn_interval = 45,
            tongue_range = 750,
            tongue_hit_delay = 20,
            tongue_miss_delay = 15,
            z_spitter_range = 850,
            z_gas_health = 250,
            pain_pills_health_value = 50,
            first_aid_heal_percent = 0.8,
            first_aid_kit_max_heal = 100,
            first_aid_kit_use_duration = 5,
            survivor_max_incapacitated_count = 2,
            z_survivor_respawn_health = 50,
            pain_pills_health_threshold = 99,
            sb_temp_health_consider_factor = 0.5,
            adrenaline_run_speed = 260,
            adrenaline_duration = 15,
            adrenaline_health_buffer = 25,
            survivor_incap_health = 300,
            survivor_ledge_grab_health = 300,
            survivor_limp_health = 40,
            survivor_revive_health = 30,
            z_mega_mob_spawn_min_interval = 420,
            z_mega_mob_spawn_max_interval = 900,
            z_mega_mob_size = 50,
            z_mob_spawn_max_interval_normal = 180,
            z_mob_spawn_min_size = 10,
            z_mob_spawn_max_size = 30,
        }
    },
    // NIGHTMARE LEVEL - Kombinasi semua buff zombie, TANPA debuff survivor
    "Nightmare" = {
        survivor = {
            RunSpeed = 220.0,
            WalkSpeed = 195.0,
            CrouchSpeed = 195.0,
            RunSpeedEnabled = 0,
            WalkSpeedEnabled = 0,
            CrouchSpeedEnabled = 0,
        },
        infected = {
            // Semua buff zombie dikombinasikan dari semua difficulty
            z_tank_speed = 215.0,
            z_spitter_speed = 300.0,
            z_witch_speed = 400.0,
            z_witch_speed_inured = 450.0,
            z_charge_start_speed = 500.0,
            z_jockey_speed = 450.0,
            z_hunter_speed = 500.0,
            z_boomer_speed = 300,
            z_smoker_speed = 320.0,
            z_speed = 335,
            z_tank_speed_enabled = 1,
            z_spitter_speed_enabled = 1,
            z_witch_speed_enabled = 1,
            z_witch_speed_inured_enabled = 1,
            z_charge_start_speed_enabled = 1,
            z_jockey_speed_enabled = 1,
            z_hunter_speed_enabled = 1,
            z_boomer_speed_enabled = 1,
            z_smoker_speed_enabled = 1,
            z_speed_enabled = 1,
        },
        director = {
            ActiveChallenge = 1,
            cm_BaseCommonAttackDamage = 100,
            cm_MaxSpecials = 5,
            cm_BaseSpecialLimit = 1,
            DominatorLimit = 5,
            cm_WanderingZombieDensityModifier = 0.025,
            ShouldAllowSpecialsWithTank = true,
            TankHitDamageModifierCoop = 1000,
            TempHealthDecayRate = 0.3,
            cm_SpecialRespawnInterval = 18,
            cm_CommonLimit = 50,
            SpecialInitialSpawnDelayMin = 15,
            SpecialInitialSpawnDelayMax = 30,
            MobSpawnMaxTime = 100,
            MobSpawnMinTime = 50,
            IntensityRelaxAllowWanderersThreshold = 1,
            ZombieSpawnRange = 1700,
        },
        convars = {
            sv_consistency = 0,
            sv_pure_kick_clients = 0,
            z_hit_from_behind_factor = 1,
            z_charge_max_speed = 1000,
            z_charger_health = 1300,
            z_charge_interval = 0,
            z_charger_pound_dmg = 100,
            z_charge_impact_radius = 180,
            z_charge_prop_damage = 25,
            z_health = 85,
            survivor_burn_factor_normal = 10,
            z_tank_health = 16000,
            z_tank_throw_force = 1200,
            z_tank_throw_health = 90,
            z_tank_footstep_shake_radius = 1250,
            z_tank_footstep_shake_amplitude = 8,
            z_spitter_health = 400,
            z_jockey_ride_damage_delay = 0.2,
            hunter_pz_claw_dmg = 80,
            z_jockey_health = 600,
            tank_burn_duration = 150,
            z_non_head_damage_factor_normal = 0.25,
            z_witch_speed = 400,
            z_witch_anger_rate = 0.3,
            survivor_friendly_fire_factor_normal = 50,
            z_spitter_max_wait_time = 3,
            survivor_incap_decay_rate = 20,
            boomer_exposed_time_tolerance = 0,
            sb_vomit_blind_time = 15,
            z_exploding_splat = 100,
            z_exploding_splat_radius = 500,
            z_exploding_force = 50000,
            z_exploding_health = 350,
            z_hunter_health = 600,
            z_exploding_inner_radius = 400,
            z_exploding_outer_radius = 500,
            boomer_vomit_delay = 0,
            tongue_choke_damage_amount = 75,
            tongue_choke_damage_interval = 0.3,
            tongue_health = 250,
            z_pounce_damage = 100,
            z_pounce_damage_delay = 0.3,
            z_pounce_damage_interrupt = 300,
            z_pounce_damage_interval = 0.3,
            z_jockey_ride_damage = 40,
            z_jockey_ride_damage_delay = 0.3,
            z_jockey_ride_damage_interval = 0.3,
            z_charge_max_damage = 100,
            z_witch_always_kills = 1,
            z_witch_burn_time = 50,
            hunter_pounce_air_speed = 1100,
            z_hunter_lunge_distance = 1200,
            boomer_pz_claw_dmg = 80,
            charger_pz_claw_dmg = 80,
            jockey_pz_claw_dmg = 80,
            tank_swing_duration = 0.12,
            tank_windup_time = 0.25,
            tank_swing_interval = 1,
            tank_swing_miss_interval = 0.6,
            smoker_tongue_delay = 0,
            director_convert_pills = 0,
            director_intensity_relax_allow_wanderers_threshold = 1,
            sb_friend_immobilized_reaction_time_normal = 0.0,
            survivor_revive_duration = 7,
            z_special_spawn_interval = 18,
            tongue_range = 1000,
            tongue_hit_delay = 10,
            tongue_miss_delay = 5,
            z_spitter_range = 1000,
            z_gas_health = 450,
            // Survivor stats TIDAK dikurangi (TANPA debuff)
            pain_pills_health_value = 50,
            first_aid_heal_percent = 1,
            first_aid_kit_max_heal = 100,
            first_aid_kit_use_duration = 5,
            survivor_max_incapacitated_count = 2,
            z_survivor_respawn_health = 50,
            pain_pills_health_threshold = 99,
            sb_temp_health_consider_factor = 0.5,
            adrenaline_run_speed = 260,
            adrenaline_duration = 15,
            adrenaline_health_buffer = 25,
            survivor_incap_health = 300,
            survivor_ledge_grab_health = 300,
            survivor_limp_health = 40,
            survivor_revive_health = 30,
            z_mega_mob_spawn_min_interval = 120,
            z_mega_mob_spawn_max_interval = 300,
            z_mega_mob_size = 100,
            z_mob_spawn_max_interval_normal = 120,
            z_mob_spawn_min_size = 20,
            z_mob_spawn_max_size = 60,
        }
    }
}

// Difficulty Display Names
DifficultyDisplayNames <- {
    "easy" = "Easy",
    "normal" = "Normal",
    "hard" = "Advanced",
    "Expert-" = "Expert-",
    "impossible" = "Expert",
    "Expert+" = "Expert+",
    "Nightmare-" = "Nightmare-",
    "Nightmare" = "Nightmare",
    "Nightmare+" = "Nightmare+",
    "Fiendish-" = "Fiendish-",
    "Fiendish" = "Fiendish",
    "Fiendish+" = "Fiendish+",
    "Cataclysmic-" = "Cataclysmic-",
    "Cataclysmic" = "Cataclysmic",
    "Cataclysmic+" = "Cataclysmic+",
    "Pandemonium-" = "Pandemonium-",
    "Pandemonium" = "Pandemonium",
    "Pandemonium+" = "Pandemonium+",
    "Unutterable-" = "Unutterable-",
    "Unutterable" = "Unutterable",
    "Unutterable+" = "Unutterable+",
    "Insurmountable-" = "Insurmountable-",
    "Insurmountable" = "Insurmountable",
}

// Difficulty Numeric Mapping
DifficultyMapping <- {
    "easy" = "1",
    "normal" = "2",
    "hard" = "3",
    "Expert-" = "4-",
    "impossible" = "4",
    "Expert+" = "4+",
    "Nightmare-" = "5-",
    "Nightmare" = "5",
    "Nightmare+" = "5+",
    "Fiendish-" = "6-",
    "Fiendish" = "6",
    "Fiendish+" = "6+",
    "Cataclysmic-" = "7-",
    "Cataclysmic" = "7",
    "Cataclysmic+" = "7+",
    "Pandemonium-" = "8-",
    "Pandemonium" = "8",
    "Pandemonium+" = "8+",
    "Unutterable-" = "9-",
    "Unutterable" = "9",
    "Unutterable+" = "9+",
    "Insurmountable-" = "10-",
    "Insurmountable" = "10",
}

// ========== END DIFFICULTY CONFIGURATION ==========

DirectorOptions <-
{
    ActiveChallenge = 1
	cm_BaseCommonAttackDamage = 1
	cm_MaxSpecials = 3
	cm_BaseSpecialLimit = 1
	DominatorLimit = 3

	cm_WanderingZombieDensityModifier = 0.015
	ShouldAllowSpecialsWithTank = true
	TankHitDamageModifierCoop = 1
	TempHealthDecayRate = 0.2
	cm_SpecialRespawnInterval = 45
	cm_MaxSpecials = 3
	cm_BaseSpecialLimit = 1
	cm_DominatorLimit = 3
	cm_CommonLimit = 30
	SpecialInitialSpawnDelayMin = 30
	SpecialInitialSpawnDelayMax = 60
	MobSpawnMaxTime = 180
	MobSpawnMinTime = 90
	IntensityRelaxAllowWanderersThreshold = 0.8
	ZombieSpawnRange = 1500
}

::HUDFlags <- {
	NOTVISIBLE = 16384
}

DifficultyHUD <- {
	Fields = 
	{
		difficultylevel   = { slot = HUD_LEFT_TOP, dataval = "Difficulty: " + difficulty, flags = HUDFlags.NOTVISIBLE}
	}
}

Difficulty <-{
	Timer = 0
	Nightmare = false
}

function GetNumSpecials(){
	local infStats = {};
	GetInfectedStats( infStats );
	return infStats.Specials;
}

function GetNumTanks(){
	local infStats = {};
	GetInfectedStats( infStats );
	return infStats.Tanks;
}

function OnGameplayStart(){
	Difficulty.Timer = 0
	tank_spawned = false
	round_started = false
	var1 = 0
    game_time <- 0
    tank_spawn_time <- 1000
}

function ApplyDifficultyConfig(difficultyName) {
	// Get config atau default ke easy
	local config = null;
	if (difficultyName in DifficultyConfigs) {
		config = DifficultyConfigs[difficultyName];
	} else {
		config = DifficultyConfigs["easy"];
	}

	// Apply Survivor Settings
	if ("survivor" in config) {
		local survivor = config.survivor;
		::tacticalMovement.Config.SurvivorSettings.RunSpeed = survivor.RunSpeed;
		::tacticalMovement.Config.SurvivorSettings.WalkSpeed = survivor.WalkSpeed;
		::tacticalMovement.Config.SurvivorSettings.CrouchSpeed = survivor.CrouchSpeed;
		::tacticalMovement.Config.SurvivorSettings.RunSpeedEnabled = survivor.RunSpeedEnabled;
		::tacticalMovement.Config.SurvivorSettings.WalkSpeedEnabled = survivor.WalkSpeedEnabled;
		::tacticalMovement.Config.SurvivorSettings.CrouchSpeedEnabled = survivor.CrouchSpeedEnabled;
	}

	// Apply Infected Settings
	if ("infected" in config) {
		local infected = config.infected;
		::tacticalMovement.Config.InfectedSettings.z_tank_speed = infected.z_tank_speed;
		::tacticalMovement.Config.InfectedSettings.z_spitter_speed = infected.z_spitter_speed;
		::tacticalMovement.Config.InfectedSettings.z_witch_speed = infected.z_witch_speed;
		::tacticalMovement.Config.InfectedSettings.z_witch_speed_inured = infected.z_witch_speed_inured;
		::tacticalMovement.Config.InfectedSettings.z_charge_start_speed = infected.z_charge_start_speed;
		::tacticalMovement.Config.InfectedSettings.z_jockey_speed = infected.z_jockey_speed;
		::tacticalMovement.Config.InfectedSettings.z_hunter_speed = infected.z_hunter_speed;
		::tacticalMovement.Config.InfectedSettings.z_boomer_speed = infected.z_boomer_speed;
		::tacticalMovement.Config.InfectedSettings.z_smoker_speed = infected.z_smoker_speed;
		::tacticalMovement.Config.InfectedSettings.z_speed = infected.z_speed;
		::tacticalMovement.Config.InfectedSettings.z_tank_speed_enabled = infected.z_tank_speed_enabled;
		::tacticalMovement.Config.InfectedSettings.z_spitter_speed_enabled = infected.z_spitter_speed_enabled;
		::tacticalMovement.Config.InfectedSettings.z_witch_speed_enabled = infected.z_witch_speed_enabled;
		::tacticalMovement.Config.InfectedSettings.z_witch_speed_inured_enabled = infected.z_witch_speed_inured_enabled;
		::tacticalMovement.Config.InfectedSettings.z_charge_start_speed_enabled = infected.z_charge_start_speed_enabled;
		::tacticalMovement.Config.InfectedSettings.z_jockey_speed_enabled = infected.z_jockey_speed_enabled;
		::tacticalMovement.Config.InfectedSettings.z_hunter_speed_enabled = infected.z_hunter_speed_enabled;
		::tacticalMovement.Config.InfectedSettings.z_boomer_speed_enabled = infected.z_boomer_speed_enabled;
		::tacticalMovement.Config.InfectedSettings.z_smoker_speed_enabled = infected.z_smoker_speed_enabled;
		::tacticalMovement.Config.InfectedSettings.z_speed_enabled = infected.z_speed_enabled;
	}

	::tacticalMovement.ApplyConvarSettings();

	// Apply Director Options
	if ("director" in config) {
		local director = config.director;
		foreach (key, value in director) {
			DirectorOptions[key] = value;
		}
	}

	// Apply Convars
	if ("convars" in config) {
		local convars = config.convars;
		foreach (key, value in convars) {
			if (typeof(value) == "string") {
				Convars.SetValue(key, value);
			} else if (typeof(value) == "float" || typeof(value) == "integer") {
				Convars.SetValue(key, value);
			}
		}
	}

	// Survival mode adjustments
	if(Director.GetGameMode() == "survival"){
		DirectorOptions.DominatorLimit = 8
		DirectorOptions.cm_SpecialRespawnInterval = 18
		DirectorOptions.cm_MaxSpecials = 8
		DirectorOptions.cm_BaseSpecialLimit = 4
		DirectorOptions.cm_DominatorLimit = 8
		DirectorOptions.SpecialInitialSpawnDelayMin = 10
		DirectorOptions.SpecialInitialSpawnDelayMax = 15
	}
}

function Update(){

	if(should_update || ::command_happened){
		should_update = false;
		::command_happened = false;
		local stringHUD = FileToString("dlbe/showHUD.txt");
		if(stringHUD == "1"){
			::Difficulty.showHUD = 1;
		}
		else{
			::Difficulty.showHUD = 0;
		}
		
		local currentDifficulty = Convars.GetStr("z_difficulty");
		
		// Map difficulty untuk display
		if(Director.IsFirstMapInScenario()){
			if (currentDifficulty in DifficultyMapping) {
				::Difficulty.difficulty = DifficultyMapping[currentDifficulty];
				StringToFile("dlbe/difficulty.txt", ::Difficulty.difficulty);
			}
		}
		else{
			local stringDifficulty = FileToString("dlbe/difficulty.txt");
			if(stringDifficulty != ""){
				::Difficulty.difficulty = stringDifficulty;
				// Reverse map untuk set convar
				foreach (diffName, diffNum in DifficultyMapping) {
					if (diffNum == stringDifficulty) {
						Convars.SetValue("z_difficulty", diffName);
						currentDifficulty = diffName;
						break;
					}
				}
			}
		}
		
		// Get display name
		difficulty = Convars.GetStr("z_difficulty");
		if (difficulty in DifficultyDisplayNames) {
			difficulty = DifficultyDisplayNames[difficulty];
		}
		
		// Apply config untuk difficulty yang dipilih
		ApplyDifficultyConfig(currentDifficulty);
		
		// Update HUD
		if(::Difficulty.showHUD == 1){
			DifficultyHUD.Fields.difficultylevel.flags <- DifficultyHUD.Fields.difficultylevel.flags & ~HUDFlags.NOTVISIBLE
			HUDPlace(HUD_LEFT_TOP, 0.01, 0.01, 0.2, 0.03);
			DifficultyHUD.Fields.difficultylevel.dataval = "Difficulty: " + difficulty;
			HUDSetLayout(DifficultyHUD);
		}
		else{
			DifficultyHUD.Fields.difficultylevel.flags <- DifficultyHUD.Fields.difficultylevel.flags | HUDFlags.NOTVISIBLE
		}
	}
	
	// Nightmare Mode Special Logic
	if(Convars.GetStr( "z_difficulty" ) == "Nightmare"){
		if(GetNumSpecials() > 0 && round_started == false){
			round_started = true;
			var1 = Time();
			tank_spawn_time = RandomInt(180,300);
		}
		if(round_started == true){
			game_time = Time() - var1;
				
			if ( GetNumTanks() < 1 && game_time > tank_spawn_time && tank_spawned == false){
				ZSpawn( { type = 8 } );
				tank_spawned = true;
			}
			if(tank_spawned == true && GetNumTanks() == 0 && game_time > tank_spawn_time + 5){
				tank_spawn_time = RandomInt(240,480);
				tank_spawned = false;
				var1 = Time();
			}
		}
	}
}

function Init(){
	Msg("Init difficulty system with combined nightmare buffs!\n");
	Msg("Difficulty: " + Convars.GetStr( "z_difficulty" ) + "\n");
	
	Difficulty.Timer = 0
	tank_spawned = false
	round_started = false
	var1 = 0
    game_time <- 0
    tank_spawn_time <- 1000
	
	InjectAndPersistCommonSpeed(::GetZ_speed(), ::GetSurvivorSpeed());
	
	Update();
	should_update = true;
}

::GetZ_speed <- function()
{
    switch (Convars.GetStr( "z_difficulty" ))
    {
        case "easy": return 250;
        case "normal": return 250;
        case "hard": return 250;
		case "Expert-": return 250;
        case "impossible": return 250;
        case "Expert+": return 255;
		case "Nightmare-": return 265;
		case "Nightmare": return 335;
		case "Nightmare+": return 278;
		case "Fiendish-": return 282;
		case "Fiendish": return 285;
		case "Fiendish+": return 290;
		case "Cataclysmic-": return 296;
		case "Cataclysmic": return 300;
		case "Cataclysmic+": return 306;
		case "Pandemonium-": return 313;
		case "Pandemonium": return 320;
		case "Unutterable": return 335;
		case "Insurmountable": return 351;
    }

    return 250;
}

::GetSurvivorSpeed <- function()
{
    switch (Convars.GetStr( "z_difficulty" ))
    {
        case "easy": return 220;
        case "normal": return 220;
        case "hard": return 220;
		case "Expert-": return 220;
        case "impossible": return 220;
        case "Expert+": return 220;
		case "Nightmare-": return 220;
		case "Nightmare": return 220;
		case "Nightmare+": return 220;
		case "Fiendish-": return 220;
		case "Fiendish": return 220;
		case "Fiendish+": return 212;
		case "Cataclysmic-": return 203;
		case "Cataclysmic": return 195;
		case "Cataclysmic+": return 188;
		case "Pandemonium-": return 179;
		case "Pandemonium": return 170;
		case "Unutterable": return 220;
		case "Insurmountable": return 220;
    }

    return 250;
}

function InjectAndPersistCommonSpeed(new_z_speed, new_survivor_speed){
    local tm = ::tacticalMovement;
    local infected = tm.Config.InfectedSettings;
	local survivor = tm.Config.SurvivorSettings;

    infected.z_speed = new_z_speed;
    infected.z_speed_enabled = 1;
	survivor.RunSpeed = new_survivor_speed;
	survivor.RunSpeedEnabled = 1;

    StringToFile("tacticalmovement/tactical_movement.cfg", tm._SerializeSettings(tm.Config, ""));
}

Init();
