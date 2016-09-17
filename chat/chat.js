var _console    = document.getElementById('console'),
    _users      = document.getElementById('users'),
    UI          = {connected:false};

// clear our log
document.getElementById('clearlog').addEventListener('click',function(e){
    e.preventDefault();
    _console.innerHTML = '';
});

$(function(){
    // setup modal and show
    UI.loginModal   = $('#login').modal({
                        backdrop    : 'static',
                        keyboard    : false
                    });
    // setup rest of UI
    UI.body         = $('body');
    UI.username     = UI.loginModal.find('input');
    UI.u_parent     = UI.username.parents('.form-group');
    UI.message      = $('#message');
    UI.sendMessage  = $('#messageFrm');
    UI.leave        = $('#leave-room');

    // focus on login field
    UI.loginModal.on('shown.bs.modal',function(e){
        UI.username.val('').focus();
        _console.innerHTML = '';
        _users.innerHTML = '';
    });

    // leave room
    UI.leave.on('click',function(){
        // Unsibscribe
        ws.unsubscribe(AdvancedSocket.channels[0]);
        // change our AdvancedSocket to not run the Auto Connect feature
        AdvancedSocket.autoConnect = false;
        AdvancedSocket.checkConnection();
        UI.connected = false;
        // UI Updates
        UI.body.addClass('off');
        UI.loginModal.modal('show');
        return false;
    })

    // join room
    UI.loginModal.find('#loginFrm').submit(function(){
        var value = UI.username.val().trim();
        if (value === ''){
            UI.u_parent.addClass('has-error');
            UI.u_parent.find('.help-block').html('Please enter a username to login');
        } else {
            // set the username into our Client Info
            AdvancedSocket.clientInfo.username = value;
            // Authenticate User
            // On Success => AdvancedSocket.connected
            // On Fail    => AdvancedSocket.onError
            ws.authenticate(value, '');
        }
        return false;
    });

    // username blur
    UI.username.on('focus',function(){
       UI.u_parent.removeClass('has-error');
       UI.u_parent.find('.help-block').html('');
    });

    // send message
    UI.sendMessage.submit(function(){
        var value = UI.message.val().trim();
        if (value !== ''){
            ws.publish(AdvancedSocket.channels[0],value);
        }
        UI.message.val('').focus();
        return false;
    });
});

function receiveMessage(obj){
    if(typeof obj.data === 'object'){
        console.log(obj);
        // process connected user menu
        _users.innerHTML = obj.data.data;
    } else if (obj.data !== 'FORCE-RECONNECT') {
        _console.innerHTML += obj.data;
        // animate the scroll
        $(_console).animate({scrollTop : _console.scrollHeight + 'px'},500);
    }
}

AdvancedSocket.connected = function (){
    // initial connect
    if (UI.connected === false){
        _console.innerHTML += '<div class="message clear"><div class="content">Welcome to the chat room ' + AdvancedSocket.clientInfo.username + '</div></div>';
        // UI Updates
        UI.username.val('');
        UI.body.removeClass('off');
        UI.loginModal.modal('hide');
        UI.message.focus();
        UI.leave.removeClass('hide');
        UI.connected = true;
    }
    AdvancedSocket.timerCount = AdvancedSocket.onlineTimer;
    AdvancedSocket.statusLabel.className = 'alert alert-success text-center';
    AdvancedSocket.statusLabel.innerHTML = 'We are connected!!!';
}

AdvancedSocket.onError = function(obj){
    // when an error occurs in the websocket
    if (obj.reqType === 'authenticate' && obj.code === -1){
        UI.u_parent.addClass('has-error');
        UI.u_parent.find('.help-block').html('Invalid User, please try again');
        UI.username.val('');
        AdvancedSocket.clientInfo.username = '';
    }
    AdvancedSocket.log('onError',obj);
};