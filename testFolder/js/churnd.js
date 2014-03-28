


function Churnd(project_id) {
  this.project_id = project_id;
}

Churnd.prototype.project_id = '';

Churnd.prototype.initialize = function () {
var url = "http://localhost:8080/frontend.html";
	var xmlhttp = new XMLHttpRequest();   // new HttpRequest instance 
xmlhttp.open("POST", url);
xmlhttp.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
xmlhttp.send(JSON.stringify({name:"John Rambo", time:"2pm"}));
  
};
