using ZMQ;

public static void myFunction(void* data) { 
	stdout.printf("Freed!\n");
	delete data;
}

public static void testDataMsg() {
	/* buffered data message */
	var msg = ZMQ.MSG.Msg.data("Hello World".data, myFunction);	

	var msg2 = null;
	int result =  msg.copy(msg2); /* this will produce a segmentation fault */
	stdout.printf("Copy result is %d.", result);
}

public static int main(string[] argv) {
	testDataMsg();
	return 1;
}