<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>WebSocket Example</title>
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.1/dist/css/bootstrap.min.css" integrity="sha256-sAcc18zvMnaJZrNT4v8J0T4HqzEUiUTlVFgDIywjQek=" crossorigin="anonymous">
</head>
<body data-auto-connect="true"
		data-name="ws"
		data-channels="demo"
		data-debug="true"
		data-do-message="onMessage"
		data-online-timer="30"
		data-offline-timer="5"
		data-reconnect-timer=".5"
		data-ping-url="ping.cfm">

	<script src="https://cdn.jsdelivr.net/npm/advancedsocket@1.0.3/dist/advancedsocket.min.js" integrity="sha256-BL/dJfKkEsGPihoT3izThE3BhTgQg4SER+mq7HwAiKE=" crossorigin="anonymous"></script>

	<cfwebsocket name 		= "ws"
				onMessage 	= "AdvancedSocket.onMessage"
				onOpen		= "AdvancedSocket.onOpen"
				onClose		= "AdvancedSocket.onClose"
				onError		= "AdvancedSocket.onError"
	 			/>

	<script>
		function onMessage( data ){
			console.log( data );
		}
	</script>
</body>
</html>