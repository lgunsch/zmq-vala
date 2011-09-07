//
//  Reading from multiple sockets
//  This version uses zmq_poll()
//
using ZMQ;

public static int main(string [] argv) {
	var context = new Context (1);

	//  Connect to task ventilator
	var receiver = Socket.create (context, SocketType.PULL);
	receiver.connect ("tcp://localhost:5557");

	//  Connect to weather server
	var subscriber = Socket.create (context, SocketType.SUB);
	subscriber.connect ("tcp://localhost:5556");
	subscriber.setsockopt (SocketOption.SUBSCRIBE, "10001 ", 6);

	//  Initialize poll set
	POLL.PollItem[] items = {
		POLL.PollItem() {socket = receiver, fd = 0, events = POLL.IN, revents = 0 },
		POLL.PollItem() {socket = subscriber, fd = 0, events = POLL.IN, revents = 0}
	};
	//  Process messages from both sockets
	while (true) {
		POLL.poll (items, -1);
		var msg = Msg ();
		if ((items[0].revents & POLL.IN) != 0) {
			receiver.recv (ref msg);
			//  Process task
		}
		if ((items[1].revents & POLL.IN) != 0) {
			subscriber.recv (ref msg);
			//  Process weather update
		}
	}
}