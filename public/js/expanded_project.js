$(function(){
	$("#account_create_submit_button").click(function(event){
		event.preventDefault();
		if($("#account_create_name_field").val().length == 0){
			console.log("empty name field");
			return;
		}
		data = {};
		data['account_name'] = $("#account_create_name_field").val();
		data['project_id'] = $(this).data('projectid');
	
		$.ajax({
	      type: 'POST',
	      accepts: "application/json",
		  url: '/new_account',
		  dataType:'json',
		  data: data,
		  success: function(json){
		  	if(json.res == "exists"){
		  		console.log("account already exists");
		  		window.location.replace("/expanded_project?" + "project_id=" + data['project_id']);
		  	}
		  	else{
		  		console.log("greaaaat success");
		  		window.location.replace("/expanded_project?" + "project_id=" + data['project_id']);
		  	}
		  	
		  },
		  error: function(){
		  	console.log("internal server error");
		  }
		});

		
	});
	

	$("#project-refresh-button").click(function(event){
		data = {};
		data['project_id'] = $(this).data('id');
		$.ajax({
	      type: 'POST',
	      accepts: "application/json",
		  url: '/refresh_project_data',
		  
		  data: data,
		  success: function(){
		  	window.location.replace("/expanded_project?" + "project_id=" + data['project_id']);
		  },
		  error: function(){
		  	console.log("internal server error");
		  }
		});
	});

	$(".delete-account-button").click(function(event){
		data = {};
		data['project_id'] = $(this).data('id');
		data['account_name'] = $(this).data('accname');
		$.ajax({
	      type: 'POST',
	      accepts: "application/json",
		  url: '/delete_account',
		  dataType:'json',
		  data: data,
		  success: function(json){
		  	window.location.replace("/expanded_project?" + "project_id=" + data['project_id']);
		  },
		  error: function(){
		  	console.log("internal server error");
		  	window.location.replace("/expanded_project?" + "project_id=" + data['project_id']);
		  }
		});

		
	});

	$("#interaction_create_submit_button").click(function(event){
		event.preventDefault();
		if($("#interaction_create_name_field").val().length == 0){
			console.log("empty name field");
			return;
		}
		data = {};
		data['interaction_name'] = $("#interaction_create_name_field").val();
		data['project_id'] = $(this).data('projectid');
		$.ajax({
	      type: 'POST',
	      accepts: "application/json",
		  url: '/new_interaction',
		  dataType:'json',
		  data: data,
		  success: function(json){
		  	if(json.res == "exists"){
		  		console.log("account already exists");
		  		window.location.replace("/expanded_project?" + "project_id=" + data['project_id']);
		  	}
		  	else{
		  		console.log("greaaaat success");
		  		window.location.replace("/expanded_project?" + "project_id=" + data['project_id']);
		  	}
		  	
		  },
		  error: function(){
		  	console.log("internal server error");
		  }
		});

		
	});

	$(".delete-interaction-button").click(function(event){
		data = {};
		data['project_id'] = $(this).data('id');
		data['interaction_name'] = $(this).data('intrname');
		$.ajax({
	      type: 'POST',
	      accepts: "application/json",
		  url: '/delete_interaction',
		  dataType:'json',
		  data: data,
		  success: function(json){
		  	window.location.replace("/expanded_project?" + "project_id=" + data['project_id']);
		  },
		  error: function(){
		  	console.log("internal server error");
		  	window.location.replace("/expanded_project?" + "project_id=" + data['project_id']);
		  }
		});

		
	});
});