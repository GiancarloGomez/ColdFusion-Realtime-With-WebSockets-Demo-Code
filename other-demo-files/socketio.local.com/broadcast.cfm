<cfscript>
	param name="url.channel" default="demo";
	param name="url.message" default="Call From Server";

	params = {
		"channel" : url.channel,
		"message" : url.message
	};

	// create new request
	ws = new http(
			url  	: "http://socketio.local.com/publish",
			method 	: "POST",
			port 	: 8080
		);
	ws.addParam(type:"formField",name:"channel",value:url.channel);

	if (structKeyExists(url,"json"))
		ws.addParam(type:"formField",name:"message",value:serializeJSON(params));
	else
		ws.addParam(type:"formField",name:"message",value:url.message);

	response = ws.send().getPrefix();

	writeOutput(response.fileContent);
</cfscript>