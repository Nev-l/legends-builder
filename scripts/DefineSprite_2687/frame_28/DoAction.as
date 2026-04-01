function onCarSelect(idx)
{
   if(idx || idx === 0)
   {
      selOppCar = carPicker.selectXML.firstChild.childNodes[idx].attributes.i;
      selOppCarXML = new XML(carPicker.selectXML.firstChild.childNodes[idx].toString()).firstChild;
   }
   carPicker.removeMovieClip();
   gotoAndStop("oppCar");
   play();
}
function onCarRO(idx)
{
   var _loc2_ = carPicker.selectXML.firstChild.childNodes[idx];
   loadPlate(_loc2_.attributes.pi,_loc2_.attributes.pn);
   classes.Drawing.carLogo(logo,_loc2_.attributes.ci);
}
clearHelp();
if(carPicker == undefined)
{
   this.attachMovie("carPicker","carPicker",this.getNextHighestDepth(),{_x:153,_y:51,displayWidth:462});
   carPicker.initDrivable(oppCarsXML,onCarSelect,onCarRO);
}
else
{
   carPicker._visible = true;
}
loadPlate(selOppCarXML.attributes.pi,selOppCarXML.attributes.pn);
classes.Drawing.carLogo(logo,selOppCarXML.attributes.ci);
nav2.onRelease = function()
{
   carPicker.removeMovieClip();
   gotoAndStop("car");
   play();
};
nav3.onRelease = function()
{
   carPicker._visible = false;
   gotoAndStop("oppCar");
   play();
};
