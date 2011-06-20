//
//  Weather update client
//  Connects SUB socket to tcp://localhost:5556
//  Collects weather updates and finds avg temp in zipcode
//
using ZMQ;
using Random;

public static int main(string[] args) {
	var context = new Context (1);
	
	//  Socket to talk to server
	stdout.printf ("Collecting updates from weather server...\n");
	var subscriber = new Socket (context, SocketType.SUB);
	subscriber.connect ("tcp://localhost:5556");

	//  Subscribe to zipcode, default is NYC, 10001
	string filter = (args.length > 1)? args[1]: "10001 ";
	subscriber.setsockopt (SocketOption.SUBSCRIBE, filter, filter.length);
	
	//  Process 100 updates
	int update_nbr;
	long total_temp = 0;
	for (update_nbr = 0; update_nbr < 100; update_nbr++) {
		var str = s_recv (subscriber);
		int zipcode, temperature, relhumidity;
		str.scanf ("%d %d %d", out zipcode, out temperature, out relhumidity);
		total_temp += temperature;
	}
	stdout.printf ("Average temperature for zipcode '%s' was %dF\n", filter, 
				   (int) (total_temp / update_nbr));

	return 0;
}
