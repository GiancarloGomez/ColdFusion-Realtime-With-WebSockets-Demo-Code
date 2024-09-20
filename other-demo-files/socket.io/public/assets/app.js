const socket   = io('',{ query: { channels : 'general,chat' }});
const form     = document.getElementById('form');
const message  = document.getElementById('message');
const messages = document.getElementById('messages');

form.addEventListener('submit', event => {
    event.preventDefault();
    if ( message.value.toString().trim() ) {
        socket.emit('publish',{ channel:'chat', message:message.value});
        message.value = '';
    }
});

socket.on( 'message', data => {
    const item = document.createElement('li'),
          pre = document.createElement('pre');

    pre.textContent = JSON.stringify( data ).replace(/,"/g,',\n "').replace('{','{\n ').replace('}','\n}');

    item.appendChild( pre )
    messages.appendChild( item  );
    messages.scrollTo( { top:document.body.scrollHeight,left:0,behavior:'smooth' } );
});