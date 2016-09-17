component {
	this.name = "websockets_demo3";

	this.wschannels = [
		{name:"demo"}
	];

	function onRequestStart() {
		if (structKeyExists(url, "reload")){
			WsPublish("demo","FORCE-RECONNECT");
			applicationStop();
			location(cgi.script_name,false);
		}
	}
}