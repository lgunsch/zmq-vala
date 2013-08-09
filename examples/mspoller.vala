//
//  Reading from multiple sockets
//  This version uses zmq_poll()
//
using ZMQ;

public static int main(string [] argv) {
    var context = new Context ();

    //  Connect to task ventilator
    var receiver = Socket.create (context, SocketType.PULL);
    receiver.connect ("tcp://localhost:5557");

    //  Connect to weather server
    var subscriber = Socket.create (context, SocketType.SUB);
    subscriber.connect ("tcp://localhost:5556");
    subscriber.setsockopt (SocketOption.SUBSCRIBE, "10001 ", 6);

    //  Initialize poll set
    Poll.PollItem[] items = {
        Poll.PollItem() {socket = receiver, fd = 0, events = Poll.IN, revents = 0 },
        Poll.PollItem() {socket = subscriber, fd = 0, events = Poll.IN, revents = 0}
    };
    //  Process messages from both sockets
    while (true) {
        Poll.poll (items, -1);
        var msg = Msg ();
        if ((items[0].revents & Poll.IN) != 0) {
            msg.recv (receiver);
            //  Process task
        }
        if ((items[1].revents & Poll.IN) != 0) {
            msg.recv (subscriber);
            //  Process weather update
        }
    }
}
