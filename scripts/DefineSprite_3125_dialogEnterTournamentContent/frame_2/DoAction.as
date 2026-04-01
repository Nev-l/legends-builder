viewThumb._visible = true;
viewThumb.clearCarView();
viewThumb.racerNumSeq = " ";
code = "";
classes.Drawing.carView(viewThumb,new XML(selCarXML),50);
loadPlate(selCarXML.attributes.pi,selCarXML.attributes.pn);
nav1.btnLabel.text = "Cancel";
nav1.onRelease = function()
{
   viewThumb.clearCarView();
   _parent.closeMe();
};
nav2.btnLabel.text = "Continue";
nav2.onRelease = function()
{
   trace("test drive?: ");
   trace(Number(selCarXML.attributes.td));
   trace(Number(selCarXML.attributes.tdex));
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
