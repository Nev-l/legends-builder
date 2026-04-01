stop();
loadThisFile = "cache/car/plates.swf";
this.createEmptyMovieClip("platesHolder",this.getNextHighestDepth());
var mclListener = new Object();
mclListener.onLoadInit = function(target_mc)
{
   trace("plates.swf loaded");
   target_mc._visible = false;
   play();
   delete plates_mcl;
   delete mclListener;
};
mclListener.onLoadError = function(target_mc)
{
   _root.displayAlert("warning","Missing Files","A file is missing from your cache folder:\r\r" + loadThisFile + "\r\rThe game will not function without this file.  Please close the game and re-install it by running the original installer.  Or you can download the latest installer at www.NittoLegends.com.  Note: Re-installing will not affect your account in any way.  You may continue to use your existing account.");
};
var plates_mcl = new MovieClipLoader();
plates_mcl.addListener(mclListener);
plates_mcl.loadClip(loadThisFile,platesHolder);
