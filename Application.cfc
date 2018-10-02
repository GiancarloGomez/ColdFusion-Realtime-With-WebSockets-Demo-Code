component {
	this.name = "websockets_demo";

	function onError(exception,eventName){
		writeDump(arguments.exception);
	}

	function onRequestStart(){
		/*
		* Set the request parameters to the IIS site running the code in
		* /other-demo-files/socket.io_site/
		*/
		// request.socketio_server = "http://socketio.fusedev.com";
		// request.socketio_broadcast = "https://socketio.fusedev.com/broadcast/";
	}
}
