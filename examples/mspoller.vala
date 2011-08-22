//
//  Reading from multiple sockets
//  This version uses zmq_poll()
//
using ZMQ;

public static int main(string [] argv) {
	var context = new Context (1);

	//  Connect to task ventilator
	var receiver = new Socket (context, SocketType.PULL);
	receiver.connect ("tcp://localhost:5557");

	//  Connect to weather server
	var subscriber = new Socket (context, SocketType.SUB);
	subscriber.connect ("tcp://localhost:5556");
	subscriber.setsockopt (SocketOption.SUBSCRIBE, "10001 ", 6);

	//  Initialize poll set
	PollItem[] items = {
		PollItem() {socket = receiver, fd = 0, events = POLLIN, revents = 0 },
		PollItem() {socket = subscriber, fd = 0, events = POLLIN, revents = 0}
	};
	//  Process messages from both sockets
	while (true) {
		poll (items, -1);
		var msg = Msg ();
		if ((items[0].revents & POLLIN) != 0) {
			receiver.recv (ref msg);
			//  Process task
		}
		if ((items[1].revents & POLLIN) != 0) {
			subscriber.recv (ref msg);
			//  Process weather update
		}
	}
}