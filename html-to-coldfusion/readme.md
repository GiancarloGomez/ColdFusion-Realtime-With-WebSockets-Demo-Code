# Connecting without ColdFusion JavaScript

This is a simple example on how to connect to the WebSockets Server without ColdFusion's JavaScript files. This is only for demo purposes and I would not recommend this just in case future changes are made to how to communicate within their core JavaScript files. The WebSocket API is simple and straight forward but subscribing, unsubscribing, authenticating, etc is all covered in their JS files as there is custom data that is prepared and sent to the server from the client. In this example I hard code the values in order to mimic what they do. You can also just include 2 of the 4 files if you do not need to support IE9 or less as I believe that is what the Ajax amd Message JS files are for.

The files I am refering to are located in:

* /CFIDE/scripts/ajax/package/cfwebsocketCore.js
* /CFIDE/scripts/ajax/package/cfwebsocketChannel.js

__IMPORTANT__
Please make sure to run the first example under `../live-demos/demo-01/` as this is the application used.