component {
	this.name = "websockets_demo1";

	this.wschannels = [
		{name:"demo"}
	];

	function onError(exception,eventName){
		writeDump(arguments.exception);
	}
}