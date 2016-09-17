<cfscript>
	param name="url.id" default="";

	clients 	= WSgetSubscribers("chat");
	clientIDs 	= [];

	arrayEach(clients, function(rec){
		arrayAppend(clientIDs,rec.clientID);
	});

	rtn = { "success" : arrayFind(clientIDs,url.id) ? true : false };


	writeOutput( serializeJSON(rtn) );
</cfscript>