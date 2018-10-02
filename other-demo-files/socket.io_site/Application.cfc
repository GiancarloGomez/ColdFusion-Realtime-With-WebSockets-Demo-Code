component {
	this.name = "socketio_demo";

	function onError(exception,eventName){
		writeOutput(arguments.exception.message);
	}

	function onRequestStart(){
		/*
		* Set the request parameters to the IIS site running the code in
		* /other-demo-files/socket.io_site/
		*
		* request.socketio_server = "http://socketio.fusedev.com";
		* request.socketio_port = 8080;
		*/
		// request.socketio_server = "http://socketio.fusedev.com";
		// request.socketio_port = 8080;
	}
}
