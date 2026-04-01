classes.Effects.roBump(btnBracket);
classes.Effects.roBump(btnHeadsUp);
btnBracket.onRelease = function()
{
   clearInterval(this.si);
   raceType = 2;
   clearHelp();
   gotoAndStop("bet");
   play();
};
btnHeadsUp.onRelease = function()
{
   clearInterval(this.si);
   raceType = 1;
   clearHelp();
   gotoAndStop("bet");
   play();
};
btnHelp.onRelease = function()
{
   helpBubble.removeMovieClip();
   helpBubble = createEmptyMovieClip("helpBubble",getNextHighestDepth());
   var _loc2_ = new Array();
   _loc2_.push(new Array(611,-23,415,-170,"Bracket: Each match is run as a bracket race, but the winners are determined by total team score.  At the start of the race, every racer will be asked to enter their own dial-in time.\rH2H: Each match is run as a head-to-head race, but the winners are determined by total team score."));
   tutorialObj = new classes.util.Tutorial(helpBubble,_loc2_);
   helpBubble.onRelease = function()
   {
      this.removeMovieClip();
   };
};
nav1.onRelease = function()
{
   clearHelp();
   gotoAndStop("hide");
   play();
};
nav2.onRelease = function()
{
   clearHelp();
   if(!raceType)
   {
      _root.displayAlert("warning","Race Type Not Set","Please select either a Bracket or Head-to-Head format by clicking one of the icons.");
   }
   else
   {
      gotoAndStop("bet");
      play();
   }
};
nav3.enabled = true;
nav3.onRelease = function()
{
   clearHelp();
   gotoAndStop("team");
   play();
};
