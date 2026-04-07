extends CharacterBody2D

# ── Stats ──────────────────────────────────────────────────────────────────────
@export var chase_speed: float = 120.0
@export var detection_radius: float = 300.0
@export var attack_radius: float = 40.0

# ── Node refs ─────────────────────────────────────────────────────────────────
@onready var anim_tree: AnimationTree = $AnimationTree
@onready var state_machine: AnimationNodeStateMachinePlayback = \
	anim_tree.get("parameters/StateMachine/MoveState/playback")

# ── State ─────────────────────────────────────────────────────────────────────
enum State { IDLE, CHASE }
var current_state = State.IDLE
var facing: Vector2 = Vector2.DOWN


func _ready() -> void:
	anim_tree.active = true


func _physics_process(_delta: float) -> void:
	# Use PlayerManager — same pattern as every other enemy in this project.
	var p = PlayerManager.player
	if p == null:
		return

	var to_player: Vector2 = p.global_position - global_position
	var dist: float = to_player.length()

	match current_state:
		State.IDLE:
			_update_anim_blend(Vector2.ZERO)
			state_machine.travel("idle")
			if dist <= detection_radius:
				current_state = State.CHASE

		State.CHASE:
			if dist > detection_radius * 1.2:
				current_state = State.IDLE
				velocity = Vector2.ZERO
			elif dist <= attack_radius:
				# In attack range — stop and face player. Add attack logic here.
				velocity = Vector2.ZERO
				facing = to_player.normalized()
				_update_anim_blend(Vector2.ZERO)
				state_machine.travel("idle")
			else:
				facing = to_player.normalized()
				velocity = facing * chase_speed
				_update_anim_blend(facing)
				state_machine.travel("chase")

	move_and_slide()


# BlendSpace2D axes: x → left(-1)/right(+1), y → front(-1)/back(+1)
func _update_anim_blend(dir: Vector2) -> void:
	anim_tree.set("parameters/StateMachine/MoveState/chase/blend_position", dir)
	anim_tree.set("parameters/StateMachine/MoveState/idle/blend_position", dir)
