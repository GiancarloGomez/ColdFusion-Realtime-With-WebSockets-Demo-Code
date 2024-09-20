<cfscript>
	if( !structKeyExists(request,"socketio_server") )
		throw("You must set the URL to the Socket.IO server - review instructions in Application.onRequestStart()");
	if( !structKeyExists(request,"socketio_port") )
		throw("You must set the port to your Socket.IO server - review instructions in Application.onRequestStart()");

	// this stops an OPTIONS request from continuing to process
	if ( !compare(cgi.request_method,"OPTIONS") )
		exit;

	isAjax = !compareNoCase(cgi["X-Requested-With"] ?: "","XMLHttpRequest");

	params = {
		"channel" 	: lcase( url.channel ?: ( form.channel ?: "demo" ) ),
		"message" 	: url.message ?: ( form.message ?: "" )
	};

	asJSON = val( url.json ?: ( form.json ?: 0 ) );

	if ( !params.message.len() ){
		include "../shared/fetch-joke.cfm";
		params.message = joke;
	}
	// remove HTML entities from string because it bombs out
	params.message = params.message.replaceAll("\&[^\;]+\;","");
	// create new request
	cfhttp(
		url 	= request.socketio_server & "/publish",
		method 	= "POST",
		port 	= request.socketio_port
	){
		cfhttpparam(type:"formField",name:"channel",value:params.channel);
		cfhttpparam(type:"formField",name:"message",value: asJSON ? serializeJSON(params) : params.message);
	}
	// for XHR response
	if ( isAjax ){
		writeOutput( params.message );
		exit;
	}
</cfscript>
<cfif !isAjax>
	<!DOCTYPE html>
	<html lang="en">
	<head>
		<meta charset="UTF-8">
		<title>Message Posted</title>
		<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.1/dist/css/bootstrap.min.css" integrity="sha256-sAcc18zvMnaJZrNT4v8J0T4HqzEUiUTlVFgDIywjQek=" crossorigin="anonymous">
	</head>
	<body class="d-flex p-3 justify-content-center align-items-center flex-column vh-100">
		<div class="p-5 bg-light border shadow-sm text-center">
			<strong>The message you posted is as follows</strong><br />
			<small class="text-success"><cfoutput>#params.message#</cfoutput></small>
		</div>
	</body>
	</html>
</cfif>