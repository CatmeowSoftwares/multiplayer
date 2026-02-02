extends Control

var chat: Array[String] = []

@onready var line_edit: LineEdit = $PanelContainer/VBoxContainer/LineEdit
@onready var v_box_container: VBoxContainer = $PanelContainer/VBoxContainer/ScrollContainer/VBoxContainer

var user = 0
func _ready():
	user = randi_range(41, 67)
	var b = PackedByteArray()
	b.resize(1024)
	b.encode_double(0, 67.41)
	print(b)
	print(b.decode_double(0))
	Network.tcp_data_received.connect(_on_tcp_data_received)
	
func _on_tcp_data_received(bytes: PackedByteArray, type: Network.Type):
	print(type)
	print("data is ", bytes)
	chat_send(bytes.get_string_from_utf8())
	
func _process(delta: float) -> void:
	pass

func send(message: String):
	var data = message.to_utf8_buffer()
	Network.tcp_put_data(data, Network.Type.CHAT_SEND)

func _on_line_edit_text_submitted(new_text: String) -> void:
	line_edit.clear()
	var text = "[User%s]: %s" % [user, new_text]
	send(text);

func chat_send(message: String):
	var label = Label.new()
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.custom_minimum_size = Vector2(200, 10)
	label.text = message
	v_box_container.add_child(label)
	chat.append(message)

func format(...args: Array):
	pass

func bytes_to_vec2(bytes: PackedByteArray) -> Vector2:
	var idx = 0;
	var vec2 = Vector2()
	for i in range(bytes.size()/8):
		var f_idx = i*4
		var f_idx2 = i*8
		var f = bytes.decode_double(f_idx)
		var f2 = bytes.decode_double(f_idx2)
		vec2 = Vector2(f, f2)
	return vec2


func remove_message_at(idx: int):
	pass
