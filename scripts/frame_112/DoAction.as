stop();
loadThisFile = "cache/misc/lb.swf";
this.createEmptyMovieClip("lbHolder",this.getNextHighestDepth());
var mclListener = new Object();
mclListener.onLoadInit = function(target_mc)
{
   trace("lb.swf loaded");
   target_mc._visible = false;
   play();
   delete lb_mcl;
   delete mclListener;
};
mclListener.onLoadError = function(target_mc)
{
   _root.displayAlert("warning","Missing Files","A file is missing from your cache folder:\r\r" + loadThisFile + "\r\rThe game will not function without this file.  Please close the game and re-install it by running the original installer.  Or you can download the latest installer at www.NittoLegends.com.  Note: Re-installing will not affect your account in any way.  You may continue to use your existing account.");
};
var lb_mcl = new MovieClipLoader();
lb_mcl.addListener(mclListener);
lb_mcl.loadClip(loadThisFile,lbHolder);
