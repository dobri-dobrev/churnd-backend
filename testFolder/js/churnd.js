


function Churnd(project_id) {
  this.project_id = project_id;
}

Churnd.prototype.project_id = '';

Churnd.prototype.login = function (email_id, account_name) {

var sendData = 
	{
		key: this.project_id, 
		email: "blah",
		account: account_name
	};
var xmlhttp = new XMLHttpRequest();   // new HttpRequest instance 
xmlhttp.open("POST", "http://localhost:9292/api/login");
xmlhttp.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
xmlhttp.send(JSON.stringify(sendData));
 // $.ajax({
 //        type: "POST",
 //        url: "http://localhost:9292/api/login",
 //        data: sendData,
 //        accepts: "application/json",
 //        dataType: "json",
 //        success: function(data){alert(data);},
 //        failure: function(errMsg) {
 //            alert(errMsg);
 //        }
 //  });
  
};
