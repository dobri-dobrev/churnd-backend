

var tracker = new Churnd('5314182e2a0b6479c7000002');
tracker.login("email@e.com","account"); 


var tB = document.getElementById('testButton');

tB.addEventListener('click', function(event) {
  console.log(tB.id);
 tracker.track("email@e.com",tB.id)

});