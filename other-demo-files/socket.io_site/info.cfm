<cfscript>
	rtn = {"success":true,"message":""};
	if(!structKeyExists(request,"socketio_server"))
		rtn.message = "You must set the URL to the Socket.IO server - review instructions in Application.onRequestStart()";
	if(!structKeyExists(request,"socketio_port"))
		rtn.message = "You must set the port to your Socket.IO server - review instructions in Application.onRequestStart()";
	rtn.success = len(rtn.message) ? false : true;
	if (rtn.success){
		rtn["data"] = {
			"socketio_server" : request.socketio_server,
			"socketio_port"  : request.socketio_port
		};
	}
	cfcontent(reset="true",type="application/json");
	writeOutput(serializeJSON(rtn));
</cfscript>