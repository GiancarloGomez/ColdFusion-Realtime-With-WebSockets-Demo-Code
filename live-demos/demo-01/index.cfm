<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>WebSocket Demo - Simple</title>
	<link rel="stylesheet" href="/live-demos/assets/css/styles.css">
</head>
<body>

	<nav>
		<span>DEMO - SIMPLE</span>
		<button type="button" id="domessage">MESSAGE</button>
		<button type="button" id="clearlog">CLEAR LOG</button>
	</nav>

	<ul id="console"></ul>

	<form id="message" class="hide">
		<textarea name="message" id="messagetext"></textarea>
		<button type="button" id="sendmessage">Send Message</button>
	</form>

	<script src="/live-demos/assets/js/script.js"></script>

	<cfwebsocket name="ws"
				 onmessage="parseMessage"
				 subscribeto="demo" />
</body>
</html>