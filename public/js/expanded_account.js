$(function(){

	$("#rule_create_submit_button").click(function(event){


		data = {};

		data['account_id'] = $(this).data('accountid');

		data['name'] = $("#rule_name").val();
		data['action'] = $("#rule_action").val();
		data['from'] = $("#rule_email").val();
		data['metric'] = $(this).data('feature');
		data['greater_than'] = 0;
		data['value'] = $("#rule_value").val();

	console.log(data);
		// $.ajax({
	 //      type: 'POST',
	 //      accepts: "application/json",
		//   url: '/new_rule',
		//   dataType:'json',
		//   data: data,
		//   success: function(json){
		//   	console.log("success")
		  	
		//   },
		//   error: function(){
		//   	console.log("internal server error");
		//   }
		// });

		
	});

});