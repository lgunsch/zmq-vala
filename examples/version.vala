//
//  Report 0MQ version
//
using ZMQ;

public static int main(string[] argv) {
	int major, minor, patch;
	version(out major, out minor, out patch);
	stdout.printf("Current 0MQ version is %d.%d.%d\n", major, minor, patch);
	
	return 0;
}
