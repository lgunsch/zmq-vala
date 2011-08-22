//
//  Reading from multiple sockets
//  This version uses a simple recv loop
//
using ZMQ;

public static int main(string [] argv) {
	//  Prepare our context and sockets
	var context = new Context (1);

	//  Connect to task ventilator
	var receiver = new Socket (context, SocketType.PULL);
	receiver.connect ("tcp://localhost:5557");

	//  Connect to weather server
	var subscriber = new Socket (context, SocketType.SUB);
	subscriber.connect ("tcp://localhost:5556");
	subscriber.setsockopt (SocketOption.SUBSCRIBE, "10001 ", 6);

	//  Process messages from both sockets
    //  We prioritize traffic from the task ventilator
    while (true) {
		//  Process any waiting tasks
		int rc = 0;
		do {
			var task = Msg ();
			if ((rc = receiver.recv (ref task, SendRecvOption.NOBLOCK)) == 0) {
				//  process task
			}
		} while (rc == 0);

		//  Process any waiting weather updates
		do {
			var update = Msg ();
			if ((rc = subscriber.recv (ref update, SendRecvOption.NOBLOCK)) == 0) {
				//  process weather update
			}
		} while (rc == 0);
		//  No activity, so sleep for 1 msec
		Thread.usleep (1000);
	}
}