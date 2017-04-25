var channels    =   ['demo','global'],
    socket      =   {},
    ws          =   {CONNECTED:0,NOTIFY:0},
    _console    =   document.getElementById('console'),
    _clearlog   =   document.getElementById('clearlog'),
    _scroll     = navigator.userAgent.indexOf('Firefox') !== -1,
    // message controls
    openMessage = document.getElementById('domessage'),
    openMessage = document.getElementById('domessage'),
    sendMessage = document.getElementById('sendmessage'),
    messageForm = document.getElementById('message'),
    messageText = document.getElementById('messagetext');


// go an connect
try{
    socket = io('http://socketio.local.com:8080/',{
        query : 'channels=' + channels.join(',')
    });
}
catch(e){
    window.alert('We could not connect to the socket IO instance, make sure you have started it.');
    socket = null;
}

/* ==========================================================================
SOCKET EVENTS
========================================================================== */
    if (socket){
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
        if (_scroll)
            document.body.scrollIntoView({block: "end", behavior: "smooth"});
        else if (_li.offsetTop + _li.offsetHeight > document.documentElement.clientHeight)
            scrollTo(document.body, (_li.offsetTop + _li.offsetHeight + 11) - document.documentElement.clientHeight, 250);
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

// https://gist.github.com/andjosh/6764939
    function scrollTo(element, to, duration) {
        var start = element.scrollTop,
            change = to - start,
            currentTime = 0,
            increment = 20;

        var animateScroll = function(){
            currentTime += increment;
            var val = Math.easeInOutQuad(currentTime, start, change, duration);
            element.scrollTop = val;
            if(currentTime < duration) {
                setTimeout(animateScroll, increment);
            }
        };
        animateScroll();
    }
    //t = current time
    //b = start value
    //c = change in value
    //d = duration
    Math.easeInOutQuad = function (t, b, c, d) {
      t /= d/2;
        if (t < 1) return c/2*t*t + b;
        t--;
        return -c/2 * (t*(t-2) - 1) + b;
    };