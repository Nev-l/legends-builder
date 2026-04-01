clearHelp();
nav1.onRelease = function()
{
   viewThumb.clearCarView();
   carPicker.removeMovieClip();
   carPicker2.removeMovieClip();
   gotoAndStop("hide");
   play();
};
nav2.onRelease = function()
{
   if(oppCarsXML)
   {
      gotoAndStop("oppCar");
      play();
   }
   else if(oppID)
   {
      gotoAndStop("oppCarLU");
      play();
   }
   else
   {
      _root.displayAlert("warning","No Opponent Selected","You must select an opponent to challenge.");
   }
};
nav3.enabled = false;
drawUserList();
