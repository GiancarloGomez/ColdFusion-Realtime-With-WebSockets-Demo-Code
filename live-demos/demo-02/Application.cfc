component {
	this.name = "websockets_demo2";

	this.wschannels = [
		{name:"demo"}
	];

	function onError(exception,eventName){
		writeDump(arguments.exception);
	}

	function onRequestStart() {
		if (structKeyExists(url, "reload")){
			WsPublish("demo","FORCE-RECONNECT");
			applicationStop();
			location(cgi.script_name,false);
		}
	}
}