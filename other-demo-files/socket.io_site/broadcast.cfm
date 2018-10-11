<cfscript>
	if(!structKeyExists(request,"socketio_server"))
		throw("You must set the URL to the Socket.IO server - review instructions in Application.onRequestStart()");
	if(!structKeyExists(request,"socketio_port"))
		throw("You must set the port to your Socket.IO server - review instructions in Application.onRequestStart()");

	param name="url.channel" default="demo";
	param name="url.message" default="";

	// this stops an OPTIONS request from continuing to process
	if (!compare(cgi.REQUEST_METHOD,"OPTIONS"))
		exit;

	isAjax = structKeyExists(cgi,"X-Requested-With") && !compareNoCase(cgi["X-Requested-With"],"XMLHttpRequest");

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
	// remove HTML entities from string because it bombs out
	params.message = params.message.replaceAll("\&[^\;]+\;","");
	// create new request
	ws = new http(
		url 	: request.socketio_server & "/publish",
		method 	: "POST",
		port 	: request.socketio_port
	);
	ws.addParam(type:"formField",name:"channel",value:params.channel);

	if (structKeyExists(url,"json"))
		ws.addParam(type:"formField",name:"message",value:serializeJSON(params));
	else
		ws.addParam(type:"formField",name:"message",value:params.message);

	response = ws.send().getPrefix();

	// for XHR response
	if (isAjax)
		writeOutput(params.message);
</cfscript>
<cfif !isAjax>
	<!DOCTYPE html>
	<html lang="en">
	<head>
		<meta charset="UTF-8">
		<title>Message Posted</title>
		<style>
			body{
				font: normal 14px/1.4 -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif, "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol";
				text-align: center;
			}
			div {
				border:.55px solid #ddd;
				padding:1em;
				background-color: #eee;
				margin-top:1em;
				border-radius: .4em;
			}
		</style>
	</head>
	<body>
		The message you posted is as follows:
		<div><cfoutput>#params.message#</cfoutput></div>
	</body>
	</html>
</cfif>