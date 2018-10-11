component {
	this.name = "socketio_demo";

	function onError(exception,eventName){
		writeOutput(arguments.exception.message);
	}

	function onRequestStart(){
		cfheader(name:"Access-Control-Allow-Origin",value:"*");
		cfheader(name:"Access-Control-Allow-Headers",value:"*");
		request.socketio_server = "http://localhost";
		request.socketio_port = 8080;
	}
}
