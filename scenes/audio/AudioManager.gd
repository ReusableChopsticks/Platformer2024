extends Node
##region Player SFX
@onready var death_sfx: AudioStreamPlayer = $PlayerSFX/DeathSFX
@onready var jump_sfx: AudioStreamPlayer = $PlayerSFX/JumpSFX
@onready var double_jump_sfx: AudioStreamPlayer = $PlayerSFX/DoubleJumpSFX
@onready var dash_sfx: AudioStreamPlayer = $PlayerSFX/DashSFX
@onready var wall_jump_sfx: AudioStreamPlayer = $PlayerSFX/WallJumpSFX
@onready var rebound_sfx: AudioStreamPlayer = $PlayerSFX/ReboundSFX
##endregion

##region Other SFX
@onready var block_break_sfx: AudioStreamPlayer = $EnvironmentSFX/BlockBreakSFX
@onready var level_complete_sfx: AudioStreamPlayer = $EnvironmentSFX/GoalSFX
##endregion

##region BGM
@onready var clair_de_lune: AudioStreamPlayer = $"Music/Clair De Lune"
##endregion

##region Variables
@onready var SFX_BUS_ID = AudioServer.get_bus_index("SFX")
@onready var BGM_BUS_ID = AudioServer.get_bus_index("BGM")
##endregion
