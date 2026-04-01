classes.Effects.roBump(btnBetFriendly);
classes.Effects.roBump(btnBetRanked);
classes.Effects.roBump(btnBetPinks);
fldBet.restrict = "0-9";
btnBetFriendly.onRelease = function()
{
   betType = 1;
   betAmount = 0;
   clearHelp();
   gotoAndStop("matches");
   play();
};
btnBetRanked.onRelease = function()
{
   clearHelp();
   if(classes.GlobalData.attr.mb == 1)
   {
      betType = 2;
      if(!betAmount)
      {
         betAmount = 0;
      }
      gotoAndStop("matches");
      play();
   }
   else
   {
      _root.displayAlert("warning","Not a Member","Only members can create a ranked challenge.  You can still accept a ranked challenge, you just can\'t create one.");
   }
};
btnHelp.onRelease = function()
{
   helpBubble.removeMovieClip();
   helpBubble = createEmptyMovieClip("helpBubble",getNextHighestDepth());
   var _loc2_ = new Array();
   _loc2_.push(new Array(611,-23,415,-170,"Friendly Race: A friendly race is just for fun.  No money can be bet, and no street credit (SC) can be won or lost.  Results don\'t count towards your team\'s win/loss record either.\rRanked race: This is where you put your team\'s reputation on the line.  Race for money or just pure glory."));
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
   if(!betType)
   {
      _root.displayAlert("warning","No Bet Set","You must select a bet type.");
   }
   else
   {
      gotoAndStop("matches");
      play();
   }
};
nav3.onRelease = function()
{
   clearHelp();
   gotoAndStop("type");
   play();
};
