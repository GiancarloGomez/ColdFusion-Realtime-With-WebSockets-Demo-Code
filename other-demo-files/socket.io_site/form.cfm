<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>Document</title>
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.1/dist/css/bootstrap.min.css" integrity="sha256-sAcc18zvMnaJZrNT4v8J0T4HqzEUiUTlVFgDIywjQek=" crossorigin="anonymous">
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/jgrowl@1.4.8/jquery.jgrowl.min.css" integrity="sha256-9N1dW2IwrV/Jdb3syY1qcLi9+GunuluB7smY+JCn/qw=" crossorigin="anonymous">
	<script src="https://kit.fontawesome.com/ca6379086e.js" crossorigin="anonymous"></script>
	<style>
		textarea { resize:none; }
		.jGrowl-notification { background-color: rgba(38,175,42,.8); }
	</style>
</head>
<body class="p-3">
	<h1 class="mt-0">Message Post Form</h1>
	<form action="/broadcast/" id="msg" name="msg" class="bg-light p-3" novalidate>
		<div class="mb-3">
			<input type="text" name="channel" class="form-control" placeholder="channel" list="channels" required>
		</div>
		<div class="mb-3">
			<textarea name="message" class="form-control" placeholder="message" required></textarea>
		</div>
		<div class="mb-3">
			<div class="form-check">
				<input class="form-check-input" type="checkbox" value="1" name="json" id="json">
				<label class="form-check-label" for="json">
					Post as JSON
				</label>
			</div>
		</div>
		<div>
			<div class="frmPrc d-grid d-none">
				<button type="button" class="btn btn-primary" disabled><i class="fas fa-spinner fa-spin"></i> PROCESSING</button>
			</div>
			<div class="frmBtn d-grid">
				<button type="submit" class="btn btn-primary">SUBMIT</button>
			</div>
		</div>
		<datalist id="channels">
			<option value="Global">
			<option value="Demo">
		  </datalist>
	</form>
	<script src="https://cdn.jsdelivr.net/npm/jquery@3.6.0/dist/jquery.min.js" integrity="sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4=" crossorigin="anonymous"></script>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.1/dist/js/bootstrap.min.js" integrity="sha256-/hGxZHGQ57fXLp+NDusFZsZo/PG21Bp2+hXYV5a6w+g=" crossorigin="anonymous"></script>
	<script src="https://cdn.jsdelivr.net/npm/jgrowl@1.4.8/jquery.jgrowl.min.js" integrity="sha256-vgPeFVwXhNNTLCZgVCDmocommCrOR7ACXowIWOJU/Jk=" crossorigin="anonymous"></script>
	<script src="https://cdn.jsdelivr.net/npm/javascript.validation@1.5.4/dist/validation.min.js" integrity="sha256-DABvIvlKs/kb1+GpcYmV7iIFhHiCwJf/I/reCc6pshE=" crossorigin="anonymous"></script>
	<script>
		const 	msg = $('#msg'),
				BootstrapVersion = 5;

		msg.submit( event => {
			event.preventDefault();
			const validation = validateForm( event.target );

			if ( validation.err.length ){
				openDialog( validation );
			}
			else {
				formButtons( true, event.target );
				$.ajax(msg.attr('action'),{
					method : 'POST',
					data: msg.serialize()
				})
				.done( response => {
					$.jGrowl('Message Sent');
				})
				.always( () => {
					event.target.message.value = '';
					formButtons( false, event.target );
				});
			}
		});

		document.msg.message.addEventListener('keydown', event => {
			if ( event.metaKey && event.key === "Enter" )
				msg.submit();
		});
	</script>
</body>
</html>