using ZMQ;

public static void myFunction(void* data) { 
	stdout.printf ("Freed!\n");
	delete data;
}

public static void testDataMsg() {
	/* buffered data message */
	var msg = ZMQ.MSG.Msg.data ("Hello World".data, myFunction);	

	MSG.Msg copy = MSG.Msg ();
	int result =  msg.copy (copy);
	stdout.printf ("Copy result is %d.\n", result);
}

public static int main(string[] argv) {
	testDataMsg ();
	return 1;
}