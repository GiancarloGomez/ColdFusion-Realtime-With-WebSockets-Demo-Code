<cfscript>
	threadName 	= "ws_msg_" & createUUID();
	message 	= ( url.message ?: "This is a message from the server" ) &
					"- published on :" &  dateTimeFormat(now(),"long");
	// Specially helpful when using Frameworks or calling in the middle of an Ajax Request
	cfthread(action:"run",name:threadName,message:message){
		WSPublish("demo", attributes.message);
	}
</cfscript>