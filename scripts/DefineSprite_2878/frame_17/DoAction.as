viewThumb._visible = true;
viewThumb.clearCarView();
viewThumb.racerNumSeq = " ";
code = "";
classes.Drawing.carView(viewThumb,new XML(selCarXML),60);
loadPlate(selCarXML.attributes.pi,selCarXML.attributes.pn);
trace("this: " + this);
nav1.onRelease = function()
{
   viewThumb.clearCarView();
   gotoAndStop("hide");
   play();
};
nav2.onRelease = function()
{
   trace("nav2.onRelease!");
   trace(this);
   trace(selCarXML);
   trace(selCarXML.attributes.td);
   trace(selCarXML.attributes.tdex);
   if(Number(selCarXML.attributes.td) && Number(selCarXML.attributes.tdex))
   {
      _root.displayTestDriveExpiredWarning();
   }
   else
   {
      carPicker.removeMovieClip();
      gotoAndStop("code");
      play();
   }
};
btnDiffCar.hot.onRelease = function()
{
   gotoAndStop("picker");
   play();
   clearInterval(this._parent.icn.si);
};
