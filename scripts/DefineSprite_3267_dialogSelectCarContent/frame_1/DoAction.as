function onCarSelect(idx)
{
   trace("onCarSelect: " + this);
   if(idx || idx === 0)
   {
      selCar = carPicker.selectXML.firstChild.childNodes[idx].attributes.i;
      selCarXML = new XML(carPicker.selectXML.firstChild.childNodes[idx]).firstChild;
   }
   carPicker.removeMovieClip();
   _root.updateDefaultCar(selCar);
   _parent._context.afterDialogSelectCar();
   this._parent.closeMe();
}
function onCarRO(idx)
{
   var _loc2_ = carPicker.selectXML.firstChild.childNodes[idx];
   classes.Drawing.plateView(plate,_loc2_.attributes.pi,_loc2_.attributes.pn,40,true,true);
   classes.Drawing.carLogo(logo,_loc2_.attributes.ci);
}
this.attachMovie("carPicker","carPicker",this.getNextHighestDepth(),{_x:14,_y:153,displayWidth:397});
carPicker.initDrivable(_global.garageXML,onCarSelect,onCarRO);
loadPlate(selCarXML.attributes.pi,selCarXML.attributes.pn);
classes.Drawing.carLogo(logo,selCarXML.attributes.pi);
btnCancel.btnLabel.text = "Cancel";
btnCancel.onRelease = function()
{
   this._parent._parent.closeMe();
};
