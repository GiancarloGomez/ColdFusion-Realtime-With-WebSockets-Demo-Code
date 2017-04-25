<cfscript>
	param name="url.channel" default="demo";
	param name="url.message" default="";

	params = {
		"channel" : url.channel,
		"message" : url.message
	};

	if (!params.message.len()){
		// Let's get a random quote from http://api.icndb.com/jokes/random just to make it fun
		try {
			cfhttp(url="http://api.icndb.com/jokes/random",result="_message",timeout=5);
			params.message = deserializeJSON(_message.fileContent).value.joke;
		}
		catch (Any e){
			params.message = "We could not fetch a funny joke so this is just the server responding";
		}
	}

	// create new request
	ws = new http(
			url  	: "http://socketio.local.com/publish",
			method 	: "POST",
			port 	: 8080
		);
	ws.addParam(type:"formField",name:"channel",value:params.channel);

	if (structKeyExists(url,"json"))
		ws.addParam(type:"formField",name:"message",value:serializeJSON(params));
	else
		ws.addParam(type:"formField",name:"message",value:params.message);

	response = ws.send().getPrefix();

	writeOutput(params.message);
</cfscript>