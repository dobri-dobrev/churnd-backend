$(function(){
	$("#register-submit-button").click(function(event){
		$(".alert").remove();
		var errFlag = 0;
		event.preventDefault();
		var errorArray = new Array();
		//console.log(errorArray)
		if($("#register-name-field").val().length == 0){
			// prependToContainer(0);
			// return;
			errorArray[0]=5;
			errFlag=1;
		}
		if($("#register-email-field").val().length == 0){
			// prependToContainer(1);
			// return;
			errorArray[1]=5;
			errFlag=1;
		}
		if($("#register-password-field").val().length < 6){
			// prependToContainer(2);
			// return;
			errorArray[2]=5;
			errFlag=1;
		}
		//console.log(errorArray);
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
		  	window.location.replace("/project");
		  },
		  error: function(){
		  	prependToContainer(3);
		  }
		});

		
	});

	function prependToContainer(errorArray){
		// var flash = '<div class="alert alert-error"><button type="button" class="close" data-dismiss="alert">&times;</button><strong>';
		// flash+= text;
		// flash += "</div>";

		// $("#register-container").prepend(flash);
		var errorCss = new Array("rnf-1","rnf-2","ref-1","ref-2","rpf-1","rpf-2");
		for (var i=0;i<errorCss.length;i+=2)
		{
			document.getElementById(errorCss[i]).className = " ";
			document.getElementById(errorCss[i+1]).className = "hide ";
		}



		if (errorArray[0] == 5)
		{
			 document.getElementById('rnf-1').className = 'error';
			 document.getElementById('rnf-2').className = 'error';
		}
		if (errorArray[1] == 5)
		{
			 document.getElementById('ref-1').className = 'error';
			 document.getElementById('ref-2').className = 'error';
		}
		if (errorArray[2] == 5)
		{
			 document.getElementById('rpf-1').className = 'error';
			 document.getElementById('rpf-2').className = 'error';
		}
	}
});