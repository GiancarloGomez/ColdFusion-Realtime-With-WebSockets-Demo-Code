var channels    =   ['demo','global'],
    socket      =   io('http://socketio.local.com:8080/',{
                        query : 'channels=' + channels.join(',')
                    }),
    ws          =   {CONNECTED:0,NOTIFY:0},
    _console    =   document.getElementById('console'),
    _clearlog   =   document.getElementById('clearlog');

/* ==========================================================================
SOCKET EVENTS
========================================================================== */
    socket.on('connect',function(){
        ws.CONNECTED = 1;
        parseMessage('connected to ' + channels.join(','));
    });

    socket.on('disconnect',function(data){
        ws.CONNECTED = 0;
        // set timeout to avoid opening alert if we refresh
        window.setTimeout(notifyDisconnect, 500);
    });

    socket.on('reconnect',function(data){
        ws.CONNECTED    = 1;
        ws.NOTIFY       = 0;
        parseMessage('We are back on');
    });

    socket.on('message',function(data){
        parseMessage(data);
        // global reload
        if (data.message && data.message === 'RELOAD'){
            parseMessage('I will reload in 3 seconds');
            window.setTimeout(function(){
                window.location.reload()
            },3000);
        }
    });

/* ==========================================================================
GLOBAL LISTENERS AND FUNCTIONS
========================================================================== */
    _clearlog.addEventListener("click",function(e){
        e.preventDefault();
        _console.innerHTML = '';
    });

    function sendMessage(channel,message){
        parseMessage(message);
        socket.emit('message',{channel : channel, message :message});
    }

    function notifyDisconnect(){
        if (ws.CONNECTED === 0 && ws.NOTIFY === 0){
            parseMessage('We have been disconnected');
            ws.NOTIFY++;
        }
    }

    function parseMessage(message){
        var t = new Date();
            t = t.toLocaleDateString() + ' ' + t.toLocaleTimeString();
        _console.innerHTML =    '<li><strong class="timestamp">' + t + '</strong>\n' +
                                '<pre>' +
                                JSON.stringify(message).replace(/,"/g,',\n "')
                                    .replace('{','{\n ')
                                    .replace('}','\n}') +
                                '</pre></li>' + _console.innerHTML;
    }