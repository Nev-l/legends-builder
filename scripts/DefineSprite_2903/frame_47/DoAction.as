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
var tTotal = Number(aryCompTourney[myIdx].rt) + Number(aryCompTourney[myIdx].et) - Number(aryCompTourney[myIdx].bt);
var myRank = rankingBoardMC.attachMovie("tournamentRankItem","myRank",rankingBoardMC.getNextHighestDepth());
myRank.username.text = classes.GlobalData.uname;
myRank.rt.text = rt.text;
myRank.et.text = et.text;
myRank.rtVal = aryCompTourney[myIdx].rt;
myRank.total = tTotal;
sortRankingBoard();
setRankingBoardAnim(1000);
currentMatch = 0;
clearInterval(computerChartAnimationInterval);
var computerChartAnimationInterval;
