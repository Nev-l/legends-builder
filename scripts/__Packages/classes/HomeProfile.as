class classes.HomeProfile extends MovieClip
{
   var scrollerContent;
   var scrollerObj;
   var txtHeader;
   var trophyRoom;
   static var _MC;
   function HomeProfile()
   {
      super();
      classes.HomeProfile._MC = this;
      this.scrollerContent = this.createEmptyMovieClip("scrollerContent",this.getNextHighestDepth());
      this.scrollerContent._y = 73;
      this.scrollerObj = new controls.ScrollPane(this.scrollerContent,693,394,null,467,694,0);
      this.goProfilePage(1);
   }
   function goProfilePage(idx)
   {
      this._parent.selectSnav(idx);
      classes.ClipFuncs.removeAllClips(this.scrollerContent);
      switch(idx)
      {
         case 1:
            this.txtHeader = "My Buddies";
            this.drawMyBuddies(1);
            §§push(this.gotoAndPlay("buddies"));
            if(this.scrollerContent.remarkMC == undefined)
            {
               classes.Remark(this.scrollerContent.attachMovie("Remark","remarkMC",this.scrollerContent.getNextHighestDepth(),{_x:378,_y:8}));
               _root.getRemarks();
            }
            break;
         case 2:
            this.txtHeader = "My Place";
            this.drawMyPlaces();
            §§push(this.gotoAndPlay("place"));
            break;
         case 3:
            this.txtHeader = "Team Status";
            this.drawTeamStatus();
            §§push(this.gotoAndPlay("team"));
            break;
         case 4:
            this.txtHeader = "Trophy Room";
            trace("setting interval");
            this.trophyRoom = new classes.TrophyRoom();
            trace(classes.HomeProfile._MC);
            trace(classes.HomeProfile._MC._parent.userInfo);
            this.trophyRoom.init(classes.HomeProfile._MC._parent.userInfo,this.scrollerObj,this.scrollerContent,4,2,true,true,50,-10);
            this.trophyRoom.badgeIntervalID = setInterval(this.trophyRoom,"drawBadges",100);
            trace("after set interval");
            trace(this.trophyRoom.badgeIntervalID);
            §§push(this.gotoAndPlay("trophies"));
         default:
            return undefined;
      }
   }
   function CB_getRemarks(d)
   {
      trace("CB_getRemarks CALLED");
      _global.myRemarksXML = new XML(d);
      if(this.scrollerContent.remarkMC)
      {
         this.scrollerContent.remarkMC.drawAllRemark(_global.myRemarksXML,true);
      }
   }
   function drawMyPlaces()
   {
      trace("drawMyPlaces");
      this.scrollerObj.setScrollToTop();
      this.scrollerContent.attachMovie("_blank","placesGroup",this.scrollerContent.getNextHighestDepth(),{_x:23,_y:0});
      var _loc3_ = _global.locationXML.firstChild.childNodes.length - 1;
      var _loc4_ = Number(_global.loginXML.firstChild.firstChild.attributes.lid);
      var _loc5_ = false;
      var _loc6_ = undefined;
      var _loc7_ = undefined;
      var _loc8_ = undefined;
      var _loc9_ = undefined;
      var _loc10_ = undefined;
      var _loc11_ = undefined;
      var _loc12_ = undefined;
      if(!isNaN(_loc3_))
      {
         _loc6_ = _loc3_;
         while(_loc6_ >= 0)
         {
            _loc7_ = Number(_global.locationXML.firstChild.childNodes[_loc6_].attributes.lid);
            _loc8_ = Number(_global.locationXML.firstChild.childNodes[_loc6_].attributes.f);
            _loc9_ = Number(_global.locationXML.firstChild.childNodes[_loc6_].attributes.r);
            _loc10_ = Number(_global.locationXML.firstChild.childNodes[_loc6_].attributes.ps) * (!Number(classes.GlobalData.attr.mb) ? 1 : 2);
            _loc11_ = this.scrollerContent.placesGroup["placesInfo" + (_loc6_ + 1)]._y;
            if(_loc5_)
            {
               _loc11_ += 133;
            }
            else
            {
               _loc11_ += 66;
            }
            _loc12_ = this.scrollerContent.placesGroup.attachMovie("placesInfo","placesInfo" + _loc6_,this.scrollerContent.placesGroup.getNextHighestDepth(),{_y:_loc11_});
            if(_loc7_ == _loc4_)
            {
               classes.Drawing.rect(_loc12_,349,133,0,20,0,0,4);
               if(_loc7_ != 100)
               {
                  _loc12_.txtRentDue = "Your rent collection is on every Friday at 5:00PM PST.\rRent payment: $" + classes.NumFuncs.commaFormat(_loc9_);
               }
               else
               {
                  _loc12_.txtRentDue = "Rent payment: $" + classes.NumFuncs.commaFormat(_loc9_);
               }
            }
            else
            {
               _loc12_.createEmptyMovieClip("rect",_loc12_.getNextHighestDepth());
               classes.Drawing.rect(_loc12_.rect,349,66,0,0,0,0,0);
               _loc12_.lid = _loc7_;
               if(_loc7_ < _loc4_ || _loc7_ == _loc4_ + 100)
               {
                  _loc12_.rect.onRelease = function()
                  {
                     trace("moving dialog: " + this._parent.lid);
                     classes.SectionHome.showMove(this._parent.lid);
                  };
               }
            }
            _loc12_.txtName = _global.locationXML.firstChild.childNodes[_loc6_].attributes.ln;
            _loc12_.txtInfo = !_loc8_ ? "No" : "$" + classes.NumFuncs.commaFormat(_loc8_);
            _loc12_.txtInfo += " move-in fee.\r";
            _loc12_.txtInfo += !_loc9_ ? "No weekly payment" : "$" + classes.NumFuncs.commaFormat(_loc9_) + " weekly payment";
            _loc12_.txtInfo += "\n" + _loc10_ + " parking space" + (_loc10_ <= 1 ? "" : "s");
            _loc12_.icon.gotoAndStop(_loc7_ / 100);
            _loc5_ = _loc7_ == _loc4_;
            _loc6_ -= 1;
         }
      }
   }
   function drawTeamStatus()
   {
      classes.ClipFuncs.removeAllClips(this.scrollerContent);
      this.scrollerObj.setScrollToTop();
      this.scrollerContent.attachMovie("homeTeamStatus","teamStatus",this.scrollerContent.getNextHighestDepth());
   }
   function drawMyBuddies(pg)
   {
      pg = Number(pg);
      trace("drawMyBuddies(" + pg + ")");
      this.scrollerObj.setScrollToTop();
      this.scrollerContent.buddiesGroup.removeMovieClip();
      this.scrollerContent.createEmptyMovieClip("buddiesGroup",this.scrollerContent.getNextHighestDepth());
      this.scrollerContent.buddiesGroup._x = 50;
      this.scrollerContent.buddiesGroup._y = 5;
      var _loc4_ = 77;
      var _loc5_ = 84;
      var _loc6_ = 4;
      var _loc7_ = 3;
      var _loc8_ = (pg - 1) * _loc6_ * _loc7_;
      var _loc9_ = Math.min(_loc6_ * _loc7_,_global.buddylist_xml.firstChild.childNodes.length - _loc8_);
      var _loc10_ = undefined;
      var _loc11_ = undefined;
      var _loc12_ = 0;
      while(_loc12_ < _loc9_)
      {
         _loc10_ = _loc12_ % _loc6_ * _loc4_;
         _loc11_ = Math.floor(_loc12_ / _loc6_) * _loc5_;
         this.scrollerContent.buddiesGroup.attachMovie("_blank","buddy" + _loc12_,this.scrollerContent.buddiesGroup.getNextHighestDepth(),{_x:_loc10_,_y:_loc11_,id:_global.buddylist_xml.firstChild.childNodes[_loc12_ + _loc8_].attributes.id});
         this.scrollerContent.buddiesGroup["buddy" + _loc12_].attachMovie("_blank","pic",1,{_xscale:50,_yscale:50});
         classes.Drawing.portrait(this.scrollerContent.buddiesGroup["buddy" + _loc12_].pic,this.scrollerContent.buddiesGroup["buddy" + _loc12_].id,1,0,0,2);
         with(this.scrollerContent.buddiesGroup["buddy" + _loc12_])
         {
            pic.onRelease = function()
            {
               classes.Control.focusViewer(this._parent.id);
            };
            createTextField("uname",2,-2,_height + 1,_width + 20,30);
            uname.selectable = false;
            uname.embedFonts = true;
            uname.autoSize = true;
            uname.antiAliasType = "advanced";
            var _loc13_ = new TextFormat();
            _loc13_.font = "Arial";
            _loc13_.size = 8;
            _loc13_.color = 16777215;
            uname.setNewTextFormat(_loc13_);
            uname.text = _global.buddylist_xml.firstChild.childNodes[_loc12_ + _loc8_].attributes.n;
         }
         _loc12_ = _loc12_ + 1;
      }
      this.drawBuddyPaging(pg);
   }
   function drawBuddyPaging(curPage, setNum)
   {
      var _loc5_ = 12;
      var _loc6_ = Math.ceil(_global.buddylist_xml.firstChild.childNodes.length / _loc5_);
      this.scrollerContent.buddiesGroup.pagingGroup.removeMovieClip();
      this.scrollerContent.buddiesGroup.attachMovie("_blank","pagingGroup",this.scrollerContent.buddiesGroup.getNextHighestDepth(),{_x:0,_y:246});
      with(this.scrollerContent.buddiesGroup.pagingGroup)
      {
         var _loc7_ = new TextFormat();
         _loc7_.font = "Arial";
         _loc7_.size = 10.7;
         _loc7_.bold = true;
         createEmptyMovieClip("fldPrev",getNextHighestDepth());
         fldPrev.createTextField("fld",fldPrev.getNextHighestDepth(),0,0,10,20);
         fldPrev.fld.selectable = false;
         fldPrev.fld.embedFonts = true;
         fldPrev.fld.autoSize = true;
         if(curPage != 1)
         {
            _loc7_.color = 16777215;
            fldPrev.gotoPage = curPage - 1;
            fldPrev.onRelease = function()
            {
               classes.HomeProfile._MC.drawMyBuddies(this.gotoPage);
            };
         }
         else
         {
            _loc7_.color = 10263708;
         }
         fldPrev.fld.setNewTextFormat(_loc7_);
         fldPrev.fld.text = "Prev";
         createEmptyMovieClip("fldNext",getNextHighestDepth());
         fldNext._x = 245;
         fldNext.createTextField("fld",getNextHighestDepth(),0,0,10,20);
         fldNext.fld.selectable = false;
         fldNext.fld.embedFonts = true;
         fldNext.fld.autoSize = true;
         if(curPage != _loc6_)
         {
            _loc7_.color = 16777215;
            fldNext.gotoPage = curPage + 1;
            fldNext.onRelease = function()
            {
               classes.HomeProfile._MC.drawMyBuddies(this.gotoPage);
            };
         }
         else
         {
            _loc7_.color = 10263708;
         }
         fldNext.fld.setNewTextFormat(_loc7_);
         fldNext.fld.text = "Next";
         _loc7_.color = 16777215;
         createTextField("fldPaging",getNextHighestDepth(),122,0,10,20);
         fldPaging.selectable = false;
         fldPaging.embedFonts = true;
         fldPaging.html = true;
         fldPaging.autoSize = "center";
         fldPaging.setNewTextFormat(_loc7_);
         var _loc8_ = 1;
         while(_loc8_ <= _loc6_)
         {
            if(_loc8_ == curPage)
            {
               fldPaging.htmlText += _loc8_ + " ";
            }
            else
            {
               fldPaging.htmlText += "<a href=\"asfunction:classes.HomeProfile._MC.drawMyBuddies," + _loc8_ + "\"><u>" + _loc8_ + "</u></a> ";
            }
            _loc8_ = _loc8_ + 1;
         }
      }
   }
   function drawTheBadges(pg)
   {
      trace("drawTheBadges: " + pg);
      this.trophyRoom.drawMyBadges(pg);
   }
}
