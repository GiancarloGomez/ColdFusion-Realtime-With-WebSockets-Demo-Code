component {
	this.name = "websockets_demo1";
    this.serialization.preservecaseforstructkey = true;

	this.wschannels = [
		{name:"demo"}
	];

	function onError(exception,eventName){
		writeDump(arguments.exception);
	}
}