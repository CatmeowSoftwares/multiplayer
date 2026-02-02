extends Node

var stream = StreamPeerTCP.new()
var udp = PacketPeerUDP.new()

var id: int
signal udp_data_received(bytes: PackedByteArray, type: Type)
signal tcp_data_received(bytes: PackedByteArray, type: Type)

enum Type {
	CHAT_SEND = 0,
	GET_PLAYER_POS,
	SET_PLAYER_POS,
}
func udp_put_data(bytes: PackedByteArray, type: Type):
	var bytes2 = bytes
	bytes2.insert(0, type)
	udp.put_packet(bytes2)
	var thread = Thread.new()
	thread.start(_udp)
func _udp():
	var data: PackedByteArray
	while udp.wait() != OK:
		data = udp.get_packet()
		if data: udp_data_received.emit(data.slice(1), data[0])
func _tcp():
	stream.poll()
	var data: PackedByteArray
	var available_bytes = stream.get_available_bytes()
	if available_bytes <= 0: return
	data = stream.get_data(available_bytes)[1]
	
	if !data.is_empty(): 
		print("real is ",data)
		tcp_data_received.emit(data.slice(1), data[0])

func udp_get():
	if udp.get_available_packet_count() > 0:
		return udp.get_packet()
	return PackedByteArray()
	
func tcp_put_data(bytes: PackedByteArray, type: Type):
	var bytes2 = bytes
	bytes2.insert(0, type)
	print("bytes2222 is: ",bytes2)
	stream.put_data(bytes2)

func _ready():
	var err = stream.connect_to_host("127.0.0.1", 8080)
	udp.connect_to_host("127.0.0.1", 8080)

	print(err)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_tcp()
func _exit_tree() -> void:
	stream.disconnect_from_host()
	#udp.d
