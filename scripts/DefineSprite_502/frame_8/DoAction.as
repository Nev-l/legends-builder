var carXML;
accountCarID = 0;
var carID;
var isBack = false;
this.attachMovie("carPickerGarage","carPicker",this.getNextHighestDepth(),{_x:32.5,_y:-17.1,displayWidth:530});
var onCarSelect = function(idx)
{
   var _loc3_ = undefined;
   if(idx || idx === 0)
   {
      classes.GlobalData.setSelectedCar(carPicker.selectXML.firstChild.childNodes[idx].attributes.i);
      getSelCarInfo();
      _root.updateDefaultCar(accountCarID);
      _loc3_ = "front";
      if(isBack)
      {
         _loc3_ = "back";
      }
      gotoAndPlay(_loc3_);
   }
};
this.carPicker.initHomeGarage(_global.garageXML,onCarSelect);
var impoundLink = function()
{
   classes.Control.goSection("impound");
};
this.carPicker.showImpounded(impoundLink);
var plateListener = new Object();
plateListener.onLoadComplete = function(target_mc)
{
   var _loc2_ = classes.GlobalData.getPlateXML(plateID);
   target_mc.region = _loc2_.attributes.c;
   target_mc.id = _loc2_.attributes.i;
   trace("LIC: " + _loc2_.attributes.c + ", " + _loc2_.attributes.i);
   var _loc3_ = lic.split("_");
   target_mc.seq1 = _loc3_[0];
   target_mc.seq2 = _loc3_[1];
   target_mc.seq3 = _loc3_[2];
   if(target_mc.region == "euro")
   {
      target_mc._xscale = target_mc._yscale = 33;
      target_mc._x = 20;
      target_mc._y = 117;
   }
   else
   {
      target_mc._xscale = target_mc._yscale = 43;
      target_mc._x = -10;
      target_mc._y = 97;
   }
};
var plateLoader = new MovieClipLoader();
plateLoader.addListener(plateListener);
getSelCarInfo();
