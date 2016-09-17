var statusDiv = document.getElementById('status');

AdvancedSocket.disconnected = function(){
    statusDiv.innerHTML = 'Disconnected';
    showStatus('disconnected');
}

AdvancedSocket.connected = function(){
    statusDiv.innerHTML = 'Connected';
    showStatus('connected');
}

AdvancedSocket.connecting = function(){
    statusDiv.innerHTML = 'Connecting ...';
    showStatus('connecting');
}

function showStatus(statusClass){
    statusDiv.className = 'on ' + statusClass;
}