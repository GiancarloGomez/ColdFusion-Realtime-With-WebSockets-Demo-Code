import express from 'express';
import { createServer } from 'node:http';
import { fileURLToPath } from 'node:url';
import { dirname, join } from 'node:path';
import { Server } from 'socket.io';

const app = express();
const server = createServer(app);
const io = new Server(server);

const __dirname = dirname(fileURLToPath(import.meta.url));

app.use( express.static('public') );
app.use( '/publish', express.json() );

// The Simple WebSocket Server
io.on('connection', socket => {

    const channels = socket.handshake.query.channels ?
                        socket.handshake.query.channels.toString().split(',') :
                        [];

    console.log( `user connected - ${socket.id}`, channels );

    const subscribeTo = channels => {
        channels.forEach( channel => {
            socket.join( channel );
            console.log( `subscribing ${socket.id} to channel ${channel}`);
        });
    }

    const unsubscribeFrom = channels => {
        channels.forEach( channel => {
            socket.leave( channel );
            console.log( `unsubscribing ${socket.id} from channel ${channel}`);
        });
    }

    // join each channel passed (room)
    subscribeTo( channels );

    socket.on('disconnect', () => {
        console.log( `user disconnected - ${socket.id}` );
    });

    socket.on('subscribe', channels => {
        channels = channels ? channels.toString().split(',') : [];
        subscribeTo( channels );
    });

    socket.on('unsubscribe', channels => {
        channels = channels ? channels.toString().split(',') : [];
        unsubscribeFrom( channels );
    });

    socket.on('publish', data => {
        console.log( 'publish ', data );

        if ( data.constructor !== Object ) {
            data = {
                message : data
            };
        }

        // send back the publisherId
        data.publisherId = socket.id;

        // emit the message to the other subscribers
        // use socket.broadcast to send to all except the sender
        if ( data.channel )
            io.to( data.channel ).emit( 'message', data );
        else
            io.emit( 'message', data );
    });
});

// publish via post
app.post('/publish', ( req, res ) => {
    console.log( `[200]  ${req.method} ${req.url} via ${req.get('user-agent')} ${req.get('host')} ${req.ip}`);

    try {
        if ( !req.body.message ) {
            return res.status(400).json({'error':'message is required'});
        }

        req.body.publisherId = 0;

        // if post to channel or global
        if ( req.body.channel )
            io.to( req.body.channel ).emit( 'message', req.body );
        else
            io.emit( 'message',req.body );

        res.json( { 'success':true } );
    }
    catch(e){
        res.json( { 'success':false } );
    }
});

// get channel subscriber count and meta
app.get('/subscribers/:channel', async ( req, res ) => {
    const sockets = ( await io.in( req.params.channel ).fetchSockets() ).map( socket => {
        return {
            id : socket.id ,
            date : socket.handshake.time
        };
    });
    res.json( { 'success':true, 'count':sockets.length, sockets } );
});

server.listen( 3000, () => {
    console.log('server running at http://localhost:3000');
});