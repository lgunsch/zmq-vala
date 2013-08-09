//
//  Weather update server
//  Binds PUB socket to tcp://*:5556
//  Publishes random weather updates
//
using ZMQ;
using Random;

public static int main(string[] args) {
    // Prepare our context and publisher
    var context = new Context ();
    var publisher = Socket.create (context, SocketType.PUB);
    var ret = publisher.bind ("tcp://*:5556");

    assert (ret == 0);

    while (true) {
        // Get values that will fool the boss
        int zipcode, temperature, relhumidity;
        zipcode = int_range (0, 100000);
        temperature = int_range (-80, 135);
        relhumidity = int_range (10, 60);

        // Send message to all subscribers
        string update = @"$(zipcode) $(temperature) $(relhumidity)";
        var reply = Msg.with_data (update.data);
        var n_sent = reply.send (publisher);
    }
}
