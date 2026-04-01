classes.Control.setMapButton("race");
displayTimes();
timesGroup.rankGroup._visible = false;
switch(qualStatus)
{
   case 0:
      timesGroup.txtStatus = "DID NOT QUALIFY";
      break;
   case -1:
      timesGroup.txtStatus = "DISQUALIFIED";
      break;
   case -2:
      timesGroup.txtStatus = "INVALID RUN";
      break;
   case -3:
      timesGroup.txtStatus = "BREAKOUT";
      break;
   default:
      timesGroup.txtStatus = "ELIMINATED";
}
btnSpectate.onRelease = function()
{
   _root.htSpectate();
   delete btnSpectate.onRelease;
};
