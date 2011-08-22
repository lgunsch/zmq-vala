//
//  Weather update server
//  Binds PUB socket to tcp://*:5556
//  Publishes random weather updates
//
using ZMQ;
using Random;

public static int main(string[] args) {
	//  Prepare our context and publisher
	var context = new Context (1);
	var publisher = new Socket (context, SocketType.PUB);
	publisher.bind ("tcp://*:5556");

	while (true) {
		//  Get values that will fool the boss
		int zipcode, temperature, relhumidity;
		zipcode = int_range (0, 100000);
		temperature = int_range (-80, 135);
		relhumidity = int_range (10, 60);

		//  Send message to all subscribers
		string update = @"$(zipcode) $(temperature) $(relhumidity)";
		stdout.printf("Sending: %s.\n", update);
		var reply = Msg.with_data (update.data);
		publisher.send (reply);
	}
}
