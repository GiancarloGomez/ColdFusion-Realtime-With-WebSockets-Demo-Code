// get our console and see if we are using firefox
var _console    = document.getElementById('console'),
    _scroll     = navigator.userAgent.indexOf('Firefox') !== -1,
    // message controls
    openMessage = document.getElementById('domessage'),
    openMessage = document.getElementById('domessage'),
    sendMessage = document.getElementById('sendmessage'),
    messageForm = document.getElementById('message'),
    messageText = document.getElementById('messagetext');

// clear our log
document.getElementById('clearlog').addEventListener('click',function(e){
    e.preventDefault();
    _console.innerHTML = '';
});

// parse message when received thru websocket
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
        ws.publish('demo',theMessage);
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