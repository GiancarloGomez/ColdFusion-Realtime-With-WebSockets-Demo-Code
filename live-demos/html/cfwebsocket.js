class CFWebSocket {

    constructor({
        appName,
        isProxy = false,
        appStartUrl,
        wsUrl,
        channel,
        subscriberInfo,
        onMessage,
        onSubscribe,
        onError,
        onClose
    } = Object()){
        this.doLog('initialized');
        if ( !appStartUrl )
            throw( 'appStartUrl must be passed in the options' );
        if ( !wsUrl )
            throw( 'wsUrl must be passed in the options' );
        const isSecure = location.protocol === 'https:' ? true : false;
        // set options
        this.options = {
            appName         : appName,
            // path to use for ws connection
            appPath         : isProxy ? '/cfws' : '/cfusion/cfusion',
            // set full server url to run on open to make sure
            // ColdFusion Application has been started
            appStartUrl     : `//${appStartUrl}`,
            // set full server url to connect to
            wsUrl           : `${isSecure ? 'wss' : 'ws'}://` +
                                wsUrl +
                                ( isProxy ? '/cfws' : '/cfusion/cfusion' ),
            // initial channels and subsriberInfo
            channel         : channel,
            subscriberInfo  : subscriberInfo,
            // For WebSocket API Events
            onMessage       : onMessage,
            onSubscribe     : onSubscribe,
            onError         : onError,
            onClose         : onClose,
            NS              : 'coldfusion.websocket.channels'
        };
        // define WebSocket connection
        this.ws = null;
        this.channels = [];
        this.openConnection();
        // create event listeners
        window.addEventListener('offline', evt => {
            this.doLog( 'I am offline!!!' );
            // AdvancedSocket.setTimer(false);
            // AdvancedSocket.disconnected();
            // if we go fully offline kill any pending timer
            // clearTimeout(AdvancedSocket.timer);
            // AdvancedSocket.doLog('AdvancedSocket : Event','offline',e);
        }, false);
        window.addEventListener('online', evt => {
            this.doLog( 'I am online!!!' );
            this.closeConnection();
            this.openConnection();
            // AdvancedSocket.doLog('AdvancedSocket : Event','online',e);
            // restart connection check
            // AdvancedSocket.checkConnection();
          }, false);
    }

    openConnection(){
        this.doLog('openConnection');
        // Create connection to the WebSocket server
        this.ws = new WebSocket( this.options.wsUrl );
        // for tracking user initiated connection close requests
        this.ws.userInitiatedClose = false;
        // WebSocket API Events
        this.ws.onopen = async (e) => {
            // to make sure we fired off a cfm file to start the
            // application run the following
            const firstCall = await fetch( this.options.appStartUrl );
            const channels  = this.channels.length ? this.channels : this.options.channel;
            if ( firstCall.status === 200 && channels)
                this.subscribe( channels );
            return;
        };
        this.ws.onmessage = (e) => {
            this.doLog('onmessage');
            // parse the message received
            var data = JSON.parse(e.data);
            // pass to our onSubscribe callback
            if ( data.code === 0 && data.type === 'response' && data.reqType === 'subscribe' && data.msg ==='ok' && typeof this.options.onSubscribe === 'function' )
                this.options.onSubscribe( data );
            // pass to our onMessage callback
            if ( typeof this.options.onMessage === 'function' )
                this.options.onMessage(data);
            // if it is a force reconnect ( from an application reload )
            if ( data.type === 'data' && data.data === 'FORCE-RECONNECT' ){
                this.openConnection();
            }
        };
        this.ws.onerror = (e) => {
            this.doLog('onerror');
            if ( typeof this.options.onError === 'function' )
                this.options.onError(e);
            else
                console.error(e);
        };
        this.ws.onclose = (e) => {
            this.doLog('onclose', this.ws);
            // this means we went offline we need to reconnect
            if ( this.ws !== null )
                this.openConnection();
        };
    }

    closeConnection( userInitiatedClose ){
        this.doLog('closeConnection');
        if ( this.isConnected() ){
            this.ws.userInitiatedClose = userInitiatedClose || true;
            this.ws.close();
            if ( typeof this.options.onClose === 'function' )
                this.options.onClose( this.options );
            this.ws = null;
        }
    }

    authenticate( username, password ){
        this.doLog('authenticate');
        const isConnected = this.isConnected();
        if ( isConnected ){
            this.sendToken({
                type        : 'authenticate',
                username    : username,
                password    : password
            });
        }
        return isConnected;
    }

    subscribe( channel, subscriberInfo ){
        this.doLog('subscribe',{ channel, subscriberInfo });
        const isConnected = this.isConnected();
        // allow multiple channel subcribe
        if ( isConnected ){
            const _channels = Array.isArray(channel) ? channel : channel.split(',');
            _channels.forEach( _channel => {
                this.channels.push( _channel );
                this.sendToken({
                    type            : 'subscribe',
                    channel         : _channel,
                    customOptions   : this.validateCustomOptions( subscriberInfo || this.options.subscriberInfo )
                });
            });
        }
        return isConnected;
    }

    unsubscribe( channel ){
        this.doLog('unsubscribe');
        const isConnected = this.isConnected();
        // allow multiple channel unsubscribe
        if ( isConnected ){
            const _channels = Array.isArray(channel) ? channel : channel.split(',');
            _channels.forEach( _channel => {
                const _index = this.channels.indexOf( _channel );
                if ( _index !== -1 )
                    this.channels.splice( _index,1 );
                this.sendToken({
                    type    : 'unsubscribe',
                    channel : _channel
                });
            });
        }
        return isConnected;
    }

    publish( channel, message, customOptions ){
        this.doLog('publish');
        const isConnected = this.isConnected();
        if ( isConnected ){
            this.sendToken({
                type            : 'publish',
                channel         : channel,
                data            : message,
                customOptions   : this.validateCustomOptions( customOptions )
            });
        }
        return isConnected;
    }

    invoke( cfcName, cfcMethod, methodArguments ){
        this.doLog('invoke');
        const isConnected = this.isConnected();
        if ( isConnected ){
            this.sendToken({
                type            : 'invoke',
                cfcName         : cfcName,
                cfcMethod       : cfcMethod,
                methodArguments : this.validateMethodArguments( methodArguments ),
                referrer        : location.pathname
            });
        }
        return isConnected;
    }

    invokeAndPublish( channel, cfcName, cfcMethod, methodArguments, customOptions ){
        this.doLog('invokeAndPublish');
        const isConnected = this.isConnected();
        if ( isConnected ){
            this.sendToken({
                type            : 'invokeAndPublish',
                channel         : channel,
                cfcName         : cfcName,
                cfcMethod       : cfcMethod,
                methodArguments : this.validateMethodArguments( methodArguments ),
                referrer        : location.pathname,
                customOptions   : this.validateCustomOptions( customOptions )
            });
        }
        return isConnected;
    }

    getSubscriberCount( channel ){
        this.doLog('invokeAndPublish');
        if ( !this.isConnected() )
            return;

        return this.sendToken({
            type    : 'getSubscriberCount',
            channel : channel
        });
    }

    getSubscriptions(){
        this.doLog('getSubscriptions');
        if ( !this.isConnected() )
            return;
        return this.sendToken({
            type : 'getSubscriptions'
        });
    }

    isConnected(){
        this.doLog('isConnected');
        return this.ws instanceof WebSocket &&
                this.ws.readyState === this.ws.OPEN;
    }

    sendToken( token ){
        this.doLog('sendToken');
        if ( token.customOptions && Object.keys(token.customOptions).length === 0 )
            delete token.customOptions;
        this.ws.send( JSON.stringify({
            ns      : this.options.NS,
            appName : this.options.appName,
            ...token
        }));
    }

    validateCustomOptions( customOptions ){
        this.doLog('validateCustomOptions');
        return typeof customOptions == 'object' ? customOptions : {};
    }

    validateMethodArguments( methodArguments ){
        this.doLog('validateMethodArguments');
        return Array.isArray( methodArguments ) ? methodArguments : []
    }
}

// for debugging purposes
CFWebSocket.prototype.doLog = new URLSearchParams(location.search).get('debug') !== null && window.console ? console.log.bind(window.console) : () => {}