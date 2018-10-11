component {
    this.name              = "webSocketsChat";
    this.sessionmanagement = true;
    this.sessiontimeout    = createTimeSpan(1,0,0,0);
    this.serialization.preservecaseforstructkey = true;

    // websockets
    this.wschannels = [
        {name:"chat",cfclistener:"ChatListener"}
    ];

    public boolean function onApplicationStart(){
        application.timestamp                   = getHttpTimeString();
        application.publishedMessages           = 0;
        application.publishedPreviousMessages   = 0;
        return true;
    }

    public boolean function onRequestStart(targetPage){
        if (structKeyExists(url,"reload")){
            // tell everyone to reconnect ( AdvancedSocket Feature )
            WsPublish("chat","FORCE-RECONNECT");
            applicationStop();
            location('./',false);
        }
        return true;
    }

    public boolean function onWSAuthenticate(string username, string password, struct connectionInfo) {
        // Demo User Authentication - very simple here you would do real work
        var usersAllowed    = ["JC","Maria","Mailang","Jonah","Gia"];
        var authenticated   = arrayFindNoCase(usersAllowed,arguments.username);
        if (authenticated){
            arguments.connectionInfo.authenticated = true;
            arguments.connectionInfo.username = arguments.username;
        } else {
            connectionInfo.authenticated = false;
        }
        return authenticated;
    }
}