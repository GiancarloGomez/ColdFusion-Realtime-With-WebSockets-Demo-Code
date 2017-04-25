<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<title>Realtime w/ WebsSockets</title>
	<link rel="icon" href="./favicon.ico">
	<link rel="author" href="./humans.txt" />
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css">
	<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Lato:300,400,700">
	<link rel="stylesheet" href="./assets/css/styles.css">
	<style>body { padding:0; }</style>
</head>
<body data-debug="false">

	<div class="container-fluid">
		<div class="page-header">
			<h1>Realtime with WebSockets - Demo Code</h1>
		</div>
		<cfoutput>
			<cfloop from="1" to="3" index="i">
				<div class="navbar navbar-default">
					<div class="container-fluid">
						<div class="navbar-header">
							<span class="navbar-brand">DEMO 0#i#</span>
						</div>
						<ul class="nav navbar-nav navbar-left">
							<li><a href="/live-demos/demo-0#i#/subscribers.cfm" data-modal="true" data-channel="DEMO 0#i#">SUBSCRIBERS</a></li>
							<li><a href="/live-demos/demo-0#i#/broadcast.cfm" data-ajax="true" data-channel="DEMO 0#i#">BROADCAST</a></li>
							<li><a href="/live-demos/demo-0#i#/" target="blank">CONSOLE</a></li>
							<cfif !compare(i,3)>
								<li><a href="/live-demos/demo-0#i#/advanced.cfm" target="blank">ADVANCED CONSOLE</a></li>
							</cfif>
						</ul>
					</div>
				</div>
			</cfloop>
			<div class="navbar navbar-default">
				<div class="container-fluid">
					<div class="navbar-header">
						<span class="navbar-brand">CHAT</span>
					</div>
					<ul class="nav navbar-nav navbar-left">
						<li><a href="/chat/subscribers.cfm" data-modal="true" data-channel="DEMO 0#i#">SUBSCRIBERS</a></li>
						<li><a href="/chat/broadcast.cfm" data-ajax="true" data-channel="DEMO 0#i#">BROADCAST</a></li>
						<li><a href="/chat/" target="blank">CHAT</a></li>
					</ul>
				</div>
			</div>
			<div class="navbar navbar-default">
				<div class="container-fluid">
					<div class="navbar-header">
						<span class="navbar-brand">OTHER</span>
					</div>
					<ul class="nav navbar-nav navbar-left">
						<!--- <li><a href="/chat/subscribers.cfm" data-modal="true" data-channel="DEMO 0#i#">SUBSCRIBERS</a></li> --->
						<!--- <li><a href="/chat/broadcast.cfm" data-ajax="true" data-channel="DEMO 0#i#">BROADCAST</a></li> --->
						<li><a href="/html-to-coldfusion/" target="blank">HTML TO COLDFUSION</a></li>
						<li><a href="http://socketio.local.com" target="blank">SOCKET IO CONSOLE</a></li>
						<li><a href="http://socketio.local.com/broadcast.cfm" data-ajax="true" data-channel="SOCKET IO">SOCKET IO BROADCAST</a></li>
					</ul>
				</div>
			</div>
		</cfoutput>
	</div>

	<div class="modal fade" tabindex="-1" role="dialog" id="notification">
		<div class="modal-dialog modal-lg" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
					<h4 class="modal-title"></h4>
				</div>
				<div class="modal-body"></div>
			</div>
		</div>
	</div>

	<!-- Third Party -->
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>

	<script>
		$(function(){
			var mdl = $('#notification').modal({show:false,backdrop:'static'});

			// broadcast
			$('a[data-ajax]').on('click',function(){
				var channel = this.dataset.channel;
				$.ajax(this.href)
				.done(function(response){
					prepareNotification(`BROADCAST : ${channel}`,response);
				});
				return false;
			});

			// show subscribers
			$('a[data-modal]').on('click',function(){
				var channel = this.dataset.channel;
				$.ajax(this.href)
				.done(function(response){
					mdl.modal('show')
						.find('.modal-title').html(`${channel} : SUBSCRIBERS`).end()
						.find('.modal-body').html(response)
				});
				return false;
			});

			// prepare notification
			function prepareNotification(title,body){
				if (!('Notification' in window)){
					alert ('Message Sent');
				}
				else if (Notification.permission === 'granted'){
					sendNotification(title,body);
				}
				else if (Notification.permission !== 'denied'){
					Notification.requestPermission(function(permission){
						if (permission === 'granted')
							sendNotification(title,body);
					});
				}
			}

			// send notification
			function sendNotification(title,body){
				var notification = new Notification(title,{
					body : body,
					icon : 'favicon.ico'
				});
				// close out notification automatically
				setTimeout(notification.close.bind(notification),5000);
			}
		});
	</script>
</body>
</html>