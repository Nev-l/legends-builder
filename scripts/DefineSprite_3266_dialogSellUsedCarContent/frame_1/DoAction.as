function onCarSelect(idx)
{
   trace("onCarSelect: " + this);
   selCar = carPicker.selectXML.firstChild.childNodes[idx].attributes.i;
   selCarXML = new XML(carPicker.selectXML.firstChild.childNodes[idx]);
   carPicker.removeMovieClip();
   nextFrame();
}
function onCarRO(idx)
{
   var _loc2_ = carPicker.selectXML.firstChild.childNodes[idx];
   classes.Drawing.plateView(plate,_loc2_.attributes.pi,_loc2_.attributes.pn,40,true,true);
   classes.Drawing.carLogo(logo,_loc2_.attributes.ci);
}
stop();
this.attachMovie("carPicker","carPicker",this.getNextHighestDepth(),{_x:14,_y:153,displayWidth:397});
carPicker.initSellable(_global.garageXML,onCarSelect,onCarRO);
loadPlate(selCarXML.firstChild.attributes.pi,selCarXML.firstChild.attributes.pn);
classes.Drawing.carLogo(logo,selCarXML.firstChild.attributes.ci);
btnCancel.btnLabel.text = "Cancel";
btnCancel.onRelease = function()
{
   this._parent._parent.closeMe();
};
