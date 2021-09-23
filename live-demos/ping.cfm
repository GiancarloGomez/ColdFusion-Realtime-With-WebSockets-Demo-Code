<cfscript>
	param name="url.id" default="";
	// get all clients
	clients = WSgetSubscribers("demo");
	match 	= false;
	// go thru each until a match is found
	for (rec in clients){
		if(!compare(rec.clientid,url.id)){
			match = true;
			break;
		}
	}
	// return response
	writeOutput(serializeJSON({"success":match}));
</cfscript>