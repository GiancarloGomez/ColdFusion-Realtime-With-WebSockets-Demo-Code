component {
	this.name = "websockets_demo";

	function onError(exception,eventName){
		writeOutput("<div style='display:flex;margin:0;padding:0;font-weight:500;height:calc( 100vh - 20px );align-items:center; justify-content:center;font-size:2em; text-align:center;'>" & arguments.exception.message & "</div>");
	}

	function onRequestStart(){
		/*
		* Set the request parameters to the IIS site running the code in
		* /other-demo-files/socket.io_site/
		*/
		// request.socketio_server = "http://localhost:{{port}}";
		// request.socketio_broadcast = "https://localhost:{{port}}/broadcast/";

		request.socketio_server = "http://localhost:51095/";
		request.socketio_broadcast = "http://localhost:51095/broadcast/";
	}
}
