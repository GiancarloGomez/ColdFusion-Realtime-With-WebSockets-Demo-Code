component extends="CFIDE.websocket.ChannelListener" {

	public boolean function allowSubscribe(struct subscriberInfo) {
		// I am crucial. You must use me. Or else.
		if( !arguments.subscriberInfo.connectionInfo.authenticated ) return false;

		return true;
	}

}