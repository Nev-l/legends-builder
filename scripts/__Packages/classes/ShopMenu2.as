class classes.ShopMenu2
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
   var storeType;
   var menuDepth;
   var idx;
   var pcid;
   var partType;
   var parentCid;
   var na;
   var hasChild;
   var clr;
   var brandName;
   var modelName;
   var ty;
   var _y;
   var onEnterFrame;
   var showSI;
   var checkSI;
   var hitTest;
   static var __missingStoreTypePatch;
   function ShopMenu2(mc, pLocationID, pPartCatXML, pPartXML, pPartOwnAndUninstalledXML, pSelectedCarXML, pOnPartClickAction, pStoreType)
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
      this.storeType = pStoreType;
      this.init();
   }
   function getCategoryAvailability(parentID, p)
   {
      var _loc4_ = 0;
      var _loc5_ = this.partCatXML.firstChild;
      var _loc6_ = 0;
      var _loc7_ = undefined;
      var _loc8_ = undefined;
      while(_loc6_ < _loc5_.childNodes.length)
      {
         if(_loc5_.childNodes[_loc6_].attributes.pi == parentID)
         {
            _loc7_ = 0;
            if(_loc5_.childNodes[_loc6_].attributes.c == 0)
            {
               _loc8_ = 0;
               while(_loc8_ < p.firstChild.childNodes.length)
               {
                  if(p.firstChild.childNodes[_loc8_].attributes.pi == _loc5_.childNodes[_loc6_].attributes.i)
                  {
                     if(p.firstChild.childNodes[_loc8_].attributes.b == "66")
                     {
                        if(Number(p.firstChild.childNodes[_loc8_].attributes.l) <= this.locationID)
                        {
                           _loc7_ += 1;
                        }
                     }
                     else if(p.firstChild.childNodes[_loc8_].attributes.l == this.locationID)
                     {
                        _loc7_ += 1;
                     }
                     else if(p.firstChild.childNodes[_loc8_].attributes.pi == 160 || p.firstChild.childNodes[_loc8_].attributes.pi == 161 || p.firstChild.childNodes[_loc8_].attributes.pi == 162 || p.firstChild.childNodes[_loc8_].attributes.pi == 163)
                     {
                        _loc7_ += 1;
                     }
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
      return _loc4_;
   }
   function isPartAvailable(partNode)
   {
      if(partNode.attributes.l == this.locationID)
      {
         return true;
      }
      if(Number(partNode.attributes.l) <= this.locationID && partNode.attributes.b == "66")
      {
         return true;
      }
      if(partNode.attributes.pi == 160 || partNode.attributes.pi == 161 || partNode.attributes.pi == 162 || partNode.attributes.pi == 163)
      {
         return true;
      }
      return false;
   }
   function addCatalogPart(targetContainer, partNode, listIdx, menuDepth)
   {
      var _loc6_ = targetContainer.attachMovie("shopMenuPartItem","PartList" + listIdx,targetContainer.getNextHighestDepth());
      _loc6_._y = 3 + listIdx * this.menuItemHeight;
      var _loc7_ = this.getPartOwnership(partNode.attributes.i) == "Bought and Installed" ? 1 : 0;
      with(_loc6_)
      {
         partName.text = partNode.attributes.n;
         _loc6_._id = partNode.attributes.i;
         price.text = "$" + partNode.attributes.p;
      }
      trace("update installed: " + _loc7_);
      _loc6_._installed = Boolean(_loc7_);
      _loc6_.installedCheckMC._visible = Boolean(_loc7_);
      _loc6_.pcid = partNode.attributes.i;
      _loc6_.partType = partNode.attributes.t;
      _loc6_.idx = listIdx;
      _loc6_.menuDepth = menuDepth;
      _loc6_.objRef = this;
      _loc6_.onRollOver = function()
      {
         this.objRef.setHiMotion("hiRO",this.menuDepth,this.idx,true);
      };
      _loc6_.onRollOut = function()
      {
         this.objRef.setHiMotion("hiRO",this.menuDepth,null,true);
      };
      _loc6_.onRelease = function()
      {
         trace("pcid: " + this.pcid);
         trace("part type: " + this.partType);
         this.objRef.clickAction(this.pcid,this.partType);
      };
      var _loc8_ = false;
      var _loc9_ = 0;
      while(this.selectedCarXML != undefined && _loc9_ < this.selectedCarXML.firstChild.childNodes.length)
      {
         if(partNode.attributes.i == this.selectedCarXML.firstChild.childNodes[_loc9_].attributes.i && partNode.attributes.t == this.selectedCarXML.firstChild.childNodes[_loc9_].attributes.pt)
         {
            _loc8_ = true;
            break;
         }
         _loc9_ += 1;
      }
      if(_loc8_)
      {
         _loc6_.partName.text += " (installed)";
         _loc6_.partName.setTextFormat(this.tfInstalled);
      }
      else
      {
         var _loc10_ = false;
         _loc9_ = 0;
         while(_loc9_ < this.partOwnAndUninstalledXML.firstChild.childNodes.length)
         {
            if(partNode.attributes.i == this.partOwnAndUninstalledXML.firstChild.childNodes[_loc9_].attributes.i && partNode.attributes.t == this.partOwnAndUninstalledXML.firstChild.childNodes[_loc9_].attributes.t)
            {
               _loc10_ = true;
               break;
            }
            _loc9_ += 1;
         }
         if(_loc10_)
         {
            _loc6_.partName.text += " (own)";
            _loc6_.partName.setTextFormat(this.tfOwn);
         }
      }
   }
   function getCategory(parentID, menuDepth, dotClr)
   {
      this.collapseToDepth(menuDepth);
      var _loc5_ = this.__MC.createEmptyMovieClip("partContainer" + menuDepth,this.__MC.getNextHighestDepth());
      _loc5_._x = 16 + menuDepth * 140;
      var _loc6_ = this.partCatXML.firstChild;
      trace("tracing the node");
      trace(_loc6_);
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
      var _loc11_ = undefined;
      while(_loc9_ < _loc6_.childNodes.length)
      {
         if(_loc6_.childNodes[_loc9_].attributes.pi == parentID && _loc6_.childNodes[_loc9_].attributes.s == this.storeType)
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
            _loc10_.parentCid = Number(_loc6_.childNodes[_loc9_].attributes.pi);
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
               trace("tempMC.onRelease");
               trace(this.pcid);
               trace(this.parentCid);
               if(this.pcid == 22)
               {
                  trace("custom gear box!");
                  this.objRef.collapseToDepth(this.menuDepth + 1);
                  this.objRef.clickAction(this.pcid,"");
               }
               else if(this.pcid == 159)
               {
                  if(!this.na)
                  {
                     this.objRef.collapseToDepth(this.menuDepth + 1);
                     this.objRef.clickAction(this.pcid,"");
                  }
               }
               else if(this.pcid == 146 || this.pcid == 148 || this.pcid == 149 || this.pcid == 150 || this.pcid == 151)
               {
                  this.objRef.collapseToDepth(this.menuDepth + 1);
                  this.objRef.clickAction(this.pcid,"");
               }
               else if(this.pcid == 172)
               {
                  this.objRef.collapseToDepth(this.menuDepth + 1);
                  this.objRef.clickAction(this.pcid,"");
               }
               else if(this.hasChild == 1)
               {
                  this.objRef.getCategory(this.pcid,this.menuDepth + 1,this.clr.getRGB());
               }
               else if(this.pcid == 14)
               {
                  this.objRef.getBrand(this.pcid,this.menuDepth + 1,this.clr.getRGB());
               }
               else
               {
                  trace("other part!");
                  this.objRef.getPart(this.pcid,this.menuDepth + 1,this.clr.getRGB());
               }
               this.objRef.setHiMotion("hiSel",this.menuDepth,this.idx);
               this.objRef.setHiText(this.menuDepth,this.idx,this.objRef.tfNA);
            };
            _loc11_ = Number(_loc6_.childNodes[_loc9_].attributes.i);
            if(_loc6_.childNodes[_loc9_].attributes.p <= 0 && _loc6_.childNodes[_loc9_].attributes.pp <= 0 && _loc11_ != 22 && _loc11_ != 2)
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
         if(_loc6_.childNodes[_loc9_].attributes.pi == parentID && this.isPartAvailable(_loc6_.childNodes[_loc9_]) && _loc6_.childNodes[_loc9_].attributes.bn != _loc10_)
         {
            _loc10_ = _loc6_.childNodes[_loc9_].attributes.bn;
            _loc11_ = _loc5_.attachMovie("shopMenuListItem","cat" + _loc7_,_loc5_.getNextHighestDepth());
            _loc11_.txt = _loc10_;
            _loc11_.brandName = _loc10_;
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
               this.objRef.getModelName(this.pcid,this.brandName,this.menuDepth + 1,this.clr.getRGB());
               this.objRef.setHiMotion("hiSel",this.menuDepth,this.idx);
               this.objRef.setHiText(this.menuDepth,this.idx,this.objRef.tfNA);
            };
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
         if(_loc7_.childNodes[_loc11_].attributes.pi == parentID && this.isPartAvailable(_loc7_.childNodes[_loc11_]) && _loc7_.childNodes[_loc11_].attributes.bn == brandName && _loc7_.childNodes[_loc11_].attributes.mn != _loc10_)
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
               this.objRef.getGroupedPart(this.pcid,this.brandName,this.modelName,this.menuDepth + 1,this.clr.getRGB());
               this.objRef.setHiMotion("hiSel",this.menuDepth,this.idx);
               this.objRef.setHiText(this.menuDepth,this.idx,this.objRef.tfNA);
            };
            _loc8_ += 1;
         }
         _loc11_ += 1;
      }
   }
   function getGroupedPart(parentID, brandName, modelName, menuDepth, dotClr)
   {
      this.collapseToDepth(menuDepth);
      var _loc7_ = this.__MC.createEmptyMovieClip("partContainer" + menuDepth,this.__MC.getNextHighestDepth());
      _loc7_._x = 16 + menuDepth * 140;
      if(!dotClr && dotClr !== 0)
      {
         dotClr = 11184810;
      }
      if(menuDepth > 0)
      {
         this.__MC._parent["dot" + menuDepth + "Clr"] = new Color(this.__MC._parent["dot" + menuDepth]);
         this.__MC._parent["dot" + menuDepth]._visible = true;
         this.__MC._parent["dot" + menuDepth + "Clr"].setRGB(dotClr);
         this.__MC._parent["txtHead" + menuDepth] = modelName;
      }
      var _loc8_ = this.partXML.firstChild;
      var _loc9_ = 0;
      var _loc10_ = 0;
      while(_loc10_ < _loc8_.childNodes.length)
      {
         if(_loc8_.childNodes[_loc10_].attributes.pi == parentID && this.isPartAvailable(_loc8_.childNodes[_loc10_]) && _loc8_.childNodes[_loc10_].attributes.bn == brandName && _loc8_.childNodes[_loc10_].attributes.mn == modelName)
         {
            this.addCatalogPart(_loc7_,_loc8_.childNodes[_loc10_],_loc9_,menuDepth);
            _loc9_ += 1;
         }
         _loc10_ += 1;
      }
      var _loc11_ = this.getPartReqsAndCons(parentID);
      trace("REQUIREMENT AND CONFLICTS " + parentID);
      trace("Requirements:");
      _loc10_ = 0;
      while(_loc10_ < _loc11_.reqs.length)
      {
         trace(_loc11_.reqs[_loc10_].partCategoryName + " - " + _loc11_.reqs[_loc10_].partOwnership);
         _loc10_ += 1;
      }
      trace("Conflicts:");
      _loc10_ = 0;
      while(_loc10_ < _loc11_.cons.length)
      {
         trace(_loc11_.cons[_loc10_].partName);
         _loc10_ += 1;
      }
   }
   function getPart(parentID, menuDepth, dotClr)
   {
      this.collapseToDepth(menuDepth);
      var _loc5_ = this.__MC.createEmptyMovieClip("partContainer" + menuDepth,this.__MC.getNextHighestDepth());
      _loc5_._x = 16 + menuDepth * 140;
      var _loc6_ = this.partCatXML.firstChild;
      var _loc7_ = "";
      trace("getPart parentID: " + parentID);
      var _loc8_ = 0;
      while(_loc8_ < _loc6_.childNodes.length)
      {
         if(_loc6_.childNodes[_loc8_].attributes.i == parentID)
         {
            _loc7_ = _loc6_.childNodes[_loc8_].attributes.n;
            trace("found: " + _loc7_);
            break;
         }
         _loc8_ += 1;
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
         this.__MC._parent["txtHead" + menuDepth] = _loc7_;
      }
      _loc6_ = this.partXML.firstChild;
      var _loc9_ = 0;
      _loc8_ = 0;
      while(_loc8_ < _loc6_.childNodes.length)
      {
         if(_loc6_.childNodes[_loc8_].attributes.pi == parentID && this.isPartAvailable(_loc6_.childNodes[_loc8_]))
         {
            this.addCatalogPart(_loc5_,_loc6_.childNodes[_loc8_],_loc9_,menuDepth);
            _loc9_ += 1;
         }
         _loc8_ += 1;
      }
      var _loc10_ = this.getPartReqsAndCons(parentID);
      trace("REQUIREMENT AND CONFLICTS " + parentID);
      trace("Requirements:");
      _loc8_ = 0;
      while(_loc8_ < _loc10_.reqs.length)
      {
         trace(_loc10_.reqs[_loc8_].partCategoryName + " - " + _loc10_.reqs[_loc8_].partOwnership);
         _loc8_ += 1;
      }
      trace("Conflicts:");
      _loc8_ = 0;
      while(_loc8_ < _loc10_.cons.length)
      {
         trace(_loc10_.cons[_loc8_].partName);
         _loc8_ += 1;
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
   function getPartReqsAndCons(pcid)
   {
      var _loc3_ = new Array();
      _loc3_.reqs = new Array();
      _loc3_.cons = new Array();
      var _loc4_ = this.partCatXML.firstChild;
      var _loc5_ = 0;
      var _loc6_ = undefined;
      var _loc7_ = undefined;
      var _loc8_ = undefined;
      var _loc9_ = undefined;
      var _loc10_ = undefined;
      var _loc11_ = undefined;
      var _loc12_ = undefined;
      var _loc13_ = undefined;
      while(_loc5_ < _loc4_.childNodes.length)
      {
         if(_loc4_.childNodes[_loc5_].attributes.i == pcid)
         {
            _loc6_ = _loc4_.childNodes[_loc5_].firstChild;
            _loc7_ = _loc4_.childNodes[_loc5_].childNodes[1];
            _loc8_ = 0;
            while(_loc8_ < _loc6_.childNodes.length)
            {
               _loc9_ = 0;
               while(_loc9_ < _loc4_.childNodes.length)
               {
                  if(_loc4_.childNodes[_loc9_].attributes.i == _loc6_.childNodes[_loc8_].attributes.i)
                  {
                     _loc10_ = new Object();
                     _loc10_.partCategoryID = _loc4_.childNodes[_loc9_].attributes.i;
                     _loc10_.partCategoryName = _loc4_.childNodes[_loc9_].attributes.n;
                     _loc10_.partOwnership = this.getPartCategoryOwnership(_loc4_.childNodes[_loc9_].attributes.i);
                     _loc3_.reqs.push(_loc10_);
                     _loc11_ = this.getPartReqsAndCons(_loc4_.childNodes[_loc9_].attributes.i);
                     _loc12_ = 0;
                     while(_loc12_ < _loc11_.reqs.length)
                     {
                        _loc3_.reqs.push(_loc11_.reqs[_loc12_]);
                        _loc12_ += 1;
                     }
                     _loc12_ = 0;
                     while(_loc12_ < _loc11_.cons.length)
                     {
                        _loc3_.cons.push(_loc11_.cons[_loc12_]);
                        _loc12_ += 1;
                     }
                     break;
                  }
                  _loc9_ += 1;
               }
               _loc8_ += 1;
            }
            _loc8_ = 0;
            while(_loc8_ < _loc7_.childNodes.length)
            {
               _loc9_ = 0;
               while(_loc9_ < this.selectedCarXML.firstChild.childNodes.length)
               {
                  if(_loc7_.childNodes[_loc8_].attributes.i == this.selectedCarXML.firstChild.childNodes[_loc9_].attributes.ci)
                  {
                     if(this.selectedCarXML.firstChild.childNodes[_loc9_].attributes["in"] == "1")
                     {
                        _loc13_ = new Object();
                        _loc13_.partID = this.selectedCarXML.firstChild.childNodes[_loc9_].attributes.i;
                        _loc13_.partName = this.selectedCarXML.firstChild.childNodes[_loc9_].attributes.n;
                        _loc3_.cons.push(_loc13_);
                     }
                  }
                  _loc9_ += 1;
               }
               _loc8_ += 1;
            }
            return _loc3_;
         }
         _loc5_ += 1;
      }
      return _loc3_;
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
