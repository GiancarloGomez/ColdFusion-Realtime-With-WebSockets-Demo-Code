<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>WebSocket Simple Example</title>
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.1/dist/css/bootstrap.min.css" integrity="sha256-sAcc18zvMnaJZrNT4v8J0T4HqzEUiUTlVFgDIywjQek=" crossorigin="anonymous">
</head>
<body>
	<cfoutput>
		<h1>#application.applicationname# <small>Simple</small></h1>
	</cfoutput>
	<cfwebsocket name="ws"
					onMessage="onMessage"
					onOpen="onOpen"
					onClose="onClose"
					onError="onError"
					usecfAuth="false"
					subscribeTo="demo,conference"/>
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
	</script>
</body>
</html>