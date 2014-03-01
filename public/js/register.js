$(function(){
	$("#register-submit-button").click(function(event){
		$(".alert").remove();
		event.preventDefault();
		if($("#register-name-field").val().length == 0){
			prependToContainer("Please add a company name");
			return;
		}
		if($("#register-email-field").val().length == 0){
			prependToContainer("Please add a valid email");
			return;
		}
		if($("#register-password-field").val().length < 6){
			prependToContainer("Please add a valid password");
			return;
		}
		data = {};
		data['name'] = $("#register-name-field").val();
		data['email'] = $("#register-email-field").val();
		data['password'] = $("#register-password-field").val();
		console.dir(data);
		$.ajax({
	      type: 'POST',
	      accepts: "application/json",
		  url: 'http://localhost:9292/register',
		  dataType:'json',
		  data: data,
		  success: function(json){
		  	console.dir(json);
		  	window.location.replace("/blah");
		  },
		  error: function(){
		  	prependToContainer("Internal Server Error");
		  }
		});

		
	});

	function prependToContainer(text){
		var flash = '<div class="alert alert-error"><button type="button" class="close" data-dismiss="alert">&times;</button><strong>';
		flash+= text;
		flash += "</div>";

		$("#register-container").prepend(flash);
	}
});