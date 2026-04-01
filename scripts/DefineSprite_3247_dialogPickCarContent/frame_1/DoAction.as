function onCarSelect(idx)
{
   trace("onCarSelect: " + this);
   classes.mc.TrackPractice._mc.container.removeMovieClip();
   selCar = carPicker.selectXML.firstChild.childNodes[idx].attributes.i;
   selCarXML = new XML(carPicker.selectXML.firstChild.childNodes[idx].toString());
   carPicker.removeMovieClip();
   trace("selCar: " + selCar);
   trace("selCarID: " + this.selCarID);
   trace(this);
   var _loc5_ = classes.GlobalData.getSelectedCarXML();
   trace("currentCarXML:" + _loc5_.toString());
   var _loc6_ = Number(_loc5_.attributes.i);
   trace("selCar: " + selCar);
   trace("currentCarID: " + _loc6_);
   trace(this);
   classes.GlobalData.priorSelectedCarID = _loc6_;
   _root.updateDefaultCar(selCar);
   classes.mc.TrackPractice._mc.selCarID = selCar;
   classes.mc.TrackPractice._mc.selCarXML = new XML(classes.GlobalData.getSelectedCarXML().toString());
   _root.practiceCreate(selCar);
   _parent.closeMe();
}
function onCarRO(idx)
{
   var _loc2_ = carPicker.selectXML.firstChild.childNodes[idx];
   classes.Drawing.plateView(plate,_loc2_.attributes.pi,_loc2_.attributes.pn,40,true,true);
   classes.Drawing.carLogo(logo,_loc2_.attributes.ci);
}
stop();
var selCarXML = new XML(classes.GlobalData.getSelectedCarXML().toString());
var selCarID = Number(selCarXML.attributes.i);
this.attachMovie("carPicker","carPicker",this.getNextHighestDepth(),{_x:14,_y:153,displayWidth:397});
carPicker.initDrivable(_global.garageXML,onCarSelect,onCarRO);
loadPlate(selCarXML.firstChild.attributes.pi,selCarXML.firstChild.attributes.pn);
classes.Drawing.carLogo(logo,selCarXML.firstChild.attributes.ci);
btnCancel.btnLabel.text = "Cancel";
btnCancel.onRelease = function()
{
   this._parent._parent.closeMe();
};
