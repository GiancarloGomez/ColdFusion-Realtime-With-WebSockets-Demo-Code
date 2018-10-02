/*
* This example is based on the application found under the /live-demos/demo-01/Application.cfc
* which is where the channel and appName (Application name) comes from
* The objects defined as subscribe,unsubscribe and message is how the WebSocket server expects to receive data in
* a send() call.
*/
var cfws = new cfwebsocket(
    'websockets_demo1',
    'demo',
    'https://demo.fusedev.com/live-demos/demo-01/runme.cfm',
    parseMessage,
    subscribed,
    true
);
// overwrite from ../assets/js/script.js
sendMessage.removeEventListener('click',doSendMessage);
sendMessage.addEventListener('click',publish);

function publish(){
    if (cfws.publish(messageText.value.trim()))
        doToggleMessageForm();
}

function subscribed(){
    // lets show our buttons
    Array.from(document.getElementsByTagName('button')).forEach(function(button){
        button.style.opacity = 1;
        button.disabled = false;
    });
}