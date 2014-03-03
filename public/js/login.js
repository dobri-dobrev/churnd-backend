$(function(){
	$("#login-submit-button").click(function(event){
		$(".alert").remove();

		var errFlag = 0;
		event.preventDefault();
		var errorArray = new Array();

		if($("#login-name-field").val().length == 0){
			// prependToContainer("Please add a company name");
			// return;
			errorArray[0]=5;
			errFlag=1;
		}
		if($("#login-password-field").val().length < 6){
			// prependToContainer("Please add a valid password");
			// return;
			errorArray[1]=5;
			errFlag=1;
		}

		if (errFlag)
		{
			prependToContainer(errorArray);
		for(var i=0;i<errorArray.length;i++)
			{
				errorArray[i] = 0;
			}			

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

	function prependToContainer(errorArray){
		// var flash = '<div class="alert alert-error"><button type="button" class="close" data-dismiss="alert">&times;</button><strong>';
		// flash+= text;
		// flash += "</div>";

		// $("#login-container").prepend(flash);

		var errorCss = new Array("lnf-1","lnf-2","lpf-1","lpf-2");
		for (var i=0;i<errorCss.length;i+=2)
		{
			document.getElementById(errorCss[i]).className = " ";
			document.getElementById(errorCss[i+1]).className = "hide ";
		}



		if (errorArray[0] == 5)
		{
			 document.getElementById('lnf-1').className = 'error';
			 document.getElementById('lnf-2').className = 'error';
		}
		if (errorArray[1] == 5)
		{
			 document.getElementById('lpf-1').className = 'error';
			 document.getElementById('lpf-2').className = 'error';
		}


	}
});