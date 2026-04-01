function timeout()
{
   err = "Sorry, the server did not respond. Please try again later.";
   _root.displayAlert("warning","Server Unavailable",err);
}
stop();
tf._visible = false;
scroller.destroy();
sendSI = _global.setTimeout(this,"timeout",30000);
