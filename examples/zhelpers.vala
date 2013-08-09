using ZMQ;

namespace ZMQ {
    /*
     * Receive 0MQ uint8 buffer from socket and convert into string.
     * Returns null if context is being terminated.
     */
    public string? s_recv (Socket socket) {
        stdout.printf ("Receive data...\n");
        var msg = Msg ();

        stdout.printf ("Waiting for data...\n");
        if (msg.recv (socket) == -1) {
            stdout.printf (" > Failed to read\n");
            return null;
        }

        size_t size = msg.size () + 1;
        uint8[] data = new uint8[size];
        Memory.copy (data, msg.data, size - 1);
        data[size - 1] = '\0';

        return (string)data;
    }

    /*
     * Convert C string to 0MQ string and send to socket.
     */
    public int s_send (Socket socket, ref Msg msg) {
        int size = msg.send (socket);
        return size;
    }
}
