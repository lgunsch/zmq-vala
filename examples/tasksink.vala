//
//  Task sink
//  Binds PULL socket to tcp://localhost:5558
//  Collects results from workers via that socket
//
using ZMQ;

public static int main (string[] argv) {
	// Prepare our context and socket
	var context = new Context (1);
	var receiver = Socket.create (context, SocketType.PULL);
	receiver.bind("tcp://*:5558");

	// Wait for start of batch
	var msg = Msg ();
	receiver.recv (ref msg);

	// Start our clock now
	var timer = new Timer ();
	timer.start ();

	// Process 100 confirmations
	for (int task_nbr = 0; task_nbr < 100; task_nbr++) {
		var confirmation = Msg ();
		receiver.recv (ref confirmation);
		if ((task_nbr / 10) * 10 == task_nbr)
			stdout.printf (":");
		else
			stdout.printf (".");
		stdout.flush ();
	}
	// Calculate and report duration of batch
	stdout.printf ("Total elapsed time: %d msec\n", (int)(timer.elapsed () * 1000));
	return 0;
}