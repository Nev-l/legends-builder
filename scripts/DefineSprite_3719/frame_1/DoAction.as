function getSelectedCarXML()
{
   carXML = new XML(classes.GlobalData.getSelectedCarXML().toString());
}
function cloneCarXML()
{
   cloneXML = new XML(carXML.toString());
}
function drawSwatches()
{
   var _loc2_ = 0;
   while(_loc2_ < paintSwatchArray.length)
   {
      paintSwatchArray[_loc2_].removeMovieClip();
      _loc2_ += 1;
   }
   paintSwatchArray = new Array();
   var _loc3_ = _global.paintsXML.firstChild;
   _loc2_ = 0;
   var _loc4_ = undefined;
   var _loc5_ = undefined;
   while(_loc2_ < _loc3_.childNodes.length)
   {
      if(_loc3_.childNodes[_loc2_].attributes.l == locationID)
      {
         _loc4_ = paintSwatchArray.length;
         _loc5_ = classes.PaintSwatch(paintSwatchContainer.attachMovie("paintSwatch","swatch" + _loc4_,paintSwatchContainer.getNextHighestDepth()));
         _loc5_._x = Math.floor(_loc4_ / columns) * xIndent + _loc4_ % columns * xSpacing;
         _loc5_._y = Math.floor(_loc4_ / columns) * yIndent;
         _loc5_.HexColor = _loc3_.childNodes[_loc2_].attributes.c;
         _loc5_.swatchColorMC.onRelease = function()
         {
            this._parent._parent._parent.addToCart(this._parent.hexColor);
         };
         paintSwatchArray.push(_loc5_);
      }
      _loc2_ += 1;
   }
   paintSwatchContainer.cacheAsBitmap = true;
}
function drawMenu()
{
   var _loc2_ = 0;
   while(_loc2_ < paintMenuArray.length)
   {
      paintMenuArray[_loc2_].removeMovieClip();
      _loc2_ += 1;
   }
   paintMenuArray = new Array();
   var _loc3_ = undefined;
   var _loc4_ = undefined;
   var _loc5_ = undefined;
   if(isWholeCar)
   {
      paintSwatchContainer._x = priceDescription._x = 200;
      _loc3_ = _global.paintCategoriesXML.firstChild;
      _loc2_ = 0;
      while(_loc2_ < _loc3_.childNodes.length)
      {
         if(Number(_loc3_.childNodes[_loc2_].attributes.i) == -2 && Number(_loc3_.childNodes[_loc2_].attributes.l) == locationID)
         {
            btnFull.price = Number(_loc3_.childNodes[_loc2_].attributes.p);
            btnFull.pointPrice = Number(_loc3_.childNodes[_loc2_].attributes.pp);
            break;
         }
         _loc2_ += 1;
      }
   }
   else
   {
      paintSwatchContainer._x = priceDescription._x = 350;
      _loc3_ = _global.paintCategoriesXML.firstChild;
      tfNA = new TextFormat();
      tfNA.color = 6710886;
      _loc2_ = 0;
      while(_loc2_ < _loc3_.childNodes.length)
      {
         if(Number(_loc3_.childNodes[_loc2_].attributes.l) == locationID)
         {
            if(Number(_loc3_.childNodes[_loc2_].attributes.i) == -2)
            {
               btnFull.price = Number(_loc3_.childNodes[_loc2_].attributes.p);
               btnFull.pointPrice = Number(_loc3_.childNodes[_loc2_].attributes.pp);
            }
            else
            {
               trace("ITEM");
               _loc4_ = paintMenuArray.length;
               _loc5_ = paintMenuContainer.attachMovie("shopMenuListItem","menu" + _loc4_,paintMenuContainer.getNextHighestDepth());
               _loc5_._x = paintMenuX;
               _loc5_._y = paintMenuY + _loc4_ * paintMenuYSpacing;
               if(Number(_loc3_.childNodes[_loc2_].attributes.i) == -1)
               {
                  _loc5_.txt = "Main Body";
                  if(selectedButton.partCategoryID == -2)
                  {
                     selectedButton = _loc5_;
                  }
               }
               else
               {
                  _loc5_.txt = _loc3_.childNodes[_loc2_].firstChild;
               }
               _loc5_.partCategoryID = Number(_loc3_.childNodes[_loc2_].attributes.i);
               _loc5_.price = Number(_loc3_.childNodes[_loc2_].attributes.p);
               _loc5_.pointPrice = Number(_loc3_.childNodes[_loc2_].attributes.pp);
               _loc5_.onRollOver = function()
               {
                  setHiAnim(menuMC.shopMenu.hiRO1,this._y - menuMC._y - menuMC.shopMenu._y);
               };
               _loc5_.onRollOut = _loc5_.onDragOut = function()
               {
                  setHiAnim(menuMC.shopMenu.hiRO1,menuMC.shopMenu.hiRO1.by);
               };
               if(isPartCategoryInstalled(carXML.firstChild,_loc5_.partCategoryID))
               {
                  _loc5_.onRelease = function()
                  {
                     resetMenu();
                     this.fld.setTextFormat(tfNA);
                     setHiAnim(menuMC.shopMenu.hiSel1,this._y - menuMC._y - menuMC.shopMenu._y);
                     selectedButton = this;
                     updatePriceDescription();
                  };
               }
               else
               {
                  _loc5_.fld.setTextFormat(tfNA);
               }
               paintMenuArray.push(_loc5_);
            }
         }
         _loc2_ += 1;
      }
   }
   updatePriceDescription();
}
function resetMenu()
{
   var _loc1_ = 0;
   while(_loc1_ < paintMenuArray.length)
   {
      if(isPartCategoryInstalled(carXML.firstChild,paintMenuArray[_loc1_].partCategoryID))
      {
         paintMenuArray[_loc1_].fld.setTextFormat(tfInit);
      }
      _loc1_ += 1;
   }
}
function updatePriceDescription()
{
   if(selectedButton)
   {
      priceDescription.text = selectedButton.txt + ": ($" + selectedButton.price + ")";
   }
   else
   {
      priceDescription.text = "";
   }
}
function isPartCategoryInstalled(xml, pid)
{
   if(pid < 0)
   {
      return true;
   }
   var _loc3_ = 0;
   while(_loc3_ < xml.childNodes.length)
   {
      if(Number(xml.childNodes[_loc3_].attributes.ci) == pid && Number(xml.childNodes[_loc3_].attributes["in"]) == 1)
      {
         return true;
      }
      _loc3_ += 1;
   }
   return false;
}
function addToCart(clr)
{
   var _loc2_ = undefined;
   var _loc3_ = undefined;
   var _loc4_ = undefined;
   var _loc5_ = undefined;
   if(selectedButton)
   {
      if(selectedButton.partCategoryID == -2)
      {
         if(cartArray.length > 0)
         {
            if(cartArray[0].partCategoryID != -2)
            {
               cartArray = new Array();
            }
            cloneCarXML();
         }
      }
      else if(cartArray.length == 1)
      {
         if(cartArray[0].partCategoryID == -2)
         {
            cartArray = new Array();
            cloneCarXML();
         }
      }
      _loc2_ = false;
      i = 0;
      while(i < cartArray.length)
      {
         if(cartArray[i].partCategoryID == selectedButton.partCategoryID)
         {
            _loc3_ = new Object();
            _loc3_.partCategoryID = selectedButton.partCategoryID;
            _loc3_.price = selectedButton.price;
            _loc3_.pointPrice = selectedButton.pointPrice;
            _loc3_.paintColor = clr;
            cartArray[i] = _loc3_;
            _loc2_ = true;
            break;
         }
         i++;
      }
      if(!_loc2_)
      {
         _loc3_ = new Object();
         _loc3_.partCategoryID = selectedButton.partCategoryID;
         _loc3_.price = selectedButton.price;
         _loc3_.pointPrice = selectedButton.pointPrice;
         _loc3_.paintColor = clr;
         cartArray.push(_loc3_);
      }
      _loc4_ = 0;
      _loc5_ = 0;
      var _loc6_ = 0;
      while(_loc6_ < cartArray.length)
      {
         _loc4_ += cartArray[_loc6_].price;
         _loc5_ += cartArray[_loc6_].pointPrice;
         _loc6_ = _loc6_ + 1;
      }
      priceGroup.fldPrice.autoSize = true;
      priceGroup.txtPrice = "$" + _loc4_;
      if(priceGroup.fldPrice._width > 109)
      {
         priceGroup.fldPrice._xscale = 10900 / priceGroup.fldPrice._width;
         priceGroup.fldPrice._yscale = priceGroup.fldPrice._yscale;
      }
      pointsGroup.fldPoints.autoSize = true;
      pointsGroup.txtPoints = _loc5_;
      if(pointsGroup.fldPoints._width > 74)
      {
         pointsGroup.fldPoints._xscale = 7400 / pointsGroup.fldPoints._width;
         pointsGroup.fldPoints._yscale = pointsGroup.fldPoints._yscale;
      }
   }
   paintCar(clr);
}
function paintCar(clr)
{
   var _loc2_ = Number(selectedButton.partCategoryID);
   var _loc3_ = undefined;
   if(_loc2_ == -2)
   {
      cloneXML.firstChild.attributes.cc = clr;
      for(var _loc4_ in cloneXML.firstChild.childNodes)
      {
         trace("checking :" + _loc4_);
         _loc3_ = cloneXML.firstChild.childNodes[_loc4_].attributes;
         if(_loc3_["in"] == 1 && classes.CarSpecs.isPaintable(Number(_loc3_.ci)))
         {
            trace("coloring: " + _loc3_.ci);
            _loc3_.cc = clr;
         }
      }
   }
   else if(_loc2_ == -1)
   {
      cloneXML.firstChild.attributes.cc = clr;
   }
   else
   {
      for(_loc4_ in cloneXML.firstChild.childNodes)
      {
         _loc3_ = cloneXML.firstChild.childNodes[_loc4_].attributes;
         if(_loc3_["in"] == 1 && Number(_loc3_.ci) == _loc2_)
         {
            _loc3_.cc = clr;
         }
      }
   }
   classes.Drawing.clearThisCarsBmps(carHolder);
   classes.Drawing.carView(carHolder,cloneXML,100,!isBack ? "front" : "back");
}
function checkOut(paymentType)
{
   var _loc3_ = "";
   var _loc4_ = 0;
   while(_loc4_ < cartArray.length)
   {
      _loc3_ += cartArray[_loc4_].partCategoryID + "~" + cartArray[_loc4_].paintColor;
      if(_loc4_ + 1 < cartArray.length)
      {
         _loc3_ += ",";
      }
      _loc4_ += 1;
   }
   if(_loc3_.length > 0)
   {
      _root.buyPaint(accountCarID,escape(_loc3_),paymentType,cartArray);
   }
}
function setHiAnim(_mc, ty)
{
   _mc.ty = ty;
   _mc.onEnterFrame = function()
   {
      if(Math.abs(this.ty - this._y) > 0.1)
      {
         this._y += (this.ty - this._y) / 3;
      }
      else
      {
         this._y = this.ty;
         delete this.onEnterFrame;
      }
   };
}
function startBuyPaint(paymentType, amt)
{
   trace("STARTBUY");
   trace(cartArray.length);
   i = 0;
   while(i < cartArray.length)
   {
      for(§each§ in cartArray[i])
      {
         trace(eval("each") + ": " + cartArray[i][eval("each")]);
      }
      i++;
   }
   _root.attachMovie("alertBuyCar","abc",_root.getNextHighestDepth());
   _root.abc.addButton("OK",true);
   _root.abc.addButton("Cancel");
   _root.abc.contentMC.txtName = "Buying Paint Job";
   _root.abc.contentMC.alertIconMC._visible = false;
   _root.abc.contentMC.txtTitle = "Buying Paint Job";
   _root.abc.contentMC.createEmptyMovieClip("viewThumb",_root.abc.contentMC.getNextHighestDepth());
   _root.abc.contentMC.viewThumb._x = 264;
   _root.abc.contentMC.viewThumb._y = 143;
   _root.abc.thumb = new BitmapData(160,100,true,0);
   var _loc5_ = new flash.geom.Matrix(0.25,0,0,0.25,0,0);
   _root.abc.thumb.draw(carHolder,_loc5_,new ColorTransform(),"normal",null,true);
   _root.abc.contentMC.viewThumb.attachBitmap(_root.abc.thumb,0,"auto",true);
   _root.abc.contentMC.fldPrice.autoSize = "right";
   if(paymentType == "m")
   {
      _root.abc.contentMC.txtPrice = "$" + amt;
      _root.abc.contentMC.pointsIcon._visible = false;
      _root.abc.contentMC.txtMsg = "You have chosen to pay with your Funds. This will deduct " + amt + " from your funds.  Are you sure you want to buy this paint job?";
   }
   else
   {
      _root.abc.contentMC.txtPrice = amt + " Points";
      _root.abc.contentMC.pointsIcon._x = _root.abc.contentMC.fldPrice._x - _root.abc.contentMC.pointsIcon._width - 3;
      _root.abc.contentMC.txtMsg = "You have chosen to pay with your Points. This will deduct " + amt + " from your Points balance.  Are you sure you want to buy this paint job?";
   }
   var _loc4_ = new Object();
   _loc4_.onRelease = function(theButton, keepBoxOpen)
   {
      switch(theButton.btnLabel.text)
      {
         case "OK":
            checkOut(paymentType);
            _root.abc.removeButtons();
            _root.abc.addDisabledButton("Cancel");
            _root.abc.addDisabledButton("OK");
            break;
         case "Cancel":
      }
      if(!keepBoxOpen)
      {
         false;
         theButton._parent._parent.closeMe();
      }
   };
   _root.abc.addListener(_loc4_);
}
function afterDialogSelectCar()
{
   cc.garbageCollect();
   _parent.sectionName = "paint";
   _parent.locationID = locationID;
   _parent.gotoAndPlay(1);
}
