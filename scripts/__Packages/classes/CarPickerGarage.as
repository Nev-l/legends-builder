class classes.CarPickerGarage extends MovieClip
{
   var btnLeft;
   var btnRight;
   var useScrollerButtons;
   var currentIndex;
   var currentHole;
   var maxIndex;
   var carCount;
   var moveCount;
   var displayWidth;
   var numberOfDots;
   var onRO;
   var onClick;
   var loadedCars;
   var gridHoles;
   var impoundIndex;
   var selectXML;
   var slotGroup;
   var fullyLoaded;
   var hi;
   var tX;
   var pickerType;
   var impoundedClick;
   var obj;
   var hSpace = 106;
   var slotCount = 0;
   var impoundCount = 0;
   function CarPickerGarage()
   {
      super();
   }
   function CarPicker()
   {
      this.cacheAsBitmap = true;
      this.btnLeft._visible = false;
      this.btnRight._visible = false;
      this.useScrollerButtons = false;
   }
   function init(pickerXML, onClickIn, onROIn)
   {
      this.useScrollerButtons = true;
      this.currentIndex = 0;
      this.currentHole = 0;
      this.maxIndex = -1;
      if(this.impoundCount)
      {
         this.slotCount += 1;
         this.carCount += 1;
      }
      this.moveCount = Math.floor(this.displayWidth / this.hSpace);
      this.numberOfDots = Math.ceil(this.carCount / this.moveCount);
      this.btnLeft._visible = true;
      this.btnRight._visible = true;
      this.onRO = onROIn;
      this.onClick = onClickIn;
      this.loadedCars = new Array();
      trace("car picker x: " + this._x);
      trace("car picker y: " + this._y);
      var i = 0;
      var _loc5_ = undefined;
      while(i < this.numberOfDots)
      {
         this.loadedCars[i] = false;
         trace("holes!");
         _loc5_ = this.gridHoles.attachMovie("carPickerGridHole",String("hole" + i),this.gridHoles.getNextHighestDepth(),{_x:-1 + i * 11,_y:-2});
         _loc5_.id = i;
         this.setHoleFunctions(_loc5_);
         if(i == 0)
         {
            _loc5_.gotoAndStop(2);
            _loc5_.onRollOut = null;
            _loc5_.onRollOver = null;
         }
         i++;
      }
      this.btnLeft.enabled = false;
      if(this.currentIndex + this.moveCount >= pickerXML.firstChild.childNodes.length)
      {
         this.btnRight.enabled = false;
      }
      else
      {
         this.btnRight.enabled = true;
      }
      var _loc6_ = false;
      var _loc7_ = undefined;
      var _loc8_ = undefined;
      if(this.impoundCount)
      {
         _loc7_ = 0;
         while(_loc7_ <= pickerXML.firstChild.childNodes.length)
         {
            if(pickerXML.firstChild.childNodes[_loc7_].nodeName == "empty")
            {
               _loc6_ = true;
               this.impoundIndex = _loc7_;
               _loc8_ = new XMLNode(1,"impound");
               pickerXML.firstChild.insertBefore(_loc8_,pickerXML.firstChild.childNodes[_loc7_]);
               break;
            }
            _loc7_ += 1;
         }
         if(_loc6_ == false)
         {
            this.impoundIndex = this.slotCount - 1;
            _loc8_ = new XMLNode(1,"impound");
            pickerXML.firstChild.appendChild(_loc8_);
         }
      }
      this.btnLeft.onRelease = function()
      {
         trace("btnLeft!");
         var _loc3_ = this._parent.currentIndex / this._parent.moveCount;
         this._parent.setNewHole(_loc3_ - 1,this._parent);
         trace("number of holes: " + Number(_global.locationXML.firstChild.childNodes[i].attributes.ps) * (!Number(classes.GlobalData.attr.mb) ? 1 : 2));
      };
      this.btnRight.onRelease = function()
      {
         trace("btnRight!");
         var _loc2_ = this._parent.currentIndex / this._parent.moveCount;
         this._parent.setNewHole(_loc2_ + 1,this._parent);
      };
      if(!pickerXML.firstChild.childNodes.length)
      {
         this.showNoneAvailable();
      }
      else
      {
         this.selectXML = pickerXML;
      }
      this.slotGroup.fullyLoaded = false;
      this.drawCars(this);
      this.setTextCars(this);
      this.slotGroup.hi = pickerXML.firstChild.childNodes.length - 1;
      var _loc9_ = this.createEmptyMovieClip("displayMask",this.getNextHighestDepth());
      classes.Drawing.rect(_loc9_,this.displayWidth,this.slotGroup.slot0._height,0,0,12);
      this.slotGroup.setMask(_loc9_);
   }
   function setHoleFunctions(hole)
   {
      trace("setHoleFunctions");
      hole.onRollOver = function()
      {
         this.gotoAndStop(3);
      };
      hole.onRollOut = function()
      {
         trace("onRollOut");
         this.gotoAndStop(1);
      };
      hole.onRelease = this.holeRelease;
   }
   function holeRelease()
   {
      this._parent._parent.setNewHole(MovieClip(this).id,this._parent._parent);
   }
   function setNewHole(newHole, mainClip)
   {
      trace("main clip location: " + mainClip._x + " " + mainClip._y);
      var _loc4_ = mainClip.currentIndex / mainClip.moveCount;
      trace("newHole");
      trace(newHole);
      trace(mainClip);
      trace(_loc4_);
      var _loc5_ = false;
      if(newHole > _loc4_)
      {
         _loc5_ = true;
      }
      var _loc6_ = this.moveCount * this.hSpace * (_loc4_ - newHole);
      if(newHole < this.carCount / this.moveCount)
      {
         mainClip.gridHoles[String("hole" + mainClip.currentHole)].gotoAndStop(1);
         this.setHoleFunctions(mainClip.gridHoles[String("hole" + mainClip.currentHole)]);
         mainClip.gridHoles[String("hole" + newHole)].gotoAndStop(2);
         mainClip.gridHoles[String("hole" + newHole)].onRollOut = null;
         mainClip.gridHoles[String("hole" + newHole)].onRollOver = null;
         mainClip.currentHole = newHole;
      }
      mainClip.currentIndex = newHole * mainClip.moveCount;
      this.setTextCars(mainClip);
      mainClip.drawCars(mainClip);
      mainClip.doTween(_loc5_,_loc6_);
   }
   function setTextCars(context)
   {
      trace("setTextCars");
      trace(context);
      var _loc2_ = context.currentIndex / context.moveCount;
      trace(String((_loc2_ + 1) * context.moveCount));
      var _loc3_ = context.carCount;
      var _loc4_ = (_loc2_ + 1) * context.moveCount;
      if(context.impoundCount)
      {
         _loc3_ -= 1;
         if(context.currentIndex + context.moveCount > context.impoundIndex)
         {
            _loc4_ -= 1;
         }
      }
      if(_loc4_ > _loc3_)
      {
         _loc4_ = _loc3_;
      }
      context.txtCars.text = String(String(_loc4_) + "/" + String(_loc3_));
   }
   function setScrollAction()
   {
      if(this.useScrollerButtons == false && this.slotGroup._width > this.displayWidth)
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
      this.carCount = _loc9_;
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
      trace("number of spots: " + _loc10_);
      _loc8_ = _loc9_;
      var _loc11_ = undefined;
      while(_loc8_ < _loc10_)
      {
         _loc11_ = new XMLNode(1,"empty");
         _loc6_.firstChild.appendChild(_loc11_);
         _loc8_ += 1;
      }
      this.slotCount = Number(_loc6_.firstChild.childNodes.length);
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
      this.impoundedClick = onClick;
   }
   function doImpounded()
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
         trace("impoundIndex: " + this.impoundIndex);
         trace("slotX: " + this.slotGroup["slot" + this.impoundIndex]._x);
         _loc3_ = this.slotGroup["slot" + this.impoundIndex];
         _loc4_ = 0;
         _loc3_._x = this.impoundIndex * this.hSpace;
         _loc3_.idx = this.impoundIndex;
         _loc3_.lines._visible = false;
         _loc3_.forSale._visible = false;
         _loc3_.locked._visible = true;
         _loc3_.testDriveExpired._visible = false;
         _loc3_.attachMovie("carPickerCarsImpounded","carsImpounded",1,{txt:_loc2_});
         _loc3_.btn.onRelease = function()
         {
            trace("impoundedClick" + this._parent._parent._parent);
            this._parent._parent._parent.impoundedClick.call(this._parent,this._parent.idx);
         };
         this.setScrollAction();
      }
   }
   function doTween(goRight, scrollAmount)
   {
      trace("hi");
      trace("btnRight: " + this.btnRight);
      this.btnRight.enabled = false;
      this.btnLeft.enabled = false;
      this.enableDots(false);
      trace("scrollAmount: " + scrollAmount);
      trace(this);
      trace(this._x);
      var _loc4_ = new mx.transitions.Tween(this.slotGroup,"_x",mx.transitions.easing.Strong.easeOut,this.slotGroup._x,this.slotGroup._x + scrollAmount,0.5,true);
      _loc4_.onMotionFinished = function()
      {
         trace("btnRight: " + this.obj._parent.btnRight);
         trace("parent: " + this.obj._parent);
         this.obj._parent.enableDots(true);
         this.obj._parent.btnRight.enabled = true;
         this.obj._parent.btnLeft.enabled = true;
         if(this.obj._parent.currentIndex == 0)
         {
            this.obj._parent.btnLeft.enabled = false;
         }
         else if(this.obj._parent.currentIndex + this.obj._parent.moveCount >= this.obj._parent.selectXML.firstChild.childNodes.length)
         {
            this.obj._parent.btnRight.enabled = false;
         }
      };
   }
   function drawCars(context)
   {
      with(context)
      {
         trace("context: " + context);
         trace("currentIndex: " + currentIndex);
         trace("maxIndex: " + maxIndex);
         var _loc3_ = this.currentIndex;
         var _loc4_ = false;
         if(loadedCars[_loc3_ / moveCount] == false)
         {
            var _loc5_ = selectXML;
            maxIndex = currentIndex;
            trace(maxIndex);
            loadedCars[_loc3_ / moveCount] = true;
            if(this.currentIndex == 0)
            {
               var _loc6_ = 1;
               while(_loc6_ < slotCount)
               {
                  trace("empty!");
                  slotGroup.slot0.duplicateMovieClip("slot" + _loc6_,_loc6_,{_x:_loc6_ * hSpace});
                  slotGroup["slot" + _loc6_].locked._visible = false;
                  slotGroup["slot" + _loc6_].forSale._visible = false;
                  slotGroup["slot" + _loc6_].testDriveExpired._visible = false;
                  slotGroup["slot" + _loc6_].hi._visible = false;
                  if(_loc5_.firstChild.childNodes[_loc6_].nodeName == "empty")
                  {
                     slotGroup["slot" + _loc6_].attachMovie("carPickerEmpty","empty",1);
                     slotGroup["slot" + _loc6_].btn.enabled = false;
                  }
                  _loc6_ = _loc6_ + 1;
               }
            }
            trace("initialValue: " + _loc3_);
            trace("currentIndex: " + currentIndex);
            _loc6_ = _loc3_;
            while(_loc6_ < this.currentIndex + moveCount)
            {
               trace("i: " + _loc6_);
               trace(slotGroup["slot" + _loc6_]._x);
               trace("booyaa!");
               if(_loc5_.firstChild.childNodes[_loc6_].nodeName == "impound")
               {
                  doImpounded();
                  slotGroup["slot" + _loc6_].hi._visible = false;
                  slotGroup["slot" + _loc6_].idx = _loc6_;
               }
               else if(_loc5_.firstChild.childNodes[_loc6_].nodeName != "empty")
               {
                  slotGroup["slot" + _loc6_].locked._visible = true;
                  slotGroup["slot" + _loc6_].forSale._visible = true;
                  slotGroup["slot" + _loc6_].testDriveExpired._visible = true;
                  trace("full slot");
                  slotGroup["slot" + _loc6_].hi._visible = false;
                  slotGroup["slot" + _loc6_].idx = _loc6_;
                  slotGroup["slot" + _loc6_].cid = Number(_loc5_.firstChild.childNodes[_loc6_].attributes.i);
                  slotGroup["slot" + _loc6_].createEmptyMovieClip("plateHolder",1);
                  slotGroup["slot" + _loc6_].plateHolder._x = 22;
                  classes.Drawing.plateView(slotGroup["slot" + _loc6_].plateHolder,Number(_loc5_.firstChild.childNodes[_loc6_].attributes.pi),_loc5_.firstChild.childNodes[_loc6_].attributes.pn,13.5,true);
                  slotGroup["slot" + _loc6_].createEmptyMovieClip("thumb",2);
                  slotGroup["slot" + _loc6_].thumb._x = 40;
                  slotGroup["slot" + _loc6_].thumb._y = -5;
                  trace("ii:" + Number(_loc5_.firstChild.childNodes[_loc6_].attributes.ii));
                  if(!Number(_loc5_.firstChild.childNodes[_loc6_].attributes.ii))
                  {
                     slotGroup["slot" + _loc6_].locked._visible = false;
                  }
                  else
                  {
                     slotGroup["slot" + _loc6_].locked.swapDepths(3);
                  }
                  if(!Number(_loc5_.firstChild.childNodes[_loc6_].attributes.lk))
                  {
                     trace("make lock invisible!");
                     slotGroup["slot" + _loc6_].forSale._visible = false;
                  }
                  else
                  {
                     trace("make lock visible!");
                     slotGroup["slot" + _loc6_].forSale._visible = true;
                     slotGroup["slot" + _loc6_].forSale.swapDepths(4);
                  }
                  trace("expired: " + _loc5_.firstChild.childNodes[_loc6_].attributes.tdex);
                  if(!Number(_loc5_.firstChild.childNodes[_loc6_].attributes.tdex))
                  {
                     slotGroup["slot" + _loc6_].testDriveExpired._visible = false;
                  }
                  else
                  {
                     trace("yeah expired!");
                     slotGroup["slot" + _loc6_].testDriveExpired._visible = true;
                     trace(slotGroup["slot" + _loc6_].testDriveExpired);
                     trace(slotGroup["slot" + _loc6_].testDriveExpired._visible);
                     slotGroup["slot" + _loc6_].locked._visible = false;
                     slotGroup["slot" + _loc6_].forSale._visible = false;
                     slotGroup["slot" + _loc6_].testDriveExpired.swapDepths(5);
                  }
                  slotGroup["slot" + _loc6_].btn.onRollOver = function()
                  {
                     onRO.call(_parent,this._parent.idx);
                  };
                  trace("pickerType: " + pickerType);
                  if(Number(_loc5_.firstChild.childNodes[_loc6_].attributes.tdex) && pickerType == 1)
                  {
                     trace("add onrelease!");
                     slotGroup["slot" + _loc6_].btn.onRelease = function()
                     {
                        _root.displayTestDriveExpiredIfNecessaryNotLogin();
                     };
                  }
                  else
                  {
                     slotGroup["slot" + _loc6_].btn.onRelease = function()
                     {
                        onClick.call(this._parent._parent._parent._parent,this._parent.idx);
                        this._parent._parent._parent.setSelectedSlot(this._parent.idx);
                     };
                  }
               }
               classes.Drawing.carView(slotGroup["slot" + _loc6_].thumb,new XML(_loc5_.firstChild.childNodes[_loc6_].toString()),12.5,"front");
               _loc6_ = _loc6_ + 1;
            }
            slotGroup["slot" + _loc6_].cacheAsBitmap = true;
         }
      }
   }
   function enableDots(enable)
   {
      var _loc3_ = 0;
      while(_loc3_ < this.numberOfDots)
      {
         trace("gridHoles: " + this.gridHoles);
         this.gridHoles[String("hole" + _loc3_)].enabled = enable;
         _loc3_ += 1;
      }
   }
}
