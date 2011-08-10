//
//  Hello World server
//  Binds REP socket to tcp://*:5555
//  Expects "Hello" from client, replies with "World"
//
using ZMQ;

public static int main(string [] argv) {
	var context = new Context (1);

	// Socket to talk to clients
	var responder = new Socket (context, SocketType.REP);
	responder.bind ("tcp://*:5555");

	while (true) {
		//  Wait for next request from client
		var request = Msg ();
		responder.recv (ref request, 0);
		stdout.printf ("Received Hello!\n");

		//  Do some 'work'
		Posix.sleep (1);

		// Send reply back to client
		var reply = Msg.with_data ("World".data);
		responder.send (reply, 0);
	}
}