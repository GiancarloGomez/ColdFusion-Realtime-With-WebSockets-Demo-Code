<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>WebSocket Example Auth</title>
</head>
<body>
	<cfscript>
		writeDump( session );
	</cfscript>
	<cfwebsocket name="ws"
					onMessage="onMessage"
					onError="onError" />
	<script>

		function onMessage( data ){
			console.log( data );
		}

		function onError( data ){
			console.error( data );
		}

		function authenticate() {
			console.log( ws.isConnected() );
			if ( ws.isConnected() ){
				ws.authenticate('jc','');
				ws.subscribe('restricted');
			}
			else {
				window.setTimeout( authenticate, 250 );
			}
		}

		window.onload = () => {
			authenticate();
		}
	</script>
</body>
</html>