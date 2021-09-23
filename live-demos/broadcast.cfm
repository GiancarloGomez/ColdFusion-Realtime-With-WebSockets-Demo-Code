<cfscript>
	isAjax 		= structKeyExists(cgi,"X-Requested-With") && !compareNoCase(cgi["X-Requested-With"],"XMLHttpRequest");
	threadName 	= "ws_msg_" & createUUID();
	msg 		= url.message ?: "";
	if (!msg.len()){
		// Let's get a random quote from http://api.icndb.com/jokes/random just to make it fun
		try {
			cfhttp(url="http://api.icndb.com/jokes/random",result="_message",timeout=5);
			msg = deserializeJSON(_message.fileContent).value.joke;
		}
		catch (Any e){
			msg = "We could not fetch a funny joke so this is just the server responding";
		}
	}
	// remove HTML entities from string because it bombs out
	msg = msg.replaceAll("\&[^\;]+\;","");
	msg = replace(msg,"&quot;","'","all");
	// Specially helpful when using Frameworks or calling in the middle of an Ajax Request
	cfthread(action:"run",name:threadName,message:msg){
		WsPublish("demo",attributes.message);
	}
	// for XHR response
	if (isAjax)
		writeOutput(msg);
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
		<div><cfoutput>#msg#</cfoutput></div>
	</body>
	</html>
</cfif>