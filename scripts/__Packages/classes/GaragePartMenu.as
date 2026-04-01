class classes.GaragePartMenu
{
   var __MC;
   var partCatXML;
   var partXML;
   var selectedCarXML;
   var onPartClickAction;
   var menuItemHeight;
   var tfInit;
   var tfNA;
   var tfInstalled;
   var yShow;
   var objRef;
   var menuDepth;
   var idx;
   var hasChild;
   var pcid;
   var clr;
   var ai;
   var partType;
   var ty;
   var _y;
   var onEnterFrame;
   var showSI;
   var checkSI;
   var hitTest;
   function GaragePartMenu(mc, pPartCatXML, pPartXML, pSelectedCarXML, pOnPartClickAction)
   {
      this.__MC = mc;
      this.__MC.objRef = this;
      this.partCatXML = pPartCatXML;
      this.partXML = pPartXML;
      this.selectedCarXML = pSelectedCarXML;
      this.onPartClickAction = pOnPartClickAction;
      this.menuItemHeight = 13;
      this.tfInit = new TextFormat();
      this.tfInit.color = 16777215;
      this.tfNA = new TextFormat();
      this.tfNA.color = 6710886;
      this.tfInstalled = new TextFormat();
      this.tfInstalled.color = 65535;
      this.yShow = this.__MC._y;
      this.__MC._parent.bars.objRef = this;
      this.__MC._parent.bars.onRollOver = function()
      {
         this.objRef.showPanel();
      };
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
                     _loc7_ += 1;
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
      var _loc11_ = undefined;
      while(_loc9_ < _loc6_.childNodes.length)
      {
         _loc10_ = false;
         switch(Number(_loc6_.childNodes[_loc9_].attributes.i))
         {
            case 101:
            case 126:
            case 127:
            case 138:
               _loc10_ = true;
               break;
         }
         if(_loc6_.childNodes[_loc9_].attributes.pi == parentID && !_loc10_ && _loc6_.childNodes[_loc9_].attributes.pi != 22)
         {
            _loc11_ = _loc5_.attachMovie("shopMenuListItem","cat" + _loc7_,_loc5_.getNextHighestDepth());
            _loc11_.txt = _loc6_.childNodes[_loc9_].attributes.n;
            _loc11_.clr = new Color(_loc11_.dot);
            if(_loc6_.childNodes[_loc9_].attributes.cl.length)
            {
               _loc11_.clr.setRGB(Number("0x" + _loc6_.childNodes[_loc9_].attributes.cl));
            }
            else
            {
               _loc11_.clr.setRGB(dotClr);
            }
            if(_loc6_.childNodes[_loc9_].attributes.c > 0)
            {
               _loc11_.hasChild = 1;
            }
            else
            {
               _loc11_.hasChild = 0;
            }
            _loc11_._y = 3 + _loc7_ * this.menuItemHeight;
            _loc11_.pcid = _loc6_.childNodes[_loc9_].attributes.i;
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
               if(this.hasChild == 1)
               {
                  this.objRef.getCategory(this.pcid,this.menuDepth + 1,this.clr.getRGB());
               }
               else
               {
                  this.objRef.getPart(this.pcid,this.menuDepth + 1,this.clr.getRGB());
               }
               this.objRef.setHiMotion("hiSel",this.menuDepth,this.idx);
               this.objRef.setHiText(this.menuDepth,this.idx,this.objRef.tfNA);
            };
            if(_loc6_.childNodes[_loc9_].attributes.p <= 0)
            {
               _loc11_.na = true;
               _loc11_.fld.setTextFormat(this.tfNA);
            }
            _loc7_ += 1;
         }
         _loc9_ += 1;
      }
   }
   function getPart(parentID, menuDepth, dotClr)
   {
      this.collapseToDepth(menuDepth);
      var _loc5_ = this.__MC.createEmptyMovieClip("partContainer" + menuDepth,this.__MC.getNextHighestDepth());
      _loc5_._x = 16 + menuDepth * 140;
      var _loc6_ = this.partCatXML.firstChild;
      var _loc7_ = "";
      var _loc8_ = 0;
      while(_loc8_ < _loc6_.childNodes.length)
      {
         if(_loc6_.childNodes[_loc8_].attributes.i == parentID)
         {
            _loc7_ = _loc6_.childNodes[_loc8_].attributes.n;
            break;
         }
         _loc8_ = _loc8_ + 1;
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
         if(_loc6_.childNodes[_loc8_].attributes.pi == parentID)
         {
            var _loc10_ = _loc5_.attachMovie("shopMenuPartItem","PartList" + _loc9_,_loc5_.getNextHighestDepth());
            _loc10_._y = 3 + _loc9_ * this.menuItemHeight;
            var _loc11_ = Number(_loc6_.childNodes[_loc8_].attributes["in"]);
            with(_loc10_)
            {
               partName.text = _loc6_.childNodes[_loc8_].attributes.n;
               _loc10_._id = _loc6_.childNodes[_loc8_].attributes.i;
               price.text = "$" + _loc6_.childNodes[_loc8_].attributes.p;
            }
            if(_loc11_ == 1)
            {
               _loc10_.partName.setTextFormat(this.tfInstalled);
            }
            _loc10_._installed = Boolean(_loc11_);
            _loc10_.installedCheckMC._visible = Boolean(_loc11_);
            _loc10_.ai = _loc6_.childNodes[_loc8_].attributes.ai;
            _loc10_.pcid = _loc6_.childNodes[_loc8_].attributes.i;
            _loc10_.partType = _loc6_.childNodes[_loc8_].attributes.t;
            _loc10_.idx = _loc9_;
            _loc10_.menuDepth = menuDepth;
            _loc10_.objRef = this;
            _loc10_.onRollOver = function()
            {
               this.objRef.setHiMotion("hiRO",this.menuDepth,this.idx,true);
            };
            _loc10_.onRollOut = function()
            {
               this.objRef.setHiMotion("hiRO",this.menuDepth,null,true);
            };
            _loc10_.onRelease = function()
            {
               this.objRef.clickAction(this.ai,this.partType);
            };
            _loc9_ = _loc9_ + 1;
         }
         _loc8_ = _loc8_ + 1;
      }
      var _loc12_ = this.getPartReqsAndCons(parentID);
      trace("REQUIREMENT AND CONFLICTS " + parentID);
      trace("Requirements:");
      _loc8_ = 0;
      while(_loc8_ < _loc12_.reqs.length)
      {
         trace(_loc12_.reqs[_loc8_].partCategoryName + " - " + _loc12_.reqs[_loc8_].partOwnership);
         _loc8_ = _loc8_ + 1;
      }
      trace("Conflicts:");
      _loc8_ = 0;
      while(_loc8_ < _loc12_.cons.length)
      {
         trace(_loc12_.cons[_loc8_].partName);
         _loc8_ = _loc8_ + 1;
      }
      _loc5_.sp = new controls.ScrollPane(_loc5_,undefined,200);
   }
   function collapseToDepth(targetDepth)
   {
      var _loc3_ = targetDepth;
      while(_loc3_ <= 4)
      {
         this.__MC["partContainer" + _loc3_].sp.destroy();
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
         _loc6_.ty = _loc7_._y + _loc7_._parent.sp.scrollDistance;
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
   function clickAction(param, param2)
   {
      this.onPartClickAction(param,param2);
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
