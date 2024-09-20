<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>WebSocket Example Auth</title>
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.1/dist/css/bootstrap.min.css" integrity="sha256-sAcc18zvMnaJZrNT4v8J0T4HqzEUiUTlVFgDIywjQek=" crossorigin="anonymous">
</head>
<body>
	<cfoutput>
		<div class="d-flex justify-content-center align-items-center flex-column vh-100 text-center">
			<strong>#application.applicationname#</strong>
			<small>Restricted Example<br />Everything is in the console</small>
		</div>
	</cfoutput>

	<cfwebsocket name="ws"
					onMessage="onMessage"
					onOpen="onOpen"
					onClose="onClose"
					onError="onError"
					subscribeTo="restricted" />
	<script>
		function onOpen( data ){
			console.log( 'onOpen', data );
		}
		function onMessage( data ){
			console.log( 'onMessage', data );
		}
		function onClose( data ){
			console.log( 'onClose', data );
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
			// authenticate();
		}
	</script>
</body>
</html>