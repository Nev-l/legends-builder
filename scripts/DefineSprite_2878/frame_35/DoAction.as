var dialInErrorMsg = "You must specify a dial-in time.  You should set your dial-in time to the number of seconds you think you will run the race, from starting line to finish.  Beating your dial-in time will disqualify you from the race, so make sure you set it low enough.";
fldDialTime.restrict = ".0-9";
nav2.onRelease = function()
{
   if(!Number(dialTime))
   {
      _root.displayAlert("warning","Dial-In time Not Set",dialInErrorMsg);
   }
   else
   {
      viewThumb.clearCarView();
      _root.updateDefaultCar(selCar);
      _parent.rankingAnimEnabled = false;
      _parent.myRacerNum = code;
      _root.ctCreate(code,dialTime,selCar);
      gotoAndStop("hide");
      play();
   }
};
nav3.onRelease = function()
{
   gotoAndStop("code");
   play();
};
