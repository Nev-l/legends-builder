function updateShopLocation()
{
   if(locationID >= 300)
   {
      shopName = "CPR Dealer";
      cprLocLogo._visible = true;
   }
   else
   {
      shopName = "Tires";
      cprLocLogo._visible = false;
   }
}
function clearCar()
{
   image_mc.clearCarView();
   for(var _loc1_ in image_mc)
   {
      image_mc[_loc1_].removeMovieClip();
   }
   classes.Drawing.clearThisCarsBmps(image_mc);
}
function gotoShowroom(d)
{
   partOwnAndUninstalledXML.parseXML(d);
   gotoAndStop("showroom");
   play();
}
function onShopPartClick(pid, t)
{
   var _loc4_ = undefined;
   var _loc5_ = undefined;
   var _loc6_ = undefined;
   if(pid == 22)
   {
      if(shoppingFor == "Engine")
      {
         _root.displayAlert("warning","Engine Must be Installed","You must install the engine to modify the gear ratios.");
      }
      else
      {
         front_back._visible = false;
         partImg._visible = brandImg._visible = false;
         _root.getGearInfo(selectedCarXML.firstChild.attributes.i);
      }
   }
   else
   {
      if(shoppingFor == "Car")
      {
         front_back._visible = true;
      }
      partImg._visible = brandImg._visible = true;
      gear_ratio._visible = false;
      selPartXML = undefined;
      _loc4_ = 0;
      while(_loc4_ < _global.partXML.firstChild.childNodes.length)
      {
         if(_global.partXML.firstChild.childNodes[_loc4_].attributes.i == pid && _global.partXML.firstChild.childNodes[_loc4_].attributes.t == t)
         {
            selPartXML = _global.partXML.firstChild.childNodes[_loc4_];
            trace(selPartXML);
            break;
         }
         _loc4_ += 1;
      }
      if(selPartXML != undefined)
      {
         if(shoppingFor != "Engine")
         {
            if(classes.CarSpecs.isVisible(selPartXML.attributes.pi))
            {
               showPartOnCar(selPartXML);
            }
         }
         _loc5_ = new classes.PartThumbnail(partImg,selPartXML.attributes.pi,selPartXML.attributes.i,selPartXML.attributes.t,selPartXML.attributes.di);
         false;
         brandImg.loadMovie("cache/brands/" + selPartXML.attributes.b + ".swf");
         partDetail.txtName = selPartXML.attributes.n;
         partDetail.fldDescription.text = "";
         _root.getPartDescription(pid,t);
         partDetail.fldDescription.setTextFormat(tfPlain);
         _loc6_ = Number(selPartXML.attributes.p);
         if(_loc6_ >= 0)
         {
            partDetail.priceGroup._visible = true;
            partDetail.priceGroup.txtPrice = "$" + classes.NumFuncs.commaFormat(selPartXML.attributes.p);
         }
         else
         {
            partDetail.priceGroup._visible = false;
         }
         _loc6_ = Number(selPartXML.attributes.pp);
         if(_loc6_ >= 0)
         {
            partDetail.pointsGroup._visible = true;
            partDetail.pointsGroup.txtPoints = classes.NumFuncs.commaFormat(selPartXML.attributes.pp);
         }
         else
         {
            partDetail.pointsGroup._visible = false;
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
      }
   }
}
function showPartOnCar(tPartXML)
{
   cloneXML = new XML(selectedCarXML.toString());
   var _loc2_ = "";
   if(isBack)
   {
      _loc2_ = "_back";
   }
   var _loc3_ = new XMLNode(1,"p");
   _loc3_.attributes.i = tPartXML.attributes.i;
   _loc3_.attributes.ci = tPartXML.attributes.pi;
   _loc3_.attributes.n = tPartXML.attributes.n;
   _loc3_.attributes.ps = tPartXML.attributes.ps;
   _loc3_.attributes.cc = 0;
   _loc3_.attributes["in"] = 1;
   _loc3_.attributes.di = tPartXML.attributes.di;
   _loc3_.attributes.pt = tPartXML.attributes.t;
   cloneXML.firstChild.appendChild(_loc3_);
   clearCar();
   classes.Drawing.carView(image_mc,cloneXML,100,!isBack ? "front" : "back");
   front_back._visible = true;
   bg.ta = 100;
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
      _root.abc.contentMC.brandImg.loadMovie("cache/brands/" + selPartXML.attributes.b + ".swf");
      _root.abc.contentMC.fldPrice.autoSize = "right";
      if(paymentType == "m")
      {
         _root.abc.contentMC.txtPrice = "$" + classes.NumFuncs.commaFormat(selPartXML.attributes.p);
         _root.abc.contentMC.pointsIcon._visible = false;
         if(selPartXML.attributes.t == "m")
         {
            _root.abc.contentMC.txtMsg = "You have chosen to buy this engine with your Funds. Buying the " + selPartXML.attributes.n + " will deduct " + _root.abc.contentMC.txtPrice + " from your funds and automatically uninstall your current engine along with all parts associated to it.  Are you sure you want to buy this engine?";
         }
         else
         {
            _root.abc.contentMC.txtMsg = "You have chosen to buy this part with your Funds. Buying the " + selPartXML.attributes.n + " will deduct " + _root.abc.contentMC.txtPrice + " from your funds.  Are you sure you want to buy this part?";
         }
      }
      else
      {
         _root.abc.contentMC.txtPrice = classes.NumFuncs.commaFormat(selPartXML.attributes.pp) + " Points";
         _root.abc.contentMC.pointsIcon._x = _root.abc.contentMC.fldPrice._x - _root.abc.contentMC.pointsIcon._width - 3;
         if(selPartXML.attributes.t == "m")
         {
            _root.abc.contentMC.txtMsg = "You have chosen to buy this part with your Points. Buying the " + selPartXML.attributes.n + " will deduct " + classes.NumFuncs.commaFormat(selPartXML.attributes.pp) + " from your Points balance and automatically uninstall your current engine along with all parts associated to it.  Are you sure you want to buy this engine?";
         }
         else
         {
            _root.abc.contentMC.txtMsg = "You have chosen to buy this part with your Points. Buying the " + selPartXML.attributes.n + " will deduct " + classes.NumFuncs.commaFormat(selPartXML.attributes.pp) + " from your Points balance.  Are you sure you want to buy this part?";
         }
      }
      _loc4_ = new Object();
      _loc4_.owner = this;
      trace("shoppingFor = " + shoppingFor);
      trace("shoppingFor = " + this.shoppingFor);
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
                  _root.buyPart(selectedCarXML.firstChild.attributes.i,selPartXML.attributes.i,paymentType,partType);
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
   var _loc2_ = new XMLNode(1,"p");
   _loc2_.attributes.ai = ai;
   _loc2_.attributes.i = selPartXML.attributes.i;
   _loc2_.attributes.ci = selPartXML.attributes.pi;
   _loc2_.attributes.n = selPartXML.attributes.n;
   _loc2_.attributes.ps = selPartXML.attributes.ps;
   _loc2_.attributes["in"] = 1;
   _loc2_.attributes.cc = 0;
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
function afterDialogSelectCar()
{
   cc.garbageCollect();
   _parent.sectionName = "wheels";
   _parent.locationID = locationID;
   bg.ta = 100;
   gotoAndStop("retrieve");
   play();
}
