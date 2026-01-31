extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var udp = PacketPeerUDP.new()
var connected = false

func _ready():
	udp.connect_to_host("127.0.0.1", 8080)
func _process(delta):
	if !connected:
		pass
		# Try to contact server
		#udp.put_packet("meow :3".to_utf8_buffer())
	if udp.get_available_packet_count() > 0:
		print("Connected: %s" % udp.get_packet().get_string_from_utf8())
		connected = true

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
