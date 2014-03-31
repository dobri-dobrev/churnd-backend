$(function(){
	$("#account_create_submit_button").click(function(event){
		event.preventDefault();
		if($("#account_create_name_field").val().length == 0){
			console.log("empty name field");
			return;
		}
		data = {};
		data['account_name'] = $("#account_create_name_field").val();
		data['project_id'] = $this.data('projectid');
	//	data['url'] = $("#project_create_url_field").val();
		$.ajax({
	      type: 'POST',
	      accepts: "application/json",
		  url: '/new_account',
		  dataType:'json',
		  data: data,
		  success: function(json){
		  	if(json.res == "exists"){
		  		console.log("account already exists");
		  		window.location.replace("/expanded_project?" + "project_id=" + $this.data('projectid'));
		  	}
		  	else{
		  		console.log("greaaaat success");
		  		window.location.replace("/expanded_project?" + "project_id=" + $this.data('projectid'));
		  	}
		  	
		  },
		  error: function(){
		  	console.log("internal server error");
		  }
		});

		
	});
});