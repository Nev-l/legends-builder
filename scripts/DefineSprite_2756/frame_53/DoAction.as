viewThumb._visible = true;
viewThumb.clearCarView();
classes.Drawing.carView(viewThumb,new XML(selCarXML.toString()),62);
loadPlate(selCarXML.attributes.pi,selCarXML.attributes.pn);
nav2.onRelease = function()
{
   if(_parent.selCarXML.attributes.td && _parent.selCarXML.attributes.tdex)
   {
      _root.displayAlert("warning","Test Drive Car","Your test drive with this car has expired. Please choose another car.");
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
