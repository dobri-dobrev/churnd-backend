


function Churnd(project_id) {
  this.project_id = project_id;
}

Churnd.prototype.project_id = '';

Churnd.prototype.login = function (email_id, account_name) {

    var sendData = 
        {
            key: this.project_id, 
            email: email_id,
            account: account_name
        };
    var xhr = new XMLHttpRequest();   // new HttpRequest instance 
    xhr.open("POST", "http://localhost:9292/api/login");
    xhr.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
    xhr.send(JSON.stringify(sendData));


    xhr.onreadystatechange=function(){
       if (xhr.readyState==4 && xhr.status==200){
          console.log('xhr.readyState=',xhr.readyState);
          console.log('xhr.status=',xhr.status);
          console.log('response=',xhr.responseText);

          // var data = $.parseJSON(xhr.responseText);
          // var uploadResult = data['message']
          // console.log('uploadResult=',uploadResult);

          // if (uploadResult=='failure'){
          //    console.log('failed to upload file');
          //    displayError('failed to upload');
          // }else if (uploadResult=='success'){
          //    console.log('successfully uploaded file');
          // }
       }
       else
       {
        console.log(xhr.statusText);
       }
    }
  
};


Churnd.prototype.track = function (email_id, interaction_type, account_name) {

    var sendData = 
        {
            key: this.project_id, 
            email: email_id,
            type: interaction_type,
            account: account_name
        };
    var xmlhttp = new XMLHttpRequest();   // new HttpRequest instance 
    xmlhttp.open("POST", "http://localhost:9292/api/track");
    xmlhttp.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
    xmlhttp.send(JSON.stringify(sendData));
  
};

Churnd.prototype.logout = function(email_id, account_name) {


    var sendData = 
        {
            key: this.project_id, 
            email: email_id,
            account: account_name
        };
    var xmlhttp = new XMLHttpRequest();   // new HttpRequest instance 
    xmlhttp.open("POST", "http://localhost:9292/api/logout");
    xmlhttp.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
    xmlhttp.send(JSON.stringify(sendData));


};