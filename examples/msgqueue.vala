//
//  Simple message queuing broker
//  Same as request-reply broker but using QUEUE device
//
using ZMQ;

public static int main(string [] argv) {
    var context = new Context ();

    //  Socket facing clients
    var frontend = Socket.create (context, SocketType.ROUTER);
    frontend.bind ("tcp://*:5559");

    //  Socket facing services
    var backend = Socket.create (context, SocketType.DEALER);
    backend.bind ("tcp://*:5560");

    //  Start built-in device
    Device.QUEUE.device (frontend, backend);

    return 0;
}

