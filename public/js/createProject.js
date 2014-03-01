$(function(){
	$("#project_create_submit_button").click(function(event){
		event.preventDefault();
		if($("#project_create_name_field").val().length == 0){
			console.log("empty name field");
			return;
		}
		if($("#project_create_url_field").val().length == 0){
			console.log("empty url field");
			return;
		}
		data = {};
		data['project_name'] = $("#project_create_name_field").val();
		data['url'] = $("#project_create_url_field").val();
		$.ajax({
	      type: 'POST',
	      accepts: "application/json",
		  url: 'http://localhost:9292/new_project',
		  dataType:'json',
		  data: data,
		  success: function(json){
		  	if(json.res == "exists"){
		  		console.log("project already exists");
		  	}
		  	else{
		  		console.log("greaaaat success");
		  		$('#firstModal').foundation('reveal', 'close');	
		  	}
		  	
		  },
		  error: function(){
		  	console.log("internal server error");
		  }
		});

		
	});
});