class classes.HomeAccount extends MovieClip
{
   var scrollerContent;
   var scrollerObj;
   var txtHeader;
   static var _MC;
   function HomeAccount()
   {
      super();
      trace("HomeAccount Constructor");
      classes.HomeAccount._MC = this;
      this.scrollerContent = this.createEmptyMovieClip("scrollerContent",this.getNextHighestDepth());
      this.scrollerContent._y = 73;
      this.scrollerObj = new controls.ScrollPane(this.scrollerContent,693,394,null,467,694,0);
      trace("facebook connected in HomeAccount: " + classes.GlobalData.facebookConnected);
      this.goAccountPage(1);
   }
   function goAccountPage(idx)
   {
      this._parent.selectSnav(idx);
      classes.ClipFuncs.removeAllClips(this.scrollerContent);
      switch(idx)
      {
         case 1:
            this.txtHeader = "Security";
            §§push(this.gotoAndPlay("security"));
            break;
         case 2:
            this.txtHeader = "Membership";
            §§push(this.gotoAndPlay("membership"));
            break;
         case 3:
            this.txtHeader = "Email Setup";
            §§push(this.gotoAndPlay("email"));
            break;
         case 4:
            this.txtHeader = "Points";
            §§push(this.gotoAndPlay("points"));
            break;
         case 5:
            trace("home account twitter login");
            this.txtHeader = "Twitter";
            _root.twitterLogin("","","checkstatus");
            §§push(this.gotoAndPlay("twitter"));
         default:
            return undefined;
      }
   }
   function drawMyPlaces()
   {
      trace("drawMyPlaces");
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
            _loc10_ = Number(_global.locationXML.firstChild.childNodes[_loc6_].attributes.ps);
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
            _loc12_.txtInfo += "\n" + _loc10_ + " parking spaces";
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
   }
}
