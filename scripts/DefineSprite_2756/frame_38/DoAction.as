if(selOppCar)
{
   viewThumb._visible = true;
   viewThumb.clearCarView();
   classes.Drawing.carView(viewThumb,new XML(selOppCarXML.toString()),62);
   loadPlate(selOppCarXML.attributes.pi,selOppCarXML.attributes.pn);
}
nav2.onRelease = function()
{
   viewThumb.clearCarView();
   carPicker.removeMovieClip();
   gotoAndStop("car");
   play();
};
nav3.enabled = true;
nav3.onRelease = function()
{
   viewThumb.clearCarView();
   gotoAndStop("opp");
   play();
};
btnDiffCar.hot.onRelease = function()
{
   gotoAndStop("oppPicker");
   play();
   clearInterval(this._parent.icn.si);
};
