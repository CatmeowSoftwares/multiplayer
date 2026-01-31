extends Control

var chat: Array[String] = []

@onready var line_edit: LineEdit = $PanelContainer/VBoxContainer/LineEdit
@onready var v_box_container: VBoxContainer = $PanelContainer/VBoxContainer/ScrollContainer/VBoxContainer
var stream = StreamPeerTCP.new()

var user = 0
func _ready():
	var err = stream.connect_to_host("127.0.0.1", 8080)
	print(err)
	
	user = randi_range(41, 67)
func _process(delta: float) -> void:
	stream.poll()
	if stream.get_status() == StreamPeerSocket.Status.STATUS_CONNECTED:
		var r = stream.get_available_bytes()
		if r > 0:
			print("data!!!!")
			var d = stream.get_data(r)[1]
			var string := ""
			for x in d:
				if x == 0: continue
				string += char(x)
			print(string)
			chat_send(string)
		

func send(message: String):
	var data = message.to_utf8_buffer()
	var err = stream.put_data(data)
	print(err)

func _on_line_edit_text_submitted(new_text: String) -> void:
	line_edit.clear()
	var text = "[User%s]: %s" % [user, new_text]
	#chat_send(text)
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
