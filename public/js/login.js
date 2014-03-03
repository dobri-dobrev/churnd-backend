$(function(){
	$("#login-submit-button").click(function(event){
		$(".alert").remove();
		event.preventDefault();
		if($("#login-name-field").val().length == 0){
			prependToContainer("Please add a company name");
			return;
		}
		if($("#login-password-field").val().length < 6){
			prependToContainer("Please add a valid password");
			return;
		}
		data = {};
		data['name'] = $("#login-name-field").val();
		data['password'] = $("#login-password-field").val();
		console.dir(data);
		$.ajax({
	      type: 'POST',
	      accepts: "application/json",
		  url: 'http://localhost:9292/login',
		  dataType:'json',
		  data: data,
		  success: function(json){
		  	window.location.replace("/projects");
		  },
		  error: function(){
		  	prependToContainer("Username and password combination not found");
		  }
		});

		
	});

	function prependToContainer(text){
		var flash = '<div class="alert alert-error"><button type="button" class="close" data-dismiss="alert">&times;</button><strong>';
		flash+= text;
		flash += "</div>";

		$("#login-container").prepend(flash);
	}
});