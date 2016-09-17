/**
* @extends CFIDE.websocket.ChannelListener
*/
component {

	public boolean function allowSubscribe(struct subscriberInfo) {
		//I am crucial. You must use me. Or else.
		if(!arguments.subscriberInfo.connectionInfo.authenticated) return false;
		//I'm an optional check just to be extra secure
		if(!structKeyExists(arguments.subscriberInfo,"username")) return false;

		// send to all connected clients that this new subscriber has joined
		WsPublish("chat",arguments.subscriberInfo.username & " has joined the chat room, say hello ... ");

		// in a thread send to all clients (including just connected the full connected list)
		thread name="subscribers_#createUUID()#" action="run"{
			returnConnectedUsers();
		}

		return true;
	}

	public boolean function allowPublish(struct publisherInfo) {
		return arguments.publisherInfo.connectionInfo.authenticated;
	}

	public any function beforePublish( any message, struct publisherInfo){

		lock scope="application" timeout="10" type="exclusive"{
			application.publishedMessages++;
		}

		local.messageData = {
			message 		: arguments.message,
			connectioninfo 	: arguments.publisherInfo.connectionInfo
		};

		return local.messageData;
	}

	public any function beforeSendMessage(any message, struct subscriberInfo){
		if (isStruct(arguments.message.message)){
			local.messageText = arguments.message.message;
		}
		else if (arguments.message.message == "FORCE-RECONNECT"){
			local.messageText = arguments.message.message;
		}
		else if (structKeyExists(arguments.message.connectionInfo,"username")){
			local.messageText 	= "<div class='message" &
									(!compare(arguments.subscriberInfo.connectioninfo.clientid,arguments.message.connectioninfo.clientid) ? " me" : "") &
									"'><div class='sender'>" &
									arguments.message.connectionInfo.username &
									"</div>" & "<div class='content'>" &
									arguments.message.message &
									"</div></div>";
		}
		else {
			local.messageText = "<div class='message system'><div class='content'>" & arguments.message.message & '</content></div>';
		}
		return local.messageText;
	}

	public function afterUnsubscribe(struct subscriberInfo){
		WsPublish("chat",arguments.subscriberInfo.username & " has left the chat room");
		returnConnectedUsers();
	}

	private function returnConnectedUsers(){
		local.clients 	= WSgetSubscribers("chat");
		local.str 		= "<ul>";
		// sort the array
		arraySort(local.clients,function (e1, e2){
			return compare(e1.subscriberInfo.username, e2.subscriberInfo.username);
		});

		for(local.client in local.clients){

        	local.city 		= isDefined("local.client.subscriberInfo.clientInfo.city") ? local.client.subscriberInfo.clientInfo.city : "";
			local.region 	= isDefined("local.client.subscriberInfo.clientInfo.region") ? local.client.subscriberInfo.clientInfo.region : "";

			local.region_string 	= "";

			if (len(trim(local.city & local.region)))
				local.region_string =  "<small>" & local.city & "," & local.region & "</small>";

			local.str &= 	"<li data-id='" & local.client.clientid & "'>" &
								local.client.subscriberInfo.username &
								local.region_string &
							"</li>";
		}
		local.str &= "</ul>";
		WsPublish("chat",{type:"clients",data:local.str});
	}

}