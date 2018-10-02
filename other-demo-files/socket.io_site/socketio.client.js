var channels    = ['demo','global'],
    socket      = {},
    server      = {},
    ws          = {CONNECTED:0,NOTIFY:0},
    _console    = document.getElementById('console'),
    _clearlog   = document.getElementById('clearlog'),
    _scroll     = navigator.userAgent.indexOf('Firefox') !== -1,
    // message controls
    openMessage = document.getElementById('domessage'),
    openMessage = document.getElementById('domessage'),
    sendMessage = document.getElementById('sendmessage'),
    messageForm = document.getElementById('message'),
    messageText = document.getElementById('messagetext');

// let's fetch our info
fetch('./info/',{type:'GET'})
    .then( response => response.json() )
    .then( response => {
        if(!response.success)
           window.alert(response.message);
        else
            callSocketIO(response.data.socketio_server,response.data.socketio_port);
    });


function callSocketIO(server,port){
    // go an connect
    try{
        socket = io(`${server}:${port}/`,{
            query : 'channels=' + channels.join(',')
        });
        setupSocketIO();
    }
    catch(e){
        window.alert('We could not connect to the socket IO instance, make sure you have started it.');
    }
}

/* ==========================================================================
SOCKET EVENTS
========================================================================== */
    function setupSocketIO(){
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
    }

/* ==========================================================================
GLOBAL LISTENERS AND FUNCTIONS
========================================================================== */
    _clearlog.addEventListener("click",function(e){
        e.preventDefault();
        _console.innerHTML = '';
    });

    function send(channel,message){
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
        var _date   = new Date(),
            // format timestamp to a readable format
            _ts     = _date.toLocaleDateString() + ' ' + _date.toLocaleTimeString(),
            // format message object into multiline readable string
            _data   = JSON.stringify(message).replace(/,"/g,',\n "').replace('{','{\n ').replace('}','\n}'),
            // create new element
            _li     = document.createElement('li');
        // set the text
        _li.innerHTML = `<strong class="timestamp">${_ts}</strong><pre>${_data}</pre>`;
        // append element to console
        _console.appendChild(_li);

        // extra
        // if firefox use internal smooth functionality of scrollIntoView - if not animate using function
        if (document.body.scrollIntoView)
            document.body.scrollIntoView({block: "end", behavior: "smooth"});
    }

    // Event Listeners on Buttons and Textarea
    openMessage.addEventListener('click',doToggleMessageForm);
    sendMessage.addEventListener('click',doSendMessage);
    messageText.addEventListener('keyup',function(event){
        if(event.keyCode === 13  && event.shiftKey === true)
            doSendMessage();
    });

    // Toggle our message modal
    function doToggleMessageForm(){
        if ( messageForm.classList.contains('hide') === true){
            messageForm.classList.remove('hide');
            messageForm.message.value = '';
        } else {
            messageForm.classList.add('hide');
        }
    }

    // Send a message to the server => publish()
    function doSendMessage(){
        var theMessage  = messageText.value.trim();
        if (theMessage !== ''){
            send('demo',theMessage);
            doToggleMessageForm();
        }
    }