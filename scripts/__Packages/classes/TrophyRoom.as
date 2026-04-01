class classes.TrophyRoom
{
   var _userInfo;
   var scrollerContent;
   var scrollerObj;
   var cols;
   var rows;
   var _usePaging;
   var _allowSetVisibility;
   var _xTrophyPos;
   var _yTrophyPos;
   var _pagingFunction;
   var _intervalCount;
   var badgeIntervalID;
   var badgeShow;
   var _xmouse;
   var _ymouse;
   var userInfo;
   var id;
   function TrophyRoom()
   {
   }
   function init(userInfo, a_scrollObj, a_scrollerContent, a_cols, a_rows, usePaging, allowSetVisibility, xTrophyPos, yTrophyPos, pagingFunction)
   {
      this._userInfo = userInfo;
      this.scrollerContent = a_scrollerContent;
      this.scrollerObj = a_scrollObj;
      this.cols = a_cols;
      this.rows = a_rows;
      this._usePaging = usePaging;
      this._allowSetVisibility = allowSetVisibility;
      this._xTrophyPos = xTrophyPos;
      this._yTrophyPos = yTrophyPos;
      this._pagingFunction = pagingFunction;
      this._intervalCount = 0;
      trace("init: ");
      trace(this.cols);
      trace(this.rows);
   }
   function drawBadges()
   {
      trace("drawBadges!");
      trace(this.cols);
      trace(this.rows);
      this._intervalCount += 1;
      clearInterval(this.badgeIntervalID);
      trace("badgeIntervalID: " + this.badgeIntervalID);
      trace("after clear interval");
      trace(this._userInfo);
      trace(this._userInfo.badgesReceived);
      if(this._intervalCount < 100)
      {
         if(this._userInfo.badgesReceived == true)
         {
            trace("drawing badges");
            this.drawMyBadges(1);
         }
         else
         {
            trace("setting interval again");
            this.badgeIntervalID = setInterval(this,"drawBadges",100);
         }
      }
   }
   function drawMyBadges(pg)
   {
      pg = Number(pg);
      trace("drawMyBadges(" + pg + ")");
      this.scrollerObj.setScrollToTop();
      this.scrollerContent.badgesGroup.removeMovieClip();
      this.scrollerContent.createEmptyMovieClip("badgesGroup",this.scrollerContent.getNextHighestDepth());
      this.scrollerContent.badgesGroup._x = this._xTrophyPos;
      this.scrollerContent.badgesGroup._y = this._yTrophyPos;
      var _loc4_ = 150;
      var _loc5_ = undefined;
      var _loc6_ = this._userInfo.showBadgesXML.firstChild.childNodes.length;
      var _loc7_ = new Array();
      if(this._allowSetVisibility == true)
      {
         _loc5_ = 170;
      }
      else
      {
         _loc5_ = 150;
      }
      if(this._usePaging == false)
      {
         trace("numberOfBadges: " + _loc6_);
         this.rows = Math.ceil(_loc6_ / this.cols);
      }
      var _loc8_ = (pg - 1) * this.cols * this.rows;
      var _loc9_ = Math.min(this.cols * this.rows,this._userInfo.showBadgesXML.firstChild.childNodes.length - _loc8_);
      var _loc10_ = undefined;
      var _loc11_ = undefined;
      trace("lim: " + _loc9_);
      trace("cols: " + this.cols);
      trace("rows: " + this.rows);
      var _loc12_ = 0;
      var _loc13_ = undefined;
      var _loc14_ = undefined;
      var _loc15_ = undefined;
      var _loc16_ = undefined;
      var _loc17_ = undefined;
      var _loc18_ = undefined;
      var _loc19_ = undefined;
      var _loc20_ = undefined;
      while(_loc12_ < _loc9_)
      {
         _loc10_ = _loc12_ % this.cols * _loc4_;
         _loc11_ = Math.floor(_loc12_ / this.cols) * _loc5_;
         _loc13_ = Number(this._userInfo.showBadgesXML.firstChild.childNodes[_loc12_ + _loc8_].attributes.i);
         _loc14_ = Number(this._userInfo.showBadgesXML.firstChild.childNodes[_loc12_ + _loc8_].attributes.n);
         _loc15_ = Number(this._userInfo.showBadgesXML.firstChild.childNodes[_loc12_ + _loc8_].attributes.v);
         this.scrollerContent.badgesGroup.attachMovie("_blank","badge" + _loc12_,this.scrollerContent.badgesGroup.getNextHighestDepth(),{_x:_loc10_,_y:_loc11_,id:_loc13_});
         _loc16_ = this.scrollerContent.badgesGroup["badge" + _loc12_];
         _loc16_.attachBitmap(_root.badgesHolder.arrBmpLarge[_loc13_],_loc16_.getNextHighestDepth());
         _loc16_.userInfo = this._userInfo;
         if(this._allowSetVisibility == true)
         {
            _loc16_.attachMovie("badgeShow","badgeShow",_loc16_.getNextHighestDepth(),{_x:45,_y:145});
            if(_loc15_ == "1")
            {
               _loc16_.badgeShow.box.gotoAndStop(2);
            }
            else
            {
               _loc16_.badgeShow.box.gotoAndStop(1);
            }
            trace("badgeShow: " + _loc16_.badgeShow);
            _loc16_.onRelease = function()
            {
               trace("badgeShow release");
               var _loc3_ = this.badgeShow.getBounds(this);
               var _loc4_ = new flash.geom.Rectangle(_loc3_.xMin,_loc3_.yMin,_loc3_.xMax - _loc3_.xMin,_loc3_.yMax - _loc3_.yMin);
               trace(_loc4_);
               trace(this._xmouse);
               trace(this._ymouse);
               if(_loc4_.contains(this._xmouse,this._ymouse))
               {
                  trace("badgeMovie userInfo: " + this.userInfo);
                  if(this.badgeShow.box._currentFrame == 1)
                  {
                     trace("goto and stop 2");
                     this.badgeShow.box.gotoAndStop(2);
                     trace("badgeNum: " + this.id);
                     this.userInfo.showBadge(true,String(this.id));
                     _root.setBadgeVisible(String(this.id),true);
                  }
                  else
                  {
                     trace("goto and stop 1");
                     this.badgeShow.box.gotoAndStop(1);
                     this.userInfo.showBadge(false,String(this.id));
                     _root.setBadgeVisible(String(this.id),false);
                  }
               }
            };
         }
         trace("badgeMovie: " + _loc16_);
         trace("badgeMovieParent: " + _loc16_._parent);
         trace("badgeMovieXY: " + _loc16_._x + " " + _loc16_._y);
         trace("badgeNumber: " + _loc13_);
         if(_loc14_ > 1)
         {
            _loc17_ = _loc16_.createTextField("count",2,100,115,24,20);
            _loc18_ = new TextFormat();
            _loc18_.font = "Arial";
            _loc18_.size = 10;
            _loc18_.color = 16777215;
            _loc18_.align = "right";
            _loc17_.embedFonts = true;
            _loc17_.autoSize = "right";
            _loc17_.setNewTextFormat(_loc18_);
            _loc17_.text = String(_loc14_);
         }
         _loc19_ = classes.Lookup.badgeAltText(_loc13_);
         _loc20_ = classes.Lookup.badgeAltDescription(_loc13_);
         trace("badgeDescription: " + _loc20_);
         classes.Help.addAltTag2(_loc16_,_loc19_,_loc20_);
         _loc12_ += 1;
      }
      if(this._usePaging == true)
      {
         this.drawBadgePaging(pg);
      }
      else
      {
         this.scrollerObj.refreshScroller();
      }
   }
   function drawBadgePaging(curPage, setNum)
   {
      var _loc4_ = 8;
      var _loc5_ = Math.ceil(this._userInfo.showBadgesXML.firstChild.childNodes.length / _loc4_);
      this.scrollerContent.badgesGroup.pagingGroup.removeMovieClip();
      this.scrollerContent.badgesGroup.attachMovie("_blank","pagingGroup",this.scrollerContent.badgesGroup.getNextHighestDepth(),{_x:0,_y:375});
      with(this.scrollerContent.badgesGroup.pagingGroup)
      {
         var _loc6_ = new TextFormat();
         _loc6_.font = "Arial";
         _loc6_.size = 10.7;
         _loc6_.bold = true;
         createEmptyMovieClip("fldPrev",getNextHighestDepth());
         fldPrev.createTextField("fld",fldPrev.getNextHighestDepth(),0,0,10,20);
         fldPrev.fld.selectable = false;
         fldPrev.fld.embedFonts = true;
         fldPrev.fld.autoSize = true;
         if(curPage != 1)
         {
            _loc6_.color = 16777215;
            fldPrev.gotoPage = curPage - 1;
            fldPrev.trophyRoom = this;
            fldPrev.onRelease = function()
            {
               trace(this.trophyRoom);
               this.trophyRoom.drawMyBadges(this.gotoPage);
            };
         }
         else
         {
            _loc6_.color = 10263708;
         }
         fldPrev.fld.setNewTextFormat(_loc6_);
         fldPrev.fld.text = "Prev";
         createEmptyMovieClip("fldNext",getNextHighestDepth());
         fldNext._x = 245;
         fldNext.createTextField("fld",getNextHighestDepth(),0,0,10,20);
         fldNext.fld.selectable = false;
         fldNext.fld.embedFonts = true;
         fldNext.fld.autoSize = true;
         if(curPage != _loc5_)
         {
            _loc6_.color = 16777215;
            fldNext.gotoPage = curPage + 1;
            fldNext.trophyRoom = this;
            fldNext.onRelease = function()
            {
               trace("fldNext release");
               trace(this);
               trace(this.trophyRoom);
               this.trophyRoom.drawMyBadges(this.gotoPage);
            };
         }
         else
         {
            _loc6_.color = 10263708;
         }
         fldNext.fld.setNewTextFormat(_loc6_);
         fldNext.fld.text = "Next";
         _loc6_.color = 16777215;
         createTextField("fldPaging",getNextHighestDepth(),122,0,10,20);
         fldPaging.selectable = false;
         fldPaging.embedFonts = true;
         fldPaging.html = true;
         fldPaging.autoSize = "center";
         fldPaging.setNewTextFormat(_loc6_);
         var _loc7_ = 1;
         while(_loc7_ <= _loc5_)
         {
            if(_loc7_ == curPage)
            {
               fldPaging.htmlText += _loc7_ + " ";
            }
            else
            {
               trace("creating click link, instance num: " + this);
               fldPaging.htmlText += "<a href=\"asfunction:classes.HomeProfile._MC.drawTheBadges," + _loc7_ + "\"><u>" + _loc7_ + "</u></a> ";
            }
            _loc7_ = _loc7_ + 1;
         }
      }
      this.scrollerContent.badgesGroup.pagingGroup._x = 300 - this.scrollerContent.badgesGroup.pagingGroup._width / 2;
      trace("pagingGroup.x: " + this.scrollerContent.badgesGroup.pagingGroup._x);
      trace("pagingGroup.width: " + this.scrollerContent.badgesGroup.pagingGroup._width);
   }
}
