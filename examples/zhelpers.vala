using ZMQ;

namespace ZMQ {
	/*
	 *  Receive 0MQ uint8 buffer from socket and convert into string.
	 *  Returns null if context is being terminated.
	 */
	public string? s_recv(Socket socket) {
		var msg = Msg ();
		if (socket.recv (ref msg) != 0) {
			return null;
		}

		size_t size = msg.size () + 1;
		uint8[] data = new uint8[size];
		Memory.copy(data, msg.data, size - 1);
		data[size - 1] = '\0';

		return (string)data;
	}
}
