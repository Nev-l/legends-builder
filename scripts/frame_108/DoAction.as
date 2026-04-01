stop();
loadThisFile = "cache/badges/badges.swf";
this.createEmptyMovieClip("badgesHolder",this.getNextHighestDepth());
var mclListener = new Object();
mclListener.onLoadInit = function(target_mc)
{
   target_mc._visible = false;
   play();
   delete badges_mcl;
   delete mclListener;
};
mclListener.onLoadError = function(target_mc)
{
   _root.displayAlert("warning","Missing Files","A file is missing from your cache folder:\r\r" + loadThisFile + "\r\rThe game will not function without this file.  Please close the game and re-install it by running the original installer.  Or you can download the latest installer at www.NittoLegends.com.  Note: Re-installing will not affect your account in any way.  You may continue to use your existing account.");
};
var badges_mcl = new MovieClipLoader();
badges_mcl.addListener(mclListener);
badges_mcl.loadClip(loadThisFile,badgesHolder);
