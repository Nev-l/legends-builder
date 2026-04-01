function cont()
{
   if(detailObj.s == 1)
   {
      gotoAndStop("detailFuture");
      play();
   }
   else if(detailObj.s == 2)
   {
      gotoAndStop("detailOpen");
      play();
   }
}
stop();
loadinDetail.loadMovie("cache/tournaments/edt_" + detailObj.it + ".swf");
var contST = _global.setTimeout(this,"cont",1500);
btnEntryReq.onRelease = function()
{
   _root.displayAlert("helmet","Entry Requirements",detailObj.entryReq);
};
btnEntryReq._visible = false;
