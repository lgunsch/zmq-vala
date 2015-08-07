//
//  Hello World server
//  Binds REP socket to tcp://*:5555
//  Expects "Hello" from client, replies with "World"
//
using ZMQ;

public static int main(string [] argv) {
    var context = new Context ();

    // Socket to talk to clients
    var responder = Socket.create (context, SocketType.REP);
    responder.bind ("tcp://*:5555");

    while (true) {
        // Wait for next request from client
        var request = Msg ();
        request.recv (responder);
        stdout.printf ("Received Hello!\n");

        // Do some 'work'
        Posix.sleep (1);

        // Send reply back to client
        var reply = Msg.with_data ("World".data);
        reply.send (responder);
    }
}
