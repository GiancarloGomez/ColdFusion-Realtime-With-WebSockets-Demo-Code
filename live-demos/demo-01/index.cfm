<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>WebSocket Demo 1</title>
	<link rel="stylesheet" href="../assets/css/styles.css">
</head>
<body>

	<nav>
		<button type="button" id="clearlog">Clear Log</button>
	</nav>

	<ul id="console"></ul>

	<script src="../assets/js/script.js"></script>

	<cfwebsocket name="ws"
				 onmessage="parseMessage"
				 subscribeto="demo" />
</body>
</html>