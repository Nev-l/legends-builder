stop();
_root.garageDynoMC = this;
var loadOnly;
if(classes.GlobalData.attr.mb == 1)
{
   priceGroup.txtPrice = "Free";
}
else if(_global.dynoXML != undefined && _global.dynoXML.firstChild != undefined && _global.dynoXML.firstChild.attributes.p != undefined)
{
   priceGroup.txtPrice = "$" + _global.dynoXML.firstChild.attributes.p;
}
else
{
   priceGroup.txtPrice = "N/A";
}
priceGroup.togBuy.onRelease = function()
{
   var _loc2_ = false;
   if(_root.displayTestDriveExpiredWarningIfNecessary != undefined)
   {
      _loc2_ = _root.displayTestDriveExpiredWarningIfNecessary() == true;
   }
   if(!_loc2_)
   {
      var _loc3_ = Number(classes.GlobalData.attr.dc);
      if(!_loc3_)
      {
         var _loc4_ = new XML(classes.GlobalData.getSelectedCarXML().toString());
         if(_loc4_.firstChild != undefined && _loc4_.firstChild.attributes.i != undefined)
         {
            _loc3_ = Number(_loc4_.firstChild.attributes.i);
         }
      }
      if(_loc3_ > 0)
      {
         _root.garageDynoBuy(_loc3_);
      }
   }
};
redrawGraph(0.1);
var selCarXML = new XML(classes.GlobalData.getSelectedCarXML().toString());
classes.Drawing.carView(carHolder,selCarXML,100,"dyno");
btnLoadDyno.onRelease = function()
{
   loadOnly = true;
   gotoAndStop("dynoReady");
   _root.garageDynoLoad();
};
btnDiffCar.hot.onRelease = function()
{
   _root.attachMovie("dialogContainer","abc",_root.getNextHighestDepth(),{contentName:"dialogSelectCarContent",_context:this._parent._parent});
   clearInterval(this._parent.icn.si);
};
