


function Churnd(project_id) {
  this.project_id = project_id;
}

Churnd.prototype.project_id = '';

Churnd.prototype.login = function (email_id, account_name) {

var sendData = JSON.stringify(
	{
		key: this.project_id, 
		email: email_id,
		account: account_name
	};

 $.ajax({
        type: "POST",
        url: "http://vast-savannah-8474.herokuapp.com/api/login",
        data: sendData,
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function(data){alert(data);},
        failure: function(errMsg) {
            alert(errMsg);
        }
  });
  
};
