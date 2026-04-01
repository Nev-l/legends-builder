stop();
loadin.removeMovieClip();
btnCancel.btnLabel.text = "Done";
trace("username in accountcontent create: " + username);
btnCancel.onRelease = function()
{
   if(_parent.facebookCreate == true)
   {
      classes.Frame._MC.updateFBLoginGroupUsernamePasswordAndLogin(_parent.contentMC.username,_parent.contentMC.password);
   }
   else
   {
      classes.Frame._MC.updateLoginGroupUsernamePasswordAndLogin(_parent.contentMC.username,_parent.contentMC.password);
   }
   _parent.closeMe();
};
