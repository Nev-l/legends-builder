function userCarsCB(txml)
{
   classes.Viewer.viewCarsXML = new XML();
   classes.Viewer.viewCarsXML = txml;
   gotoAndStop("cont");
   play();
}
function getSelCarInfo()
{
   accountCarID = Number(carXML.firstChild.attributes.i);
   carID = carXML.firstChild.attributes.ci;
}
function applyGarageTextStyle(tf, fmt)
{
   tf.selectable = false;
   tf.multiline = false;
   tf.wordWrap = false;
   tf.embedFonts = false;
   tf.antiAliasType = "advanced";
   tf.setNewTextFormat(fmt);
}
function ensureGarageDetailFields()
{
   var _loc2_ = undefined;
   var _loc3_ = undefined;
   var _loc4_ = undefined;
   if(garageDetailMC == undefined)
   {
      this.createEmptyMovieClip("garageDetailMC",this.getNextHighestDepth());
      garageDetailMC.createTextField("investLabel",garageDetailMC.getNextHighestDepth(),0,0,120,16);
      garageDetailMC.createTextField("investValue",garageDetailMC.getNextHighestDepth(),0,14,130,20);
      garageDetailMC.createTextField("avgLabel",garageDetailMC.getNextHighestDepth(),0,38,120,16);
      garageDetailMC.createTextField("avgValue",garageDetailMC.getNextHighestDepth(),0,52,130,20);
      _loc2_ = new TextFormat();
      _loc2_.font = "_sans";
      _loc2_.size = 9;
      _loc2_.color = 11184810;
      _loc3_ = new TextFormat();
      _loc3_.font = "_sans";
      _loc3_.size = 11;
      _loc3_.bold = true;
      _loc3_.color = 16777215;
      applyGarageTextStyle(garageDetailMC.investLabel,_loc2_);
      applyGarageTextStyle(garageDetailMC.avgLabel,_loc2_);
      applyGarageTextStyle(garageDetailMC.investValue,_loc3_);
      applyGarageTextStyle(garageDetailMC.avgValue,_loc3_);
   }
   _loc4_ = licPlate._width > 0 ? licPlate._width : 72;
   garageDetailMC._x = licPlate._x + _loc4_ + 12;
   garageDetailMC._y = licPlate._y + 2;
}
function updateGarageCarDetails()
{
   var _loc3_ = Number(carXML.firstChild.attributes.mi);
   var _loc4_ = carXML.firstChild.attributes.aet;
   ensureGarageDetailFields();
   garageDetailMC.investLabel.text = "Invested";
   garageDetailMC.avgLabel.text = "Avg ET";
   if(!isNaN(_loc3_) && _loc3_ > 0)
   {
      garageDetailMC.investValue.text = "$" + classes.NumFuncs.commaFormat(_loc3_);
   }
   else
   {
      garageDetailMC.investValue.text = "$0";
   }
   if(_loc4_ != undefined && _loc4_ != "")
   {
      garageDetailMC.avgValue.text = _loc4_ + " sec";
   }
   else
   {
      garageDetailMC.avgValue.text = "--";
   }
}
function buildPage()
{
   var _loc3_ = function(idx)
   {
      var _loc2_ = undefined;
      if(idx || idx === 0)
      {
         carXML = new XML(carPicker.selectXML.firstChild.childNodes[idx].toString());
         getSelCarInfo();
         _loc2_ = "front";
         if(isBack)
         {
            _loc2_ = "back";
         }
         carMC.clearCarView();
         classes.ClipFuncs.removeAllClips(carMC);
         classes.Drawing.carView(carMC,carXML,100,_loc2_);
         classes.Drawing.plateView(licPlate,Number(carXML.firstChild.attributes.pi),carXML.firstChild.attributes.pn,21,true);
         updateGarageCarDetails();
      }
   };
   var _loc4_ = undefined;
   if(_parent.carID)
   {
      _loc4_ = 0;
      while(_loc4_ < classes.Viewer.viewCarsXML.firstChild.childNodes.length)
      {
         if(Number(classes.Viewer.viewCarsXML.firstChild.childNodes[_loc4_].attributes.i) == _parent.carID)
         {
            carXML = new XML(classes.Viewer.viewCarsXML.firstChild.childNodes[_loc4_].toString());
         }
         _loc4_ += 1;
      }
      _parent.carID = undefined;
   }
   else
   {
      carXML = new XML(classes.Viewer.viewCarsXML.firstChild.firstChild.toString());
   }
   getSelCarInfo();
   var _loc5_ = this.getNextHighestDepth();
   if(carMC == undefined)
   {
      this.createEmptyMovieClip("carMC",_loc5_ + 1);
      carMC._x = 130;
      carMC._y = -50;
   }
   carMC.clearCarView();
   classes.ClipFuncs.removeAllClips(carMC);
   classes.Drawing.carView(carMC,carXML,100);
   classes.Drawing.plateView(licPlate,Number(carXML.firstChild.attributes.pi),carXML.firstChild.attributes.pn,21,true);
   updateGarageCarDetails();
   this.attachMovie("carPicker","carPicker",_loc5_,{_x:-11,displayWidth:754});
   this.carPicker.initDrivable(classes.Viewer.viewCarsXML,_loc3_);
}
