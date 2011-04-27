using ZMQ;

public static void myFunction(void* data) { 
	stdout.printf("Freed!");
	delete data;
}

public static void testDataMsg() {
	/* buffered data message */
	uint8[] mydata = {0,1,2,3};
	var msg3 = ZMQ.MSG.Msg.data(mydata, myFunction);	
}

public static int main(string[] argv) {
	testDataMsg();
	return 1;
}