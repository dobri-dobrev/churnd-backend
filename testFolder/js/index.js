

var tracker = new Churnd('5338a5896abe8419b4000002');
tracker.login("email@e.com","dropbox"); 


var tB = document.getElementById('trackButton');

tB.addEventListener('click', function(event) {
  console.log(tB.id);
 tracker.track("email@e.com",tB.id, "dropbox")

});

var lG = document.getElementById('logoutButton');

lG.addEventListener('click', function(event) {
  console.log(lG.id);
 tracker.logout("email@e.com","dropbox")

});