// get our console
var _console = document.getElementById('console');

// clear our log
document.getElementById('clearlog').addEventListener('click',function(e){
    e.preventDefault();
    _console.innerHTML = '';
});

// parse message when received thru websocket
function parseMessage(message){
    var timestamp = new Date();
    // format timestamp to a readable format
    timestamp   = timestamp.toLocaleDateString() + ' ' + timestamp.toLocaleTimeString();
    // format message object into multiline readable string
    message     = JSON.stringify(message).replace(/,"/g,',\n "').replace('{','{\n ').replace('}','\n}');
    // preprend new li to console
    _console.insertAdjacentHTML('afterbegin',`
        <li>
            <strong>${timestamp}</strong>
            <pre>${message}</pre>
        </li>
    `);
}