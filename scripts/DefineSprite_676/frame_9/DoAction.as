function executeCallback()
{
   trace("executeCallback intervalId: " + intervalId);
   clearInterval(intervalId);
   gotoAndStop("disable");
   play();
}
stop();
currentText = "Currently tweeting under " + _global.twitterName;
var intervalId;
var maxCount = 10;
var duration = 2000;
intervalId = setInterval(this,"executeCallback",duration);
