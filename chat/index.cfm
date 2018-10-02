<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<link rel="icon" href="/favicon.png">
	<title>WebSocket Chat</title>
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css">
	<link rel="stylesheet" href="../assets/css/chat.css">
</head>
<body 	data-channels="chat"
		data-debug="false"
		data-auto-connect="false"
		data-online-timer="10"
		data-ping-url="ping.cfm"
		data-do-message="receiveMessage"
		class="off">

	<!-- TOP BAR : ACTIONS -->
	<nav class="navbar navbar-default navbar-fixed-top" role="navigation">
		<div class="container-fluid">
			<div class="navbar-header">
				<span class="navbar-brand">Chat App</span>
			</div>
			<ul class="nav navbar-nav pull-right">
				<li><a href="#" id="clearlog">Clear Messages</a></li>
				<li><a href="#" id="leave-room" class="hide">Leave Room</a></li>
			</ul>
		</div>
	</nav>

	<!-- BOTTOM BAR : STATUS NOTIFICATIONS -->
	<div class="navbar navbar-default navbar-fixed-bottom">
		<div id="status-message" class="hide"></div>
	</div>

	<!-- MESSAGE FORM -->
	<div class="navbar navbar-default navbar-fixed-bottom" id="chat-message-form">
		<form id="messageFrm">
		<div class="input-group">
			<input type="text" class="form-control" id="message">
			<span class="input-group-btn">
				<button class="btn btn-success" type="submit" id="send-message">Send</button>
			</span>
		</div>
		</form>
	</div>

	<!-- USERS LIST -->
	<div id="users"></div>

	<!-- MESSAGES -->
	<ul id="console" class="list-unstyled"></ul>

	<!-- LOGIN MODAL -->
	<div class="modal fade" id="login">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h4 class="modal-title">Chat Login</h4>
				</div>
				<div class="modal-body">
					<form id="loginFrm">
					<div class="form-group">
						<label class="control-label" for="username">Name</label>
						<input type="username" class="form-control" id="username" placeholder="Enter your name">
						<span class="help-block"></span>
					</div>
					<div class="form-group" style="margin:0;">
						<button type="submit" class="btn btn-primary">Login</button>
					</div>
					</form>
				</div>
			</div>
		</div>
	</div>

	<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"></script>
	<script src="../assets/js/advancedsocket.js"></script>
	<script src="../assets/js/chat.js"></script>

	<cfwebsocket 	name		= "ws"
					onMessage	= "AdvancedSocket.onMessage"
					onOpen		= "AdvancedSocket.onOpen"
					onClose		= "AdvancedSocket.onClose"
					onError		= "AdvancedSocket.onError">
</body>
</html>