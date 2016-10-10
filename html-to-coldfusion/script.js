/*
* This example is based on the application found under the /live-demos/demo-01/Application.cfc
* which is where the channel and appName (Application name) comes from
* The objects defined as subscribe,unsubscribe and message is how the WebSocket server expects to receive data in
* a send() call.
*
* The ColdFusion team included a lot of functionality in their JavaScript, so I do recommend continuing to use
* the cfwebsocket tag but just in case you rather not this includes basci functionality of connecting, subscribing
* unsubscribing and sending / receiving message
*
* This sample assumes you already ran the demo-01 application and that you are using the internal websocket
* server on port 8577 (this is the type of work that the CF's team's code already handles for you along with Flash fallback)
*/
var ws          = new WebSocket('ws://' + location.hostname + ':8577/cfusion/cfusion'),
    subscribe   = {ns: 'coldfusion.websocket.channels', type: 'subscribe', channel: 'demo', appName: 'websockets_demo1'},
    unsubscribe = {ns: 'coldfusion.websocket.channels', type: 'unsubscribe', channel: 'demo', appName: 'websockets_demo1'},
    message     = {ns: 'coldfusion.websocket.channels', type: 'publish', channel: 'demo', data:'', appName: 'websockets_demo1'},
    openMessage = document.getElementById('domessage'),
    sendMessage = document.getElementById('sendmessage'),
    messageForm = document.getElementById('message'),
    messageText = document.getElementById('messagetext');


// WebSocket API Events

ws.onopen = function(e){
    console.log('onopen',e);
    // when we open go ahead and connect
    subscribeMe();
    // lets show our buttons
    Array.from(document.getElementsByTagName('button')).forEach(function(button){
        button.style.opacity = 1;
        button.disabled = false;
    });
};

ws.onmessage = function(e){
    // when we receive a message pass it to the parseMessage function (the data piece of the object received)
    console.log('onmessage',e);
    parseMessage(JSON.parse(e.data));
};

ws.onerror = function(e){
    console.log('onerror',e);
};

ws.onclose = function(e){
    console.log('close',e);
};

// Event Listeners on Buttons and Textarea
openMessage.addEventListener('click',doToggleMessageForm);
sendMessage.addEventListener('click',doSendMessage);
messageText.addEventListener('keyup',function(event){
    if(event.keyCode === 13  && event.shiftKey === true)
        doSendMessage();
});

// Subscribe me to a channel
function subscribeMe(){
    if (ws.readyState === ws.OPEN)
        ws.send(JSON.stringify(subscribe));
}

// Unsibscribe me from the channel
function unsubscribeMe(){
    if (ws.readyState === ws.OPEN)
        ws.send(JSON.stringify(unsubscribe));
}

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
    var thisMessage = Object.assign({},message),
        theMessage  = messageText.value.trim();
    if (theMessage !== ''){
        thisMessage.data = theMessage;
        ws.send(JSON.stringify(thisMessage));
        doToggleMessageForm();
    }
}