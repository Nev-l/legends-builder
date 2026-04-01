function onCarSelect(idx)
{
   if(idx || idx === 0)
   {
      selCar = carPicker2.selectXML.firstChild.childNodes[idx].attributes.i;
      selCarXML = new XML(carPicker2.selectXML.firstChild.childNodes[idx].toString()).firstChild;
      trace(selCarXML);
   }
   carPicker2.removeMovieClip();
   gotoAndStop("car");
   play();
}
function onCarRO(idx)
{
   var _loc2_ = carPicker2.selectXML.firstChild.childNodes[idx];
   loadPlate(_loc2_.attributes.pi,_loc2_.attributes.pn);
   classes.Drawing.carLogo(logo,_loc2_.attributes.ci);
}
if(carPicker2 == undefined)
{
   this.attachMovie("carPicker","carPicker2",this.getNextHighestDepth(),{_x:153,_y:51,displayWidth:462});
   carPicker2.initDrivable(_global.garageXML,onCarSelect,onCarRO);
}
else
{
   carPicker2._visible = true;
}
loadPlate(selCarXML.attributes.pi,selCarXML.attributes.pn);
classes.Drawing.carLogo(logo,selCarXML.attributes.ci);
nav2.onRelease = function()
{
   carPicker2.removeMovieClip();
   gotoAndStop("type");
   play();
};
nav3.onRelease = function()
{
   carPicker2._visible = false;
   gotoAndStop("car");
   play();
};
