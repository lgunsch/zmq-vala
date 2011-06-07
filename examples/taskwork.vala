//
//  Task worker
//  Connects PULL socket to tcp://localhost:5557
//  Collects workloads from ventilator via that socket
//  Connects PUSH socket to tcp://localhost:5558
//  Sends results to sink via that socket
//
using ZMQ;

public static int main (string[] argv) {
	var context = new Context (1);

	// Socket to receive messages on
	var receiver = new Socket (context, SocketType.PULL);
	receiver.connect ("tcp://localhost:5557");

	// Socket to send messages to
	var sender = new Socket (context, SocketType.PUSH);
	sender.connect ("tcp://localhost:5558");

	// Process tasks forever
	while (true) {
		var msg = MSG.Msg ();
		receiver.recv (msg);
		// Simple progress indicator for the viewer
		var str = @"$(msg.data ())";
		stdout.printf ("%s.", str);
		stdout.flush ();

		// Do the work
		Thread.usleep (int.parse (str) * 100);

		// Send results to sink
		sender.send (MSG.Msg ());
	}
}