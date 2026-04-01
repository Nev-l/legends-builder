function timeout()
{
   err = "Sorry, the server did not respond. Please try again later.";
   gotoAndStop("error");
   play();
}
stop();
sendSI = _global.setTimeout(this,"timeout",30000);
