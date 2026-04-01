stop();
btn.onRelease = function()
{
   if(Number(classes.GlobalData.attr.ti))
   {
      classes.Control.dialogAlert("Can Not Join Team","You can not join another team while you are already on a team. You may quit your current team by going to the Team HQ.");
   }
   else
   {
      _root.teamAccept(tID);
      this.enabled = false;
   }
};
