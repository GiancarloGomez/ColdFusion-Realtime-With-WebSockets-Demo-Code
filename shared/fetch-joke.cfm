<cfscript>
	joke = "";
	try {
		categories = [
			"animal",
			"career",
			"celebrity",
			"dev",
			// "explicit",
			"fashion",
			"food",
			"history",
			"money",
			"movie",
			"music",
			"political",
			"religion",
			"science",
			"sport",
			"travel"
		];
		cfhttp(
			url     = "https://api.chucknorris.io/jokes/random?category=" & categories[ randRange(1,categories.len()) ],
			timeout = 5,
			result  = "apiRequest"
		);
		joke = deserializeJSON( apiRequest.fileContent ).value
	}
	catch ( any e ){
		joke = "We could not fetch a funny joke so this is just the server responding";
	}
</cfscript>