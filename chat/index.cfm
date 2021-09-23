<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<link rel="icon" href="/favicon.png">
	<title>WebSocket Chat</title>
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" integrity="sha256-djO3wMl9GeaC/u6K+ic4Uj/LKhRUSlUFcsruzS7v5ms=" crossorigin="anonymous">
	<link rel="stylesheet" href="./assets/chat.css">
</head>
<body 	data-channels="chat"
		data-debug="false"
		data-auto-connect="false"
		data-online-timer="10"
		data-ping-url="./ping/"
		data-do-message="receiveMessage"
		class="d-flex flex-column off">

	<!-- TOP BAR -->
	<nav class="navbar navbar-light bg-light">
		<div class="container-fluid">
			<div>
				<span class="navbar-brand">Chat App</span>
			</div>
			<div>
				<a href="#" id="clear-messages" class="btn btn-sm btn-secondary">Clear Messages</a></li>
				<a href="#" id="leave-room" class="btn btn-sm btn-danger">Leave Room</a></li>
			</div>
		</div>
	</nav>

	<!-- CHAT USERS AND MESSAGES -->
	<main class="d-flex">
		<!-- USERS LIST -->
		<div id="users" class="bg-light"></div>
		<!-- MESSAGES -->
		<div id="messages" class="flex-grow-1"></div>
	</main>

	<!-- MESSAGE FORM -->
	<div id="chat-message-form" class="bg-light">
		<form id="messageFrm">
			<div class="mb-2">
				<div class="input-group">
					<span class="input-group-text">To:</span>
					<select id="message-to" class="form-select"></select>
				</div>
			</div>
			<div class="input-group">
				<input type="text" class="form-control" id="message">
				<button class="btn btn-success" type="submit" id="send-message">Send</button>
			</div>
		</form>
	</div>

	<!--  STATUS NOTIFICATIONS -->
	<div id="status-message">
		We are good
	</div>

	<!-- LOGIN MODAL -->
	<div class="modal fade" id="login">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title text-center">Chat Login</h4>
				</div>
				<div class="modal-body">
					<form id="loginFrm">
						<div class="input-group has-validation">
							<input type="username" class="form-control" id="username" placeholder="Please enter your name">
							<button type="submit" class="btn btn-primary">Login</button>
							<div class="invalid-feedback"></div>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>


	<script src="https://cdn.jsdelivr.net/npm/jquery@3.6.0/dist/jquery.min.js" integrity="sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4=" crossorigin="anonymous"></script>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.min.js" integrity="sha256-XDbijJp72GS2c+Ij234ZNJIyJ1Nv+9+HH1i28JuayMk=" crossorigin="anonymous"></script>
	<script src="https://cdn.jsdelivr.net/npm/advancedsocket@latest/dist/advancedsocket.min.js" integrity="sha256-BL/dJfKkEsGPihoT3izThE3BhTgQg4SER+mq7HwAiKE=" crossorigin="anonymous"></script>
	<script src="./assets/chat.js"></script>

	<cfwebsocket 	name		= "ws"
					onMessage	= "AdvancedSocket.onMessage"
					onOpen		= "AdvancedSocket.onOpen"
					onClose		= "AdvancedSocket.onClose"
					onError		= "AdvancedSocket.onError">
</body>
</html>