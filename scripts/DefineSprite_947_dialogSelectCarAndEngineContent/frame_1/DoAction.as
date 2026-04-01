function onItemSelect(idx)
{
   trace("onItemSelect: " + idx);
   if(idx || idx === 0)
   {
      selCar = carPicker.selectXML.firstChild.childNodes[idx].attributes.i;
      selCarXML = new XML(carPicker.selectXML.firstChild.childNodes[idx]).firstChild;
   }
   carPicker.removeMovieClip();
   _root.updateDefaultCar(selCar);
   _parent._context.afterDialogSelectCar();
   _parent._context.shoppingFor = "Car";
   this._parent.closeMe();
}
function onEngineSelect(aeid)
{
   trace("onEngineSelect: " + aeid);
   carPicker.removeMovieClip();
   _parent._context.afterDialogSelectEngine(aeid);
   _parent._context.shoppingFor = "Engine";
   this._parent.closeMe();
}
function onItemRO(idx)
{
   var _loc2_ = carPicker.selectXML.firstChild.childNodes[idx];
   if(_loc2_.attributes.ei)
   {
      fldEngineNote._visible = true;
      plate.unloadMovie();
      logo.unloadMovie();
   }
   else
   {
      fldEngineNote._visible = false;
      classes.Drawing.plateView(plate,_loc2_.attributes.pi,_loc2_.attributes.pn,40,true,true);
      classes.Drawing.carLogo(logo,_loc2_.attributes.ci);
   }
}
function CB_engineList()
{
   trace("CB_engineList");
   this.attachMovie("carPicker","carPicker",this.getNextHighestDepth(),{_x:14,_y:153,displayWidth:397});
   carPicker.initDrivable(_global.garageXML,onItemSelect,onItemRO);
   carPicker.initEngines(_global.shopPartsMC.enginePartXML,onEngineSelect,onItemRO);
   loadPlate(selCarXML.attributes.pi,selCarXML.attributes.pn);
   classes.Drawing.carLogo(logo,selCarXML.attributes.pi);
}
fldEngineNote._visible = false;
_root.engineList();
btnCancel.btnLabel.text = "Cancel";
btnCancel.onRelease = function()
{
   this._parent._parent.closeMe();
};
