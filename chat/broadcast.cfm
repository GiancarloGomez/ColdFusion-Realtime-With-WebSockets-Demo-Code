<cfscript>
	// this stops an OPTIONS request from continuing to process
	if ( !compare(cgi.request_method,"OPTIONS") )
		exit;

	isAjax     = !compareNoCase(cgi["X-Requested-With"],"XMLHttpRequest");
	threadName = "ws_msg_" & createUUID();

	params = {
		"channel" : "chat",
		"message" : url.message ?: ( form.message ?: "" )
	};

	asJSON = val( url.json ?: ( form.json ?: 0 ) );

	if ( !params.message.len() ){
		include "../shared/fetch-joke.cfm";
		params.message = joke;
	}
	// remove HTML entities from string because it bombs out
	params.message  = params.message .replaceAll("\&[^\;]+\;","");
	// publish via thread, specially helpful when using Frameworks or calling in the middle of an Ajax Request
	cfthread( action="run",name=threadName,params=params,asJSON=asJSON){
		wsPublish(
			attributes.params.channel,
			attributes.asJSON ? serializeJSON(attributes.params) : attributes.params.message
		);
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