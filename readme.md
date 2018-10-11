# Realtime with WebSockets - Demo Code
__Presented By [Giancarlo Gomez](https://github.com/GiancarloGomez)__

This is the demo code used in my WebSockets presentation.

* __assets__<br />The CSS and JavaScript files that are shared by the live demo UIs
	* __css__
	* __js__
* __chat__<br />The Chat demo
* __html-to-coldfusion__<br />The HTML to ColdFusion WebSocket example.
* __live-demos__
	* __demo-01__<br />Minimal requirements
	* __demo-02__<br />AdvancedSocket Example
* __other-demo-files__
	* __socket.io__ ( [node.js required](https://nodejs.org/) )<br />
	This is the code for the [socket.io](http://socket.io/) server that will run on port 8080.
	Remember to do an ``npm install`` after downloading and then run ``node server.js`` to start.
	* __socket.io_site__<br />
	The example site using the socket.io server to connect, send and receive messages both from the client and the server.
	This should be mapped to its own site or ran as a separate server using CommandBox.

## Running Demos ( CommandBox, Socket.IO and )
You can easily run the demos using CommandBox. Simply clone this repo to your local machine
and execute the ``box start`` command at the ``root`` folder for the main app and in the ``other-demo-files\socket.io_site``
folder for the demo of using Socket.IO instead of ColdFusion's WebSockets.

__Application.cfc Settings__
To run this code you must set 2 request variables in ``Application.cfc``, these variables are for the site ran from ``other-demo-files\socket.io_site``

```javascript
request.socketio_server = "http://127.0.0.1:51095/";
request.socketio_broadcast = "http://127.0.0.1:51095/broadcast/";
```

__Socket.IO__<br />
As stated above you will need to run ``node server.js`` command at the ``other-demo-files\socket.io`` folder.

__HTML To ColdFusion Demo__<br />
Once you have configured both of your servers, make sure to go into the ``html-to-coldfusion\script.js`` and set
the values to the WebSocket Port used by ColdFusion and the Path and Port to your server.

```javascript
var cfws = new cfwebsocket(
	// appName for the server we are interacting => live-demos\demo-01
    'websockets_demo1',
    // the name of the channel we are subscribing to
    'demo',
    // the file to run in case a ColdFusion request has not execute yet
    'http://localhost:50320/live-demos/demo-01/runme/',
    // the global function to execute to parse a message received
    parseMessage,
    // the global function to execute when we subscribe
    subscribed,
    // if we are using the proxy method
    false,
    // the Port used by ColdFusion for WebSockets ( if not included it uses defaults defined in cfwebsocket.js)
    8581,
    // the server we are connecting to
    'localhost',
    // if the connection should be secure
    false
);
```

## Conferences
* NCDevCon 2016
* Dev.Objective 2016
* ColdFusion Summit 2016
* ColdFusion Summit 2017
* ColdFusion Summit 2018

## Slides
All slides can be found in the [ColdFusion Realtime With WebSockets Repo](https://github.com/GiancarloGomez/ColdFusion-Realtime-With-WebSockets "ColdFusion Realtime With WebSockets Repo")
