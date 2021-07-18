component extends="CFIDE.websocket.ChannelListener" {

	public boolean function allowSubscribe( struct subscriberInfo ) {
		//I am crucial. You must use me. Or else.
		if( !arguments.subscriberInfo.connectionInfo.authenticated ) return false;
		//I'm an optional check just to be extra secure
		if( !structKeyExists(arguments.subscriberInfo,"username") ) return false;
		// send to all connected clients that this new subscriber has joined
		wsPublish( "chat",arguments.subscriberInfo.username & " has joined the chat room, say hello ... " );
		// in a thread send to all clients (including just connected the full connected list)
		thread name="subscribers_#createUUID()#" action="run"{
			returnConnectedUsers();
		}
		return true;
	}

	public boolean function allowPublish( struct publisherInfo ) {
		return arguments.publisherInfo.connectionInfo.authenticated;
	}

	public any function beforePublish( any message, struct publisherInfo ){
		cflock( scope="application", timeout="10", type="exclusive" ){
			application.publishedMessages++;
		}
		var messageData = {
			message 		: arguments.message,
			publisherInfo 	: arguments.publisherInfo.connectionInfo,
			to 				: arguments.publisherInfo.to ?: {}
		};
		return messageData;
	}

	public any function beforeSendMessage( any message, struct subscriberInfo ){
		var className 			= "message";
		var isMe 				= false;
		var isPrivateMessage 	= false;
		var messageText 		= "";
		var privateMessageText 	= "";

		if ( isStruct(arguments.message.message) ){
			messageText = arguments.message.message;
		}
		else if ( arguments.message.message == "FORCE-RECONNECT" ){
			messageText = arguments.message.message;
		}
		else if ( structKeyExists(arguments.message.publisherInfo,"username") ){
			isMe = !compare(arguments.subscriberInfo.connectioninfo.clientid,arguments.message.publisherInfo.clientid);

			isPrivateMessage = !structIsEmpty( arguments.message.to ?: {} ) &&
								structKeyExists(arguments.message.to,"id") &&
								structKeyExists(arguments.message.to,"username");

			className 		&= 	( isMe ? " me" : "" ) &
								( isPrivateMessage ? " private" : "" );

			if ( isPrivateMessage ){
				privateMessageText = 	"<small>Private
											#( isMe ? "to " & arguments.message.to.username : "from " & arguments.message.publisherInfo.username )#
										</small>";
			}
			messageText 	= 	"<div class=""#className#"">
									<div class=""sender"">
										#arguments.message.publisherInfo.username#
										#privateMessageText#
									</div>
									<div class=""content"">#arguments.message.message#</div>
								</div>";
		}
		else {
			messageText 	= 	"<div class=""#className# system"">
									<div class=""sender"">SYSTEM</div>
									<div class=""content"">#arguments.message.message#</div>
								</div>";
		}
		return messageText;
	}

	public any function canSendMessage(any message, struct subscriberInfo, struct publisherInfo) {
		var canSend 		= true;
		var privateToData 	= {};

		// system messages skip this check as they are meant for all
		// which is done by making sure that publisherInfo.connectionInfo.clientID
		// exists as the system message does not have one
		if ( !isNull(arguments.publisherInfo.connectionInfo.clientID) ){
			privateToData = !isNull(message.to) && isStruct(message.to) ? message.to : {};
			// if not private
			// or myself
			// or message is for me
			canSend = 	( structIsEmpty( privateToData ) ) ||
						arguments.publisherInfo.connectionInfo.clientID == arguments.subscriberInfo.connectionInfo.clientID ||
						privateToData.id == arguments.subscriberInfo.connectionInfo.clientID ;
		}
		return canSend;
	}

	public function afterUnsubscribe( struct subscriberInfo ){
		wsPublish("chat",arguments.subscriberInfo.username & " has left the chat room");
		returnConnectedUsers();
	}

	/**
	 * Publishes array of connected users for UI processing on client
	 */
	private function returnConnectedUsers(){
		var _clients 	= wsGetSubscribers("chat");
		var _client 	= {};
		var clients 	= [];

		// sort the array
		arraySort(_clients,function (e1, e2){
			return compare(e1.subscriberInfo.username, e2.subscriberInfo.username);
		});

		for( _client in _clients ){
			clients.append({
				"id"			: _client.clientid,
				"username" 		: _client.subscriberInfo.username,
				"city" 			: trim( _client.subscriberInfo.clientInfo.city ?: "" ),
				"region" 		: trim( _client.subscriberInfo.clientInfo.region ?: "" )
			});
		}

		wsPublish( "chat",{"type":"clients","data":clients} );
	}
}