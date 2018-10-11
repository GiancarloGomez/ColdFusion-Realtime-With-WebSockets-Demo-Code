<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>WebSocket Demo 1</title>
	<link rel="stylesheet" href="/assets/css/styles.css">
</head>
<body>

	<nav>
		<span>DEMO 01</span>
		<button type="button" id="domessage">MESSAGE</button>
		<button type="button" id="clearlog">CLEAR LOG</button>
	</nav>

	<ul id="console"></ul>

	<form id="message" class="hide">
		<textarea name="message" id="messagetext"></textarea>
		<button type="button" id="sendmessage">Send Message</button>
	</form>

	<script src="/assets/js/script.js"></script>

	<cfwebsocket name="ws"
				 onmessage="parseMessage"
				 subscribeto="demo" />
</body>
</html>