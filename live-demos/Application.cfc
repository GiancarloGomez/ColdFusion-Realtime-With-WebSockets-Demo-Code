component {
	this.name 				= "websockets_2021_demo";
	this.sessionmanagement 	= true;
	this.sessiontimeout 	= createTimeSpan(1,0,0,0);
	this.serialization.preservecaseforstructkey = true;

	this.wschannels = [
		{name:"demo"},
		{name:"conference"},
		{name:"restricted",cfclistener:"demo-00.RestrictedListener"}
	];

	public void function onRequestStart() {
		if (structKeyExists(url, "reload")){
			wsPublish("demo","FORCE-RECONNECT");
			applicationStop();
			location(cgi.script_name,false);
		}
	}

	public void function onError(exception,eventName){
		writeDump(arguments.exception);
	}

	public boolean function onWSAuthenticate(string username, string password, struct connectionInfo) {
		var usersAllowed 	= ["JC","Maria","Mailang","Jonah","Gia"];
		var authenticated 	= arrayFindNoCase(usersAllowed,arguments.username);
		if (authenticated){
			arguments.connectionInfo.authenticated = true;
			arguments.connectionInfo.username = arguments.username;
		} else {
			arguments.connectionInfo.authenticated = false;
		}
		return authenticated ;
	}
}