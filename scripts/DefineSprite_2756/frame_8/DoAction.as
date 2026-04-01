nav1.onRelease = function()
{
   clearHelp();
   gotoAndStop("hide");
   play();
};
nav2.onRelease = function()
{
   clearHelp();
   if(selTeam)
   {
      gotoAndStop("type");
      play();
   }
   else
   {
      _root.displayAlert("warning","No Team Selected","You must select a team to challenge.");
   }
};
nav3.enabled = false;
btnHelp.onRelease = function()
{
   clearHelp();
   helpBubble = createEmptyMovieClip("helpBubble",getNextHighestDepth());
   var _loc2_ = new Array();
   _loc2_.push(new Array(611,-23,415,-170,"Racers are paired up in matches that are run one at a time.  Each team\'s runs are combined into a total team score.  The winner of each match is not important.  However for each match a breakout, foul, invalid, or DNS will take a penalty score of +" + classes.GlobalData.teamRivalPenalty + " for bracket, +" + classes.GlobalData.teamRivalBracketPenalty + " for H2H."));
   tutorialObj = new classes.util.Tutorial(helpBubble,_loc2_);
   helpBubble.onRelease = function()
   {
      this.removeMovieClip();
   };
};
txtMaxBet = "Your Max Bet: $" + classes.NumFuncs.commaFormat(Number(teamListXML.firstChild.attributes.mb));
drawTeamList();
