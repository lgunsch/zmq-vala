using ZMQ;

public static void myFunction() {
	stdout.printf("Freed!");
}

public static void testDataMsg() {
	/* buffered data message */
	uint8[] mydata = {0,1,2,3};
//	GLib.Func myfun =  (a) =>  { stdout.printf("Freed!"); };
	var msg3 = ZMQ.MSG.Msg.data(mydata, myFunction);	
}

public static int main(string[] argv) {
	testDataMsg();
	return 1;
}