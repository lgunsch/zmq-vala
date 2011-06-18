using ZMQ;

namespace ZMQ {
	/*
	 *  Receive 0MQ uint8 buffer from socket and convert into string.
	 *  Returns null if context is being terminated.
	 */
	public string? s_recv(Socket socket) {
		var msg = MSG.Msg ();
		if (socket.recv (msg) != 0) {
			return null;
		}
		uint8[] data = new uint8[msg.size () + 1];
		Memory.copy (data, msg.data (), data.length - 1);
		data[data.length] = '\0';  
		return (string)data;
	}
}
