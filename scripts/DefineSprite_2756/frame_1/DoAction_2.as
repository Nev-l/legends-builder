stop();
_root.createTeamChallengePanel = this;
var hidden = true;
var selTeam;
var selTeamName;
var raceType = 0;
var betType;
var betAmount = 0;
panel.btn.onRelease = function()
{
   if(classes.GlobalData.attr.tr > 0 && classes.GlobalData.attr.tr < 4)
   {
      clearHelp();
      play();
   }
   else
   {
      _root.displayAlert("warning","Not Allowed","You are not allowed to create team challenges.  You must be a leader, co-leader or dealer of a team to create a team challenge.");
   }
};
