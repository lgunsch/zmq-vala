using ZMQ;

public static void my_free_function(void* data) {
	stdout.printf ("Freed!\n");
	delete data;
}

public static void test_data_msg() {
	/* buffered data message */
	var msg = Msg.with_data ("Hello World".data, my_free_function);
}

public static void test_size_msg() {
	/* test message with fixed size */
	var msg = Msg.with_size (4);
}

public static void test_msg_copy() {
	Msg msg = Msg();
	Msg copy = Msg ();
	int result = msg.copy (ref copy);
	stdout.printf ("Copy result is %d.\n", result);
} 

public static void test_msg_move()  {
    Msg src = Msg.with_data ("Hello".data);
	stdout.printf ("Message source size is %d.\n", (int)src.size ());
	Msg dst = Msg ();
	src.move (ref dst);
	stdout.printf ("Destination size is now %d.\n", (int)dst.size ());
}

public static void test_msg_data() {
	var msg = Msg.with_data ("Hello".data);
	uint8[] buf = msg.data;
	stdout.printf ("Data size %d\n", buf.length);
}

public static int main(string[] argv) {
	test_data_msg ();
	test_size_msg ();
	test_msg_copy ();
	test_msg_move ();
	return 1;
}