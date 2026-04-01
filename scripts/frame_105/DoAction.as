stop();
trace("ROOT: frame_105 (preloadAssets) reached!");
loadThisFile = "cache/misc/imp.swf";
this.createEmptyMovieClip("imp",this.getNextHighestDepth());
var mclListener = new Object();
mclListener.onLoadInit = function(target_mc)
{
   trace("imp.swf loaded");
   target_mc._visible = false;
   play();
   delete imp_mcl;
   delete mclListener;
};
mclListener.onLoadError = function(target_mc)
{
   _root.displayAlert("warning","Missing Files","A file is missing from your cache folder:\r\r" + loadThisFile + "\r\rThe game will not function without this file.  Please close the game and re-install it by running the original installer.  Or you can download the latest installer at www.NittoLegends.com.  Note: Re-installing will not affect your account in any way.  You may continue to use your existing account.");
};
var imp_mcl = new MovieClipLoader();
imp_mcl.addListener(mclListener);
imp_mcl.loadClip(loadThisFile,imp);
