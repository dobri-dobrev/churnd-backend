$(function(){

	$("#rule_create_submit_button").click(function(event){


		data = {};

		data['account_id'] = $(this).data('accountid');

		data['name'] = $("#rule_name").val();
		data['action'] = $("#rule_action").val();
		data['from'] = $("#rule_email").val();
		data['metric'] = $("#rule_feature").val();
		data['greater_than'] = $("#rule_option").val();
		data['value'] = $("#rule_value").val();
		data['emails_sent'] = 0;

		var project_id = $(this).data('projectid');
		var account_name = $(this).data('accountname');

		$.ajax({
	      type: 'POST',
	      accepts: "application/json",
		  url: '/add_rule',
		  dataType:'json',
		  data: data,
		  success: function(){
		  	console.log("success")
		  	
		  },
		  error: function(){
		  	console.log("internal server error");
		  	window.location.replace("/expanded_account?" + "project_id=" + project_id + "&account=" + account_name);
		  }
		});

		
	});

	$(".delete_rule_button").click(function(event){
		var project_id = $(this).data('projectid');
		var account_name = $(this).data('accountname');

		data = {};

		data['rule_id'] = $(this).data('ruleid');
		
		$.ajax({
	      type: 'POST',
	      accepts: "application/json",
		  url: '/delete_rule',
		  dataType:'json',
		  data: data,
		  success: function(){
		  	console.log("success")
		  	
		  },
		  error: function(){
		  	console.log("internal server error");
		  	window.location.replace("/expanded_account?" + "project_id=" + project_id + "&account=" + account_name);
		  }
		});


		});

});