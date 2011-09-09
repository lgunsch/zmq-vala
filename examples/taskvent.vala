//
//  Task ventilator
//  Binds PUSH socket to tcp://localhost:5557
//  Sends batch of tasks to workers via that socket
//
using ZMQ;

public static int main (string[] argv) {
	var context = new Context(1);

	// Socket to send messages on
	var sender = Socket.create (context, SocketType.PUSH);
	sender.bind ("tcp://*:5557");

	stdout.printf ("Press Enter when the workers are ready: ");
	stdin.read_line ();
	stdout.printf ("Sending tasks to workers...\n");

	//  The first message is "0" and signals start of batch
	var first = Msg.with_data ("0".data);
	sender.send (ref first);

	// Send 100 tasks
	int total_msec = 0;      // Total expected cost in msec
	for (int task_nbr = 0; task_nbr < 100; task_nbr++) {
		// Random workload from 1 to 100 msecs
		int workload = Random.int_range (1, 100);
		total_msec += workload;
		var str = @"$(workload)";
		var msg = Msg.with_data (str.data);
		sender.send (ref msg);
	}
	stdout.printf ("Total expected cost: %d msec\n", total_msec);
	Thread.usleep (1000000);      // Give 0MQ time to deliver

	return 0;
}