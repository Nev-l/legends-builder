function redrawGraph(gs)
{
   graphScale = gs;
   dynoScale = 10 / graphScale;
   dyno.dynoHolder._yscale = dynoScale;
   var _loc2_ = 1;
   while(_loc2_ <= 10)
   {
      dyno["power" + _loc2_] = _loc2_ * 100 * graphScale;
      _loc2_ += 1;
   }
}
function populateSingleSwatch()
{
   createSwatch(swatchHolder,16711680,44527);
   arySwatch[0].onRelease();
}
function populateSessionSwatch()
{
   createSwatch(swatchHolder,16711680,44527);
   createSwatch(swatchHolder,16745216,21670);
   createSwatch(swatchHolder,763680,9830639);
   createSwatch(swatchHolder,15537242,16776960);
   createSwatch(swatchHolder,16030401,9291327);
   createSwatch(swatchHolder,14803425,16158294);
   arySwatch[0].onRelease();
}
function createSwatch(mc, cH, cT)
{
   var _loc4_ = mc.createEmptyMovieClip("swatch" + arySwatch.length,mc.getNextHighestDepth());
   _loc4_._x = arySwatch.length * 20;
   _loc4_.isSelected = false;
   _loc4_.clrHp = cH;
   _loc4_.clrTorque = cT;
   _loc4_.createEmptyMovieClip("selectedMC",_loc4_.getNextHighestDepth());
   _loc4_.selectedMC.moveTo(0,0);
   _loc4_.selectedMC.lineStyle(1,16777215,100);
   _loc4_.selectedMC.lineTo(15,0);
   _loc4_.selectedMC.lineTo(15,27);
   _loc4_.selectedMC.lineTo(0,27);
   _loc4_.selectedMC.lineTo(0,0);
   _loc4_.selectedMC._visible = false;
   _loc4_.beginFill(cH,100);
   _loc4_.moveTo(3,3);
   _loc4_.lineTo(12,3);
   _loc4_.lineTo(12,12);
   _loc4_.lineTo(3,12);
   _loc4_.lineTo(3,3);
   _loc4_.endFill();
   _loc4_.beginFill(0,0);
   _loc4_.moveTo(3,12);
   _loc4_.lineTo(12,12);
   _loc4_.lineTo(12,14);
   _loc4_.lineTo(3,14);
   _loc4_.lineTo(3,12);
   _loc4_.endFill();
   _loc4_.beginFill(cT,100);
   _loc4_.moveTo(3,14);
   _loc4_.lineTo(12,14);
   _loc4_.lineTo(12,23);
   _loc4_.lineTo(3,23);
   _loc4_.lineTo(3,14);
   _loc4_.endFill();
   _loc4_.onRollOver = function()
   {
      this.selectedMC._visible = true;
   };
   _loc4_.onRollOut = function()
   {
      if(!this.isSelected)
      {
         this.selectedMC._visible = false;
      }
   };
   _loc4_.onRelease = function()
   {
      clrHp = this.clrHp;
      clrTorque = this.clrTorque;
      var _loc2_ = 0;
      while(_loc2_ < arySwatch.length)
      {
         arySwatch[_loc2_].isSelected = false;
         arySwatch[_loc2_].selectedMC._visible = false;
         _loc2_ += 1;
      }
      this.isSelected = true;
      this.selectedMC._visible = true;
   };
   arySwatch.push(_loc4_);
}
function drawDyno(aryDyno, aryFuel, aryRatio, aryMaxIcon, _dynoName)
{
   var _loc6_ = undefined;
   var _loc7_ = undefined;
   var _loc8_ = undefined;
   var _loc9_ = undefined;
   var _loc10_ = dyno.dynoHolder.createEmptyMovieClip("dyno" + dyno.dynoHolder.getNextHighestDepth(),dyno.dynoHolder.getNextHighestDepth());
   _loc10_.createEmptyMovieClip("torque",_loc10_.getNextHighestDepth());
   _loc10_.createEmptyMovieClip("hp",_loc10_.getNextHighestDepth());
   _loc10_.torque.lineStyle(1,clrTorque,100,true,"normal","round","round");
   _loc10_.hp.lineStyle(1,clrHp,100,true,"normal","round","round");
   _loc10_.torque.moveTo(85,(- aryDyno[0]) * 5);
   _loc10_.hp.moveTo(85,(- aryDyno[0]) * 1700 / 5252 * 5);
   dynoIncrement = 0;
   _loc6_ = _loc7_ = 0;
   var _loc11_ = 0;
   while(_loc11_ < aryDyno.length)
   {
      if(aryDyno[_loc11_] > aryDyno[_loc6_])
      {
         _loc6_ = _loc11_;
      }
      if(aryDyno[_loc11_] * (_loc11_ + 17) > aryDyno[_loc7_] * (_loc7_ + 17))
      {
         _loc7_ = _loc11_;
      }
      _loc11_ += 1;
   }
   _loc8_ = aryDyno[_loc6_];
   _loc9_ = Math.round(aryDyno[_loc7_] * (_loc7_ + 17) * 100 / 5252 * 100) / 100;
   var _loc12_ = undefined;
   if(_loc8_ > _loc9_)
   {
      _loc12_ = Math.ceil(_loc8_ / 100) / 10;
   }
   else
   {
      _loc12_ = Math.ceil(_loc9_ / 100) / 10;
   }
   trace("minGraphScale = " + _loc12_);
   trace("graphScale = " + graphScale);
   if(_loc12_ > graphScale)
   {
      redrawGraph(_loc12_);
      trace("redrawGraph");
   }
   var _loc13_ = drawDynoInfo(_dynoName,clrHp,clrTorque,"Max " + _loc9_ + " HP @ " + (_loc7_ + 17) + "00 RPM","Max " + _loc8_ + " FT-LBS @ " + (_loc6_ + 17) + "00 RPM",aryDyno,aryFuel,aryRatio,aryMaxIcon);
   _loc13_._visible = false;
   aryDynoCollection.push(new Array(_loc10_,_loc13_));
   clearInterval(dynoInterval);
   dynoInterval = setInterval(animateDyno,33,_loc10_,_loc13_,aryDyno,aryFuel,aryRatio,aryMaxIcon);
}
function animateDyno(mc, mcInfo, aryDyno, aryAir, aryRatio, aryMaxIcon)
{
   if(dynoIncrement >= aryDyno.length)
   {
      clearInterval(dynoInterval);
      AFmaxIcon = 0;
      AFMeter = chipSetting;
      mcInfo._visible = true;
      canDyno = true;
      btnStartDyno._alpha = 100;
      scrollerObj.refreshScroller();
      return undefined;
   }
   var _loc7_ = aryDyno[dynoIncrement] * (dynoIncrement + 17) * 100 / 5252;
   mc.torque.lineTo((17 + dynoIncrement) * 5,(- aryDyno[dynoIncrement]) * 5);
   mc.hp.lineTo((17 + dynoIncrement) * 5,(- _loc7_) * 5);
   AFLimit = aryAir[dynoIncrement];
   AFMeter = aryRatio[dynoIncrement];
   AFmaxIcon = aryMaxIcon[dynoIncrement];
   dynoIncrement++;
}
function drawDynoInfo(_dynoName, cH, cT, tH, tT, aryDyno, aryAir, aryRatio, aryMaxIcon)
{
   var _loc10_ = scrollerContent.attachMovie("dynoGraphInfo","dynoInfo" + scrollerContent.getNextHighestDepth(),scrollerContent.getNextHighestDepth());
   _loc10_._y = aryDynoCollection.length * 70;
   if(!_dynoName)
   {
      _dynoName = "Dyno Graph " + dynoNumber;
      dynoNumber++;
      _loc10_.btnSave.onRelease = function()
      {
         saveDynoInfo(this._parent);
      };
   }
   else
   {
      _loc10_.btnSave._visible = false;
   }
   _loc10_.dynoName.text = _dynoName;
   _loc10_.isVisible = true;
   _loc10_.maxTorque.text = tT;
   _loc10_.maxHp.text = tH;
   _loc10_.aryDyno = aryDyno;
   _loc10_.aryAir = aryAir;
   _loc10_.aryRatio = aryRatio;
   _loc10_.aryMaxIcon = aryMaxIcon;
   var _loc11_ = new Color(_loc10_.clrHp);
   _loc11_.setRGB(cH);
   _loc11_ = new Color(_loc10_.clrTorque);
   _loc11_.setRGB(cT);
   _loc10_.checkbox.onRelease = function()
   {
      this._parent.isVisible = !this._parent.isVisible;
      if(this._parent.isVisible)
      {
         this.gotoAndStop(1);
      }
      else
      {
         this.gotoAndStop(2);
      }
      setDynoVisibility(this._parent);
   };
   _loc10_.btnRemove.onRelease = function()
   {
      deleteDyno(this._parent);
   };
   return _loc10_;
}
function setDynoVisibility(dynoInfoMC)
{
   var _loc2_ = 0;
   while(_loc2_ < aryDynoCollection.length)
   {
      if(aryDynoCollection[_loc2_][1] == dynoInfoMC)
      {
         aryDynoCollection[_loc2_][0]._visible = aryDynoCollection[_loc2_][1].isVisible;
         break;
      }
      _loc2_ += 1;
   }
}
function deleteDyno(dynoInfoMC)
{
   var _loc2_ = 0;
   var _loc3_ = undefined;
   while(_loc2_ < aryDynoCollection.length)
   {
      if(aryDynoCollection[_loc2_][1] == dynoInfoMC)
      {
         aryDynoCollection[_loc2_][0].removeMovieClip();
         aryDynoCollection[_loc2_][1].removeMovieClip();
         dynoInfoMC.removeMovieClip();
         _loc3_ = _loc2_ + 1;
         while(_loc3_ < aryDynoCollection.length)
         {
            aryDynoCollection[_loc3_][1]._y = (_loc3_ - 1) * 70;
            _loc3_ += 1;
         }
         aryDynoCollection.splice(_loc2_,1);
         break;
      }
      _loc2_ += 1;
   }
}
function saveDynoInfo(mc)
{
   selectedDynoInfo = mc;
   _root.garageDynoSave(mc.aryDyno,mc.aryAir,mc.aryRatio,mc.aryMaxIcon);
}
function saveDynoInfoCallback(n)
{
   selectedDynoInfo.btnSave._visible = false;
   selectedDynoInfo.dynoName.text = n;
}
function afterDialogSelectCar()
{
   _parent.sectionName = "dyno";
   _parent.locationID = locationID;
   _parent.gotoAndPlay(1);
}
var maxPsi = 10;
var boostSetting = 5;
var chipSetting = 0;
var AFLimit = 0;
var AFMeter = chipSetting;
var graphScale;
var clrTorque;
var clrHp;
var arySwatch;
var dynoInterval;
var dynoIncrement;
var dynoNumber = 1;
var aryDynoCollection;
var selectedDynoInfo;
