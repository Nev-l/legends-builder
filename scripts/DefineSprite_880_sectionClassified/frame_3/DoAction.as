stop();
detail.removeMovieClip();
_root.listClassified(searchCarID,searchEngineID,searchPage);
btnBrowse.onRelease = function()
{
   searchPage = 1;
   gotoAndStop("browse");
   play();
};
btnTrade.onRelease = function()
{
   gotoAndStop("trade");
   play();
};
