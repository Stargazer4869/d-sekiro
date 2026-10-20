extends Node3D

# Milestone 0 only: movement and a reproducible render benchmark, no combat.
var player: CharacterBody3D
var camera: Camera3D
var hud: Label
var yaw := 0.0
var pitch := -0.35
var samples: Array[float] = []
var elapsed := 0.0
var benchmark := false
var completed := false
var result_text := ""
var captured := false

func box(pos: Vector3, size: Vector3, color: Color) -> void:
	var body := StaticBody3D.new()
	body.position = pos
	var mesh := MeshInstance3D.new()
	var shape := BoxMesh.new()
	shape.size = size
	mesh.mesh = shape
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	mesh.material_override = material
	body.add_child(mesh)
	var collision := CollisionShape3D.new()
	var bounds := BoxShape3D.new()
	bounds.size = size
	collision.shape = bounds
	body.add_child(collision)
	add_child(body)

func _ready() -> void:
	benchmark = "--benchmark" in OS.get_cmdline_user_args()
	DisplayServer.window_move_to_foreground()
	if benchmark:
		DisplayServer.window_set_size(Vector2i(1920, 1080))
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	var world := WorldEnvironment.new()
	world.environment = Environment.new()
	world.environment.background_mode = Environment.BG_COLOR
	world.environment.background_color = Color(0.08, 0.10, 0.14)
	world.environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	world.environment.ambient_light_color = Color(0.7, 0.8, 1.0)
	world.environment.ambient_light_energy = 0.6
	add_child(world)
	var light := DirectionalLight3D.new()
	light.rotation_degrees = Vector3(-55, -25, 0)
	light.shadow_enabled = true
	add_child(light)
	box(Vector3(0, -0.5, 0), Vector3(24, 1, 24), Color(0.25, 0.29, 0.33))
	for side in [-1, 1]:
		box(Vector3(side * 12, 1, 0), Vector3(0.5, 3, 24), Color(0.38, 0.42, 0.47))
		box(Vector3(0, 1, side * 12), Vector3(24, 3, 0.5), Color(0.38, 0.42, 0.47))
	for x in [-7, 7]:
		for z in [-7, 7]:
			box(Vector3(x, 1.5, z), Vector3(1.5, 3, 1.5), Color(0.55, 0.47, 0.35))
	box(Vector3(0, 1, -3), Vector3(1, 2, 1), Color(0.75, 0.28, 0.20))
	player = CharacterBody3D.new()
	player.position = Vector3(0, 1.1, 5)
	var visual := MeshInstance3D.new()
	visual.mesh = CapsuleMesh.new()
	var material := StandardMaterial3D.new()
	material.albedo_color = Color(0.25, 0.7, 0.9)
	visual.material_override = material
	player.add_child(visual)
	var collision := CollisionShape3D.new()
	collision.shape = CapsuleShape3D.new()
	player.add_child(collision)
	add_child(player)
	camera = Camera3D.new()
	camera.current = true
	add_child(camera)
	var layer := CanvasLayer.new()
	add_child(layer)
	hud = Label.new()
	hud.position = Vector2(24, 24)
	hud.add_theme_font_size_override("font_size", 22)
	layer.add_child(hud)
	print("TRIAL_START ", Engine.get_version_info().string, " renderer=gl_compatibility benchmark=", benchmark)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if event.pressed else Input.MOUSE_MODE_VISIBLE
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		yaw -= event.relative.x * 0.004
		pitch = clampf(pitch - event.relative.y * 0.004, -0.9, 0.15)
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		if event.keycode == KEY_R:
			player.position = Vector3(0, 1.1, 5)

func _physics_process(delta: float) -> void:
	if benchmark:
		player.position = Vector3(sin(elapsed * 0.4) * 6, 1.1, cos(elapsed * 0.4) * 6)
		yaw = -elapsed * 0.4
	else:
		var direction := Vector3(
			float(Input.is_physical_key_pressed(KEY_D)) - float(Input.is_physical_key_pressed(KEY_A)),
			0,
			float(Input.is_physical_key_pressed(KEY_S)) - float(Input.is_physical_key_pressed(KEY_W)))
		direction = direction.rotated(Vector3.UP, yaw).normalized()
		player.velocity.x = direction.x * 5.0
		player.velocity.z = direction.z * 5.0
		if not player.is_on_floor():
			player.velocity.y -= 20.0 * delta
		else:
			player.velocity.y = 0
		player.move_and_slide()
	camera.position = player.position + Vector3(0, 1, 0) + Vector3(0, 0, 6).rotated(Vector3.RIGHT, pitch).rotated(Vector3.UP, yaw)
	camera.look_at(player.position + Vector3(0, 0.6, 0))

func _process(delta: float) -> void:
	elapsed += delta
	if "--capture" in OS.get_cmdline_user_args() and elapsed > 2.0 and not captured:
		captured = true
		get_viewport().get_texture().get_image().save_png("res://../reports/trial.png")
		get_tree().quit()
	if benchmark and elapsed > 5.0 and elapsed <= 65.0:
		samples.append(delta * 1000.0)
	if benchmark and elapsed > 65.0 and not completed:
		completed = true
		var total := 0.0
		for sample in samples:
			total += sample
		samples.sort()
		var result := {
			"engine": Engine.get_version_info().string,
			"renderer": "gl_compatibility",
			"draw_calls_last_frame": Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME),
			"viewport": get_viewport().get_visible_rect().size,
			"window": DisplayServer.window_get_size(),
			"warmup_seconds": 5, "sample_count": samples.size(),
			"sample_seconds": total / 1000.0,
			"average_fps": samples.size() * 1000.0 / total,
			"p95_frame_ms": samples[int((samples.size() - 1) * 0.95)],
			"max_frame_ms": samples.back(),
			"note": "Script frame deltas; automated orbit; verify drawable resolution and manual feel separately."
		}
		result_text = JSON.stringify(result)
		print("TRIAL_RESULT ", result_text)
		var output := FileAccess.open("user://milestone0-result.json", FileAccess.WRITE)
		if output:
			output.store_string(result_text)
		get_tree().quit()
	hud.text = "MILESTONE 0 — GRAYBOX TOOLCHAIN TRIAL\nWASD move · Hold right mouse to orbit · R reset · Esc release mouse\nFPS: %d | %s\n%s" % [Engine.get_frames_per_second(), "Automated benchmark: %.0f / 65 s" % elapsed if benchmark else "Manual play — no combat yet", result_text]
