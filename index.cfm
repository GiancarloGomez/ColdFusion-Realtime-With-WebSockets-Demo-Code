<cfscript>
	if( !structKeyExists(request,"socketio_server") )
		throw("You must set the full URL to the Socket.IO Console Site to request.socketio_server - review instructions in Application.onRequestStart()");
	if( !structKeyExists(request,"socketio_broadcast") )
		throw("You must set the full URL to the Socket.IO Broadcast Handler to request.socketio_broadcast - review instructions in Application.onRequestStart()");
	links = [
		{
			title 		: "DEMOS",
			description : "",
			nav 		: [
				{link:"/live-demos/demo-00/",title:"Minimal"},
				{link:"/live-demos/demo-00/restricted/",title:"Restricted"},
				{link:"/live-demos/demo-01/",title:"Simple"},
				{link:"/live-demos/demo-01/advanced/",title:"Advanced"},
				{link:"/live-demos/broadcast/",title:"Broadcast",ajax:true},
				{link:"/live-demos/subscribers/",title:"Subscribers",modal:true},
				{link:"/live-demos/console/",title:"Console"}
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
				{link:"/chat/subscribers/",title:"Subscribers",modal:true},
				{link:"/chat/console/",title:"Console"}
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
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.1/dist/css/bootstrap.min.css" integrity="sha256-sAcc18zvMnaJZrNT4v8J0T4HqzEUiUTlVFgDIywjQek=" crossorigin="anonymous">
	<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.3.1/css/all.css" integrity="sha384-mzrmE5qonljUremFsqc01SB46JvROS7bZs3IO2EmfFsd15uHvIt+Y8vEf7N7fWAU" crossorigin="anonymous">
	<link rel="stylesheet" href="/live-demos/assets/css/styles.css">
	<style>body { padding:1em 0 100px; }</style>
</head>
<body>
	<div class="container-fluid">
		<h1 class="text-center mb-3">
			WebSockets 201
		</h1>
		<cfoutput>
			<cfloop array="#links#" item="link" index="i">
				<div class="bg-light border d-flex flex-column gap-3 flex-md-row justify-content-between align-items-center p-2 shadow-sm my-3">
					<strong class="h4 m-0">#link.title#</strong>
					<div class="d-flex flex-wrap justify-content-center align-items-stretch gap-3 ml-auto align-items-center">
						<cfloop array="#link.nav#" item="nav">
							<a href="#nav.link#" target="_blank" class="btn btn-sm btn-primary text-uppercase" data-channel="#link.title#" #(nav.ajax ?: false) ? 'data-ajax="true"' : ''# #(nav.modal ?: false) ? 'data-modal="true"' : ''#>#nav.title#</a>
						</cfloop>
					</div>
				</div>
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
		<div class="modal-dialog modal-fullscreen" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title">Modal title</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
				  </div>
				<div class="modal-body"></div>
			</div>
		</div>
	</div>

	<script src="https://cdn.jsdelivr.net/npm/jquery@3.6.0/dist/jquery.min.js" integrity="sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4=" crossorigin="anonymous"></script>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.1/dist/js/bootstrap.bundle.min.js" integrity="sha256-5aErhPlUPVujIxg3wvJGdWNAWqZqWCtvxACYX4XfSa0=" crossorigin="anonymous"></script>

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