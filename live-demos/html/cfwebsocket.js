class CFWebSocket {

    constructor(
        appName,
        server,
        isProxy,
        wsPort,
        appStartPath,
        channel,
        customOptions,
        onMessage,
        onSubscribe
    ){
        // used in payloads
        this.NS       = "coldfusion.websocket.channels";
        this.appName  = appName;
        // set protocol
        this.isSecure = location.protocol === 'https:' ? true : false;
        this.protocol = this.isSecure ? 'wss' : 'ws';
        // path to use for connection
        this.path = isProxy ? '/cfws/' : '/cfusion/cfusion';
        // set full server url to connect to
        this.server = `${this.protocol}://${server ? server : location.hostname}${wsPort ? `:${wsPort}` : ''}`;
        // Create connection to server
        this.ws = new WebSocket(`${this.server}${this.path}`);
        // WebSocket API Events
        this.ws.onopen = async (e) => {
            // to make sure we fired off a cfm file to start the application run the following
            const firstCall = await fetch( appStartPath );
            if ( firstCall.status === 200 && channel )
                this.subscribe( channel, customOptions );
        };
        this.ws.onmessage = (e) => {
            // parse the message received
            var data = JSON.parse(e.data);
            // pass to our onSubscribe callback
            if ( data.code === 0 && data.type === 'response' && data.reqType === 'subscribe' && data.msg ==='ok' && typeof onSubscribe === 'function' )
                onSubscribe( data );
            // pass to our onMessage callback
            if (onMessage && typeof onMessage === 'function' )
                onMessage(data);
        };
        this.ws.onerror = (e) => {
            console.log('onerror',e);
        };
        this.ws.onclose = (e) => {
            console.log('close',e);
        };
    }

    authenticate( username, password ){
        this.sendToken({
            ns          : this.NS,
            type        : 'authenticate',
            username    : username,
            password    : password,
            appName     : this.appName
        });
    }

    subscribe( channel, customOptions ){
        channel.split(',').forEach( _channel => {
            this.sendToken({
                ns              : this.NS,
                type            : 'subscribe',
                channel         : _channel,
                appName         : this.appName,
                customOptions   : this.validateCustomOptions( customOptions )
            });
        });
    }

    unsubscribe( channel ){
        channel.split(',').forEach( _channel => {
            this.sendToken({
                ns              : this.NS,
                type            : 'unsubscribe',
                channel         : _channel,
                appName         : this.appName
            });
        });
    }

    publish( channel, message, customOptions ){
        this.sendToken({
            ns              : this.NS,
            type            : 'publish',
            channel         : channel,
            data            : message,
            appName         : this.appName,
            customOptions   : this.validateCustomOptions( customOptions )
        });
    }

    invoke( cfcName, cfcMethod, methodArguments ){
        this.sendToken({
            ns              : this.NS,
            type            : 'invoke',
            cfcName         : cfcName,
            cfcMethod       : cfcMethod,
            methodArguments : this.validateMethodArguments( methodArguments ),
            appName         : this.appName,
            referrer        : location.pathname
        });
    }

    invokeAndPublish( channel, cfcName, cfcMethod, methodArguments, customOptions ){
        this.sendToken({
            ns              : this.NS,
            type            : 'invokeAndPublish',
            channel         : channel,
            cfcName         : cfcName,
            cfcMethod       : cfcMethod,
            methodArguments : this.validateMethodArguments( methodArguments ),
            appName         : this.appName,
            referrer        : location.pathname,
            customOptions   : this.validateCustomOptions( customOptions )
        });
    }

    getSubscriberCount( channel ){
        this.sendToken({
            ns              : this.NS,
            type            : 'getSubscriberCount',
            channel         : channel,
            appName         : this.appName
        });
    }

    getSubscriptions(){
        this.sendToken({
            ns              : this.NS,
            type            : 'getSubscriptions',
            appName         : this.appName
        });
    }

    sendToken( token ){
        this.ws.send( JSON.stringify(token) );
    }

    validateCustomOptions( customOptions ){
        return typeof customOptions == 'object' ? customOptions : {};
    }

    validateMethodArguments( methodArguments ){
        return Array.isArray( methodArguments ) ? methodArguments : []
    }
}