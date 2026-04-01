stop();
loadThisFile = "cache/misc/news.swf";
this.createEmptyMovieClip("newsHolder",this.getNextHighestDepth());
var mclListener = new Object();
mclListener.onLoadInit = function(target_mc)
{
   trace("news.swf loaded");
   trace(target_mc.infoPage);
   target_mc.infoPage.init();
   delete news_mcl;
   delete mclListener;
};
mclListener.onLoadError = function(target_mc)
{
   _root.displayAlert("warning","Missing Files","A file is missing from your cache folder:\r\r" + loadThisFile + "\r\rThe game will not function without this file.  Please close the game and re-install it by running the original installer.  Or you can download the latest installer at www.NittoLegends.com.  Note: Re-installing will not affect your account in any way.  You may continue to use your existing account.");
};
var news_mcl = new MovieClipLoader();
news_mcl.addListener(mclListener);
news_mcl.loadClip(loadThisFile,newsHolder);
