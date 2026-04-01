function onSwatchClick(newColor)
{
   selCarClr = newColor;
   var _loc2_ = new classes.CarSpecs();
   _loc2_.modSpec("globalClr",Number("0x" + newColor));
   var _loc3_ = new Object();
   _loc3_.cs = _loc2_;
   _loc3_.carID = selCarNum;
   _loc3_.cs.spoilerID = 1;
   _loc3_.cs.rideHeight = Number(selCarXML.attributes.rh);
   _loc3_.cs.wheelSize = Number(selCarXML.attributes.ws);
   _loc3_.cs.wheelFID = _loc3_.cs.wheelRID = Number(selCarXML.attributes.wid);
   trace("wheelFID: " + selCarXML.attributes.wid);
   _loc3_.cs.tireScaleFactor = 1 + Number(selCarXML.attributes.ts) / 100;
   _loc3_.cs.setWheelAndTireScales();
   image_mc.clearCarView();
   var _loc4_ = "";
   if(isBack)
   {
      _loc4_ = "back";
      image_mc._x = 170;
   }
   else
   {
      _loc4_ = "front";
      image_mc._x = 210;
   }
   classes.Drawing.carView(image_mc,new XML(),100,_loc4_,_loc3_);
}
function drawSwatches()
{
   var _loc4_ = 0;
   while(_loc4_ < paintSwatchArray.length)
   {
      paintSwatchArray[_loc4_].removeMovieClip();
      _loc4_ += 1;
   }
   paintSwatchArray = new Array();
   if(selCarXML == undefined || selCarXML.childNodes == undefined)
   {
      return undefined;
   }
   var _loc5_ = selCarXML;
   _loc4_ = 0;
   var _loc3_;
   var _loc2_;
   while(_loc4_ < _loc5_.childNodes.length)
   {
      _loc3_ = paintSwatchArray.length;
      _loc2_ = classes.PaintSwatch(paintSwatchContainer.attachMovie("paintSwatch","swatch" + _loc3_,paintSwatchContainer.getNextHighestDepth()));
      _loc2_._x = - (Math.floor(_loc3_ / columns) * xIndent + _loc3_ % columns * xSpacing);
      _loc2_._y = Math.floor(_loc3_ / columns) * yIndent;
      _loc2_.HexColor = _loc5_.childNodes[_loc4_].attributes.cd;
      _loc2_.swatchColorMC.onRelease = function()
      {
         this._parent._parent._parent.onSwatchClick(this._parent.hexColor);
      };
      paintSwatchArray.push(_loc2_);
      _loc4_ += 1;
   }
}
function onShopPartClick(pid, repeat)
{
   var _loc2_ = 0;
   while(_loc2_ < dealerCarsXML.firstChild.childNodes.length)
   {
      if(dealerCarsXML.firstChild.childNodes[_loc2_].attributes.i == pid)
      {
         selCarXML = dealerCarsXML.firstChild.childNodes[_loc2_];
         break;
      }
      _loc2_ += 1;
   }
   var _loc10_;
   if(!repeat)
   {
      _loc10_ = selCarXML.childNodes.length - 1;
      selCarClr = selCarXML.childNodes[_loc10_].attributes.cd;
   }
   var _loc7_ = "";
   if(isBack)
   {
      _loc7_ = "back";
      image_mc._x = 170;
   }
   else
   {
      _loc7_ = "front";
      image_mc._x = 210;
   }
   selCarNum = pid;
   image_mc.clearCarView();
   var _loc9_ = new classes.CarSpecs();
   _loc9_.modSpec("globalClr",Number("0x" + selCarClr));
   var _loc3_ = new Object();
   _loc3_.cs = _loc9_;
   _loc3_.carID = selCarNum;
   _loc3_.cs.spoilerID = 1;
   _loc3_.cs.rideHeight = Number(selCarXML.attributes.rh);
   _loc3_.cs.wheelSize = Number(selCarXML.attributes.ws);
   _loc3_.cs.wheelFID = _loc3_.cs.wheelRID = Number(selCarXML.attributes.wid);
   _loc3_.cs.tireScaleFactor = 1 + Number(selCarXML.attributes.ts) / 100;
   _loc3_.cs.setWheelAndTireScales();
   classes.Drawing.carView(image_mc,new XML(),100,_loc7_,_loc3_);
   carDetail.priceGroup._visible = true;
   soldOutSign._visible = false;
   var _loc5_;
   var _loc6_;
   var _loc8_;
   if(selCarXML != undefined)
   {
      paintSwatchContainer._y = paintSwatchContainer.by - 15 * Math.floor((selCarXML.childNodes.length - 1) / columns);
      for(§each§ in carDetail)
      {
         if(carDetail[eval("each")].getDepth() > 0)
         {
            carDetail[eval("each")].removeMovieClip();
         }
      }
      if(selCarXML.attributes.mo == 1)
      {
         carDetail.mo._visible = true;
      }
      else
      {
         carDetail.mo._visible = false;
      }
      carDetail.txt1 = selCarXML.attributes.eo + " engine, " + selCarXML.attributes.dt + ", " + selCarXML.attributes.np + "-pass, " + selCarXML.attributes.ct;
      carDetail.txt2 = selCarXML.attributes.et;
      carDetail.txt3 = selCarXML.attributes.tt;
      carDetail.txt4 = selCarXML.attributes.sw + " lb (mfr)";
      carDetail.txt5 = selCarXML.attributes.st + " sec (est)";
      _loc5_ = selCarXML.attributes.cbl;
      _loc6_ = selCarXML.attributes.cb;
      isPhasingOut = Number(selCarXML.attributes.po);
      phaseOutStockLeft = Number(selCarXML.attributes.poc);
      _global.carsLeft = _loc5_ - _loc6_;
      carDetail.pointsGroup.togBuy.txt = "Buy";
      carDetail.priceGroup.togBuy.txt = "Buy";
      carDetail.phaseOutClip._visible = false;
      if(_loc5_ == 0 || isPhasingOut == 1)
      {
         carDetail.carsLeftClip._visible = false;
         _global.carsUnlimited = true;
         if(isPhasingOut == 1)
         {
            carDetail.phaseOutClip._visible = true;
            carDetail.phaseOutClip.carsRemaining.text = classes.NumFuncs.commaFormat(phaseOutStockLeft);
            if(phaseOutStockLeft <= 0)
            {
               carDetail.pointsGroup._visible = false;
               carDetail.priceGroup._visible = false;
               trace("setting soldOutSign to visible");
               soldOutSign._visible = true;
            }
         }
      }
      else
      {
         _global.carsUnlimited = false;
         carDetail.carsLeftClip._visible = true;
         _loc8_ = _loc5_ - _loc6_;
         carDetail.carsLeftClip.carsLeftClip.carsLeft = classes.NumFuncs.commaFormat(_loc8_);
         carDetail.carsLeftClip.carsLeftClip.totalSold = classes.NumFuncs.commaFormat(_loc6_);
         if(_loc8_ <= 0)
         {
            carDetail.pointsGroup.togBuy.txt = "Detail";
            carDetail.priceGroup.togBuy.txt = "Detail";
         }
      }
      if(selCarXML.attributes.pp == -1)
      {
         carDetail.pointsGroup._visible = false;
      }
      else
      {
         if(Number(selCarXML.attributes.pp) <= -1)
         {
            carDetail.pointsGroup.txtPoints = "N/A";
         }
         else
         {
            carDetail.pointsGroup.txtPoints = classes.NumFuncs.commaFormat(selCarXML.attributes.pp);
         }
         classes.Effects.roBump(carDetail.pointsGroup.togBuy);
         carDetail.pointsGroup.togBuy.onRelease = function()
         {
            startBuyCar("p");
         };
         carDetail.pointsGroup._visible = true;
      }
      txtPoints = selCarXML.attributes.pp + " Points";
      carDetail.txtYear = selCarXML.attributes.y;
      _loc2_ = 1;
      while(_loc2_ <= 5)
      {
         carDetail["fld" + _loc2_].setTextFormat(tfPlain);
         _loc2_ += 1;
      }
      if(Number(selCarXML.attributes.p) <= -1)
      {
         carDetail.priceGroup.txtPrice = "N/A";
      }
      else
      {
         carDetail.priceGroup.txtPrice = "$" + classes.NumFuncs.commaFormat(selCarXML.attributes.p);
      }
      carDetail.logo.loadMovie("cache/car/logo_" + selCarNum + ".swf");
      drawSwatches();
      carDetail._visible = true;
      classes.Effects.roBump(carDetail.priceGroup.togBuy);
      carDetail.priceGroup.togBuy.onRelease = function()
      {
         startBuyCar("m");
      };
   }
   else
   {
      carDetail._visible = false;
   }
   if(skipToCar)
   {
      delete mb.onEnterFrame;
      mb.hidePanel();
   }
}
function startBuyCar(paymentType)
{
   var _loc4_ = undefined;
   if(carDetail.carsLeftClip.carsLeftClip.carsLeft <= 0 && _global.carsUnlimited == false || isPhasingOut == 1 && phaseOutStockLeft <= 0)
   {
      _root.attachMovie("alertBuyCar","abc",_root.getNextHighestDepth());
      _root.abc.addButton("OK",true);
      _root.abc.addButton("Cancel");
      _root.abc.contentMC.txtName = selCarXML.attributes.n;
      _root.abc.contentMC.alertIconMC.gotoAndStop("key");
      if(_global.carsUnlimited == false)
      {
         _root.abc.contentMC.txtTitle = "Limited Edition";
      }
      else
      {
         _root.abc.contentMC.txtTitle = "Discontinued";
      }
      _root.abc.contentMC.createEmptyMovieClip("viewThumb",_root.abc.contentMC.getNextHighestDepth());
      _root.abc.contentMC.viewThumb._x = 264;
      _root.abc.contentMC.viewThumb._y = 143;
      _root.abc.thumb = new flash.display.BitmapData(160,100,true,0);
      _loc4_ = new flash.geom.Matrix(0.25,0,0,0.25,0,0);
      _root.abc.thumb.draw(image_mc,_loc4_,new flash.geom.ColorTransform(),"normal",null,true);
      _root.abc.contentMC.viewThumb.attachBitmap(_root.abc.thumb,0,"auto",true);
      _root.abc.contentMC.fldPrice.autoSize = "right";
      if(paymentType == "m")
      {
         _root.abc.contentMC.txtPrice = "$" + classes.NumFuncs.commaFormat(selCarXML.attributes.p);
         _root.abc.contentMC.pointsIcon._visible = false;
         _root.abc.contentMC.txtMsg = selCarXML.attributes.led;
      }
      else
      {
         _root.abc.contentMC.txtPrice = classes.NumFuncs.commaFormat(selCarXML.attributes.pp) + " Points";
         _root.abc.contentMC.pointsIcon._x = _root.abc.contentMC.fldPrice._x - _root.abc.contentMC.pointsIcon._width - 3;
         _root.abc.contentMC.txtMsg = selCarXML.attributes.led;
      }
      _root.abc.addListener({onRelease:function(theButton, keepBoxOpen)
      {
         false;
         theButton._parent._parent.closeMe();
      }});
   }
   else if(paymentType == "m" && locationID > Number(classes.GlobalData.attr.lid))
   {
      classes.Control.dialogAlert("Can Not Buy From This Dealership","Sorry, you can not buy from this dealership.  You are free to browse, but you must live at or above this neighborhood in order to buy.");
   }
   else if(paymentType == "m" && Number(selCarXML.attributes.p) <= -1)
   {
      classes.Control.dialogAlert("Car Not Available","Sorry, this car is not available for purchase.");
   }
   else if(paymentType == "p" && Number(selCarXML.attributes.pp) <= -1)
   {
      classes.Control.dialogAlert("Car Not Available","Sorry, this car is not available for purchase.");
   }
   else
   {
      trace("startBuyCar immediate purchase: " + selCarNum + " payment=" + paymentType);
      _root.attachMovie("alertBuyCar","abc",_root.getNextHighestDepth());
      _root.abc.contentMC.txtName = selCarXML.attributes.n;
      _root.abc.contentMC.alertIconMC.gotoAndStop("key");
      _root.abc.contentMC.txtTitle = "Purchasing Car";
      _root.abc.contentMC.createEmptyMovieClip("viewThumb",_root.abc.contentMC.getNextHighestDepth());
      _root.abc.contentMC.viewThumb._x = 264;
      _root.abc.contentMC.viewThumb._y = 143;
      _root.abc.thumb = new flash.display.BitmapData(160,100,true,0);
      _loc4_ = new flash.geom.Matrix(0.25,0,0,0.25,0,0);
      _root.abc.thumb.draw(image_mc,_loc4_,new flash.geom.ColorTransform(),"normal",null,true);
      _root.abc.contentMC.viewThumb.attachBitmap(_root.abc.thumb,0,"auto",true);
      _root.abc.contentMC.fldPrice.autoSize = "right";
      if(paymentType == "m")
      {
         _root.abc.contentMC.txtPrice = "$" + classes.NumFuncs.commaFormat(selCarXML.attributes.p);
         _root.abc.contentMC.pointsIcon._visible = false;
      }
      else
      {
         _root.abc.contentMC.txtPrice = classes.NumFuncs.commaFormat(selCarXML.attributes.pp) + " Points";
         _root.abc.contentMC.pointsIcon._x = _root.abc.contentMC.fldPrice._x - _root.abc.contentMC.pointsIcon._width - 3;
      }
      _root.abc.contentMC.txtMsg = "Processing purchase for the " + selCarXML.attributes.n + ".";
      _root.abc.addDisabledButton("OK");
      _root.abc.addDisabledButton("Cancel");
      _root.buyCar(selCarNum,paymentType,selCarClr);
   }
}
var isPhasingOut;
var phaseOutStockLeft;
