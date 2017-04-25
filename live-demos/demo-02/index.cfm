<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>WebSocket Demo 2</title>
	<link rel="stylesheet" href="../../assets/css/styles.css">
</head>
<body>

	<nav>
		<span>DEMO 02</span>
		<button type="button" id="domessage">MESSAGE</button>
		<button type="button" id="clearlog">CLEAR LOG</button>
	</nav>

	<ul id="console"></ul>

	<script src="../../assets/js/script.js"></script>

	<cfwebsocket name="ws"
				 onmessage="parseMessage"
				 subscribeto="demo"
				 secure="true" />
</body>
</html>