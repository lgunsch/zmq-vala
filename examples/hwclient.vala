//
//  Hello World client
//  Connects REQ socket to tcp://localhost:5555
//  Sends "Hello" to server, expects "World" back
//
using ZMQ;

public static int main(string [] argv) {
    var context = new Context ();

    // Socket to talk to server
    stdout.printf ("Connecting to hello world server…\n");
    var requester = Socket.create (context, SocketType.REQ);
    requester.connect ("tcp://localhost:5555");

    for (int request_nbr = 0; request_nbr != 10; request_nbr++) {
        var request = Msg.with_data ("Hello".data);
        stdout.printf ("Sending Hello %d…\n", request_nbr);
        request.send (requester);

        var reply = Msg ();
        reply.recv (requester);
        stdout.printf ("Received World %d\n", request_nbr);
    }

    return 0;
}
