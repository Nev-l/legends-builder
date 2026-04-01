function shouldWeCheckBox(theIndex)
{
   trace("shouldWeCheckBox");
   trace(theIndex);
   var _loc2_ = false;
   var _loc3_ = 0;
   for(i in contentArray[theIndex])
   {
      trace(contentArray[theIndex][i]);
      if(contentArray[theIndex][i].isRepair == true)
      {
         trace(contentArray[theIndex][i].price);
         _loc2_ = true;
         _loc3_ += contentArray[theIndex][i].price;
      }
   }
   if(_loc2_ == true)
   {
      trace("hilite!");
      leftButtonArray[theIndex].buyItems = true;
      leftButtonArray[theIndex].box.gotoAndStop(2);
   }
   else
   {
      trace("don\'t hilite");
      leftButtonArray[theIndex].buyItems = false;
      leftButtonArray[theIndex].box.gotoAndStop(1);
   }
   leftButtonArray[theIndex].txtPrice.text = "$" + _loc3_;
}
function showThisContent(theIndex)
{
   hideAllContent();
   trace("showThisContent");
   trace(theIndex);
   trace(contentArray[theIndex]);
   contentArray[theIndex]._visible = true;
}
function hideAllContent()
{
   engineRepairContent._visible = false;
   nitrousContent._visible = false;
   fluidContent._visible = false;
   raceGasContent._visible = false;
   tireStickContent._visible = false;
}
function hideAllButtons()
{
   leftButtons.mvEngineRepair._visible = false;
   leftButtons.mvFluid._visible = false;
   leftButtons.mvNitrous._visible = false;
   leftButtons.mvRaceGas._visible = false;
   leftButtons.mvTraction._visible = false;
}
function hideAllHilites()
{
   var _loc1_ = 0;
   while(_loc1_ < leftButtonArray.length)
   {
      leftButtonArray[_loc1_].hilite._visible = false;
      _loc1_ += 1;
   }
}
function hiliteAllItems(hiliteThem, theIndex)
{
   trace("hiliteAllItems");
   for(i in contentArray[theIndex])
   {
      trace(contentArray[theIndex][i]);
      if(hiliteThem == true && contentArray[theIndex][i]._visible == true)
      {
         contentArray[theIndex][i].isRepair = true;
         contentArray[theIndex][i].box.gotoAndStop(2);
      }
      else
      {
         contentArray[theIndex][i].isRepair = false;
         contentArray[theIndex][i].box.gotoAndStop(1);
      }
   }
}
function loadRepairShop(repairXML)
{
   trace("loadRepairShop");
   var _loc10_;
   hideAllContent();
   hideAllButtons();
   contentArray.splice(0);
   leftButtonArray.splice(0);
   aryRepair.splice(0);
   var _loc19_;
   var _loc21_;
   var _loc12_;
   for(§each§ in this.engineRepairContent)
   {
      this[eval("each")].removeMovieClip();
   }
   var _loc23_ = 14.95;
   var _loc17_ = 0;
   nitrousRefill._visible = oilFlush._visible = secondaryBox._visible = false;
   var _loc25_;
   var _loc24_;
   var _loc3_;
   var _loc5_;
   var _loc11_;
   var _loc9_;
   var _loc8_;
   var _loc15_;
   var _loc13_;
   var _loc18_;
   var _loc16_;
   var _loc22_;
   var _loc20_;
   var _loc14_;
   var _loc7_;
   var _loc6_;
   if(repairXML.firstChild.childNodes.length == 0)
   {
      noDamageText._visible = true;
   }
   else
   {
      _loc25_ = Number(repairXML.firstChild.attributes.p);
      _loc24_ = Number(repairXML.firstChild.attributes.v);
      trace("length: " + repairXML.firstChild.childNodes.length);
      fluidContent.oilFlush._visible = false;
      _loc3_ = 0;
      while(_loc3_ < repairXML.firstChild.childNodes.length)
      {
         _loc10_ = false;
         if(Number(repairXML.firstChild.childNodes[_loc3_].attributes.ci) == 102)
         {
            trace("nitrous!");
            _loc5_ = nitrousContent.nitrousRefill;
            _loc5_.bottle1.bottleMask._y = (110 - Number(repairXML.firstChild.childNodes[_loc3_].attributes.d)) / 100 * _loc5_.bottle1.bottleMask._height;
            _loc5_.title.text = repairXML.firstChild.childNodes[_loc3_].attributes.n;
            if(_loc5_.title.text.indexOf("2 ") == 0)
            {
               _loc5_.bottle2._visible = true;
               _loc5_.bottle2.bottleMask._y = _loc5_.bottle1.bottleMask._y;
            }
            else
            {
               _loc5_.bottle2._visible = false;
            }
            _loc5_.txtLeft.text = "Your nitrous tank(s) have about " + Math.round(Number(repairXML.firstChild.childNodes[_loc3_].attributes.d)) + "% remaining.";
            if(Math.round(Number(repairXML.firstChild.childNodes[_loc3_].attributes.d)) < 100)
            {
               _loc5_.txtLeft.text += "It may be a good idea to top them off.";
            }
            contentArray.push(nitrousContent);
            leftButtonArray.push(leftButtons.mvNitrous);
            nitrousRefill._visible = true;
            _loc5_.repairIndex = contentArray.length - 1;
         }
         else if(Number(repairXML.firstChild.childNodes[_loc3_].attributes.ci) == 165 || Number(repairXML.firstChild.childNodes[_loc3_].attributes.ci) == 168 || Number(repairXML.firstChild.childNodes[_loc3_].attributes.ci) == 169)
         {
            trace("oil!");
            trace("looking thru contentArray");
            trace(contentArray.length);
            _loc9_ = 0;
            while(_loc9_ < contentArray.length)
            {
               if(contentArray[_loc9_] == fluidContent)
               {
                  _loc10_ = true;
                  break;
               }
               _loc9_ += 1;
            }
            if(Number(repairXML.firstChild.childNodes[_loc3_].attributes.ci) == 165)
            {
               trace("royal purple fluid");
               _loc11_ = 1;
               _loc5_ = fluidContent.oilFlush;
               fluidContent.oilFlush._visible = true;
               _loc21_ = _loc5_;
               oilFlush._visible = true;
            }
            else if(Number(repairXML.firstChild.childNodes[_loc3_].attributes.ci) == 168)
            {
               _loc5_ = fluidContent.attachMovie("OilFilterItem","oilFilterItem",fluidContent.getNextHighestDepth());
               _loc19_ = _loc5_;
               trace("royal purple oil filter");
               _loc11_ = 2;
               _loc5_._x = 33;
            }
            else
            {
               _loc5_ = fluidContent.attachMovie("CoolantItem","CoolantItem",fluidContent.getNextHighestDepth());
               _loc12_ = _loc5_;
               trace("mishimoto coolant");
               trace(_loc12_);
               _loc11_ = 3;
               _loc5_._x = 33;
            }
            _loc5_.fluidTypeLabel = _loc11_;
            if(_loc10_ == false)
            {
               contentArray.push(fluidContent);
               leftButtonArray.push(leftButtons.mvFluid);
               _loc5_.repairIndex = contentArray.length - 1;
            }
            else
            {
               _loc5_.repairIndex = _loc9_;
            }
            trace("check this out: ");
            trace(_loc5_);
         }
         else if(Number(repairXML.firstChild.childNodes[_loc3_].attributes.ci) == -1)
         {
            trace("race gas!");
            _loc5_ = raceGasContent.raceGas;
            _loc5_.gasCan.mask._y = Number(repairXML.firstChild.childNodes[_loc3_].attributes.d) / 100 * _loc5_.gasCan.mask._height + 39;
            _loc5_.txtLeft.text = "You have " + Math.round(100 - Number(repairXML.firstChild.childNodes[_loc3_].attributes.d)) + "% race gas left.";
            contentArray.push(raceGasContent);
            leftButtonArray.push(leftButtons.mvRaceGas);
            _loc5_.repairIndex = contentArray.length - 1;
         }
         else if(Number(repairXML.firstChild.childNodes[_loc3_].attributes.ci) == -2)
         {
            trace("tire stick!");
            _loc5_ = tireStickContent.tireStick;
            _loc5_.tractionCan.mask._y = Number(repairXML.firstChild.childNodes[_loc3_].attributes.d) / 100 * _loc5_.tractionCan.mask._height + 30;
            _loc5_.txtLeft.text = "You have " + Math.round(100 - Number(repairXML.firstChild.childNodes[_loc3_].attributes.d)) + "% traction compound left.";
            trace("tmpItem._x: " + _loc5_._x);
            trace("tmpItem._y: " + _loc5_._y);
            contentArray.push(tireStickContent);
            leftButtonArray.push(leftButtons.mvTraction);
            _loc5_.repairIndex = contentArray.length - 1;
         }
         else
         {
            _loc8_ = 0;
            while(_loc8_ < contentArray.length)
            {
               if(contentArray[_loc8_] == engineRepairContent)
               {
                  _loc10_ = true;
                  break;
               }
               _loc8_ += 1;
            }
            _loc5_ = engineRepairContent.attachMovie("repairItem","repairItem" + _loc3_,engineRepairContent.getNextHighestDepth());
            if(_loc10_ == false)
            {
               contentArray.push(engineRepairContent);
               leftButtonArray.push(leftButtons.mvEngineRepair);
               _loc5_.repairIndex = contentArray.length - 1;
            }
            else
            {
               _loc5_.repairIndex = _loc8_;
            }
            _loc15_ = Number(repairXML.firstChild.childNodes[_loc3_].attributes.d);
            _loc13_ = classes.Repair.formatDamageItem(Number(repairXML.firstChild.childNodes[_loc3_].attributes.ci),_loc15_,_loc25_,_loc24_);
            _loc5_.title.text = _loc13_.title;
            _loc5_.description.text = _loc13_.description;
            _loc5_._x = 33;
            _loc5_._y = _loc23_ + _loc17_ * 60;
            _loc17_ += 1;
         }
         _loc5_.id = Number(repairXML.firstChild.childNodes[_loc3_].attributes.i);
         _loc5_.price = Number(repairXML.firstChild.childNodes[_loc3_].attributes.p);
         _loc5_.ptPrice = Number(repairXML.firstChild.childNodes[_loc3_].attributes.pp);
         _loc5_.priceTxt.text = "$" + _loc5_.price;
         _loc5_.isRepair = true;
         trace("tmpItem");
         trace(_loc12_);
         trace(_loc12_._parent);
         trace(_loc5_);
         trace(_loc5_.isRepair);
         _loc5_.box.gotoAndStop(2);
         _loc5_.box.onRelease = function()
         {
            this._parent.isRepair = !this._parent.isRepair;
            if(this._parent.isRepair)
            {
               this.gotoAndStop(2);
            }
            else
            {
               this.gotoAndStop(1);
            }
            _root.repairPartMC.shouldWeCheckBox(this._parent.repairIndex);
            _root.repairPartMC.updateTotal();
         };
         aryRepair.push(_loc5_);
         trace("tmpItem._x: " + _loc5_._x);
         trace("tmpItem._y: " + _loc5_._y);
         _loc3_ += 1;
      }
      _loc18_ = 10;
      _loc16_ = 10;
      trace("filter: " + _loc19_ + " parent: " + _loc19_._parent);
      trace("flush: " + _loc21_ + " parent: " + _loc21_._parent);
      trace("coolant: " + _loc12_ + " parent: " + _loc12_._parent);
      for(_loc14_ in fluidContent)
      {
         trace("clipName");
         trace(_loc14_);
         _loc7_ = fluidContent[_loc14_];
         trace("fluid content clip: " + _loc7_);
         trace(_loc7_.isRepair);
         if(_loc7_.isRepair == true)
         {
            trace("isRepair");
            trace(_loc7_.fluidTypeLabel);
            if(_loc7_.fluidTypeLabel == 1)
            {
               if(_loc7_._visible == true)
               {
                  _loc18_ += 95;
                  _loc16_ += 95;
               }
            }
            else if(_loc7_.fluidTypeLabel == 2)
            {
               _loc22_ = _loc7_;
               _loc16_ += 90;
            }
            else if(_loc7_.fluidTypeLabel == 3)
            {
               _loc20_ = _loc7_;
            }
         }
      }
      if(_loc22_)
      {
         trace("found second");
         _loc22_._y = _loc18_;
      }
      if(_loc20_)
      {
         trace("found third");
         _loc20_._y = _loc16_;
      }
      trace("leftButtonArray length: " + leftButtonArray.length);
      _loc6_ = 0;
      while(_loc6_ < leftButtonArray.length)
      {
         trace(_loc6_);
         trace(leftButtonArray[_loc6_]);
         leftButtonArray[_loc6_].hilite._visible = false;
         leftButtonArray[_loc6_]._visible = true;
         leftButtonArray[_loc6_]._y = _loc6_ * 45;
         leftButtonArray[_loc6_].repairIndex = _loc6_;
         leftButtonArray[_loc6_].box.gotoAndStop(2);
         leftButtonArray[_loc6_].buyItems = true;
         shouldWeCheckBox(_loc6_);
         leftButtonArray[_loc6_].hitArea.onRelease = function()
         {
            trace("hilite");
            trace(this._parent.hilite);
            _root.repairPartMC.hideAllHilites();
            this._parent.hilite._visible = true;
            _root.repairPartMC.hideAllContent();
            _root.repairPartMC.showThisContent(this._parent.repairIndex);
         };
         leftButtonArray[_loc6_].box.onRelease = function()
         {
            this._parent.buyItems = !this._parent.buyItems;
            if(this._parent.buyItems)
            {
               this.gotoAndStop(2);
               trace("show check box");
               _root.repairPartMC.hiliteAllItems(true,this._parent.repairIndex);
            }
            else
            {
               this.gotoAndStop(1);
               trace("clear check box");
               _root.repairPartMC.hiliteAllItems(false,this._parent.repairIndex);
            }
            _root.repairPartMC.hideAllHilites();
            this._parent.hilite._visible = true;
            _root.repairPartMC.hideAllContent();
            _root.repairPartMC.showThisContent(this._parent.repairIndex);
            _root.repairPartMC.shouldWeCheckBox(this._parent.repairIndex);
            _root.repairPartMC.updateTotal();
         };
         _loc6_ += 1;
      }
      contentArray[0]._visible = true;
      leftButtonArray[0].hilite._visible = true;
      updateTotal();
   }
}
function clearAllItem()
{
   var _loc1_ = 0;
   while(_loc1_ < aryRepair.length)
   {
      aryRepair[_loc1_].removeMovieClip();
      _loc1_ += 1;
   }
   aryRepair = new Array();
   updateTotal();
}
function repairItem(payType)
{
   var _loc3_ = "";
   var _loc4_ = 0;
   var _loc5_ = 0;
   var _loc6_ = 0;
   while(_loc6_ < aryRepair.length)
   {
      if(aryRepair[_loc6_].isRepair)
      {
         _loc3_ += aryRepair[_loc6_].id + ",";
         _loc4_ += Number(aryRepair[_loc6_].price);
         _loc5_ += Number(aryRepair[_loc6_].ptPrice);
      }
      _loc6_ += 1;
   }
   trace("repair these: " + _loc3_);
   if(_loc3_.length)
   {
      _loc3_ = _loc3_.substr(0,_loc3_.length - 1);
      if(payType == "m")
      {
         _root.repairParts(selCar,_loc3_,_loc4_,payType);
      }
      else if(payType == "p")
      {
         _root.repairParts(selCar,_loc3_,_loc5_,payType);
      }
   }
   else
   {
      _root.displayAlert("warning","No Parts Selected","You have no parts selected for repair.");
   }
}
function updateTotal()
{
   var _loc2_ = 0;
   var _loc3_ = 0;
   var _loc1_ = 0;
   while(_loc1_ < aryRepair.length)
   {
      if(aryRepair[_loc1_].isRepair)
      {
         _loc2_ += aryRepair[_loc1_].price;
         _loc3_ += aryRepair[_loc1_].ptPrice;
      }
      _loc1_ += 1;
   }
   priceGroup.txtPrice = "$" + _loc2_;
   pointsGroup.txtPoints = _loc3_;
}
function afterDialogSelectCar()
{
   _parent.sectionName = "repair";
   _parent.locationID = locationID;
   _parent.gotoAndPlay(1);
}
var aryRepair = new Array();
var contentArray = new Array();
var leftButtonArray = new Array();
