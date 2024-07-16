extends Node

@onready var death_sfx: AudioStreamPlayer = $PlayerSFX/DeathSFX
@onready var jump_sfx: AudioStreamPlayer = $PlayerSFX/JumpSFX
@onready var double_jump_sfx: AudioStreamPlayer = $PlayerSFX/DoubleJumpSFX
@onready var dash_sfx: AudioStreamPlayer = $PlayerSFX/DashSFX
@onready var wall_jump_sfx: AudioStreamPlayer = $PlayerSFX/WallJumpSFX
@onready var rebound_sfx: AudioStreamPlayer = $PlayerSFX/ReboundSFX

@onready var block_break_sfx: AudioStreamPlayer = $EnvironmentSFX/BlockBreakSFX

@onready var SFX_BUS_ID = AudioServer.get_bus_index("SFX")
@onready var BGM_BUS_ID = AudioServer.get_bus_index("BGM")
