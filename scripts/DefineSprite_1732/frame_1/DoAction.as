stop();
var detailObj = _root.main.sectionHolder.sectionClip.detailObj;
var loadListener = new Object();
loadListener.onLoadComplete = function(target_mc)
{
   play();
   delete loadListener;
};
loadListener.onLoadError = function()
{
   play();
   delete loadListener;
};
var mcLoader = new MovieClipLoader();
mcLoader.addListener(loadListener);
mcLoader.loadClip("cache/tournaments/eib_" + detailObj.it + ".swf",bg);
