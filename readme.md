# Realtime with WebSockets - Demo Code
__Presented By [Giancarlo Gomez](https://github.com/GiancarloGomez)__

This is the demo code used in my WebSockets presentation.

* __assets__<br />The CSS and JavaScript files that are shared by the live demo UIs
	* __css__
	* __js__
* __chat__<br />The chat demo
* __live-demos__
	* __demo-01__<br />Minimal requirements
	* __demo-02__<br />AdvancedSocket Example
* __other-demo-files__
	* __socket.io__ ( [node.js required](https://nodejs.org/) )<br />
	This is the code for the [socket.io](http://socket.io/) server that will run on port 8080.
	Remember to do an <code>npm install</code> after downloading and then run <code>node server.js</code> to start.
	* __socket.io_site__<br />
	The example site using the socket.io server to connect, send and receive messages both from the client and the server.
	This should be mapped to its own site.

## Conferences
* NCDevCon 2016
* Dev.Objective 2016
* ColdFusion Summit 2016
* ColdFusion Summit 2017
* ColdFusion Summit 2018

## Slides
All slides can be found in the [ColdFusion Realtime With WebSockets Repo](https://github.com/GiancarloGomez/ColdFusion-Realtime-With-WebSockets "ColdFusion Realtime With WebSockets Repo")

## Coming Soon
At this moment, the demo files are based on deployment on IIS 8+ using the proxy or embedded WebSocket server. Apache and CommandBox ready updates will be available soon.