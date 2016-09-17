<cfscript>
	WSPublish("demo", url.message ?: "This is a message from the server on " & dateTimeFormat(now(),"long"));
</cfscript>