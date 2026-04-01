var dialInErrorMsg = "You must specify a dial-in time.  You should set your dial-in time to the number of seconds you think you will run the race, from starting line to finish.  The difference between your and your opponent\'s dial-in times sets the handicap for this race.  Beating your dial-in time will disqualify you from the race, so make sure you set it low enough.";
fldDialTime.restrict = ".0-9";
nav2.onRelease = function()
{
   if(!Number(dialTime))
   {
      _root.displayAlert("warning","Dial-In time Not Set",dialInErrorMsg);
   }
   else
   {
      _root.chatKOTHJoin(selCar,dialTime);
      gotoAndStop("hide");
      play();
   }
};
nav3.onRelease = function()
{
   gotoAndStop("car");
   play();
};
panel.togLineUp.helpBubble.removeMovieClip();
