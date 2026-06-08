IncludeScript("difficulty_config");
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
