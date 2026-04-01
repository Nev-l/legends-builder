class classes.ShopMenu2CPR
{
   var __MC;
   var locationID;
   var partCatXML;
   var partXML;
   var partOwnAndUninstalledXML;
   var selectedCarXML;
   var onPartClickAction;
   var menuItemHeight;
   var tfInit;
   var tfNA;
   var tfInstalled;
   var tfOwn;
   var yShow;
   var objRef;
   var menuDepth;
   var idx;
   var pcid;
   var hasChild;
   var clr;
   var brandName;
   var modelName;
   var partType;
   var ty;
   var _y;
   var onEnterFrame;
   var showSI;
   var checkSI;
   var hitTest;
   static var __missingStoreTypePatch;
   function ShopMenu2CPR(mc, pLocationID, pPartCatXML, pPartXML, pPartOwnAndUninstalledXML, pSelectedCarXML, pOnPartClickAction)
   {
      this.__MC = mc;
      this.__MC.objRef = this;
      this.locationID = pLocationID;
      this.partCatXML = pPartCatXML;
      this.partXML = pPartXML;
      this.partOwnAndUninstalledXML = pPartOwnAndUninstalledXML;
      this.selectedCarXML = pSelectedCarXML;
      this.onPartClickAction = pOnPartClickAction;
      this.menuItemHeight = 14;
      this.tfInit = new TextFormat();
      this.tfInit.color = 16777215;
      this.tfNA = new TextFormat();
      this.tfNA.color = 6710886;
      this.tfInstalled = new TextFormat();
      this.tfInstalled.color = 61680;
      this.tfOwn = new TextFormat();
      this.tfOwn.color = 14872576;
      this.yShow = this.__MC._y;
      this.__MC._parent.bars.objRef = this;
      this.__MC._parent.bars.onRollOver = function()
      {
         this.objRef.showPanel();
      };
      this.init();
      this.__MC._y = - this.__MC._height;
   }
   function getCategoryAvailability(parentID, p)
   {
      trace("getCategoryAvailability: " + parentID + " ...");
      var _loc4_ = 0;
      var _loc5_ = this.partCatXML.firstChild;
      var _loc6_ = 0;
      var _loc7_ = undefined;
      var _loc8_ = undefined;
      while(_loc6_ < _loc5_.childNodes.length)
      {
         trace("...getCategoryAvailability: " + _loc6_ + ": " + _loc5_.childNodes[_loc6_].attributes.pi + ", " + _loc5_.childNodes[_loc6_].attributes.i + " ...");
         if(_loc5_.childNodes[_loc6_].attributes.pi == parentID)
         {
            trace("...getCategoryAvailability, yes it is ... p==p");
            _loc7_ = 0;
            if(_loc5_.childNodes[_loc6_].attributes.c == 0)
            {
               trace("...getCategoryAvailability, yes it totally is ... c==0");
               _loc8_ = 0;
               while(_loc8_ < p.firstChild.childNodes.length)
               {
                  if(p.firstChild.childNodes[_loc8_].attributes.pi == _loc5_.childNodes[_loc6_].attributes.i && Number(p.firstChild.childNodes[_loc8_].attributes.l) <= this.locationID)
                  {
                     _loc7_ += 1;
                  }
                  else if(Number(p.firstChild.childNodes[_loc8_].attributes.l) <= this.locationID)
                  {
                     trace("NO: " + p.firstChild.childNodes[_loc8_].attributes.n);
                  }
                  _loc8_ += 1;
               }
            }
            else
            {
               _loc7_ = this.getCategoryAvailability(_loc5_.childNodes[_loc6_].attributes.i,p);
            }
            _loc4_ += _loc7_;
            _loc5_.childNodes[_loc6_].attributes.p = _loc7_;
         }
         _loc6_ += 1;
      }
      trace("... " + _loc4_);
      return _loc4_;
   }
   function getCategory(parentID, menuDepth, dotClr)
   {
      this.collapseToDepth(menuDepth);
      var _loc5_ = this.__MC.createEmptyMovieClip("partContainer" + menuDepth,this.__MC.getNextHighestDepth());
      _loc5_._x = 16 + menuDepth * 140;
      var _loc6_ = this.partCatXML.firstChild;
      var _loc7_ = 0;
      var _loc8_ = "";
      var _loc9_ = 0;
      while(_loc9_ < _loc6_.childNodes.length)
      {
         if(_loc6_.childNodes[_loc9_].attributes.i == parentID)
         {
            _loc8_ = _loc6_.childNodes[_loc9_].attributes.n;
            break;
         }
         _loc9_ += 1;
      }
      if(!dotClr && dotClr !== 0)
      {
         dotClr = 11184810;
      }
      if(menuDepth > 0)
      {
         this.__MC._parent["dot" + menuDepth + "Clr"] = new Color(this.__MC._parent["dot" + menuDepth]);
         this.__MC._parent["dot" + menuDepth]._visible = true;
         this.__MC._parent["dot" + menuDepth + "Clr"].setRGB(dotClr);
         this.__MC._parent["txtHead" + menuDepth] = _loc8_;
      }
      _loc9_ = 0;
      var _loc10_ = undefined;
      while(_loc9_ < _loc6_.childNodes.length)
      {
         if(_loc6_.childNodes[_loc9_].attributes.pi == parentID && _loc6_.childNodes[_loc9_].attributes.s == "1")
         {
            _loc10_ = _loc5_.attachMovie("shopMenuListItem","cat" + _loc7_,_loc5_.getNextHighestDepth());
            _loc10_.txt = _loc6_.childNodes[_loc9_].attributes.n;
            _loc10_.clr = new Color(_loc10_.dot);
            if(_loc6_.childNodes[_loc9_].attributes.cl.length)
            {
               _loc10_.clr.setRGB(Number("0x" + _loc6_.childNodes[_loc9_].attributes.cl));
            }
            else
            {
               _loc10_.clr.setRGB(dotClr);
            }
            if(_loc6_.childNodes[_loc9_].attributes.c > 0)
            {
               _loc10_.hasChild = 1;
            }
            else
            {
               _loc10_.hasChild = 0;
            }
            _loc10_._y = 3 + _loc7_ * this.menuItemHeight;
            _loc10_.pcid = Number(_loc6_.childNodes[_loc9_].attributes.i);
            _loc10_.idx = _loc7_;
            _loc10_.menuDepth = menuDepth;
            _loc10_.objRef = this;
            _loc10_.onRollOver = function()
            {
               this.objRef.setHiMotion("hiRO",this.menuDepth,this.idx);
            };
            _loc10_.onRollOut = function()
            {
               this.objRef.setHiMotion("hiRO",this.menuDepth);
            };
            _loc10_.onRelease = function()
            {
               if(this.pcid == 22)
               {
                  this.objRef.collapseToDepth(this.menuDepth + 1);
                  this.objRef.clickAction(22,"");
               }
               else if(this.hasChild == 1)
               {
                  this.objRef.getCategory(this.pcid,this.menuDepth + 1,this.clr.getRGB());
               }
               else
               {
                  this.objRef.getBrand(this.pcid,this.menuDepth + 1,this.clr.getRGB());
               }
               this.objRef.setHiMotion("hiSel",this.menuDepth,this.idx);
               this.objRef.setHiText(this.menuDepth,this.idx,this.objRef.tfNA);
            };
            if(_loc6_.childNodes[_loc9_].attributes.p <= 0 && _loc6_.childNodes[_loc9_].attributes.pp <= 0 && Number(_loc6_.childNodes[_loc9_].attributes.i) != 22)
            {
               _loc10_.na = true;
               _loc10_.fld.setTextFormat(this.tfNA);
            }
            _loc7_ += 1;
         }
         _loc9_ += 1;
      }
   }
   function getBrand(parentID, menuDepth, dotClr)
   {
      this.collapseToDepth(menuDepth);
      var _loc5_ = this.__MC.createEmptyMovieClip("partContainer" + menuDepth,this.__MC.getNextHighestDepth());
      _loc5_._x = 16 + menuDepth * 140;
      var _loc6_ = this.partXML.firstChild;
      var _loc7_ = 0;
      var _loc8_ = "";
      var _loc9_ = 0;
      while(_loc9_ < this.partCatXML.firstChild.childNodes.length)
      {
         if(this.partCatXML.firstChild.childNodes[_loc9_].attributes.i == parentID)
         {
            _loc8_ = this.partCatXML.firstChild.childNodes[_loc9_].attributes.n;
            break;
         }
         _loc9_ += 1;
      }
      if(!dotClr && dotClr !== 0)
      {
         dotClr = 11184810;
      }
      if(menuDepth > 0)
      {
         this.__MC._parent["dot" + menuDepth + "Clr"] = new Color(this.__MC._parent["dot" + menuDepth]);
         this.__MC._parent["dot" + menuDepth]._visible = true;
         this.__MC._parent["dot" + menuDepth + "Clr"].setRGB(dotClr);
         this.__MC._parent["txtHead" + menuDepth] = _loc8_;
      }
      var _loc10_ = undefined;
      _loc9_ = 0;
      var _loc11_ = undefined;
      while(_loc9_ < _loc6_.childNodes.length)
      {
         if(_loc6_.childNodes[_loc9_].attributes.pi == parentID && _loc6_.childNodes[_loc9_].attributes.bn != _loc10_ && _loc6_.childNodes[_loc9_].attributes.l <= this.locationID)
         {
            _loc10_ = _loc6_.childNodes[_loc9_].attributes.bn;
            _loc11_ = _loc5_.attachMovie("shopMenuListItem","cat" + _loc7_,_loc5_.getNextHighestDepth());
            trace(_loc10_);
            _loc11_.txt = _loc10_;
            _loc11_.clr = new Color(_loc11_.dot);
            if(_loc6_.childNodes[_loc9_].attributes.cl.length)
            {
               _loc11_.clr.setRGB(Number("0x" + _loc6_.childNodes[_loc9_].attributes.cl));
            }
            else
            {
               _loc11_.clr.setRGB(dotClr);
            }
            _loc11_._y = 3 + _loc7_ * this.menuItemHeight;
            _loc11_.pcid = parentID;
            _loc11_.brandName = _loc10_;
            _loc11_.idx = _loc7_;
            _loc11_.menuDepth = menuDepth;
            _loc11_.objRef = this;
            _loc11_.onRollOver = function()
            {
               this.objRef.setHiMotion("hiRO",this.menuDepth,this.idx);
            };
            _loc11_.onRollOut = function()
            {
               this.objRef.setHiMotion("hiRO",this.menuDepth);
            };
            _loc11_.onRelease = function()
            {
               if(this.pcid == 22)
               {
                  this.objRef.collapseToDepth(this.menuDepth + 1);
                  this.objRef.clickAction(22,"");
               }
               else
               {
                  this.objRef.getModelName(this.pcid,this.brandName,this.menuDepth + 1,this.clr.getRGB());
               }
               this.objRef.setHiMotion("hiSel",this.menuDepth,this.idx);
               this.objRef.setHiText(this.menuDepth,this.idx,this.objRef.tfNA);
            };
            if(_loc6_.childNodes[_loc9_].attributes.p <= 0 && _loc6_.childNodes[_loc9_].attributes.pp <= 0 && Number(_loc6_.childNodes[_loc9_].attributes.i) != 22)
            {
               _loc11_.na = true;
               _loc11_.fld.setTextFormat(this.tfNA);
            }
            _loc7_ += 1;
         }
         _loc9_ += 1;
      }
   }
   function getModelName(parentID, brandName, menuDepth, dotClr)
   {
      this.collapseToDepth(menuDepth);
      var _loc6_ = this.__MC.createEmptyMovieClip("partContainer" + menuDepth,this.__MC.getNextHighestDepth());
      _loc6_._x = 16 + menuDepth * 140;
      var _loc7_ = this.partXML.firstChild;
      var _loc8_ = 0;
      var _loc9_ = brandName;
      if(!dotClr && dotClr !== 0)
      {
         dotClr = 11184810;
      }
      if(menuDepth > 0)
      {
         this.__MC._parent["dot" + menuDepth + "Clr"] = new Color(this.__MC._parent["dot" + menuDepth]);
         this.__MC._parent["dot" + menuDepth]._visible = true;
         this.__MC._parent["dot" + menuDepth + "Clr"].setRGB(dotClr);
         this.__MC._parent["txtHead" + menuDepth] = _loc9_;
      }
      var _loc10_ = undefined;
      var _loc11_ = 0;
      var _loc12_ = undefined;
      while(_loc11_ < _loc7_.childNodes.length)
      {
         if(_loc7_.childNodes[_loc11_].attributes.pi == parentID && _loc7_.childNodes[_loc11_].attributes.bn == brandName && _loc7_.childNodes[_loc11_].attributes.mn != _loc10_ && _loc7_.childNodes[_loc11_].attributes.l <= this.locationID)
         {
            _loc10_ = _loc7_.childNodes[_loc11_].attributes.mn;
            _loc12_ = _loc6_.attachMovie("shopMenuListItem","cat" + _loc8_,_loc6_.getNextHighestDepth());
            _loc12_.txt = _loc10_;
            _loc12_.brandName = brandName;
            _loc12_.modelName = _loc10_;
            _loc12_.clr = new Color(_loc12_.dot);
            if(_loc7_.childNodes[_loc11_].attributes.cl.length)
            {
               _loc12_.clr.setRGB(Number("0x" + _loc7_.childNodes[_loc11_].attributes.cl));
            }
            else
            {
               _loc12_.clr.setRGB(dotClr);
            }
            _loc12_._y = 3 + _loc8_ * this.menuItemHeight;
            _loc12_.pcid = parentID;
            _loc12_.idx = _loc8_;
            _loc12_.menuDepth = menuDepth;
            _loc12_.objRef = this;
            _loc12_.onRollOver = function()
            {
               this.objRef.setHiMotion("hiRO",this.menuDepth,this.idx);
            };
            _loc12_.onRollOut = function()
            {
               this.objRef.setHiMotion("hiRO",this.menuDepth);
            };
            _loc12_.onRelease = function()
            {
               if(this.pcid == 22)
               {
                  this.objRef.collapseToDepth(this.menuDepth + 1);
                  this.objRef.clickAction(22,"");
               }
               else
               {
                  this.objRef.getPart(this.pcid,this.brandName,this.modelName,this.menuDepth + 1,this.clr.getRGB());
               }
               this.objRef.setHiMotion("hiSel",this.menuDepth,this.idx);
               this.objRef.setHiText(this.menuDepth,this.idx,this.objRef.tfNA);
            };
            if(_loc7_.childNodes[_loc11_].attributes.p <= 0 && _loc7_.childNodes[_loc11_].attributes.pp <= 0 && Number(_loc7_.childNodes[_loc11_].attributes.i) != 22)
            {
               _loc12_.na = true;
               _loc12_.fld.setTextFormat(this.tfNA);
            }
            _loc8_ += 1;
         }
         _loc11_ += 1;
      }
   }
   function getPart(parentID, brandName, modelName, menuDepth, dotClr)
   {
      this.collapseToDepth(menuDepth);
      var _loc7_ = this.__MC.createEmptyMovieClip("partContainer" + menuDepth,this.__MC.getNextHighestDepth());
      _loc7_._x = 16 + menuDepth * 140;
      var _loc8_ = this.partCatXML.firstChild;
      var _loc9_ = modelName;
      if(!dotClr && dotClr !== 0)
      {
         dotClr = 11184810;
      }
      if(menuDepth > 0)
      {
         this.__MC._parent["dot" + menuDepth + "Clr"] = new Color(this.__MC._parent["dot" + menuDepth]);
         this.__MC._parent["dot" + menuDepth]._visible = true;
         this.__MC._parent["dot" + menuDepth + "Clr"].setRGB(dotClr);
         this.__MC._parent["txtHead" + menuDepth] = _loc9_;
      }
      _loc8_ = this.partXML.firstChild;
      var _loc10_ = 0;
      var _loc11_ = 0;
      while(_loc11_ < _loc8_.childNodes.length)
      {
         if(_loc8_.childNodes[_loc11_].attributes.pi == parentID && _loc8_.childNodes[_loc11_].attributes.bn == brandName && _loc8_.childNodes[_loc11_].attributes.mn == modelName && _loc8_.childNodes[_loc11_].attributes.l <= this.locationID)
         {
            var _loc12_ = _loc7_.attachMovie("shopMenuPartItem","PartList" + _loc10_,_loc7_.getNextHighestDepth());
            _loc12_._y = 3 + _loc10_ * this.menuItemHeight;
            var _loc13_ = undefined;
            if(this.getPartOwnership(_loc8_.childNodes[_loc11_].attributes.i) == "Bought and Installed")
            {
               _loc13_ = 1;
            }
            else
            {
               _loc13_ = 0;
            }
            with(_loc12_)
            {
               partName.text = _loc8_.childNodes[_loc11_].attributes.n;
               _loc12_._id = _loc8_.childNodes[_loc11_].attributes.i;
               price.text = "$" + _loc8_.childNodes[_loc11_].attributes.p;
            }
            trace("update installed: " + _loc13_);
            _loc12_._installed = Boolean(_loc13_);
            _loc12_.installedCheckMC._visible = Boolean(_loc13_);
            _loc12_.pcid = _loc8_.childNodes[_loc11_].attributes.i;
            _loc12_.partType = _loc8_.childNodes[_loc11_].attributes.t;
            _loc12_.idx = _loc10_;
            _loc12_.menuDepth = menuDepth;
            _loc12_.objRef = this;
            _loc12_.onRollOver = function()
            {
               this.objRef.setHiMotion("hiRO",this.menuDepth,this.idx,true);
            };
            _loc12_.onRollOut = function()
            {
               this.objRef.setHiMotion("hiRO",this.menuDepth,null,true);
            };
            _loc12_.onRelease = function()
            {
               this.objRef.clickAction(this.pcid,this.partType);
            };
            var _loc14_ = false;
            var _loc15_ = 0;
            while(_loc15_ < this.selectedCarXML.firstChild.childNodes.length)
            {
               if(_loc8_.childNodes[_loc11_].attributes.i == this.selectedCarXML.firstChild.childNodes[_loc15_].attributes.i && _loc8_.childNodes[_loc11_].attributes.t == this.selectedCarXML.firstChild.childNodes[_loc15_].attributes.pt)
               {
                  _loc14_ = true;
                  break;
               }
               _loc15_ = _loc15_ + 1;
            }
            if(_loc14_)
            {
               _loc12_.partName.text += " (installed)";
               _loc12_.partName.setTextFormat(this.tfInstalled);
            }
            else
            {
               var _loc16_ = false;
               _loc15_ = 0;
               while(_loc15_ < this.partOwnAndUninstalledXML.firstChild.childNodes.length)
               {
                  if(_loc8_.childNodes[_loc11_].attributes.i == this.partOwnAndUninstalledXML.firstChild.childNodes[_loc15_].attributes.i && _loc8_.childNodes[_loc11_].attributes.t == this.partOwnAndUninstalledXML.firstChild.childNodes[_loc15_].attributes.t)
                  {
                     _loc16_ = true;
                     break;
                  }
                  _loc15_ = _loc15_ + 1;
               }
               if(_loc16_)
               {
                  _loc12_.partName.text += " (own)";
                  _loc12_.partName.setTextFormat(this.tfOwn);
               }
            }
            _loc10_ = _loc10_ + 1;
         }
         _loc11_ = _loc11_ + 1;
      }
   }
   function collapseToDepth(targetDepth)
   {
      var _loc3_ = targetDepth;
      while(_loc3_ <= 4)
      {
         this.__MC["partContainer" + _loc3_].removeMovieClip();
         this.__MC._parent["dot" + _loc3_]._visible = false;
         this.__MC._parent["txtHead" + _loc3_] = "";
         this.__MC["hiSel" + _loc3_].ty = - this.__MC["hiSel" + _loc3_]._height - 10;
         this.__MC["hiRO" + _loc3_].ty = - this.__MC["hiRO" + _loc3_]._height - 10;
         this.__MC["hiSel" + _loc3_]._y = this.__MC["hiSel" + _loc3_].ty;
         this.__MC["hiRO" + _loc3_]._y = this.__MC["hiRO" + _loc3_].ty;
         _loc3_ += 1;
      }
   }
   function setHiMotion(hiType, hiDepth, targetIdx, forPart)
   {
      var _loc6_ = undefined;
      var _loc7_ = undefined;
      if(forPart)
      {
         _loc6_ = this.__MC[hiType + "Part"];
         _loc7_ = this.__MC["partContainer" + hiDepth]["PartList" + targetIdx];
         _loc6_._x = this.__MC["partContainer" + hiDepth]._x;
         _loc6_._width = this.__MC["partContainer" + hiDepth]._width;
      }
      else
      {
         _loc6_ = this.__MC[hiType + hiDepth];
         _loc7_ = this.__MC["partContainer" + hiDepth]["cat" + targetIdx];
      }
      if(targetIdx == undefined)
      {
         if(forPart)
         {
            _loc6_.ty = this.__MC.hiSelPart._y;
         }
         else
         {
            _loc6_.ty = this.__MC["hiSel" + hiDepth]._y;
         }
      }
      else
      {
         _loc6_.ty = _loc7_._y;
      }
      _loc6_.onEnterFrame = function()
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
   function setHiText(hiDepth, targetIdx, ptf)
   {
      trace("setHiText: " + ptf);
      for(var _loc5_ in this.__MC["partContainer" + hiDepth])
      {
         if(this.__MC["partContainer" + hiDepth][_loc5_].na)
         {
            this.__MC["partContainer" + hiDepth][_loc5_].fld.setTextFormat(this.tfNA);
         }
         else
         {
            this.__MC["partContainer" + hiDepth][_loc5_].fld.setTextFormat(this.tfInit);
         }
      }
      this.__MC["partContainer" + hiDepth]["cat" + targetIdx].fld.setTextFormat(ptf);
   }
   function getPartCategoryOwnership(pcid)
   {
      var _loc3_ = 0;
      while(_loc3_ < this.selectedCarXML.firstChild.childNodes.length)
      {
         if(pcid == this.selectedCarXML.firstChild.childNodes[_loc3_].attributes.ci)
         {
            if(this.selectedCarXML.firstChild.childNodes[_loc3_].attributes["in"] == "1")
            {
               return "Bought and Installed";
            }
            return "Bought but not installed";
         }
         _loc3_ += 1;
      }
      return "Not yet purchased";
   }
   function getPartOwnership(pid)
   {
      var _loc3_ = 0;
      while(_loc3_ < this.selectedCarXML.firstChild.childNodes.length)
      {
         if(pid == this.selectedCarXML.firstChild.childNodes[_loc3_].attributes.i)
         {
            if(this.selectedCarXML.firstChild.childNodes[_loc3_].attributes["in"] == "1")
            {
               return "Bought and Installed";
            }
            return "Bought but not installed";
         }
         _loc3_ += 1;
      }
      return "Not yet purchased";
   }
   function showPanel()
   {
      clearInterval(this.showSI);
      clearInterval(this.checkSI);
      this.showSI = setInterval(this.stepPanel,30,this,this.yShow);
      this.checkSI = setInterval(this.checkPanelHit,100,this);
   }
   function hidePanel()
   {
      clearInterval(this.checkSI);
      clearInterval(this.showSI);
      this.showSI = setInterval(this.stepPanel,30,this,- this.__MC._height);
   }
   function prepPanelRemove()
   {
      trace("prepPanelRemove");
      trace(this.checkSI);
      trace(this.showSI);
      clearInterval(this.checkSI);
      clearInterval(this.showSI);
   }
   function stepPanel(objRef, targetY)
   {
      if(Math.abs(targetY - objRef.__MC._y) > 0.1)
      {
         objRef.__MC._y += (targetY - objRef.__MC._y) / 3;
      }
      else
      {
         clearInterval(objRef.showSI);
      }
   }
   function checkPanelHit(objRef)
   {
      if(!objRef.__MC.hitTest(_root._xmouse,_root._ymouse,false) && !objRef.__MC._parent.bars.hitTest(_root._xmouse,_root._ymouse,false))
      {
         objRef.hidePanel();
      }
   }
   function clickAction(param1, param2)
   {
      this.onPartClickAction(param1,param2);
   }
   function init()
   {
      this.__MC._y = this.yShow;
      this.__MC.onEnterFrame = function()
      {
         if(this.hitTest(_root._xmouse,_root._ymouse))
         {
            this.objRef.showPanel();
            delete this.onEnterFrame;
         }
      };
      this.getCategoryAvailability(0,this.partXML);
      this.getCategory(0,0);
   }
}
