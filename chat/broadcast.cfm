<cfscript>
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
	// Specially helpful when using Frameworks or calling in the middle of an Ajax Request
	cfthread(action:"run",name:threadName,message:msg){
		WsPublish("chat",attributes.message);
	}
	// for notifications
	writeOutput(msg);
</cfscript>