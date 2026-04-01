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
if(carPicker == undefined)
{
   this.attachMovie("carPicker","carPicker",this.getNextHighestDepth(),{_x:153,_y:51,displayWidth:462});
   carPicker.initDrivable(_global.garageXML,onCarSelect,onCarRO);
}
else
{
   carPicker._visible = true;
}
loadPlate(selCarXML.attributes.pi,selCarXML.attributes.pn);
classes.Drawing.carLogo(logo,selCarXML.attributes.ci);
nav2.onRelease = function()
{
   carPicker.removeMovieClip();
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
};
nav3.onRelease = function()
{
   carPicker._visible = false;
   gotoAndStop("car");
   play();
};
panel.togLineUp.helpBubble.removeMovieClip();
