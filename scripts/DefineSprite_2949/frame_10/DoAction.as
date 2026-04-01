countdownGroup.onEnterFrame = setCountdownTime;
countdownGroup._visible = true;
createLeaderboard();
txtRankHead = "RT            ET";
if(Number(detailObj.b))
{
   txtRankHead += "        DIAL-IN           ";
}
else
{
   txtRankHead += "         DIFF";
}
if(!joinFlag)
{
   _root.htConnect(detailObj.i);
   joinFlag = true;
}
if(!isNaN(qualStatus))
{
   if(qualStatus >= 1)
   {
      gotoAndStop("prelimsQual");
      play();
   }
   else if(qualStatus < 1)
   {
      gotoAndStop("prelimsOut");
      play();
   }
}
