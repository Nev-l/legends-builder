stop();
container.removeMovieClip();
stopAllSounds();
rankingBoardGroup._x = 211;
rankingBoardGroup._y = 270;
scrollerObj.resetMask(null,null,255,323);
scrollerObj.resetScroller(323,255,null);
var myIdx = 32;
var i = 0;
while(i < aryCompTourney.length)
{
   if(aryCompTourney[i].id == classes.GlobalData.id)
   {
      myIdx = i;
      break;
   }
   i++;
}
bt.text = formatDecimal(aryCompTourney[myIdx].bt);
rt.text = formatDecimal(aryCompTourney[myIdx].rt);
et.text = formatDecimal(aryCompTourney[myIdx].et);
btnTryAgain.onRelease = function()
{
   gotoAndPlay(1);
};
