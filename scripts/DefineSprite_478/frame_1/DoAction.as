function onPartClick(ai, t)
{
   mb.hidePanel();
   delete selPartXML;
   var _loc6_ = 0;
   while(_loc6_ < _global.partsBinXML.firstChild.childNodes.length)
   {
      if(Number(_global.partsBinXML.firstChild.childNodes[_loc6_].attributes.ai) == ai && _global.partsBinXML.firstChild.childNodes[_loc6_].attributes.t == t)
      {
         selPartXML = _global.partsBinXML.firstChild.childNodes[_loc6_];
         break;
      }
      _loc6_ += 1;
   }
   var _loc7_ = undefined;
   var _loc8_ = undefined;
   if(selPartXML != undefined)
   {
      _loc7_ = new classes.PartThumbnail(partImg,selPartXML.attributes.pi,selPartXML.attributes.i,selPartXML.attributes.t,selPartXML.attributes.di);
      false;
      partImg._x = 6;
      partImg._y = 225;
      if(selPartXML.attributes.pi == 165)
      {
         partImg._xscale = partImg._yscale = 45;
      }
      else if(selPartXML.attributes.pi == 167 || selPartXML.attributes.pi == 168 || selPartXML.attributes.pi == 169 || selPartXML.attributes.pi == 170)
      {
         partImg._xscale = partImg._yscale = 50;
         partImg._x = 16;
         partImg._y = 240;
         if(selPartXML.attributes.pi == 167)
         {
            partImg._x = 11;
         }
         else if(selPartXML.attributes.pi == 168)
         {
            partImg._y = 245;
         }
         else if(selPartXML.attributes.pi == 169)
         {
            partImg._x = 31;
            partImg._y = 245;
         }
         else if(selPartXML.attributes.pi == 170)
         {
            partImg._x = 31;
         }
      }
      else
      {
         partImg._xscale = partImg._yscale = 100;
      }
      partDetail.txtName = selPartXML.attributes.n;
      _root.getPartDescription(selPartXML.attributes.i,t);
      partDetail.fldDescription.text = "";
      partDetail.fldDescription.setTextFormat(tfPlain);
      partDetail.txtTradeInPrice = "Trade-in Value: $" + classes.NumFuncs.commaFormat(selPartXML.attributes.p);
      switch(Number(selPartXML.attributes.pi))
      {
         case 61:
         case 62:
         case 86:
         case 87:
         case 137:
            _loc8_ = 2;
            break;
         case 81:
         case 82:
            _loc8_ = 3;
            break;
         default:
            _loc8_ = 1;
      }
      if(partType == "Car Parts")
      {
         _parent.redrawCar(selPartXML);
         if(Number(selPartXML.attributes["in"]) == 1)
         {
            if(selPartXML.attributes.t == "m")
            {
               partDetail.btnUninstall._visible = false;
            }
            else
            {
               partDetail.btnUninstall._visible = true;
               _loc6_ = 0;
               while(_loc6_ < _global.partCatXML.firstChild.childNodes.length)
               {
                  if(_global.partCatXML.firstChild.childNodes[_loc6_].attributes.i == selPartXML.attributes.pi)
                  {
                     if(_global.partCatXML.firstChild.childNodes[_loc6_].attributes.r == "1")
                     {
                        partDetail.btnUninstall._visible = false;
                     }
                     break;
                  }
                  _loc6_ += 1;
               }
            }
            partDetail.btnInstall._visible = false;
            partDetail.btnTradeIn._visible = false;
            partDetail.btnInstallTurbo._visible = false;
            partDetail.btnInstallSuper._visible = false;
            partDetail.btnSwapEngine._visible = false;
            if(_loc8_ == currEngineTypeID)
            {
               if(_loc8_ == 1)
               {
                  partDetail.btnUninstallTurbo._visible = false;
                  partDetail.btnUninstallSuper._visible = false;
               }
               else if(_loc8_ == 2)
               {
                  if(selPartXML.attributes.pi == 86)
                  {
                     partDetail.btnUninstallTurbo._visible = false;
                  }
                  else
                  {
                     partDetail.btnUninstallTurbo._visible = true;
                  }
                  partDetail.btnUninstallSuper._visible = false;
               }
               else if(_loc8_ == 3)
               {
                  partDetail.btnUninstallTurbo._visible = false;
                  partDetail.btnUninstallSuper._visible = true;
               }
            }
            else
            {
               partDetail.btnUninstallTurbo._visible = false;
               partDetail.btnUninstallSuper._visible = false;
            }
         }
         else
         {
            partDetail.btnUninstall._visible = false;
            partDetail.btnUninstallTurbo._visible = false;
            partDetail.btnUninstallSuper._visible = false;
            partDetail.btnInstall._visible = false;
            partDetail.btnInstallTurbo._visible = false;
            partDetail.btnInstallSuper._visible = false;
            partDetail.btnSwapEngine._visible = false;
            partDetail.btnTradeIn._visible = true;
            if(selPartXML.attributes.t == "m")
            {
               partDetail.btnSwapEngine._visible = true;
               newEngineID = selPartXML.attributes.ai;
            }
            else if(_loc8_ == 1 || _loc8_ == currEngineTypeID)
            {
               partDetail.btnInstall._visible = true;
            }
            else if(_loc8_ == 2)
            {
               if(currEngineTypeID == 1)
               {
                  partDetail.btnInstallTurbo._visible = true;
               }
            }
            else if(_loc8_ == 3)
            {
               if(currEngineTypeID == 1)
               {
                  partDetail.btnInstallSuper._visible = true;
               }
            }
            else
            {
               trace("THIS IS NOT TRAPPED");
            }
         }
      }
      else
      {
         partDetail.btnInstall._visible = false;
         partDetail.btnUninstall._visible = false;
         partDetail.btnInstallTurbo._visible = false;
         partDetail.btnInstallSuper._visible = false;
         partDetail.btnUninstallTurbo._visible = false;
         partDetail.btnUninstallSuper._visible = false;
         partDetail.btnSwapEngine._visible = false;
         partDetail.btnTradeIn._visible = true;
      }
      partDetail._visible = true;
   }
   else
   {
      partDetail._visible = false;
   }
}
function startTradeInPart()
{
   _root.attachMovie("alertBuyPart","abc",_root.getNextHighestDepth());
   _root.abc.addButton("OK",true);
   _root.abc.addButton("Cancel");
   _root.abc.contentMC.txtName = selPartXML.attributes.n;
   _root.abc.contentMC.alertIconMC.gotoAndStop("shop");
   _root.abc.contentMC.txtTitle = "Trade in part";
   _root.abc.contentMC.fldPrice.autoSize = "right";
   _root.abc.contentMC.txtPrice = "$" + classes.NumFuncs.commaFormat(selPartXML.attributes.p);
   _root.abc.contentMC.pointsIcon._visible = false;
   _root.abc.contentMC.txtMsg = "You have chosen to trade in this part. Trading in the " + selPartXML.attributes.n + " will add " + _root.abc.contentMC.txtPrice + " to your funds.  Are you sure you want to trade in this part?";
   var _loc2_ = new Object();
   _loc2_.onRelease = function(theButton, keepBoxOpen)
   {
      switch(theButton.btnLabel.text)
      {
         case "OK":
            _root.sellPart(selPartXML.attributes.ai,selPartXML.attributes.t);
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
   _root.abc.addListener(_loc2_);
}
function tradeInCartPart()
{
   var _loc2_ = classes.GlobalData.getSelectedCarXML();
   var _loc1_ = 0;
   while(_loc1_ < _loc2_.childNodes.length)
   {
      if(_loc2_.childNodes[_loc1_].attributes.i == selPartXML.attributes.i)
      {
         _loc2_.childNodes[_loc1_].removeNode();
         break;
      }
      _loc1_ += 1;
   }
   selPartXML.removeNode();
   clearCart();
}
function startInstallPart()
{
   _root.abc.closeMe();
   _root.attachMovie("alertBuyPart","abc",_root.getNextHighestDepth());
   _root.abc.addButton("OK",true);
   _root.abc.addButton("Cancel");
   _root.abc.contentMC.txtName = selPartXML.attributes.n;
   _root.abc.contentMC.alertIconMC.gotoAndStop("shop");
   _root.abc.contentMC.pointsIcon._visible = false;
   var _loc2_ = undefined;
   _loc2_ = new classes.PartThumbnail(_root.abc.contentMC.partImg,selPartXML.attributes.pi,selPartXML.attributes.i,selPartXML.attributes.t,selPartXML.attributes.di);
   if(selPartXML.attributes.pi == 165)
   {
      _root.abc.contentMC.partImg._xscale = _root.abc.contentMC.partImg._yscale = 45;
   }
   else if(selPartXML.attributes.pi == 167 || selPartXML.attributes.pi == 168 || selPartXML.attributes.pi == 169 || selPartXML.attributes.pi == 170)
   {
      _root.abc.contentMC.partImg._xscale = _root.abc.contentMC.partImg._yscale = 50;
      _root.abc.contentMC.partImg._x += 10;
      _root.abc.contentMC.partImg._y += 15;
      if(selPartXML.attributes.pi == 167)
      {
         _root.abc.contentMC.partImg._x -= 5;
      }
      else if(selPartXML.attributes.pi == 169)
      {
         _root.abc.contentMC.partImg._x += 15;
      }
      else if(selPartXML.attributes.pi == 170)
      {
         _root.abc.contentMC.partImg._x += 15;
         _root.abc.contentMC.partImg._y -= 5;
      }
   }
   else
   {
      _root.abc.contentMC.partImg._xscale = _root.abc.contentMC.partImg._yscale = 100;
   }
   false;
   _root.abc.contentMC.brandImg.loadMovie("cache/brands/" + selPartXML.attributes.b + ".swf");
   if(selPartXML.attributes.t == "m")
   {
      _root.abc.contentMC.txtTitle = "Swap Engine";
      _root.abc.contentMC.fldPrice.autoSize = "right";
      _root.abc.contentMC.txtPrice = "$100";
      _root.abc.contentMC.txtMsg = "You have chosen to swap to this engine. Swapping engines will deduct $100 from your funds. Are you sure you want to perform this engine swap?";
   }
   else
   {
      _root.abc.contentMC.txtTitle = "Install Part";
      _root.abc.contentMC.fldPrice.autoSize = "right";
      _root.abc.contentMC.txtPrice = "";
      _root.abc.contentMC.txtMsg = "You have chosen to install this part on your car. Do you want to continue?";
   }
   var _loc3_ = new Object();
   _loc3_.onRelease = function(theButton, keepBoxOpen)
   {
      var _loc4_ = undefined;
      switch(theButton.btnLabel.text)
      {
         case "OK":
            _loc4_ = classes.GlobalData.getSelectedCarXML();
            _root.installPart(selPartXML.attributes.ai,selPartXML.attributes.i,_loc4_.attributes.i,_loc4_.attributes.ae,selPartXML.attributes.t);
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
   _root.abc.addListener(_loc3_);
}
function installCartPart()
{
   var _loc3_ = new XMLNode(1,"p");
   _loc3_.attributes.ai = selPartXML.attributes.ai;
   _loc3_.attributes.i = selPartXML.attributes.i;
   _loc3_.attributes.ci = selPartXML.attributes.pi;
   _loc3_.attributes.n = selPartXML.attributes.n;
   _loc3_.attributes["in"] = 1;
   _loc3_.attributes.cc = selPartXML.attributes.cc;
   _loc3_.attributes.pdi = selPartXML.attributes.pdi;
   _loc3_.attributes.di = selPartXML.attributes.di;
   _loc3_.attributes.pt = selPartXML.attributes.t;
   _loc3_.attributes.ps = selPartXML.attributes.ps;
   var _loc2_ = classes.GlobalData.getSelectedCarXML();
   var _loc1_ = 0;
   while(_loc1_ < _loc2_.childNodes.length)
   {
      if(_loc2_.childNodes[_loc1_].attributes.ci == selPartXML.attributes.pi)
      {
         _loc2_.childNodes[_loc1_].removeNode();
      }
      _loc1_ += 1;
   }
   _loc2_.appendChild(_loc3_);
   clearCart();
}
function startUninstallPart()
{
   _root.attachMovie("alertBuyPart","abc",_root.getNextHighestDepth());
   _root.abc.addButton("OK",true);
   _root.abc.addButton("Cancel");
   _root.abc.contentMC.txtName = selPartXML.attributes.n;
   _root.abc.contentMC.alertIconMC.gotoAndStop("shop");
   _root.abc.contentMC.txtTitle = "Uninstall part";
   _root.abc.contentMC.fldPrice.autoSize = "right";
   _root.abc.contentMC.txtPrice = "";
   _root.abc.contentMC.pointsIcon._visible = false;
   _root.abc.contentMC.txtMsg = "You have chosen to uninstall this part. Are you sure?";
   var _loc2_ = new Object();
   _loc2_.onRelease = function(theButton, keepBoxOpen)
   {
      var _loc4_ = undefined;
      switch(theButton.btnLabel.text)
      {
         case "OK":
            _loc4_ = classes.GlobalData.getSelectedCarXML();
            if(selPartXML.attributes.t == "c")
            {
               _root.uninstallPart(selPartXML.attributes.ai,selPartXML.attributes.i,_loc4_.attributes.i,"c");
            }
            else
            {
               _root.uninstallPart(selPartXML.attributes.ai,selPartXML.attributes.i,_loc4_.attributes.ae,"e");
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
   _root.abc.addListener(_loc2_);
}
function uninstallCartPart()
{
   var _loc2_ = classes.GlobalData.getSelectedCarXML();
   var _loc3_ = 0;
   while(_loc3_ < _loc2_.childNodes.length)
   {
      if(_loc2_.childNodes[_loc3_].attributes.i == selPartXML.attributes.i)
      {
         _loc2_.childNodes[_loc3_].removeNode();
         break;
      }
      _loc3_ += 1;
   }
   selPartXML.attributes["in"] = 0;
   _parent.redrawCar();
   clearCart();
}
function clearCart()
{
   delete selPartXML;
   gotoAndStop("retrieve");
   play();
}
function buildSwapMenu(xml)
{
   var swapMenuHilite = swapMenuHolder.createEmptyMovieClip("swapMenuHilite",swapMenuHolder.getNextHighestDepth());
   swapMenuHilite.beginFill(65535,100);
   swapMenuHilite.moveTo(0,0);
   swapMenuHilite.lineTo(154,0);
   swapMenuHilite.lineTo(154,13);
   swapMenuHilite.lineTo(0,13);
   swapMenuHilite.lineTo(0,0);
   swapMenuHilite.endFill();
   var _loc2_ = swapItemHolder.createEmptyMovieClip("swapItemHilite",swapItemHolder.getNextHighestDepth());
   _loc2_.beginFill(16777215,100);
   _loc2_.moveTo(0,0);
   _loc2_.lineTo(300,0);
   _loc2_.lineTo(300,13);
   _loc2_.lineTo(0,13);
   _loc2_.lineTo(0,0);
   _loc2_.endFill();
   _loc2_._visible = false;
   btnInstallSystem._visible = false;
   swapDataXML = xml;
   var _loc3_ = swapDataXML.firstChild;
   arySwapMenu = new Array();
   var _loc4_ = undefined;
   var _loc5_ = undefined;
   if(_loc3_.childNodes.length > 0)
   {
      _loc4_ = 0;
      while(_loc4_ < _loc3_.childNodes.length)
      {
         _loc5_ = swapMenuHolder.attachMovie("shopSwapMenu","swapMenu" + _loc4_,swapMenuHolder.getNextHighestDepth());
         _loc5_._y = _loc4_ * 13;
         if(_loc3_.childNodes[_loc4_].childNodes.length > 0)
         {
            _loc3_.childNodes[_loc4_].attributes.sid = _loc3_.childNodes[_loc4_].firstChild.attributes.ai;
            _loc5_.box._visible = true;
         }
         else
         {
            _loc3_.childNodes[_loc4_].attributes.sid = "0";
            _loc5_.box._visible = false;
         }
         _loc5_.catName.text = _loc3_.childNodes[_loc4_].attributes.n;
         _loc5_.xml = _loc3_.childNodes[_loc4_];
         _loc5_.onRelease = function()
         {
            buildSwapItem(this.xml);
            var _loc2_ = new TextFormat();
            _loc2_.color = 16777215;
            var _loc3_ = 0;
            while(_loc3_ < arySwapMenu.length)
            {
               arySwapMenu[_loc3_].catName.setTextFormat(_loc2_);
               _loc3_ += 1;
            }
            _loc2_.color = 5921370;
            this.catName.setTextFormat(_loc2_);
            swapMenuHilite._y = this._y;
            swapItemHolder.swapItemHilite._visible = false;
            selectedCatMC = this;
         };
         arySwapMenu.push(_loc5_);
         _loc4_ += 1;
      }
      arySwapMenu[0].onRelease();
   }
   swapMenuSP.refreshScroller();
   checkIfSystemIsReady();
}
function buildSwapItem(xml)
{
   partDetail._visible = false;
   partImg._visible = false;
   var _loc2_ = 0;
   while(_loc2_ < arySwapItem.length)
   {
      arySwapItem[_loc2_].removeMovieClip();
      _loc2_ += 1;
   }
   arySwapItem = new Array();
   swapItemHilite._visible = false;
   _loc2_ = 0;
   var _loc3_ = undefined;
   var _loc4_ = undefined;
   while(_loc2_ < xml.childNodes.length)
   {
      _loc3_ = swapItemHolder.attachMovie("shopSwapItem","swapItem" + _loc2_,swapItemHolder.getNextHighestDepth());
      _loc3_._y = _loc2_ * 13;
      _loc3_.xml = xml.childNodes[_loc2_];
      _loc3_.partName.text = xml.childNodes[_loc2_].attributes.n;
      if(xml.attributes.sid == xml.childNodes[_loc2_].attributes.ai)
      {
         _loc4_ = new TextFormat();
         _loc4_.color = 65535;
         _loc3_.partName.setTextFormat(_loc4_);
         _loc3_.dot.gotoAndStop(2);
      }
      _loc3_.onRelease = function()
      {
         selectedPartMC = this;
         var _loc2_ = new classes.PartThumbnail(partImg,selectedCatMC.xml.attributes.i,this.xml.attributes.i,"e");
         false;
         partImg._x = 6;
         partImg._y = 225;
         if(selectedCatMC.xml.attributes.i == 165)
         {
            partImg._xscale = partImg._yscale = 45;
         }
         else if(selectedCatMC.xml.attributes.i == 167 || selectedCatMC.xml.attributes.i == 168 || selectedCatMC.xml.attributes.i == 169 || selectedCatMC.xml.attributes.i == 170)
         {
            partImg._xscale = partImg._yscale = 50;
            partImg._x = 16;
            partImg._y = 240;
            if(selectedCatMC.xml.attributes.i == 167)
            {
               partImg._x = 11;
            }
            else if(selectedCatMC.xml.attributes.i == 168)
            {
               partImg._y = 245;
            }
            else if(selectedCatMC.xml.attributes.i == 169)
            {
               partImg._x = 31;
               partImg._y = 245;
            }
            else if(selectedCatMC.xml.attributes.i == 170)
            {
               partImg._x = 31;
            }
         }
         else
         {
            partImg._xscale = partImg._yscale = 100;
         }
         partImg._visible = true;
         partDetail._visible = true;
         partDetail.fldName.text = this.xml.attributes.n;
         if(this.xml.firstChild.nodeValue)
         {
            partDetail.txtDescription = this.xml.firstChild.nodeValue;
         }
         else
         {
            partDetail.txtDescription = "";
         }
         this._parent.swapItemHilite._visible = true;
         this._parent.swapItemHilite._y = this._y;
      };
      arySwapItem.push(_loc3_);
      _loc2_ += 1;
   }
}
function onSelectPart()
{
   var _loc2_;
   var _loc1_;
   if(selectedCatMC && selectedPartMC)
   {
      selectedCatMC.xml.attributes.sid = selectedPartMC.xml.attributes.ai;
      selectedCatMC.box._visible = true;
      _loc2_ = new TextFormat();
      _loc2_.color = 13421772;
      _loc1_ = 0;
      while(_loc1_ < arySwapItem.length)
      {
         arySwapItem[_loc1_].partName.setTextFormat(_loc2_);
         arySwapItem[_loc1_].dot.gotoAndStop(1);
         _loc1_ += 1;
      }
      _loc2_.color = 65535;
      selectedPartMC.partName.setTextFormat(_loc2_);
      selectedPartMC.dot.gotoAndStop(2);
      checkIfSystemIsReady();
   }
}
function checkIfSystemIsReady()
{
   var _loc2_ = true;
   var _loc1_ = 0;
   while(_loc1_ < swapDataXML.firstChild.childNodes.length)
   {
      if(!Number(swapDataXML.firstChild.childNodes[_loc1_].attributes.sid))
      {
         _loc2_ = false;
         break;
      }
      _loc1_ += 1;
   }
   if(_loc2_)
   {
      rightPane.message.text = "This system is ready to be installed. Click the install button below to install this configuration to your car.";
      btnInstallSystem._visible = true;
   }
}
function onInstallSystem()
{
   var _loc2_ = "";
   var _loc3_ = 0;
   while(_loc3_ < swapDataXML.firstChild.childNodes.length)
   {
      _loc2_ += swapDataXML.firstChild.childNodes[_loc3_].attributes.sid + ",";
      _loc3_ += 1;
   }
   if(_loc2_.length > 0)
   {
      _loc2_ = _loc2_.substr(0,_loc2_.length - 1);
      if(newEngineTypeID == -1)
      {
         _root.engineSwapFinish(classes.GlobalData.getSelectedCarXML().attributes.i,newEngineID,_loc2_);
      }
      else
      {
         _root.systemSwap(classes.GlobalData.getSelectedCarXML().attributes.i,newEngineTypeID,_loc2_);
      }
   }
}
function onSwapEngineSuccess()
{
   var _loc4_ = classes.GlobalData.getSelectedCarXML();
   var _loc3_ = 0;
   while(_loc3_ < _loc4_.childNodes.length)
   {
      if(_loc4_.childNodes[_loc3_].attributes.pt != "c")
      {
         _loc4_.childNodes[_loc3_].removeNode();
      }
      _loc3_ += 1;
   }
   var _loc1_ = new XMLNode(1,"p");
   _loc1_.attributes.ai = selPartXML.attributes.ai;
   _loc1_.attributes.i = selPartXML.attributes.i;
   _loc1_.attributes.ci = selPartXML.attributes.pi;
   _loc1_.attributes.n = selPartXML.attributes.n;
   _loc1_.attributes["in"] = 1;
   _loc1_.attributes.pt = "m";
   _loc4_.appendChild(_loc1_);
   _loc3_ = 0;
   var _loc2_;
   while(_loc3_ < swapDataXML.firstChild.childNodes.length)
   {
      _loc2_ = 0;
      while(_loc2_ < swapDataXML.firstChild.childNodes[_loc3_].childNodes.length)
      {
         if(swapDataXML.firstChild.childNodes[_loc3_].attributes.sid == swapDataXML.firstChild.childNodes[_loc3_].childNodes[_loc2_].attributes.ai)
         {
            _loc1_ = new XMLNode(1,"p");
            _loc1_.attributes.ai = swapDataXML.firstChild.childNodes[_loc3_].childNodes[_loc2_].attributes.ai;
            _loc1_.attributes.i = swapDataXML.firstChild.childNodes[_loc3_].childNodes[_loc2_].attributes.i;
            _loc1_.attributes.ci = swapDataXML.firstChild.childNodes[_loc3_].childNodes[_loc2_].attributes.pi;
            _loc1_.attributes.n = swapDataXML.firstChild.childNodes[_loc3_].childNodes[_loc2_].attributes.n;
            _loc1_.attributes["in"] = 1;
            _loc1_.attributes.pt = "e";
            _loc4_.appendChild(_loc1_);
         }
         _loc2_ += 1;
      }
      _loc3_ += 1;
   }
   gotoAndStop("retrieve");
   play();
}
function onSellAllSpareParts(price)
{
   _root.attachMovie("alertBuyPart","abc",_root.getNextHighestDepth());
   _root.abc.addButton("Continue",true);
   _root.abc.addButton("Cancel");
   _root.abc.contentMC.txtName = "All Spare Parts";
   _root.abc.contentMC.alertIconMC.gotoAndStop("warningtriangle");
   _root.abc.contentMC.pointsIcon._visible = false;
   _root.abc.contentMC.txtTitle = "Warning: SELL ALL?";
   _root.abc.contentMC.fldPrice.autoSize = "right";
   _root.abc.contentMC.txtPrice = "$" + price;
   _root.abc.contentMC.txtMsg = "You are about to sell all of your spare parts.  Some of these parts may be required for future modifications.  Are you sure you want to proceed?";
   var _loc3_ = new Object();
   _loc3_.onRelease = function(theButton, keepBoxOpen)
   {
      switch(theButton.btnLabel.text)
      {
         case "Continue":
            _root.sellAllSpare();
            _root.abc.removeButtons();
            _root.abc.addDisabledButton("Continue");
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
   _root.abc.addListener(_loc3_);
}
var selPartXML;
var arySwapMenu;
var arySwapItem;
var selectedCatMC;
var selectedPartMC;
var swapDataXML;
