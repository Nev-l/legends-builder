function cont()
{
   _root.chatListUsers();
}
stop();
raceRoomInitFlag = true;
loadinBG.removeMovieClip();
chartThumbSelector._visible = false;
chartThumbSelector.cacheAsBitmap = true;
loadin.swapDepths(8);
rankingBoardGroup.swapDepths(9);
countdownGroup.swapDepths(10);
userListGroup.swapDepths(11);
chatWindow.swapDepths(12);
togChart._visible = false;
ticker._visible = false;
if(spectateFlag)
{
   rankingBoardGroup._visible = false;
   rankingBoardGroup._x = 195;
   rankingBoardGroup._y = 128;
   scrollerObj.resetMask(null,null,327,216);
   scrollerObj.resetScroller(216,null,null);
   countdownGroup._y = 85;
   countdownGroup._visible = true;
   countdownGroup.onEnterFrame = setCountdownTime;
   _root.htGetTournamentTree();
}
else
{
   txtRankTitle = "";
   txtRankHead = "";
   rankingBoardGroup.removeMovieClip();
   countdownGroup.removeMovieClip();
   createChart();
}
chartVisibility(false);
trace("detailObj...");
for(var each in detailObj)
{
   trace(eval("each") + ": " + detailObj[eval("each")]);
}
loadin.loadMovie("cache/tournaments/er_" + tourneyScheduleID + ".swf");
var contST = _global.setTimeout(this,"cont",1500);
