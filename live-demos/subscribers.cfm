<cfscript>
	topLevelChannels = wsGetAllChannels();

	for (channel in topLevelChannels){

		subChannels = wsGetAllChannels(channel);

		if (subChannels.len()){
			for (subChannel in subChannels)
				writeDump(label:subChannel,var:wsGetSubscribers(subChannel))
		} else {
			writeDump(label:channel,var:wsGetSubscribers(channel));
		}
	}
</cfscript>