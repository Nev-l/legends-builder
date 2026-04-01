stop();
var CB_decline = function(s)
{
   if(s == 1)
   {
      classes.SectionTeamHQ._MC.goPage(3);
   }
   else
   {
      _root.displayAlert("warning","Application Decline Failed","Sorry, for some reason your attempt to decline this application failed. Please try again later.");
   }
   delete _global.teamUpdateID;
};
btnAccept.onRelease = function()
{
   _root.teamUpdateApp(uID,1);
   nextFrame();
};
btnDecline.onRelease = function()
{
   classes.Lookup.addCallback("teamUpdateApp",this,CB_decline,"");
   _root.teamUpdateApp(uID,0);
   this._parent.removeMovieClip();
};
