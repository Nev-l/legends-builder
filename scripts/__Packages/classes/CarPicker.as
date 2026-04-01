class classes.CarPicker extends MovieClip
{
   var selectXML;
   var slotGroup;
   var pickerType;
   var displayWidth;
   var fullyLoaded;
   var hi;
   var tX;
   var hSpace = 106;
   var slotCount = 0;
   var impoundCount = 0;
   function CarPicker()
   {
      super();
      this.cacheAsBitmap = true;
   }
   function init(pickerXML, onClick, onRO)
   {
      if(!pickerXML.firstChild.childNodes.length)
      {
         this.showNoneAvailable();
      }
      else
      {
         this.selectXML = pickerXML;
      }
      this.slotGroup.fullyLoaded = false;
      var _loc3_ = 0;
      while(_loc3_ < pickerXML.firstChild.childNodes.length)
      {
         if(_loc3_ > 0)
         {
            this.slotGroup.slot0.duplicateMovieClip("slot" + _loc3_,_loc3_,{_x:_loc3_ * this.hSpace});
         }
         this.slotGroup["slot" + _loc3_].hi._visible = false;
         this.slotGroup["slot" + _loc3_].idx = _loc3_;
         trace("booyaa!");
         if(pickerXML.firstChild.childNodes[_loc3_].nodeName == "empty")
         {
            this.slotGroup["slot" + _loc3_].locked._visible = false;
            this.slotGroup["slot" + _loc3_].forSale._visible = false;
            this.slotGroup["slot" + _loc3_].testDriveExpired._visible = false;
            this.slotGroup["slot" + _loc3_].attachMovie("carPickerEmpty","empty",1);
            this.slotGroup["slot" + _loc3_].btn.enabled = false;
         }
         else
         {
            this.slotGroup["slot" + _loc3_].cid = Number(pickerXML.firstChild.childNodes[_loc3_].attributes.i);
            this.slotGroup["slot" + _loc3_].createEmptyMovieClip("plateHolder",1);
            this.slotGroup["slot" + _loc3_].plateHolder._x = 22;
            classes.Drawing.plateView(this.slotGroup["slot" + _loc3_].plateHolder,Number(pickerXML.firstChild.childNodes[_loc3_].attributes.pi),pickerXML.firstChild.childNodes[_loc3_].attributes.pn,13.5,true);
            this.slotGroup["slot" + _loc3_].createEmptyMovieClip("thumb",2);
            this.slotGroup["slot" + _loc3_].thumb._x = 40;
            this.slotGroup["slot" + _loc3_].thumb._y = -5;
            if(!Number(pickerXML.firstChild.childNodes[_loc3_].attributes.ii))
            {
               this.slotGroup["slot" + _loc3_].locked._visible = false;
            }
            else
            {
               this.slotGroup["slot" + _loc3_].locked.swapDepths(3);
            }
            if(!Number(pickerXML.firstChild.childNodes[_loc3_].attributes.lk))
            {
               this.slotGroup["slot" + _loc3_].forSale._visible = false;
            }
            else
            {
               this.slotGroup["slot" + _loc3_].forSale._visible = true;
               this.slotGroup["slot" + _loc3_].forSale.swapDepths(4);
            }
            trace("expired: " + pickerXML.firstChild.childNodes[_loc3_].attributes.tdex);
            if(!Number(pickerXML.firstChild.childNodes[_loc3_].attributes.tdex))
            {
               this.slotGroup["slot" + _loc3_].testDriveExpired._visible = false;
            }
            else
            {
               trace("yeah expired!");
               this.slotGroup["slot" + _loc3_].testDriveExpired._visible = true;
               trace(this.slotGroup["slot" + _loc3_].testDriveExpired);
               trace(this.slotGroup["slot" + _loc3_].testDriveExpired._visible);
               this.slotGroup["slot" + _loc3_].locked._visible = false;
               this.slotGroup["slot" + _loc3_].forSale._visible = false;
               this.slotGroup["slot" + _loc3_].testDriveExpired.swapDepths(5);
            }
            this.slotGroup["slot" + _loc3_].btn.onRollOver = function()
            {
               onRO.call(this._parent,this._parent.idx);
            };
            trace("pickerType: " + this.pickerType);
            if(Number(pickerXML.firstChild.childNodes[_loc3_].attributes.tdex) && this.pickerType == 1)
            {
               trace("add onrelease!");
               this.slotGroup["slot" + _loc3_].btn.onRelease = function()
               {
                  _root.displayTestDriveExpiredIfNecessaryNotLogin();
               };
            }
            else
            {
               this.slotGroup["slot" + _loc3_].btn.onRelease = function()
               {
                  onClick.call(this._parent._parent._parent._parent,this._parent.idx);
                  this._parent._parent._parent.setSelectedSlot(this._parent.idx);
               };
            }
            classes.Drawing.carView(this.slotGroup["slot" + _loc3_].thumb,new XML(pickerXML.firstChild.childNodes[_loc3_].toString()),12.5,"front");
         }
         this.slotGroup["slot" + _loc3_].cacheAsBitmap = true;
         this.slotCount += 1;
         _loc3_ += 1;
      }
      this.slotGroup.hi = pickerXML.firstChild.childNodes.length - 1;
      var _loc4_ = this.createEmptyMovieClip("displayMask",this.getNextHighestDepth());
      classes.Drawing.rect(_loc4_,this.displayWidth,this.slotGroup.slot0._height,0,0);
      this.slotGroup.setMask(_loc4_);
      this.setScrollAction();
   }
   function setScrollAction()
   {
      if(this.slotGroup._width > this.displayWidth)
      {
         this.slotGroup.onEnterFrame = function()
         {
            var _loc3_ = undefined;
            if(this.fullyLoaded)
            {
               if(this["slot" + this.hi]._width && this.hitTest(_root._xmouse,_root._ymouse,false))
               {
                  this.tX = (- (this._width - this._parent.displayWidth)) * this._parent._xmouse / this._parent.displayWidth;
                  this._x += (this.tX - this._x) / 3;
               }
            }
            else
            {
               _loc3_ = 0;
               for(var _loc4_ in this)
               {
                  if(_loc4_.substr(0,4) == "slot")
                  {
                     if(this[_loc4_].thumb.loaded || !this[_loc4_].cid)
                     {
                        _loc3_ += 1;
                     }
                  }
               }
               if(_loc3_ >= this._parent.slotCount)
               {
                  this.fullyLoaded = true;
               }
            }
         };
      }
   }
   function setSelectedSlot(idx)
   {
      trace("setSelectedSlot: " + idx);
      for(var _loc3_ in this.slotGroup)
      {
         if(_loc3_.substr(0,4) == "slot")
         {
            this.slotGroup[_loc3_].btn._visible = true;
            this.slotGroup[_loc3_].hi._visible = false;
            if(this.slotGroup[_loc3_].idx == idx)
            {
               this.slotGroup[_loc3_].btn._visible = false;
               this.slotGroup[_loc3_].hi._visible = true;
            }
         }
      }
   }
   function setSelectedCar(cid)
   {
      for(var _loc3_ in this.slotGroup)
      {
         if(_loc3_.substr(0,4) == "slot")
         {
            if(classes.GlobalData.attr.dc == this.slotGroup[_loc3_].cid)
            {
               this.setSelectedSlot(this.slotGroup[_loc3_].idx);
            }
         }
      }
   }
   function initDrivable(listXML, onClick, onRO)
   {
      this.pickerType = 0;
      var _loc5_ = new XML(listXML.toString());
      var _loc6_ = _loc5_.firstChild.childNodes.length - 1;
      var _loc7_ = undefined;
      if(!isNaN(_loc6_))
      {
         _loc7_ = _loc6_;
         while(_loc7_ >= 0)
         {
            if(Number(_loc5_.firstChild.childNodes[_loc7_].attributes.ii))
            {
               _loc5_.firstChild.childNodes[_loc7_].removeNode();
               this.impoundCount += 1;
            }
            else if(Number(_loc5_.firstChild.childNodes[_loc7_].attributes.lk))
            {
               _loc5_.firstChild.childNodes[_loc7_].removeNode();
            }
            _loc7_ -= 1;
         }
      }
      if(_loc5_.firstChild.childNodes.length)
      {
         this.init(_loc5_,onClick,onRO);
      }
      else
      {
         this.showNoneAvailable();
      }
   }
   function initSellable(listXML, onClick, onRO)
   {
      this.pickerType = 0;
      var _loc5_ = new XML(listXML.toString());
      var _loc6_ = _loc5_.firstChild.childNodes.length - 1;
      var _loc7_ = undefined;
      if(!isNaN(_loc6_))
      {
         _loc7_ = _loc6_;
         while(_loc7_ >= 0)
         {
            if(Number(_loc5_.firstChild.childNodes[_loc7_].attributes.lk))
            {
               _loc5_.firstChild.childNodes[_loc7_].removeNode();
            }
            _loc7_ -= 1;
         }
      }
      if(_loc5_.firstChild.childNodes.length)
      {
         this.init(_loc5_,onClick,onRO);
      }
      else
      {
         this.showNoneAvailable();
      }
   }
   function initEngines(pickerXML, onClick, onRO)
   {
      this.pickerType = 0;
      var _loc4_ = undefined;
      var _loc5_ = undefined;
      var _loc6_ = undefined;
      var _loc7_ = undefined;
      if(pickerXML.firstChild.childNodes.length)
      {
         if(this.selectXML.firstChild.childNodes.length)
         {
            _loc4_ = 0;
            while(_loc4_ < pickerXML.firstChild.childNodes.length)
            {
               this.selectXML.firstChild.appendChild(pickerXML.firstChild.childNodes[_loc4_].cloneNode(true));
               _loc4_ += 1;
            }
         }
         else
         {
            this.selectXML = pickerXML;
         }
         _loc5_ = this.slotCount;
         _loc6_ = _loc5_ + pickerXML.firstChild.childNodes.length;
         _loc7_ = _loc5_ * this.hSpace;
         _loc4_ = _loc5_;
         while(_loc4_ < _loc6_)
         {
            this.slotGroup.attachMovie("carPickerEngineSlot","slot" + _loc4_,_loc4_,{_x:_loc7_});
            _loc7_ += 66;
            this.slotGroup["slot" + _loc4_].idx = _loc4_;
            this.slotGroup["slot" + _loc4_].hi._visible = false;
            this.slotGroup["slot" + _loc4_].locked._visible = false;
            this.slotGroup["slot" + _loc4_].forSale._visible = false;
            this.slotGroup["slot" + _loc4_].testDriveExpired._visible = false;
            this.slotGroup["slot" + _loc4_].eid = Number(pickerXML.firstChild.childNodes[_loc4_ - _loc5_].attributes.i);
            this.slotGroup["slot" + _loc4_].ei = Number(pickerXML.firstChild.childNodes[_loc4_ - _loc5_].attributes.ei);
            this.slotGroup["slot" + _loc4_].txt = pickerXML.firstChild.childNodes[_loc4_ - _loc5_].attributes.n;
            this.slotGroup["slot" + _loc4_].createEmptyMovieClip("thumb",2);
            this.slotGroup["slot" + _loc4_].thumb._x = 30;
            this.slotGroup["slot" + _loc4_].thumb._y = -5;
            this.slotGroup["slot" + _loc4_].thumb._xscale = 50;
            this.slotGroup["slot" + _loc4_].thumb._yscale = 50;
            trace(_global.assetPath + "/parts/m" + this.slotGroup["slot" + _loc4_].ei + ".swf");
            this.slotGroup["slot" + _loc4_].thumb.loadMovie(_global.assetPath + "/parts/m" + this.slotGroup["slot" + _loc4_].ei + ".swf");
            this.slotGroup["slot" + _loc4_].btn.onRollOver = function()
            {
               onRO.call(this._parent,this._parent.idx);
            };
            this.slotGroup["slot" + _loc4_].btn.onRelease = function()
            {
               onClick.call(this._parent._parent._parent._parent,this._parent.eid);
               this._parent._parent._parent.setSelectedSlot(this._parent.idx);
            };
            this.slotCount += 1;
            _loc4_ += 1;
         }
         this.slotGroup.hi = pickerXML.firstChild.childNodes.length - 1;
         if(!displayMask)
         {
            var _loc8_ = this.createEmptyMovieClip("displayMask",this.getNextHighestDepth());
            classes.Drawing.rect(_loc8_,this.displayWidth,this.slotGroup.slot0._height,0,0);
            this.slotGroup.setMask(_loc8_);
         }
         this.setScrollAction();
      }
   }
   function initHomeGarage(listXML, onClick, onRO)
   {
      this.pickerType = 1;
      var _loc6_ = new XML(listXML.toString());
      var _loc7_ = _loc6_.firstChild.childNodes.length;
      var _loc8_ = undefined;
      if(!isNaN(_loc7_))
      {
         _loc8_ = _loc7_ - 1;
         while(_loc8_ >= 0)
         {
            if(Number(_loc6_.firstChild.childNodes[_loc8_].attributes.ii))
            {
               _loc6_.firstChild.childNodes[_loc8_].removeNode();
               this.impoundCount += 1;
            }
            _loc8_ -= 1;
         }
      }
      var _loc9_ = _loc6_.firstChild.childNodes.length;
      var _loc10_ = 0;
      _loc8_ = 0;
      while(_loc8_ < _global.locationXML.firstChild.childNodes.length)
      {
         if(classes.GlobalData.attr.lid == _global.locationXML.firstChild.childNodes[_loc8_].attributes.lid)
         {
            _loc10_ = Number(_global.locationXML.firstChild.childNodes[_loc8_].attributes.ps) * (!Number(classes.GlobalData.attr.mb) ? 1 : 2);
         }
         _loc8_ += 1;
      }
      _loc8_ = _loc9_;
      var _loc11_ = undefined;
      while(_loc8_ < _loc10_)
      {
         _loc11_ = new XMLNode(1,"empty");
         _loc6_.firstChild.appendChild(_loc11_);
         _loc8_ += 1;
      }
      if(_loc6_.firstChild.childNodes.length)
      {
         this.init(_loc6_,onClick,onRO);
      }
      else
      {
         this.showNoneAvailable();
      }
   }
   function showNoneAvailable()
   {
      trace("showNoneAvailable");
      this.slotGroup.slot0.locked._visible = false;
      this.slotGroup.slot0.forSale._visible = false;
      this.slotGroup.slot0.testDriveExpired._visible = false;
      this.slotGroup.slot0.attachMovie("carPickerNoneAvailable","noneAvailable",1);
   }
   function showImpounded(onClick, onRO)
   {
      trace("showImpounded");
      var _loc2_ = undefined;
      var _loc3_ = undefined;
      var _loc4_ = undefined;
      if(this.impoundCount)
      {
         _loc2_ = this.impoundCount + "\rCAR";
         if(this.impoundCount > 1)
         {
            _loc2_ += "S";
         }
         _loc2_ += " IMPOUNDED";
         _loc3_ = this.slotGroup.slot0.duplicateMovieClip("slot" + this.slotCount,this.slotCount);
         _loc4_ = 0;
         for(var _loc5_ in this.slotGroup)
         {
            if(_loc5_.substr(0,4) == "slot")
            {
               if(this.slotGroup[_loc5_].cid)
               {
                  _loc4_ += 1;
               }
               else
               {
                  this.slotGroup[_loc5_]._x += this.hSpace;
               }
            }
         }
         _loc3_._x = _loc4_ * this.hSpace;
         _loc3_.idx = this.slotCount;
         _loc3_.lines._visible = false;
         _loc3_.forSale._visible = false;
         _loc3_.testDriveExpired._visible = false;
         _loc3_.attachMovie("carPickerCarsImpounded","carsImpounded",1,{txt:_loc2_});
         _loc3_.btn.onRollOver = function()
         {
            onRO.call(this._parent,this._parent.idx);
         };
         _loc3_.btn.onRelease = function()
         {
            onClick.call(this._parent,this._parent.idx);
         };
         this.setScrollAction();
      }
   }
}
