viewThumb._visible = true;
viewThumb.clearCarView();
classes.Drawing.carView(viewThumb,new XML(selCarXML),62);
loadPlate(selCarXML.attributes.pi,selCarXML.attributes.pn);
btnDiffCar.hot.onRelease = function()
{
   viewThumb.clearCarView();
   gotoAndStop("picker");
   play();
   clearInterval(this._parent.icn.si);
};
nav1.onRelease = function()
{
   viewThumb.clearCarView();
   gotoAndStop("hide");
   play();
};
nav2.onRelease = function()
{
   if(Number(selCarXML.attributes.td) && Number(selCarXML.attributes.tdex))
   {
      _root.displayTestDriveExpiredWarning();
   }
   else
   {
      _root.updateDefaultCar(selCar);
      viewThumb.clearCarView();
      if(_global.chatObj.roomType == "KOTHH")
      {
         _root.chatKOTHJoin(selCar);
         gotoAndStop("hide");
         play();
      }
      else if(_global.chatObj.roomType == "KOTHB")
      {
         gotoAndStop("bracket");
         play();
      }
   }
};
panel.togLineUp.helpBubble.removeMovieClip();
