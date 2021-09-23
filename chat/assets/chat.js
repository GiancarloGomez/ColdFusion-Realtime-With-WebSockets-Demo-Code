const Chat = {
    connected: false,
    clients: [],
    channel: null,
    username: null,
    clientID: null,
    ui: {
        body: document.body,
        loginModal: null,
        usernameField: null,
        usernameErrorText: null,
        usernameFormGroup: null,
        clearMessages: null,
        leaveRoom: null,
        messageToField: null,
        messageField: null,
        messageForm: null,
        messages: null,
        users: null

    },
    init : function() {
        const _this = this,
              _ui   = this.ui;
        // setup modal and show
        _ui.loginModal = $('#login')
                            .modal({
                                backdrop    : 'static',
                                keyboard    : false
                            })
                            .modal('show');
        // setup rest of UI
        _ui.usernameField        = _ui.loginModal.find('input');
        _ui.usernameErrorText    = _ui.loginModal.find('.invalid-feedback');
        _ui.usernameFormGroup    = _ui.usernameField.parents('.input-group');
        _ui.messageForm          = $('#messageFrm');
        _ui.messageToField       = $('#message-to');
        _ui.messageField         = $('#message');
        _ui.leaveRoom            = $('#leave-room');
        _ui.clearMessages        = document.getElementById('clear-messages')
        _ui.messages             = document.getElementById('messages');
        _ui.users                = document.getElementById('users');

        // listeners

        // focus on login field
        _ui.loginModal.on('shown.bs.modal',function(e){
            _ui.usernameField.val('').focus();
            _this.clearMessages();
            _ui.users.innerHTML = '';
        });

        // username blur
        _ui.usernameField.on('focus',function(){
            _ui.usernameField.removeClass('is-invalid');
            _ui.usernameErrorText.html('');
        });

        // clear our log
        _ui.clearMessages.addEventListener('click',_this.clearMessages.bind(_this));

        // join room
        _ui.loginModal.find('#loginFrm').submit(_this.login.bind(_this));

        // leave room
        _ui.leaveRoom.on('click',_this.logout.bind(_this));

        // send message
        _ui.messageForm.submit(_this.sendMessage.bind(_this));
    },
    clearMessages: function( event ){
        if ( event )
            event.preventDefault();
        this.ui.messages.innerHTML = '';
    },
    login: function ( event ){
        if ( event ){
            event.preventDefault();
            let username = this.ui.usernameField.val().trim();
            if ( username === '' ){
                this.ui.usernameField.addClass('is-invalid');
                this.ui.usernameErrorText.html('Please enter a username to login');
            }
            else {
                // set the username into our Client Info
                AdvancedSocket.clientInfo.username = username;
                // Authenticate User
                // On Success => AdvancedSocket.connected
                // On Fail    => AdvancedSocket.onError
                ws.authenticate( username, '' );
            }
        }
    },
    loginError: function(){
        this.ui.usernameField.addClass('is-invalid').val('');
        this.ui.usernameErrorText.html('Invalid User, please try again');
    },
    logout: function( event ){
        if ( event ){
            event.preventDefault();
            // Unsubscribe
            ws.unsubscribe( this.channel );
            // data updates
            this.connected  = false;
            this.clientID   =
            this.channel    =
            this.username   = null;
            // UI Updates
            this.ui.body.classList.add('off');
            this.ui.loginModal.modal('show');
            // change our AdvancedSocket to not run the Auto Connect feature
            AdvancedSocket.autoConnect = false;
            AdvancedSocket.checkConnection();
        }
    },
    receiveMessage: function( obj ){
        if( typeof obj.data === 'object' ){
            // process connected user menu
            this.clients = obj.data.data;
            this.updateClients();
        }
        else if ( obj.data !== 'FORCE-RECONNECT' ) {
            this.ui.messages.innerHTML += obj.data;
            // animate the scroll
            if ( typeof document.body.scrollIntoView === 'function' ){
                this.ui.messages.querySelector('.message:last-child').scrollIntoView({
                    behavior : 'smooth'
                });
            }
            else {
                $(this.ui.messages).animate({scrollTop : this.ui.messages.scrollHeight + 'px'},500);
            }
        }
    },
    sendMessage:function( event ){
        if ( event ){
            event.preventDefault();

            let value   = this.ui.messageField.val().trim(),
                toID    = this.ui.messageToField.val(),
                data     = {};

            if ( value !== '' ){
                // for private message
                if ( toID !== '' )
                    data.to = this.clients.find(client => client.id === toID );
                // publish
                ws.publish( this.channel, value, data );
                // reset message field
                this.ui.messageField.val('').focus();
            }
        }
    },
    updateClients: function() {
        let userList = '<ul>',
            options = '<option value="">All</option>';
        this.clients.forEach(client => {
            // do not include me in the message to options
            if ( client.id !== this.clientID )
                options += `<option value="${client.id}">${client.username}</option>`;
            userList += `<li data-id="${client.id}" class="${client.id === this.clientID ? 'me' : ''}">
                ${client.username}
                ${(client.city + client.region).length ? `<small>${client.city}, ${client.region}</small>` : ''}
            </li>`;
        });
        this.ui.users.innerHTML = userList;
        this.ui.messageToField.html( options )
    },
    welcome: function( clientID, username, channel ){
        if ( clientID && username ){
            this.ui.messages.innerHTML += `<div class="message welcome">
                                                <div class="content">Welcome to the chat room ${username}</div>
                                            </div>`;
            // UI Updates
            this.ui.usernameField.val('');
            this.ui.body.classList.remove('off');
            this.ui.loginModal.modal('hide');
            this.ui.messageField.focus();
            this.ui.leaveRoom.removeClass('hide');
            // data update
            this.connected  = true;
            this.clientID   = clientID;
            this.channel    = channel;
            this.username   = username;
        }
    }
};

// bind global to Chat receive message function
// for use with AdvanceSocket until I update to work with
// namespace functions
var receiveMessage = Chat.receiveMessage.bind(Chat);

// AdvanceSocket connect and onError overrides
AdvancedSocket.connected = function (){
    // initial connect
    if ( Chat.connected === false )
        Chat.welcome( AdvancedSocket.clientID, AdvancedSocket.clientInfo.username, AdvancedSocket.channels[0] );
    // set timer and status element
    AdvancedSocket.timerCount = AdvancedSocket.onlineTimer;
    AdvancedSocket.statusLabel.className = 'alert alert-success text-center';
    AdvancedSocket.statusLabel.innerHTML = 'We are connected!!!';
}

AdvancedSocket.onError = function(obj){
    // when an error occurs in the websocket
    if ( obj.reqType === 'authenticate' && obj.code === -1 ){
        Chat.loginError();
        AdvancedSocket.clientInfo.username = '';
    }
    // AdvancedSocket.log('onError',obj);
};

document.addEventListener('DOMContentLoaded',() => {
    Chat.init();
}, false);