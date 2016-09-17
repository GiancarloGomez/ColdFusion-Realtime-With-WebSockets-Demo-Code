var app         = require('express')(),
    server      = require('http').Server(app),
    io          = require('socket.io')(server),
    bodyParser  = require('body-parser'),
    url         = require('url');

// listen on custom port
server.listen(8080);

// The Simple WebSocket Server
io.on('connection', function (socket) {
    // parse the url and retrieve the channels value
    var query       = url.parse(socket.handshake.url, true).query,
        channels    = query.channels ? query.channels.toString().split(',') : [];

    // join each channel passed (room)
    for (var channel in channels){
        socket.join(channels[channel])
        // connecting to channel
        console.log('connecting to channel ' + channels[channel]);
    }

    // when the client emits a 'message'
    socket.on('message',function(data){
        console.log('message : ',data);
        // emit the message to the other subscribers
        if (data.channel)
            socket.broadcast.to(data.channel).emit('message',data);
        else
            socket.broadcast.emit('message',data);
    });

    // when a client disconnects
    socket.on('disconnect', function(){
        console.log('disconnect');
    });
});

/*
* https://github.com/expressjs/body-parser
* Node.js body parsing middleware
* the bodyParser object exposes various factories to create middlewares.
* All middlewares will populate the req.body property with the parsed body,
* or an empty object ({}) if there was no body to parse (or an error was returned).
*/
app.use(bodyParser.urlencoded({extended:true}));

// POST MESSAGE
// Easy way to post a message so connected clients can receive from external services
app.post('/publish',function(req, res){

    var message;

    console.log("[200] " + req.method + " to " + req.url + " from " + req.get('user-agent') + ' ' + req.get('host') + ' ' + req.ip);
    console.log(req.body);

    // try to parse the message first or send as simple string
    try{
        message = JSON.parse(req.body.message);
    }
    catch(e) {
        message = req.body.message;
    }
    // append channel to object
    if(typeof message === 'object' && req.body.channel && !message.channel);
        message.channel = req.body.channel;
    try{
        // if post to channel or global
        if (req.body.channel)
            io.sockets.to(req.body.channel).emit('message',message);
        else
            io.sockets.emit('message',{message:message});
        res.json({'success':true});
    }
    catch(e){
        res.json({'success':false});
    }
});
