<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>WebSocket Demo 3 - Advanced</title>
	<link rel="stylesheet" href="../../assets/css/styles.css">
	<link rel="stylesheet" href="../../assets/css/advanced.css">
</head>
<body 	data-channels="demo"
		data-debug="true"
		data-do-message="parseMessage"
		data-online-timer="10"
		data-offline-timer="2"
		data-reconnect-timer="2"
		data-ping-url="ping.cfm">

	<nav>
		<div id="status"></div>
		<span>DEMO 03 - ADVANCED</span>
		<button type="button" id="domessage">MESSAGE</button>
		<button type="button" id="clearlog">CLEAR LOG</button>
	</nav>

	<ul id="console"></ul>

	<form id="message" class="hide">
		<textarea name="message" id="messagetext"></textarea>
		<button type="button" id="sendmessage">Send Message</button>
	</form>

	<script src="../../assets/js/advancedsocket.js"></script>
	<script src="../../assets/js/script.js"></script>
	<script src="../../assets/js/advanced.js"></script>

	<cfwebsocket 	name="ws"
					onMessage="AdvancedSocket.onMessage"
					onOpen="AdvancedSocket.onOpen"
					onClose="AdvancedSocket.onClose"
					onError="AdvancedSocket.onError" />
</body>
</html>