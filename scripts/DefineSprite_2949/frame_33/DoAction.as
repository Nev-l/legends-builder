stop();
qualFlag = true;
rankingBoardGroup._visible = false;
rankingBoardGroup._x = 150;
rankingBoardGroup._y = 416;
countdownGroup._y = 344;
countdownGroup._visible = true;
scrollerObj.resetMask(null,null,327,132);
scrollerObj.resetScroller(132,310,null);
var loadListener = new Object();
loadListener.onLoadComplete = function(target_mc)
{
   play();
   delete loadListener;
};
loadListener.onLoadError = function(target_mc)
{
   play();
   delete loadListener;
};
var mcLoader = new MovieClipLoader();
mcLoader.addListener(loadListener);
mcLoader.loadClip("cache/tournaments/eq_" + detailObj.it + ".swf",loadinBG);
