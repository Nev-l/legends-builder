function loadPlate(pid, seq)
{
   if(pid <= 7 || pid >= 11)
   {
      classes.Drawing.plateView(plate,pid,seq,45,true);
   }
   else
   {
      classes.Drawing.plateView(plate,pid,seq,30,true);
   }
}
function checkDone()
{
   if(_parent.mp == 0)
   {
      payType = "m";
      gotoAndStop("confirm");
      play();
   }
   else if(_parent.pp == 0)
   {
      payType = "p";
      gotoAndStop("confirm");
      play();
   }
   else
   {
      gotoAndStop("payType");
      play();
   }
}
