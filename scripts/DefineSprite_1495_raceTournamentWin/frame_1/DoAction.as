var detailObj = _root.main.sectionHolder.sectionClip.detailObj;
if(_global.chatObj.roomType != "CT")
{
   stop();
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
}
