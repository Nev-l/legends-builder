function clearCar()
{
   image_mc.clearCarView();
   for(var _loc1_ in image_mc)
   {
      image_mc[_loc1_].removeMovieClip();
   }
   classes.Drawing.clearThisCarsBmps(image_mc);
}
function cloneGarageCar()
{
   selectedCarXML = new XML(classes.GlobalData.getSelectedCarXML().toString());
   cloneXML = new XML(selectedCarXML.toString());
   image_mc.removeMovieClip();
   this.createEmptyMovieClip("image_mc",this.getNextHighestDepth());
   image_mc._x = 192;
   image_mc._y = 100;
   classes.Drawing.carView(image_mc,cloneXML,100,!isBack ? "front" : "back");
}
function gotoShowroom(d)
{
   partOwnAndUninstalledXML.parseXML(d);
   gotoAndStop("showroom");
   play();
}
function onShopPartClick(pid, t)
{
   trace("onShopPartClick: " + pid + ", " + t);
   image_mc._visible = true;
   front_back._visible = true;
   var _loc6_ = undefined;
   if(pid == 22 && t != "m")
   {
      partDetail.mo._visible = false;
      if(shoppingFor == "Engine")
      {
         _root.displayAlert("warning","Engine Must be Installed","You must install the engine to modify the gear ratios.");
      }
      else
      {
         front_back._visible = false;
         partImg._visible = brandImg._visible = false;
         browseGraphics._visible = false;
         browseGaugeGraphics._visible = false;
         shopUGGGroup._visible = false;
         _root.getGearInfo(selectedCarXML.firstChild.attributes.i);
      }
   }
   else if(pid == 159)
   {
      partDetail.mo._visible = false;
      partImg._visible = brandImg._visible = false;
      browseGraphics._visible = false;
      browseGaugeGraphics._visible = false;
      gear_ratio._visible = false;
      shopUGGGroup._visible = true;
      shopUGGGroup.init();
      initUGGPurchase();
   }
   else
   {
      if(shoppingFor == "Car")
      {
         front_back._visible = true;
      }
      partImg._visible = brandImg._visible = true;
      gear_ratio._visible = false;
      shopUGGGroup._visible = false;
      selPartXML = undefined;
      if(pid == 146 || pid >= 148 && pid <= 151)
      {
         browseGaugeGraphics._visible = false;
         browseGraphics.init(pid);
         selPartXML = undefined;
         partDetail._visible = false;
         partImg._visible = false;
         brandImg.unloadMovie();
      }
      else if(pid == 172)
      {
         image_mc._visible = false;
         front_back._visible = false;
         browseGraphics._visible = false;
         loadThisFile = "cache/car/rc.swf";
         this.createEmptyMovieClip("rcHolder",this.getNextHighestDepth());
         var _loc7_ = new Object();
         _loc7_.onLoadInit = function(target_mc)
         {
            trace("rc.swf loaded");
            target_mc._visible = false;
            target_mc.showLeft(true);
            target_mc.left.isRace(false);
            browseGaugeGraphics.gaugePreview = target_mc.left;
            delete rc_mcl;
            delete mclListener;
            browseGaugeGraphics.init(172);
         };
         _loc7_.onLoadError = function(target_mc)
         {
            _root.displayAlert("warning","Missing Files","A file is missing from your cache folder:\r\r" + loadThisFile + "\r\rThe game will not function without this file.  Please close the game and re-install it by running the original installer.  Or you can download the latest installer at www.NittoLegends.com.  Note: Re-installing will not affect your account in any way.  You may continue to use your existing account.");
         };
         var _loc8_ = new MovieClipLoader();
         _loc8_.addListener(_loc7_);
         _loc8_.loadClip(loadThisFile,browseGaugeGraphics.gaugeHolder);
      }
      else
      {
         browseGraphics._visible = false;
         browseGaugeGraphics._visible = false;
         _loc6_ = 0;
         while(_loc6_ < _global.partXML.firstChild.childNodes.length)
         {
            if(_global.partXML.firstChild.childNodes[_loc6_].attributes.i == pid && _global.partXML.firstChild.childNodes[_loc6_].attributes.t == t)
            {
               selPartXML = _global.partXML.firstChild.childNodes[_loc6_];
               break;
            }
            _loc6_ += 1;
         }
         showPartPreview(pid,t);
      }
   }
}
function showPartPreview(pid, t)
{
   var _loc3_ = undefined;
   var _loc4_ = undefined;
   if(selPartXML != undefined)
   {
      if(shoppingFor != "Engine")
      {
         if(classes.CarSpecs.isVisible(selPartXML.attributes.pi))
         {
            showPartOnCar(selPartXML);
         }
      }
      _loc3_ = new classes.PartThumbnail(partImg,selPartXML.attributes.pi,selPartXML.attributes.i,selPartXML.attributes.t,selPartXML.attributes.di);
      false;
      if(selPartXML.attributes.pi == 165)
      {
         partImg._x = 1;
         partImg._y = 269;
      }
      else
      {
         partImg._x = 18;
         partImg._y = 338;
      }
      brandImg.loadMovie("cache/brands/" + selPartXML.attributes.b + ".swf");
      partDetail.txtName = selPartXML.attributes.n;
      partDetail.fldDescription.text = "";
      _root.getPartDescription(pid,t);
      partDetail.fldDescription.setTextFormat(tfPlain);
      _loc4_ = Number(selPartXML.attributes.p);
      if(_loc4_ >= 0)
      {
         partDetail.priceGroup._visible = true;
         partDetail.priceGroup.txtPrice = "$" + classes.NumFuncs.commaFormat(selPartXML.attributes.p);
      }
      else
      {
         partDetail.priceGroup._visible = false;
      }
      _loc4_ = Number(selPartXML.attributes.pp);
      if(_loc4_ >= 0)
      {
         partDetail.pointsGroup._visible = true;
         partDetail.pointsGroup.txtPoints = classes.NumFuncs.commaFormat(selPartXML.attributes.pp);
      }
      else
      {
         partDetail.pointsGroup._visible = false;
      }
      if(selPartXML.attributes.mo == 1)
      {
         partDetail.mo._visible = true;
      }
      else
      {
         partDetail.mo._visible = false;
      }
      partDetail._visible = true;
      partDetail.priceGroup.togBuy.onRelease = function()
      {
         startBuyPart("m",t);
      };
      partDetail.pointsGroup.togBuy.onRelease = function()
      {
         startBuyPart("p",t);
      };
   }
   else
   {
      partDetail._visible = false;
      brandImg.unloadMovie();
      clearCar();
      classes.Drawing.carView(image_mc,cloneXML,100,!isBack ? "front" : "back");
   }
}
function showPartOnCar(tPartXML)
{
   cloneXML = new XML(selectedCarXML.toString());
   for(var _loc2_ in cloneXML.firstChild.childNodes)
   {
      if(cloneXML.firstChild.childNodes[_loc2_].attributes.ci == tPartXML.attributes.pi)
      {
         cloneXML.firstChild.childNodes[_loc2_].removeNode();
      }
   }
   var _loc3_ = "";
   if(isBack)
   {
      _loc3_ = "_back";
   }
   var _loc4_ = new XMLNode(1,"p");
   _loc4_.attributes.i = tPartXML.attributes.i;
   _loc4_.attributes.ci = tPartXML.attributes.pi;
   _loc4_.attributes.n = tPartXML.attributes.n;
   _loc4_.attributes.ps = tPartXML.attributes.ps;
   if(tPartXML.attributes.cc != undefined)
   {
      _loc4_.attributes.cc = tPartXML.attributes.cc;
   }
   else
   {
      _loc4_.attributes.cc = 0;
   }
   _loc4_.attributes["in"] = 1;
   _loc4_.attributes.pdi = tPartXML.attributes.pdi;
   _loc4_.attributes.di = tPartXML.attributes.di;
   _loc4_.attributes.pt = tPartXML.attributes.t;
   cloneXML.firstChild.appendChild(_loc4_);
   clearCar();
   classes.Drawing.carView(image_mc,cloneXML,100,!isBack ? "front" : "back");
}
function previewCustomGraphics()
{
   cloneXML = new XML(selectedCarXML.toString());
   var _loc1_ = new Array(151,149,148,150);
   var _loc3_ = 0;
   while(_loc3_ < _loc1_.length)
   {
      if(!shopUGGGroup["path" + _loc1_[_loc3_]].length)
      {
         _loc1_.splice(_loc3_,1);
         _loc3_ -= 1;
      }
      _loc3_ += 1;
   }
   for(var _loc4_ in cloneXML.firstChild.childNodes)
   {
      _loc3_ = 0;
      while(_loc3_ < _loc1_.length)
      {
         if(cloneXML.firstChild.childNodes[_loc4_].attributes.ci == _loc1_[_loc3_] || cloneXML.firstChild.childNodes[_loc4_].attributes.ci == _loc1_[_loc3_] + 12)
         {
            cloneXML.firstChild.childNodes[_loc4_].removeNode();
         }
         _loc3_ += 1;
      }
   }
   var _loc5_ = "";
   if(isBack)
   {
      _loc5_ = "_back";
   }
   _loc3_ = 0;
   var _loc2_;
   while(_loc3_ < _loc1_.length)
   {
      _loc2_ = new XMLNode(1,"p");
      _loc2_.attributes.i = 1;
      _loc2_.attributes.ci = _loc1_[_loc3_];
      _loc2_.attributes.n = "";
      _loc2_.attributes.ps = 0;
      _loc2_.attributes.cc = 0;
      _loc2_.attributes["in"] = 1;
      _loc2_.attributes.pdi = 1;
      _loc2_.attributes.di = 1;
      _loc2_.attributes.localPath = shopUGGGroup["loadin" + _loc1_[_loc3_]];
      cloneXML.firstChild.appendChild(_loc2_);
      _loc3_ += 1;
   }
   clearCar();
   classes.Drawing.carView(image_mc,cloneXML,100,!isBack ? "front" : "back",undefined,5000);
   initUGGPurchase();
}
function startBuyPart(paymentType, partType)
{
   var _loc3_ = undefined;
   var _loc4_ = undefined;
   if(paymentType == "m" && locationID > Number(classes.GlobalData.attr.lid))
   {
      classes.Control.dialogAlert("Can Not Use Game Cash","Sorry, you can not currently buy from this store using Game Cash.  You must live at or above this neighborhood (" + classes.Lookup.homeName(locationID) + ") in order to buy with Game Cash.\r\rTip: You can use Points to purchase any product in any neighborhood.");
   }
   else
   {
      _root.attachMovie("alertBuyPart","abc",_root.getNextHighestDepth());
      _root.abc.addButton("OK",true);
      _root.abc.addButton("Cancel");
      _root.abc.contentMC.txtName = selPartXML.attributes.n;
      _root.abc.contentMC.alertIconMC.gotoAndStop("shop");
      _root.abc.contentMC.txtTitle = "Purchasing part";
      _loc3_ = new classes.PartThumbnail(_root.abc.contentMC.partImg,selPartXML.attributes.pi,selPartXML.attributes.i,selPartXML.attributes.t,selPartXML.attributes.di);
      false;
      if(selPartXML.attributes.pi == 165)
      {
         _root.abc.contentMC.partImg._xscale = _root.abc.contentMC.partImg._yscale = 45;
      }
      else if(selPartXML.attributes.pi == 167)
      {
         _root.abc.contentMC.partImg._xscale = _root.abc.contentMC.partImg._yscale = 45;
         _root.abc.contentMC.partImg._x += 10;
         _root.abc.contentMC.partImg._y += 20;
      }
      else if(selPartXML.attributes.pi == 169)
      {
         _root.abc.contentMC.partImg._xscale = _root.abc.contentMC.partImg._yscale = 60;
         _root.abc.contentMC.partImg._x += 20;
         _root.abc.contentMC.partImg._y += 20;
      }
      else if(selPartXML.attributes.pi == 168)
      {
         _root.abc.contentMC.partImg._xscale = _root.abc.contentMC.partImg._yscale = 60;
         _root.abc.contentMC.partImg._y += 20;
      }
      else
      {
         _root.abc.contentMC.partImg._xscale = _root.abc.contentMC.partImg._yscale = 100;
      }
      _root.abc.contentMC.brandImg.loadMovie("cache/brands/" + selPartXML.attributes.b + ".swf");
      _root.abc.contentMC.fldPrice.autoSize = "right";
      if(paymentType == "m")
      {
         _root.abc.contentMC.txtPrice = "$" + classes.NumFuncs.commaFormat(selPartXML.attributes.p);
         _root.abc.contentMC.pointsIcon._visible = false;
         if(selPartXML.attributes.t == "m")
         {
            _root.abc.contentMC.txtMsg = "Buying the " + selPartXML.attributes.n + " engine will deduct " + _root.abc.contentMC.txtPrice + " from your funds.  Your current engine and all of its parts will be uninstalled and placed in your spare parts bin.  Are you sure you want to buy this engine?";
         }
         else
         {
            _root.abc.contentMC.txtMsg = "Buying the " + selPartXML.attributes.n + " will deduct " + _root.abc.contentMC.txtPrice + " from your funds.  Are you sure you want to buy this part?";
         }
      }
      else
      {
         _root.abc.contentMC.txtPrice = classes.NumFuncs.commaFormat(selPartXML.attributes.pp) + " Points";
         _root.abc.contentMC.pointsIcon._x = _root.abc.contentMC.fldPrice._x - _root.abc.contentMC.pointsIcon._width - 3;
         if(selPartXML.attributes.t == "m")
         {
            _root.abc.contentMC.txtMsg = "Buying the " + selPartXML.attributes.n + " engine will deduct " + classes.NumFuncs.commaFormat(selPartXML.attributes.pp) + " from your Points balance.  Your current engine and all of its parts will be uninstalled and placed in your spare parts bin.  Are you sure you want to buy this engine?";
         }
         else
         {
            _root.abc.contentMC.txtMsg = "Buying the " + selPartXML.attributes.n + " will deduct " + classes.NumFuncs.commaFormat(selPartXML.attributes.pp) + " from your Points balance.  Are you sure you want to buy this part?";
         }
      }
      _loc4_ = new Object();
      _loc4_.owner = this;
      _loc4_.onRelease = function(theButton, keepBoxOpen)
      {
         switch(theButton.btnLabel.text)
         {
            case "OK":
               trace("shoppingFor = " + this.owner.shoppingFor);
               if(this.owner.shoppingFor == "Engine")
               {
                  _root.engineBuyPart(selPartXML.attributes.i,paymentType);
               }
               else
               {
                  _root.buyPart(selectedCarXML.firstChild.attributes.i,selPartXML.attributes.i,paymentType,partType,selPartXML.attributes.pvid,selPartXML.attributes.cc);
               }
               _root.abc.removeButtons();
               _root.abc.addDisabledButton("OK");
               _root.abc.addDisabledButton("Cancel");
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
}
function installCartPart(ai)
{
   trace("installCartPart: " + ai);
   var _loc2_ = new XMLNode(1,"p");
   _loc2_.attributes.ai = ai;
   _loc2_.attributes.i = selPartXML.attributes.i;
   _loc2_.attributes.ci = selPartXML.attributes.pi;
   _loc2_.attributes.n = selPartXML.attributes.n;
   _loc2_.attributes.ps = selPartXML.attributes.ps;
   _loc2_.attributes.sl = 10000;
   _loc2_.attributes["in"] = 1;
   if(selPartXML.attributes.cc != undefined)
   {
      _loc2_.attributes.cc = selPartXML.attributes.cc;
   }
   else
   {
      _loc2_.attributes.cc = 0;
   }
   _loc2_.attributes.pdi = selPartXML.attributes.pdi;
   _loc2_.attributes.di = selPartXML.attributes.di;
   _loc2_.attributes.pt = selPartXML.attributes.t;
   var _loc3_ = classes.GlobalData.getSelectedCarXML();
   var _loc4_ = 0;
   var _loc5_ = undefined;
   while(_loc4_ < _loc3_.childNodes.length)
   {
      if(_loc3_.childNodes[_loc4_].attributes.ci == selPartXML.attributes.pi || selPartXML.attributes.t == "m")
      {
         _loc5_ = new XMLNode(1,"p");
         _loc5_.attributes.i = _loc3_.childNodes[_loc4_].attributes.i;
         _loc5_.attributes.t = _loc3_.childNodes[_loc4_].attributes.pt;
         partOwnAndUninstalledXML.firstChild.appendChild(_loc5_);
         _loc3_.childNodes[_loc4_].removeNode();
      }
      _loc4_ += 1;
   }
   _loc3_.appendChild(_loc2_);
   selectedCarXML = new XML(classes.GlobalData.getSelectedCarXML().toString());
   clearCart();
}
function partBoughtButNotInstalled()
{
   var _loc1_ = new XMLNode(1,"p");
   _loc1_.attributes.i = selPartXML.attributes.i;
   _loc1_.attributes.t = selPartXML.attributes.t;
   partOwnAndUninstalledXML.firstChild.appendChild(_loc1_);
}
function clearCart()
{
   delete selPartXML;
   gotoAndStop("retrieve");
   play();
}
function afterBuyEngine()
{
   delete selPartXML;
   classes.Lookup.addCallback("getOneCar",this,cb_getCarAfterEngine,String(selAcid));
   _root.getOneCar(selAcid);
}
function cb_getCarAfterEngine(pxml)
{
   trace("cb_getCarAfterEngine...");
   trace(pxml);
   classes.GlobalData.replaceCarNode(pxml.toString());
   clearCart();
}
function afterDialogSelectCar()
{
   cc.garbageCollect();
   _parent.sectionName = "parts";
   _parent.locationID = locationID;
   _parent.gotoAndPlay(1);
}
function afterDialogSelectEngine(aeid)
{
   cc.garbageCollect();
   _parent.sectionName = "parts";
   _parent.locationID = locationID;
   if(aeid != selAeid)
   {
      selAeid = aeid;
      gotoAndStop("retrieveEngine");
      play();
   }
   else
   {
      gotoAndStop("showroom");
      play();
   }
}
function showGearRatio(d)
{
   var _loc3_ = new XML();
   _loc3_.ignoreWhite = true;
   _loc3_.parseXML(d);
   gear_ratio.g1.text = _loc3_.firstChild.firstChild.attributes.g1;
   gear_ratio.g2.text = _loc3_.firstChild.firstChild.attributes.g2;
   gear_ratio.g3.text = _loc3_.firstChild.firstChild.attributes.g3;
   gear_ratio.g4.text = _loc3_.firstChild.firstChild.attributes.g4;
   gear_ratio.g5.text = _loc3_.firstChild.firstChild.attributes.g5;
   gear_ratio.g6.text = _loc3_.firstChild.firstChild.attributes.g6;
   gear_ratio.fg.text = _loc3_.firstChild.firstChild.attributes.fg;
   gear_ratio._visible = true;
   partDetail.txtName = "Custom Gear Ratio";
   partDetail.txtDescription = "Custom Gear Ratio allows you to modify your gears. This purchase is non-refundable and non-reversible. Modifying gear ratios will let your car reach the desired speed faster.";
   partDetail.fldDescription.setTextFormat(tfPlain);
   var _loc4_ = Number(_global.gearsXML.firstChild.attributes.p);
   if(_loc4_ >= 0)
   {
      partDetail.priceGroup._visible = true;
      partDetail.priceGroup.txtPrice = "$" + classes.NumFuncs.commaFormat(_loc4_);
   }
   else
   {
      partDetail.priceGroup._visible = false;
   }
   _loc4_ = Number(_global.gearsXML.firstChild.attributes.pp);
   if(_loc4_ >= 0)
   {
      partDetail.pointsGroup._visible = true;
      partDetail.pointsGroup.txtPoints = classes.NumFuncs.commaFormat(_loc4_);
   }
   else
   {
      partDetail.pointsGroup._visible = false;
   }
   partDetail._visible = true;
   partDetail.priceGroup.togBuy.onRelease = function()
   {
      startBuyGears("m");
   };
   partDetail.pointsGroup.togBuy.onRelease = function()
   {
      startBuyGears("p");
   };
}
function startBuyGears(paymentType)
{
   _root.attachMovie("alertBuyPart","abc",_root.getNextHighestDepth());
   _root.abc.addButton("OK",true);
   _root.abc.addButton("Cancel");
   _root.abc.contentMC.txtName = "Custom Gear Ratio";
   _root.abc.contentMC.alertIconMC.gotoAndStop("shop");
   _root.abc.contentMC.txtTitle = "Purchasing part";
   var _loc4_ = new classes.PartThumbnail(_root.abc.contentMC.partImg,22,0,"e");
   false;
   _root.abc.contentMC.fldPrice.autoSize = "right";
   if(paymentType == "m")
   {
      _root.abc.contentMC.txtPrice = "$" + classes.NumFuncs.commaFormat(_global.gearsXML.firstChild.attributes.p);
      _root.abc.contentMC.pointsIcon._visible = false;
      _root.abc.contentMC.txtMsg = "You have chosen to buy this part with your Funds. Buying the Custom Gear Ratio will deduct " + _global.gearsXML.firstChild.attributes.p + " from your funds.  Are you sure you want to buy this part?";
   }
   else
   {
      _root.abc.contentMC.txtPrice = classes.NumFuncs.commaFormat(_global.gearsXML.firstChild.attributes.pp) + " Points";
      _root.abc.contentMC.pointsIcon._x = _root.abc.contentMC.fldPrice._x - _root.abc.contentMC.pointsIcon._width - 3;
      _root.abc.contentMC.txtMsg = "You have chosen to buy this part with your Points. Buying the Custom Gear Ratio will deduct " + _global.gearsXML.firstChild.attributes.pp + " from your Points balance.  Are you sure you want to buy this part?";
   }
   var _loc5_ = new Object();
   _loc5_.owner = this;
   _loc5_.onRelease = function(theButton, keepBoxOpen)
   {
      switch(theButton.btnLabel.text)
      {
         case "OK":
            _root.buyGears(selectedCarXML.firstChild.attributes.i,paymentType,gear_ratio.g1.text,gear_ratio.g2.text,gear_ratio.g3.text,gear_ratio.g4.text,gear_ratio.g5.text,gear_ratio.g6.text,gear_ratio.fg.text);
            _root.abc.removeButtons();
            _root.abc.addDisabledButton("OK");
            _root.abc.addDisabledButton("Cancel");
            break;
         case "Cancel":
      }
      if(!keepBoxOpen)
      {
         false;
         theButton._parent._parent.closeMe();
      }
   };
   _root.abc.addListener(_loc5_);
}
function initUGGPurchase()
{
   partDetail.txtName = "Custom Panel Graphics";
   partDetail.txtDescription = "Apply your own images to your car!\r\rSelect images from your computer to apply to one or more panels of your car (can be Jpeg, PNG or GIF). When you\'re happy with the look, click the \'Buy\' button so the rest of the world can see them!";
   partDetail.fldDescription.setTextFormat(tfPlain);
   partDetail.priceGroup._visible = false;
   partDetail.pointsGroup._visible = true;
   partDetail.pointsGroup.txtPoints = classes.NumFuncs.commaFormat(shopUGGGroup.getCombinedCost());
   partDetail._visible = true;
   partDetail.pointsGroup.togBuy.onRelease = function()
   {
      if(shopUGGGroup.getUggCount())
      {
         startBuyCustomGraphics("p");
      }
      else
      {
         classes.Control.dialogAlert("No Graphics Panel Selected","Please select at least one panel to customize.");
      }
   };
}
function startBuyCustomGraphics(paymentType)
{
   trace("startBuyCustomGraphics... ");
   var _loc2_ = new Object();
   _loc2_.filesize = shopUGGGroup.getCombinedFilesize();
   _loc2_.uggCount = shopUGGGroup.getUggCount();
   _loc2_.uggCost = shopUGGGroup.getCombinedCost();
   classes.Control.dialogContainer("dialogUggUploadContent",_loc2_);
}
