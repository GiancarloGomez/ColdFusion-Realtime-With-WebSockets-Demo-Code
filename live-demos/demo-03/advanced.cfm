<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>WebSocket Demo 3 - Advanced</title>
	<link rel="stylesheet" href="../assets/css/styles.css">
	<link rel="stylesheet" href="../assets/css/advanced.css">
</head>
<body 	data-channels="demo"
		data-debug="true"
		data-do-message="parseMessage"
		data-online-timer="10"
		data-offline-timer="2"
		data-reconnect-timer="2"
		data-ping-url="ping.cfm">
	<nav>
		<button type="button" id="clearlog">Clear Log</button>
	</nav>

	<div id="status"></div>

	<ul id="console"></ul>

	<script src="../assets/js/advancedsocket.js"></script>
	<script src="../assets/js/script.js"></script>
	<script src="../assets/js/advanced.js"></script>

	<cfwebsocket 	name="ws"
					onMessage="AdvancedSocket.onMessage"
					onOpen="AdvancedSocket.onOpen"
					onClose="AdvancedSocket.onClose"
					onError="AdvancedSocket.onError" />
</body>
</html>