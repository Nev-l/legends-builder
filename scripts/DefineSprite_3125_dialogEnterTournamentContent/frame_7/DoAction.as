function onCarSelect(idx)
{
   if(idx || idx === 0)
   {
      selCar = carPicker.selectXML.firstChild.childNodes[idx].attributes.i;
      selCarXML = new XML(carPicker.selectXML.firstChild.childNodes[idx]).firstChild;
   }
   carPicker._visible = false;
   gotoAndStop("car");
   play();
}
function onCarRO(idx)
{
   var _loc2_ = carPicker.selectXML.firstChild.childNodes[idx];
   loadPlate(_loc2_.attributes.pi,_loc2_.attributes.pn);
   classes.Drawing.carLogo(logo,_loc2_.attributes.ci);
}
viewThumb._visible = false;
if(carPicker == undefined)
{
   this.attachMovie("carPicker","carPicker",this.getNextHighestDepth(),{_x:14,_y:184,displayWidth:397});
   carPicker.initDrivable(_global.garageXML,onCarSelect,onCarRO);
}
else
{
   carPicker._visible = true;
}
loadPlate(selCarXML.attributes.pi,selCarXML.attributes.pn);
classes.Drawing.carLogo(logo,selCarXML.attributes.ci);
