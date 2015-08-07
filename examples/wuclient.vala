//
//  Weather update client
//  Connects SUB socket to tcp://localhost:5556
//  Collects weather updates and finds avg temp in zipcode

using ZMQ;
using Random;

public static int main(string[] args) {
    var context = new Context ();

    // Socket to talk to server
    stdout.printf ("Collecting updates from weather server...\n");

    var subscriber = Socket.create (context, SocketType.SUB);
    stdout.printf (" > Socket created\n");

    subscriber.connect ("tcp://127.0.0.1:5556");
    stdout.printf (" > Connected to localhost:5556\n");

    // Subscribe to zipcode, default is NYC, 10001
    string filter = (args.length > 1)? args[1]: "10001 ";
    var ret = subscriber.setsockopt (SocketOption.SUBSCRIBE, filter, filter.length);

    assert (ret == 0);

    //  Process updates
    int update_nbr;
    long total_temp = 0;

    for (update_nbr = 0; update_nbr < 100000; update_nbr++) {
        var msg = Msg ();

        var n_read = msg.recv (subscriber);
        if (n_read == -1)
            stderr.printf (":: Failed to read ::\n");

        size_t size = msg.size () + 1;
        uint8[] data = new uint8[size];
        Memory.copy (data, msg.data, size - 1);
        data[size - 1] = '\0';
        var str = (string)data;

        int zipcode, temperature, relhumidity;
        str.scanf ("%d %d %d", out zipcode, out temperature, out relhumidity);
        total_temp += temperature;
    }

    stdout.printf ("Average temperature for zipcode '%s' was %dF\n", filter,
                   (int) (total_temp / update_nbr));

    return 0;
}
