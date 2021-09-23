<cfscript>
	if(!structKeyExists(request,"socketio_server"))
		throw("You must set the full URL to the Socket.IO Console Site to request.socketio_server - review instructions in Application.onRequestStart()");
	if(!structKeyExists(request,"socketio_broadcast"))
		throw("You must set the full URL to the Socket.IO Broadcast Handler to request.socketio_broadcast - review instructions in Application.onRequestStart()");
	links = [
		{
			title 		: "DEMOS",
			description : "",
			nav 		: [
				{link:"/live-demos/demo-00/",title:"Simple"},
				{link:"/live-demos/demo-00/restricted/",title:"Restricted"},
				{link:"/live-demos/demo-01/",title:"Simple Console"},
				{link:"/live-demos/demo-01/advanced/",title:"Advanced Console"},
				{link:"/live-demos/broadcast/",title:"Broadcast",ajax:true},
				{link:"/live-demos/subscribers/",title:"Subscribers",modal:true}
			]
		},
		// {
		// 	title 		: "DEMO 2",
		// 	description : "ADVANCED",
		// 	nav 		: [
		// 		{link:"/live-demos/demo-02/",title:"Simple Console"},
		// 		{link:"/live-demos/demo-02/advanced/",title:"Advanced Console"},
		// 		{link:"/live-demos/demo-02/broadcast/",title:"Broadcast",ajax:true},
		// 		{link:"/live-demos/demo-02/subscribers/",title:"Subscribers",modal:true}
		// 	]
		// },
		{
			title 		: "CHAT",
			description : "",
			nav 		: [
				{link:"/chat/",title:"Chat App"},
				{link:"/chat/broadcast/",title:"Broadcast",ajax:true},
				{link:"/chat/subscribers/",title:"Subscribers",modal:true}
			]
		}
		// {
		// 	title 		: "OTHER",
		// 	description : "",
		// 	nav 		: [
		// 		{link:"/html-to-coldfusion/",title:"HTML to ColdFusion"},
		// 		{link:request.socketio_server,title:"Socket.IO Console"},
		// 		{link:request.socketio_broadcast,title:"Socket.IO Broadcast",ajax:true}
		// 	]
		// }
	];
</cfscript>
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<title>WebSockets 201</title>
	<link rel="icon" href="/favicon.ico">
	<link rel="author" href="/humans.txt" />
	<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css" integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous">
	<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.3.1/css/all.css" integrity="sha384-mzrmE5qonljUremFsqc01SB46JvROS7bZs3IO2EmfFsd15uHvIt+Y8vEf7N7fWAU" crossorigin="anonymous">
	<link rel="stylesheet" href="/live-demos/assets/css/styles.css">
	<style>body { padding:1em 0 100px; }</style>
</head>
<body>
	<div class="container">
		<h1 class="text-center">WebSockets 201</h1>
		<cfoutput>
			<cfloop array="#links#" item="link" index="i">
				<nav class="navbar navbar-light bg-light navbar-expand-md">
					<span class="navbar-brand" href="##">#link.title# <small class="text-info">#link.description#</small></span>
					<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="##demo_controls_#i#" aria-controls="##demo_controls_#i#" aria-expanded="false" aria-label="Toggle navigation">
						<span class="navbar-toggler-icon"></span>
					</button>
					<div class="collapse navbar-collapse" id="demo_controls_#i#">
						<ul class="navbar-nav ml-auto">
							<cfloop array="#link.nav#" item="nav">
								<li class="nav-item"><a href="#nav.link#" class="nav-link" target="blank" data-channel="#link.title#" #(nav.ajax ?: false) ? 'data-ajax="true"' : ''# #(nav.modal ?: false) ? 'data-modal="true"' : ''#>#nav.title#</a></li>
							</cfloop>
						</ul>
					</div>
				</nav>
			</cfloop>
		</cfoutput>
	</div>

	<p id="sig">
		Giancarlo Gomez<br />
		<a href="https://fusedevelopments.com" target="_blank">Fuse Developments</a> &bull;
		<a href="https://crosstrackr.com" target="_blank">CrossTrackr</a>
		<br />
		<a href="https://github.com/GiancarloGomez" target="_blank"><i class="fab fa-github"></i></a> &nbsp;
		<a href="https://twitter.com/GiancarloGomez" target="_blank"><i class="fab fa-twitter"></i></a> &nbsp;
		<a href="https://www.instagram.com/GiancarloGomez" target="_blank"><i class="fab fa-instagram"></i></a> &nbsp;
		<a href="https://www.facebook.com/giancarlo.gomez" target="_blank"><i class="fab fa-facebook"></i></a> &nbsp;
		<a href="https://www.linkedin.com/in/giancarlogomez" target="_blank"><i class="fab fa-linkedin-in"></i></a> &nbsp;
		<a href="https://www.giancarlogomez.com" target="_blank"><i class="fas fa-rss"></i></a> &nbsp;
		<a href="mailto:giancarlo.gomez@gmail.com"><i class="far fa-envelope"></i></a>
	</p>

	<div class="modal fade" tabindex="-1" role="dialog" id="notification">
		<div class="modal-dialog modal-lg" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title"></h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
				</div>
				<div class="modal-body"></div>
			</div>
		</div>
	</div>

	<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
	<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.min.js" integrity="sha384-ChfqqxuZUCnJSK3+MXmPNIyE6ZbWh2IMqE241rYiqJxyMiZ6OW/JmZQ5stwEULTy" crossorigin="anonymous"></script>

	<script>
		$(function(){
			var mdl = $('#notification').modal({show:false,backdrop:'static'});

			// broadcast
			$('a[data-ajax]').on('click',function(){
				var channel = this.dataset.channel;
				fetch(this.href,headers())
					.then( response => response.text() )
					.then( response => prepareNotification(`BROADCAST : ${channel}`,response) );
				return false;
			});

			// show subscribers
			$('a[data-modal]').on('click',function(){
				var channel = this.dataset.channel;
				fetch(this.href,headers())
					.then( response => response.text() )
					.then( response => {
						mdl.modal('show')
							.find('.modal-title').html(`${channel} : SUBSCRIBERS`).end()
							.find('.modal-body').html(response)
					} );
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

			// fetch api headers
			function headers(options) {
				options = options || {}
				options.headers = options.headers || {}
				options.headers['X-Requested-With'] = 'XMLHttpRequest'
				options.method = 'GET'
				return options
			}
		});
	</script>
</body>
</html>