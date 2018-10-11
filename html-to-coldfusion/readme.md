# Connecting without ColdFusion JavaScript

This is a simple example on how to connect to the WebSockets Server without ColdFusion Team's JavaScript files.

The WebSocket API is simple and straight forward but subscribing, unsubscribing, authenticating, etc is all covered in the ColdFusion JS files as there is custom data that is prepared and sent to the server from the client.

In this example I created a cfwebsocket.js file that prepares the object necessary for subscribing, unsubscribing and publishing messages to a channel.

The ColdFusion Team's JavaScript files where I was able to reverse engineer this from are:
* /CFIDE/scripts/ajax/package/cfwebsocketCore.js
* /CFIDE/scripts/ajax/package/cfwebsocketChannel.js

__REQUIRED SETUP IN script.js__
Make sure to edit the parameters when creating the connection based on the server and ports you are running.

__IMPORTANT__
Please make sure to run the first example under `../live-demos/demo-01/` as this is the application used.