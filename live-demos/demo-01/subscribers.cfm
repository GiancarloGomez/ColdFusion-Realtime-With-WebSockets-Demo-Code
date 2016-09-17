<cfscript>
	topLevelChannels = WSGetAllChannels();

	for (channel in topLevelChannels){

		subChannels = WSGetAllChannels(channel);

		if (subChannels.len()){
			for (subChannel in subChannels)
				writeDump(label:subChannel,var:WSGetSubscribers(subChannel))
		} else {
			writeDump(label:channel,var:WSGetSubscribers(channel));
		}
	}
</cfscript>