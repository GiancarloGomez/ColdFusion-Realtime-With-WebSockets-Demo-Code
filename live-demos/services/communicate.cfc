component {
	remote any function publish(){
		sleep( 1000 );
		return "This is the value returned from publish()";
	}

	remote any function p2p( string value = 5 ){
		if ( !isNumeric( arguments.value ) )
			arguments.value = 5;
		cfthread ( action="run", name="backToInvoker_#createUUID()#", total=arguments.value ) {
			for ( i = 1; i <= total; i++ ){
				sleep( 500 );
				wsSendMessage( i & " of " & total & " : I am only returning this to the P2P Client" );
			}
		}
		return "This is the value returned from p2p()";
	}

	remote any function doIt( required string name, required string message ){
		return arguments.name & " says """ & arguments.message & """";
	}
}