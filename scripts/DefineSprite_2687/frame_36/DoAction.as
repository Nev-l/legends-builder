clearHelp();
viewThumb._visible = true;
viewThumb.clearCarView();
classes.Drawing.carView(viewThumb,new XML(selCarXML.toString()),62);
loadPlate(selCarXML.attributes.pi,selCarXML.attributes.pn);
nav2.onRelease = function()
{
   if(Number(selCarXML.attributes.td) && Number(selCarXML.attributes.tdex))
   {
      _root.displayTestDriveExpiredWarning();
   }
   else
   {
      _root.updateDefaultCar(selCar);
      carPicker2.removeMovieClip();
      viewThumb.clearCarView();
      gotoAndStop("type");
      play();
   }
};
nav3.onRelease = function()
{
   viewThumb.clearCarView();
   gotoAndStop("oppCar");
   play();
};
btnDiffCar.hot.onRelease = function()
{
   viewThumb.clearCarView();
   gotoAndStop("picker");
   play();
   clearInterval(this._parent.icn.si);
};
