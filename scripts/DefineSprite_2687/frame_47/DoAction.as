clearHelp();
classes.Effects.roBump(btnBracket);
classes.Effects.roBump(btnHeadsUp);
var dialInErrorMsg = "You must specify a dial-in time when choosing a bracket race.  You should set your dial-in time to the number of seconds you think you will run the race, from starting line to finish.  The difference between your and your opponent\'s dial-in times sets the handicap for this race.  Beating your dial-in time will disqualify you from the race, so make sure you set it low enough.";
fldDialTime.restrict = ".0-9";
btnBracket.onRelease = function()
{
   clearInterval(this.si);
   if(Number(dialTime))
   {
      raceType = 1;
      gotoAndStop("bet");
      play();
   }
   else
   {
      _root.displayAlert("warning","Dial-In time Not Set",dialInErrorMsg);
   }
};
btnHeadsUp.onRelease = function()
{
   clearInterval(this.si);
   raceType = 2;
   dialTime = "";
   gotoAndStop("bet");
   play();
};
nav2.onRelease = function()
{
   if(raceType == 1 && !Number(dialTime))
   {
      _root.displayAlert("warning","Dial-In time Not Set",dialInErrorMsg);
   }
   else if(!raceType)
   {
      _root.displayAlert("warning","Race Type Not Set","Please select either a Bracket race or Heads Up race.  If you select Bracket you must also enter a dial-in time.");
   }
   else
   {
      gotoAndStop("bet");
      play();
   }
};
nav3.onRelease = function()
{
   gotoAndStop("car");
   play();
};
