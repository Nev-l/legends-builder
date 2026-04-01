clearHelp();
popSelectRacer._visible = false;
popSelectCar._visible = false;
classes.Drawing.portrait(teamPic1,classes.GlobalData.attr.ti,2,0,0,2,false,"teamavatars");
teamName1 = classes.GlobalData.attr.tn;
classes.Drawing.portrait(teamPic2,selTeam,2,0,0,2,false,"teamavatars");
teamName2 = selTeamName;
var i = 1;
while(i <= 2)
{
   var j = 1;
   while(j <= 4)
   {
      this["btn" + i + "Add" + j].teamIdx = i;
      if(i == 1)
      {
         this["btn" + i + "Add" + j].teamID = Number(classes.GlobalData.attr.ti);
      }
      else
      {
         this["btn" + i + "Add" + j].teamID = selTeam;
      }
      this["btn" + i + "Add" + j].idx = j;
      this["btn" + i + "Add" + j].onRelease = onBtnAddClick;
      this["team" + i + "Slot" + j].teamIdx = i;
      this["team" + i + "Slot" + j].idx = j;
      this["team" + i + "Slot" + j].btnBar.onRelease = function()
      {
         this._parent._parent["btn" + this._parent.teamIdx + "Add" + this._parent.idx].onRelease();
      };
      if(!this["team" + i + "Slot" + j].userID)
      {
         this["team" + i + "Slot" + j]._visible = false;
      }
      j++;
   }
   i++;
}
btnHelp.onRelease = function()
{
   helpBubble.removeMovieClip();
   helpBubble = createEmptyMovieClip("helpBubble",getNextHighestDepth());
   var _loc2_ = new Array();
   _loc2_.push(new Array(611,-23,415,-170,"A team race consists of two to four matches.  A racer may only be in one match per team race."));
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
   checkMatches();
};
nav3.onRelease = function()
{
   clearHelp();
   gotoAndStop("bet");
   play();
};
