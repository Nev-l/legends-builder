class classes.Viewer extends MovieClip
{
   var myClr;
   var clrOverlay;
   var ro1;
   var ro2;
   var btnWinDrag;
   var btnMinimize;
   var scrollerContent;
   var scrollerObj;
   var uID;
   var tID;
   var tog_im;
   var tog_email;
   var tog_addbuddy;
   var tog_reportMisconduct;
   var tabDown;
   var uTID;
   var uTname;
   var uName;
   var uCred;
   var txtStats;
   var userInfo;
   var idx;
   var sectionNum;
   var rptMisconductBubble;
   var teamInfo;
   var reloadTeamInfo;
   var tx;
   var onEnterFrame;
   var currentXNum;
   var ty;
   var trophyRoom;
   var goldPlate;
   var badgeArray;
   var membersArr;
   var icnSearchResults;
   var btnSearchRacers;
   var btnSearchTeams;
   var carID;
   var txtResultCount;
   static var __MC;
   static var _MC;
   static var viewXML;
   static var viewTeamXML;
   static var viewBuddiesXML;
   static var curSearchPage;
   static var showingSearchType;
   static var totalSearchPages;
   static var viewCarsXML;
   static var viewRemarksXML;
   var txtSearch = "";
   var txtPagingNav = "";
   var searchTerm = "";
   var x3 = 597;
   var x4 = 705;
   function Viewer()
   {
      super();
      classes.Viewer.__MC = this;
      classes.Viewer._MC = this;
      this.cacheAsBitmap = true;
      this.myClr = new Color(this.clrOverlay);
      this.ro1._visible = false;
      this.ro2._visible = false;
      this.profileElementsVisibility(false);
      this.initSearchPage();
      var _loc4_ = 1;
      this.btnWinDrag.onPress = function()
      {
         classes.Viewer._MC.swapDepths(classes.Viewer._MC._parent.getNextHighestDepth());
         classes.Viewer._MC.startDrag(false);
      };
      this.btnWinDrag.onRelease = this.btnWinDrag.onReleaseOutside = function()
      {
         classes.Viewer._MC.stopDrag();
      };
      this.btnWinDrag.useHandCursor = false;
      this.btnMinimize.onRelease = function()
      {
         classes.Control.dockViewer();
      };
      if(this.scrollerContent == undefined)
      {
         this.scrollerContent = this.createEmptyMovieClip("scrollerContent",this.getNextHighestDepth());
         this.scrollerContent._x = 112;
         this.scrollerContent._y = 192;
         this.scrollerObj = new controls.ScrollPane(this.scrollerContent,646,241,null,307,761,131);
      }
      if(this.uID)
      {
         classes.Lookup.addCallback("getUser",this,this.CB_getUser,String(this.uID));
         _root.getUser(this.uID);
      }
      else if(this.tID)
      {
         this.goSection(3);
      }
      else
      {
         this.goSearch();
      }
   }
   function CB_getUser(d)
   {
      trace("CB_getUser");
      classes.Viewer.__MC.initUser(d);
   }
   function profileElementsVisibility(vis)
   {
      this.tog_im._visible = vis;
      this.tog_email._visible = vis;
      this.tog_addbuddy._visible = vis;
      this.tog_reportMisconduct._visible = vis;
      this.tabDown._visible = vis;
      this.ro1._visible = vis;
      this.ro2._visible = vis;
   }
   function initUser(d)
   {
      classes.Viewer.viewXML = new XML(d);
      this.uID = classes.Viewer.viewXML.firstChild.firstChild.attributes.i;
      this.uTID = Number(classes.Viewer.viewXML.firstChild.firstChild.attributes.ti);
      this.uTname = classes.Viewer.viewXML.firstChild.firstChild.attributes.tn;
      this.uName = classes.Viewer.viewXML.firstChild.firstChild.attributes.u;
      this.uCred = classes.Viewer.viewXML.firstChild.firstChild.attributes.sc;
      if(Number(classes.Viewer.viewXML.firstChild.firstChild.attributes.w) > -1)
      {
         this.txtStats = "Wins: " + classes.Viewer.viewXML.firstChild.firstChild.attributes.w + "    Losses: " + classes.Viewer.viewXML.firstChild.firstChild.attributes.l;
      }
      else
      {
         this.txtStats = "win/loss stats available with membership";
      }
      if(classes.Viewer.viewXML.firstChild.firstChild.attributes.bg.length)
      {
         this.paintOverlay(classes.Viewer.viewXML.firstChild.firstChild.attributes.bg);
      }
      var _loc3_ = undefined;
      if(this.userInfo.uID != this.uID)
      {
         this.userInfo.removeMovieClip();
         _loc3_ = this.attachMovie("userInfo","userInfo",this.getNextHighestDepth(),{_x:28,_y:89,uID:this.uID,uName:this.uName,tID:this.uTID,tName:this.uTname,uCred:this.uCred,showBadgesXML:new XML(classes.Viewer.viewXML.firstChild.firstChild.toString())});
         _loc3_.cacheAsBitmap = true;
      }
      var _loc4_ = 1;
      while(_loc4_ <= 2)
      {
         classes.Effects.roBump(classes.Viewer.__MC["ro" + _loc4_]);
         classes.Viewer.__MC["ro" + _loc4_].idx = _loc4_;
         classes.Viewer.__MC["ro" + _loc4_]._visible = true;
         classes.Viewer.__MC["ro" + _loc4_].onRelease = function()
         {
            if(classes.Control.serverAvail())
            {
               this._parent.goSection(this.idx);
            }
         };
         _loc4_ += 1;
      }
      this.initProfileButtons();
      if(this.scrollerContent == undefined)
      {
         this.scrollerContent = this.createEmptyMovieClip("scrollerContent",this.getNextHighestDepth());
         this.scrollerContent._x = 112;
         this.scrollerContent._y = 192;
         this.scrollerObj = new controls.ScrollPane(this.scrollerContent,646,241,null,307,761,131);
      }
      this.goSection(this.sectionNum);
   }
   function initProfileButtons()
   {
      this.tog_im._visible = true;
      this.tog_email._visible = true;
      this.tog_addbuddy._visible = true;
      this.tog_reportMisconduct._visible = true;
      this.rptMisconductBubble._visible = false;
      classes.Effects.roBounce(this.tog_im);
      classes.Effects.roBounce(this.tog_email);
      classes.Effects.roBounce(this.tog_addbuddy);
      classes.Effects.roBounce(this.tog_reportMisconduct);
      this.tog_im.onRelease = function()
      {
         classes.Control.focusNim(this._parent.uID);
      };
      this.tog_email.onRelease = function()
      {
         classes.Control.focusEmail(this._parent.uName);
      };
      this.tog_addbuddy.onRelease = function()
      {
         _root.inquiryNimUser(this._parent.uName,this._parent.uID);
      };
      this.tog_reportMisconduct.onRelease = function()
      {
         var _loc2_ = classes.SupportCenter.USER_TYPE;
         var _loc3_ = classes.SupportCenter.USER;
         if(classes.GlobalData.role == 1 || classes.GlobalData.role == 8)
         {
            _loc3_ = classes.SupportCenter.MOD;
            _loc2_ = classes.SupportCenter.SENIOR_MOD_TYPE;
         }
         else if(classes.GlobalData.role == 2)
         {
            _loc3_ = classes.SupportCenter.MOD;
            _loc2_ = classes.SupportCenter.MOD_TYPE;
         }
         if(_loc3_ == classes.SupportCenter.MOD)
         {
            trace("viewer, selected id: " + this._parent.uID);
            classes.Control.focusModTools(_loc2_,classes.data.SupportCenterData.USER_DETAILS,this._parent.uName,this._parent.uID);
         }
         else
         {
            classes.Control.focusSupportCenter(_loc2_,classes.data.SupportCenterData.REPORT_MISCONDUCT,this._parent.uName);
         }
      };
   }
   function clearUser()
   {
      trace("clearUser");
      this.paintOverlay();
      this.userInfo.removeMovieClip();
      this.teamInfo.removeMovieClip();
      for(var _loc2_ in this.scrollerContent)
      {
         this.scrollerContent[_loc2_].removeMovieClip();
      }
      classes.Viewer.__MC.scrollerObj.setScrollToTop();
   }
   function goSection(idx)
   {
      trace("goSection: " + idx);
      this.txtSearch = "";
      classes.ClipFuncs.removeAllClips(this.scrollerContent);
      this.reloadTeamInfo = true;
      this.scrollerContent.clear();
      this.scrollerContent._x = 112;
      this.scrollerContent._y = 192;
      this.scrollerObj.resetMask(this.scrollerContent._x,this.scrollerContent._y,646,241);
      if(idx != 3 && idx != 4)
      {
         this.teamInfo.removeMovieClip();
         delete this.teamInfo;
         if(idx == 1 || idx == 2)
         {
            classes.Viewer.__MC.tabDown._visible = true;
            classes.Viewer.__MC.tabDown.tx = classes.Viewer.__MC["ro" + idx]._x;
            classes.Viewer.__MC.tabDown.onEnterFrame = function()
            {
               this._x += (this.tx - this._x) / 3;
               if(Math.abs(this.tx - this._x) < 0.1)
               {
                  delete this.onEnterFrame;
               }
            };
         }
      }
      else
      {
         if(idx == 3)
         {
            this.teamInfo.removeMovieClip();
            trace("__MC.tabDown._x");
            trace(classes.Viewer.__MC.tabDown._x);
            this.currentXNum = this.x3;
            if(classes.Viewer.__MC.tabDown._x != this.x4)
            {
               classes.Viewer.__MC.tabDown._x = this.x3;
            }
            else
            {
               this.reloadTeamInfo = false;
            }
         }
         else
         {
            this.currentXNum = this.x4;
         }
         classes.Viewer.__MC.tabDown._visible = true;
         classes.Viewer.__MC.tabDown.tx = this.currentXNum;
         classes.Viewer.__MC.tabDown.onEnterFrame = function()
         {
            this._x += (this.tx - this._x) / 3;
            if(Math.abs(this.tx - this._x) < 0.1)
            {
               trace("stuff: " + this._x);
               this._x = this.tx;
               delete this.onEnterFrame;
            }
         };
      }
      trace("tabDown._x");
      trace(classes.Viewer.__MC.tabDown._x);
      switch(idx)
      {
         case 0:
            classes.Control.serverUnlock();
            this.gotoAndStop(1);
            this.scrollerObj.setScrollToTop();
            break;
         case 1:
            this.gotoAndPlay("garage");
            this.scrollerObj.setScrollToTop();
            this.initProfileButtons();
            break;
         case 2:
            this.gotoAndPlay("profile");
            this.scrollerObj.setScrollToTop();
            this.initProfileButtons();
            break;
         case 3:
            this.goTeam();
            break;
         case 4:
            this.goTeamTrophies();
         default:
            return undefined;
      }
   }
   function goProfilePage(idx)
   {
      classes.Viewer.__MC.selSnav = idx;
      classes.Viewer.__MC.snavDown.onEnterFrame = function()
      {
         this.ty = this._parent["snav" + idx]._y;
         this._y += (this.ty - this._y) / 3;
         if(Math.abs(this.ty - this._y) < 0.1)
         {
            this._y = this.ty;
            delete this.onEnterFrame;
         }
      };
      this.clearProfileContentAll();
      switch(idx)
      {
         case 1:
            trace("my buddies!");
            if(this.scrollerContent.remarkMC == undefined)
            {
               classes.Remark(this.scrollerContent.attachMovie("Remark","remarkMC",this.scrollerContent.getNextHighestDepth(),{_x:360,_y:8}));
               _root.getUserRemarks(this.uID);
            }
            _root.getUserBuddies(this.uID);
         case 2:
            this.gotoAndStop("trophies");
            trace(this.scrollerContent.remarkMC);
            this.trophyRoom = new classes.TrophyRoom();
            trace(classes.HomeProfile._MC);
            trace(classes.HomeProfile._MC._parent.userInfo);
            trace(this.userInfo);
            this.trophyRoom.init(classes.UserInfo(this.userInfo),this.scrollerObj,this.scrollerContent,4,2,false,false,37,-10);
            this.trophyRoom.badgeIntervalID = setInterval(this.trophyRoom,"drawBadges",100);
      }
      return undefined;
   }
   function goSearch()
   {
      trace("goSearch");
      this.clearProfileContent();
      this.profileElementsVisibility(false);
      this.initSearchPage();
      this.gotoAndPlay("search");
   }
   function goTeam()
   {
      trace("goTeam");
      this.clearProfileContent();
      this.profileElementsVisibility(false);
      this.tabDown._visible = true;
      classes.ClipFuncs.removeAllClips(this.scrollerContent);
      this.scrollerContent._x = 74;
      classes.Viewer.__MC.scrollerObj.resetMask(this.scrollerContent._x,null,662);
      trace("goto team");
      var _loc2_ = 3;
      §§push(this.gotoAndPlay("team"));
      while(_loc2_ <= 4)
      {
         trace("bumpers:");
         trace(classes.Viewer.__MC["ro" + _loc2_]);
         classes.Effects.roBump(classes.Viewer.__MC["ro" + _loc2_]);
         classes.Viewer.__MC["ro" + _loc2_].idx = _loc2_;
         classes.Viewer.__MC["ro" + _loc2_]._visible = true;
         classes.Viewer.__MC["ro" + _loc2_].onRelease = function()
         {
            trace("onRelease!");
            this._parent.goSection(this.idx);
         };
         _loc2_ += 1;
      }
   }
   function goTeamTrophies()
   {
      trace("goTeamTrophies");
      trace(this.teamInfo);
      this.teamInfo.swapDepths(this.getNextHighestDepth());
      var _loc2_ = 163;
      var _loc3_ = classes.Viewer.viewTeamXML.firstChild.firstChild.attributes;
      this.goldPlate.txtField.text = _loc3_.n;
      this.drawBadges(classes.Viewer.viewTeamXML);
      this.gotoAndStop("teamTrophies");
   }
   function drawBadges(bxml)
   {
      this.badgeArray = new Array();
      var _loc3_ = undefined;
      trace("bxml: ");
      trace(bxml);
      var _loc4_ = 0;
      while(_loc4_ < bxml.firstChild.firstChild.childNodes.length)
      {
         trace(bxml.firstChild.firstChild.childNodes[_loc4_].nodeName);
         if(bxml.firstChild.firstChild.childNodes[_loc4_].nodeName == "b")
         {
            trace("found badge!");
            _loc3_ = bxml.firstChild.firstChild.childNodes[_loc4_].attributes;
            this.badgeArray.push(_loc3_);
         }
         _loc4_ += 1;
      }
      this.drawMyBadges(1);
   }
   function drawMyBadges(pg)
   {
      if(this.scrollerContent == undefined)
      {
         this.scrollerContent = this.createEmptyMovieClip("scrollerContent",this.getNextHighestDepth());
         this.scrollerContent._y = 205;
         this.scrollerContent._x = 162;
         this.scrollerObj = new controls.ScrollPane(this.scrollerContent,693,394,null,467,694,0);
      }
      this.scrollerContent._x = 131;
      this.scrollerContent._y = 176;
      this.scrollerObj.resetMask(this.scrollerContent._x,this.scrollerContent._y,646,500);
      trace(this.scrollerContent);
      pg = Number(pg);
      trace("drawMyBadges(" + pg + ")");
      this.scrollerObj.setScrollToTop();
      this.scrollerContent.badgesGroup.removeMovieClip();
      this.scrollerContent.createEmptyMovieClip("badgesGroup",this.scrollerContent.getNextHighestDepth());
      var _loc4_ = 157;
      var _loc5_ = 113;
      var _loc6_ = 4;
      var _loc7_ = 2;
      var _loc8_ = (pg - 1) * _loc6_ * _loc7_;
      var _loc9_ = Math.min(_loc6_ * _loc7_,this.badgeArray.length - _loc8_);
      var _loc10_ = undefined;
      var _loc11_ = undefined;
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
         _loc10_ = _loc12_ % _loc6_ * _loc4_;
         _loc11_ = Math.floor(_loc12_ / _loc6_) * _loc5_;
         _loc13_ = Number(this.badgeArray[_loc12_ + _loc8_].i);
         _loc14_ = Number(this.badgeArray[_loc12_ + _loc8_].n);
         _loc15_ = Number(this.badgeArray[_loc12_ + _loc8_].v);
         this.scrollerContent.badgesGroup.attachMovie("_blank","badge" + _loc12_,this.scrollerContent.badgesGroup.getNextHighestDepth(),{_x:_loc10_,_y:_loc11_,id:_loc13_});
         _loc16_ = this.scrollerContent.badgesGroup["badge" + _loc12_];
         _loc16_.attachBitmap(_root.badgesHolder.arrBmpLarge[_loc13_],_loc16_.getNextHighestDepth());
         trace("badgeMovie: " + _loc16_);
         trace("badgeMovieParent: " + _loc16_._parent);
         trace("badgeMovieXY: " + _loc16_._x + " " + _loc16_._y);
         trace("badge bitmap: " + _root.badgesHolder.arrBmpLarge[_loc13_]);
         trace("badgeNumber: " + _loc13_);
         if(_loc14_ > 1)
         {
            _loc17_ = _loc16_.createTextField("count",2,75,5,24,20);
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
      this.drawBadgePaging(pg);
   }
   function drawBadgePaging(curPage, setNum)
   {
      var _loc4_ = 8;
      var _loc5_ = Math.ceil(this.badgeArray.length / _loc4_);
      this.scrollerContent.badgesGroup.pagingGroup.removeMovieClip();
      this.scrollerContent.badgesGroup.attachMovie("_blank","pagingGroup",this.scrollerContent.badgesGroup.getNextHighestDepth(),{_x:0,_y:242});
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
            fldPrev.onRelease = function()
            {
               classes.Viewer._MC.drawMyBadges(this.gotoPage);
            };
         }
         else
         {
            _loc6_.color = 10263708;
         }
         fldPrev.fld.setNewTextFormat(_loc6_);
         fldPrev.fld.text = "Prev";
         createEmptyMovieClip("fldNext",getNextHighestDepth());
         fldNext._x = 175;
         fldNext.createTextField("fld",getNextHighestDepth(),0,0,10,20);
         fldNext.fld.selectable = false;
         fldNext.fld.embedFonts = true;
         fldNext.fld.autoSize = true;
         if(curPage != _loc5_)
         {
            _loc6_.color = 16777215;
            fldNext.gotoPage = curPage + 1;
            fldNext.onRelease = function()
            {
               classes.Viewer._MC.drawMyBadges(this.gotoPage);
            };
         }
         else
         {
            _loc6_.color = 10263708;
         }
         fldNext.fld.setNewTextFormat(_loc6_);
         fldNext.fld.text = "Next";
         _loc6_.color = 16777215;
         createTextField("fldPaging",getNextHighestDepth(),93,0,10,20);
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
               fldPaging.htmlText += "<a href=\"asfunction:classes.Viewer._MC.drawMyBadges," + _loc7_ + "\"><u>" + _loc7_ + "</u></a> ";
            }
            _loc7_ = _loc7_ + 1;
         }
      }
      this.scrollerContent.badgesGroup.pagingGroup._x = 182;
   }
   function clearProfileContent()
   {
      for(var _loc2_ in this.scrollerContent)
      {
         if(_loc2_ != "remarkMC")
         {
            this.scrollerContent[_loc2_].removeMovieClip();
         }
      }
   }
   function clearProfileContentAll()
   {
      for(var _loc2_ in this.scrollerContent)
      {
         this.scrollerContent[_loc2_].removeMovieClip();
      }
   }
   function drawTeam(txml)
   {
      var _loc3_ = txml.firstChild.firstChild.attributes;
      var _loc4_ = this.attachMovie("teamInfo","teamInfo",this.getNextHighestDepth(),{_x:28,_y:89,tID:_loc3_.i,tName:_loc3_.n,tCred:_loc3_.sc,teamXML:classes.Viewer.viewTeamXML});
      _loc4_.cacheAsBitmap = true;
      var _loc5_ = txml.firstChild.firstChild.attributes;
      this.txtStats = "Wins: " + _loc5_.tw + "    " + "Losses: " + _loc5_.tl;
      this.paintOverlay(_loc3_.bg);
      var _loc6_ = {_x:23};
      _loc6_.txtCreateDate = _loc3_.de.substr(0,_loc3_.de.indexOf(" "));
      _loc6_.txtTeamFunds = "$" + _loc3_.tf;
      _loc6_.txtMsg = _loc3_.lc;
      var _loc7_ = 0;
      while(_loc7_ < txml.firstChild.firstChild.childNodes.length)
      {
         if(txml.firstChild.firstChild.childNodes[_loc7_].attributes.tr == 1)
         {
            _loc6_.leaderID = txml.firstChild.firstChild.childNodes[_loc7_].attributes.i;
            _loc6_.leaderName = txml.firstChild.firstChild.childNodes[_loc7_].attributes.un;
            _loc6_.leaderSC = txml.firstChild.firstChild.childNodes[_loc7_].attributes.sc;
            _loc6_.leaderET = txml.firstChild.firstChild.childNodes[_loc7_].attributes.et;
            break;
         }
         _loc7_ += 1;
      }
      _loc4_ = this.scrollerContent.attachMovie("viewerTeamInfo1","teamInfo1",this.scrollerContent.getNextHighestDepth(),_loc6_);
      _loc4_.cacheAsBitmap = true;
      this.drawTeamMembers(1);
      this.scrollerObj.setScrollToTop();
   }
   function drawTeamMembers(pg)
   {
      if(!pg)
      {
         pg = 1;
      }
      var _loc3_ = classes.Viewer.viewTeamXML;
      this.scrollerContent.membersGroup.removeMovieClip();
      this.scrollerContent.attachMovie("_blank","membersGroup",this.scrollerContent.getNextHighestDepth(),{_x:440});
      var _loc4_ = 77;
      var _loc5_ = 62;
      var _loc6_ = 3;
      var _loc7_ = 3;
      var _loc8_ = (pg - 1) * _loc6_ * _loc7_;
      var _loc9_ = new Array();
      var _loc10_ = 0;
      while(_loc10_ < _loc3_.firstChild.firstChild.childNodes.length)
      {
         if(Number(_loc3_.firstChild.firstChild.childNodes[_loc10_].attributes.tr) > 1)
         {
            _loc9_.push(_loc3_.firstChild.firstChild.childNodes[_loc10_].attributes);
         }
         _loc10_ = _loc10_ + 1;
      }
      _loc9_.sortOn(["tr","sc","un"],[1,Array.DESCENDING,1]);
      this.membersArr = new Array();
      var _loc11_ = 0;
      _loc10_ = 0;
      while(_loc10_ < _loc9_.length)
      {
         this.membersArr[_loc11_] = _loc9_[_loc10_];
         if(this.membersArr[_loc11_].tr != 4)
         {
            _loc11_ += _loc6_;
         }
         else
         {
            _loc11_ += 1;
         }
         _loc10_ = _loc10_ + 1;
      }
      var _loc12_ = Math.min(_loc6_ * _loc7_,this.membersArr.length - _loc8_);
      var _loc13_ = new TextFormat();
      _loc13_.font = "Arial";
      _loc13_.size = 8;
      _loc13_.color = 16777215;
      var _loc14_ = undefined;
      var _loc15_ = undefined;
      var _loc16_ = undefined;
      var _loc17_ = undefined;
      var _loc18_ = 0;
      _loc10_ = 0;
      while(_loc10_ < _loc12_)
      {
         if(_loc10_ && _loc10_ % 3 == 0)
         {
            _loc18_ += _loc5_;
         }
         _loc14_ = Boolean(this.membersArr[_loc10_ + _loc8_].tr != 4);
         _loc17_ = _loc10_ % _loc6_ * _loc4_;
         if(this.membersArr[_loc10_ + _loc8_].tr == 2 && !this.scrollerContent.membersGroup.headCoLeader)
         {
            classes.Drawing.standardText(this.scrollerContent.membersGroup,"headCoLeader","Co-Leaders:",-10,_loc18_,80,"right");
            _loc18_ += 10;
         }
         else if(this.membersArr[_loc10_ + _loc8_].tr == 3 && !this.scrollerContent.membersGroup.headDealer)
         {
            classes.Drawing.standardText(this.scrollerContent.membersGroup,"headDealer","Dealers:",-10,_loc18_,80,"right");
            _loc18_ += 10;
         }
         else if(this.membersArr[_loc10_ + _loc8_].tr == 4 && !this.scrollerContent.membersGroup.headMembers)
         {
            classes.Drawing.standardText(this.scrollerContent.membersGroup,"headMembers","Members:",-10,_loc18_,80,"right");
            _loc18_ += 10;
         }
         this.scrollerContent.membersGroup.attachMovie("_blank","member" + _loc10_,this.scrollerContent.membersGroup.getNextHighestDepth(),{_x:_loc17_,_y:_loc18_,id:this.membersArr[_loc10_ + _loc8_].i,un:this.membersArr[_loc10_ + _loc8_].un});
         if(_loc14_)
         {
            _loc15_ = this.scrollerContent.membersGroup["member" + _loc10_].attachMovie("userInfo50","userInfo",1,{scale:50,uID:this.membersArr[_loc10_ + _loc8_].i,uName:this.membersArr[_loc10_ + _loc8_].un,uCred:this.membersArr[_loc10_ + _loc8_].sc});
            _loc16_ = Number(this.membersArr[_loc10_ + _loc8_].et);
            _loc15_.fldTitleET.text = "BEST AVG ET:";
            _loc15_.fldET.text = _loc16_ <= 0 ? "N/A" : classes.NumFuncs.zeroFill(Math.round(_loc16_ * 1000) / 1000,3);
            _loc15_.fldOwnership.text = this.membersArr[_loc10_ + _loc8_].po + "% owner : $" + this.membersArr[_loc10_ + _loc8_].fu;
            _loc15_.cacheAsBitmap = true;
            _loc10_ += 3;
         }
         else
         {
            this.scrollerContent.membersGroup["member" + _loc10_].attachMovie("_blank","pic",1,{_xscale:50,_yscale:50});
            classes.Drawing.portrait(this.scrollerContent.membersGroup["member" + _loc10_].pic,this.scrollerContent.membersGroup["member" + _loc10_].id,1,0,0,2);
            with(this.scrollerContent.membersGroup["member" + _loc10_])
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
               uname.setNewTextFormat(_loc13_);
               uname.text = un;
            }
            _loc10_ += 1;
         }
      }
      if(this.membersArr.length)
      {
         this.drawTeamMembersPaging(pg,_loc18_ + _loc5_);
      }
   }
   function drawTeamMembersPaging(curPage, yPos)
   {
      var _loc5_ = 9;
      var _loc6_ = Math.ceil(this.membersArr.length / _loc5_);
      yPos = Math.max(yPos,207);
      this.scrollerContent.membersGroup.pagingGroup.removeMovieClip();
      this.scrollerContent.membersGroup.attachMovie("_blank","pagingGroup",this.scrollerContent.membersGroup.getNextHighestDepth(),{_x:-50,_y:yPos});
      with(this.scrollerContent.membersGroup.pagingGroup)
      {
         var _loc7_ = new TextFormat();
         _loc7_.font = "Arial";
         _loc7_.size = 10.7;
         _loc7_.bold = true;
         createEmptyMovieClip("fldPrev",getNextHighestDepth());
         if(curPage != 1)
         {
            _loc7_.color = 16777215;
            fldPrev.gotoPage = Number(curPage) - 1;
            fldPrev.onRelease = function()
            {
               classes.Viewer.__MC.drawTeamMembers(this.gotoPage);
            };
         }
         else
         {
            _loc7_.color = 10263708;
         }
         classes.Drawing.standardText(fldPrev,"fld","Prev",0,0,100,"left",_loc7_);
         createEmptyMovieClip("fldNext",getNextHighestDepth());
         fldNext._x = 245;
         if(curPage != _loc6_)
         {
            _loc7_.color = 16777215;
            fldNext.gotoPage = Number(curPage) + 1;
            fldNext.onRelease = function()
            {
               classes.Viewer.__MC.drawTeamMembers(this.gotoPage);
            };
         }
         else
         {
            _loc7_.color = 10263708;
         }
         classes.Drawing.standardText(fldNext,"fld","Next",0,0,100,"left",_loc7_);
         _loc7_.color = 16777215;
         classes.Drawing.standardText(_parent.pagingGroup,"fldPaging","",122,0,100,"center",_loc7_);
         fldPaging.html = true;
         var _loc8_ = 1;
         while(_loc8_ <= _loc6_)
         {
            if(_loc8_ == curPage)
            {
               fldPaging.htmlText += _loc8_ + " ";
            }
            else
            {
               fldPaging.htmlText += "<a href=\"asfunction:classes.Viewer.__MC.drawTeamMembers," + _loc8_ + "\"><u>" + _loc8_ + "</u></a> ";
            }
            _loc8_ = _loc8_ + 1;
         }
      }
   }
   function drawBuddies(pg)
   {
      pg = Number(pg);
      if(!pg)
      {
         pg = 1;
      }
      this.clearProfileContent();
      this.scrollerContent.attachMovie("_blank","buddiesGroup",this.scrollerContent.getNextHighestDepth(),{_x:40,_y:5});
      trace(this.scrollerContent.buddiesGroup);
      var _loc3_ = 77;
      var _loc4_ = 62;
      var _loc5_ = 4;
      var _loc6_ = 3;
      var _loc7_ = (pg - 1) * _loc5_ * _loc6_;
      var _loc8_ = Math.min(_loc5_ * _loc6_,classes.Viewer.viewBuddiesXML.firstChild.childNodes.length - _loc7_);
      var _loc9_ = undefined;
      var _loc10_ = undefined;
      var _loc11_ = 0;
      while(_loc11_ < _loc8_)
      {
         _loc9_ = _loc11_ % _loc5_ * _loc3_;
         _loc10_ = Math.floor(_loc11_ / _loc5_) * _loc4_;
         this.scrollerContent.buddiesGroup.attachMovie("_blank","buddy" + _loc11_,this.scrollerContent.buddiesGroup.getNextHighestDepth(),{_x:_loc9_,_y:_loc10_,id:classes.Viewer.viewBuddiesXML.firstChild.childNodes[_loc11_ + _loc7_].attributes.i});
         this.scrollerContent.buddiesGroup["buddy" + _loc11_].attachMovie("_blank","pic",1,{_xscale:50,_yscale:50});
         classes.Drawing.portrait(this.scrollerContent.buddiesGroup["buddy" + _loc11_].pic,this.scrollerContent.buddiesGroup["buddy" + _loc11_].id,1,0,0,2);
         with(this.scrollerContent.buddiesGroup["buddy" + _loc11_])
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
            var _loc12_ = new TextFormat();
            _loc12_.font = "Arial";
            _loc12_.size = 8;
            _loc12_.color = 16777215;
            uname.setNewTextFormat(_loc12_);
            uname.text = classes.Viewer.viewBuddiesXML.firstChild.childNodes[_loc11_ + _loc7_].attributes.n;
         }
         _loc11_ = _loc11_ + 1;
      }
      this.drawBuddyPaging(pg);
   }
   function drawBuddyPaging(curPage, setNum)
   {
      var _loc4_ = 12;
      var _loc5_ = Math.ceil(classes.Viewer.viewBuddiesXML.firstChild.childNodes.length / _loc4_);
      this.scrollerContent.buddiesGroup.pagingGroup.removeMovieClip();
      this.scrollerContent.buddiesGroup.attachMovie("_blank","pagingGroup",this.scrollerContent.buddiesGroup.getNextHighestDepth(),{_x:0,_y:190});
      with(this.scrollerContent.buddiesGroup.pagingGroup)
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
            fldPrev.gotoPage = Number(curPage) - 1;
            fldPrev.onRelease = function()
            {
               classes.Viewer.__MC.drawBuddies(this.gotoPage);
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
            fldNext.gotoPage = Number(curPage) + 1;
            fldNext.onRelease = function()
            {
               classes.Viewer.__MC.drawBuddies(this.gotoPage);
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
               fldPaging.htmlText += "<a href=\"asfunction:classes.Viewer.__MC.drawBuddies," + _loc7_ + "\"><u>" + _loc7_ + "</u></a> ";
            }
            _loc7_ = _loc7_ + 1;
         }
      }
   }
   function initSearchPage()
   {
      this.icnSearchResults._visible = false;
      this.btnSearchRacers.onRelease = function()
      {
         this._parent.presetSearch();
         this._parent.txtSearchTitle = "Search Results: Racers";
         classes.Lookup.addCallback("racerSearch",this._parent,this._parent.CB_searchRacers,"");
         _root.racerSearch(this._parent.searchTerm);
      };
      this.btnSearchTeams.onRelease = function()
      {
         this._parent.presetSearch();
         this._parent.txtSearchTitle = "Search Results: Teams";
         classes.Lookup.addCallback("teamSearch",this._parent,this._parent.CB_searchTeams,"");
         _root.teamSearch(this._parent.searchTerm);
      };
      if(this.scrollerContent == undefined)
      {
         this.scrollerContent = this.createEmptyMovieClip("scrollerContent",this.getNextHighestDepth());
         this.scrollerContent._x = 112;
         this.scrollerContent._y = 131;
         this.scrollerObj = new controls.ScrollPane(this.scrollerContent,685,307,null,null,761,131);
      }
      classes.ClipFuncs.removeAllClips(this.scrollerContent);
      this.scrollerContent._x = 112;
      classes.Viewer.__MC.scrollerObj.resetMask(this.scrollerContent._x,null,685);
      this.searchMessage("Search for Racers or Teams above.");
   }
   function presetSearch()
   {
      delete this.tID;
      delete this.uID;
      delete this.carID;
      this.profileElementsVisibility(false);
      this.paintOverlay();
      this.gotoAndPlay("search");
      this.txtResultCount = "";
      this.txtPagingNav = "";
      this.searchTerm = this.txtSearch;
      this.icnSearchResults._visible = true;
      classes.ClipFuncs.removeAllClips(this);
   }
   function CB_searchTeams(d)
   {
      var _loc3_ = new XML(d);
      if(this.scrollerContent == undefined)
      {
         this.scrollerContent = this.createEmptyMovieClip("scrollerContent",this.getNextHighestDepth());
         this.scrollerContent._x = 112;
         this.scrollerContent._y = 131;
         this.scrollerObj = new controls.ScrollPane(this.scrollerContent,685,307,null,null,761,131);
      }
      if(_loc3_.firstChild.childNodes.length)
      {
         this.displaySearchResults(_loc3_,"teams");
      }
      else
      {
         this.displaySearchEmpty();
      }
   }
   function CB_searchRacers(d)
   {
      var _loc3_ = new XML(d);
      if(this.scrollerContent == undefined)
      {
         this.scrollerContent = this.createEmptyMovieClip("scrollerContent",this.getNextHighestDepth());
         this.scrollerContent._x = 112;
         this.scrollerContent._y = 131;
         this.scrollerObj = new controls.ScrollPane(this.scrollerContent,685,307,null,null,761,131);
      }
      if(_loc3_.firstChild.childNodes.length)
      {
         this.displaySearchResults(_loc3_,"racers");
      }
      else
      {
         this.displaySearchEmpty();
      }
   }
   static function searchJumpBack(step)
   {
      step = Number(step);
      var _loc3_ = Math.max(1,classes.Viewer.curSearchPage - step);
      if(classes.Viewer.showingSearchType == "racers")
      {
         classes.Lookup.addCallback("racerSearch",classes.Viewer._MC,classes.Viewer._MC.CB_searchRacers,"");
         _root.racerSearch(classes.Viewer._MC.searchTerm,_loc3_);
      }
      else if(classes.Viewer.showingSearchType == "teams")
      {
         classes.Lookup.addCallback("teamSearch",classes.Viewer._MC,classes.Viewer._MC.CB_searchTeams,"");
         _root.teamSearch(classes.Viewer._MC.searchTerm,_loc3_);
      }
   }
   static function searchJumpForward(step)
   {
      step = Number(step);
      trace("searchJumpForward: " + step);
      var _loc3_ = Math.min(classes.Viewer.totalSearchPages,classes.Viewer.curSearchPage + step);
      trace("npage: " + classes.Viewer.totalSearchPages + ", " + (classes.Viewer.curSearchPage + step));
      if(classes.Viewer.showingSearchType == "racers")
      {
         classes.Lookup.addCallback("racerSearch",classes.Viewer._MC,classes.Viewer._MC.CB_searchRacers,"");
         _root.racerSearch(classes.Viewer._MC.searchTerm,_loc3_);
      }
      else if(classes.Viewer.showingSearchType == "teams")
      {
         classes.Lookup.addCallback("teamSearch",classes.Viewer._MC,classes.Viewer._MC.CB_searchTeams,"");
         _root.teamSearch(classes.Viewer._MC.searchTerm,_loc3_);
      }
   }
   static function searchJumpTo(page)
   {
      page = Number(page);
      if(classes.Viewer.showingSearchType == "racers")
      {
         classes.Lookup.addCallback("racerSearch",classes.Viewer._MC,classes.Viewer._MC.CB_searchRacers,"");
         _root.racerSearch(classes.Viewer._MC.searchTerm,page);
      }
      else if(classes.Viewer.showingSearchType == "teams")
      {
         classes.Lookup.addCallback("teamSearch",classes.Viewer._MC,classes.Viewer._MC.CB_searchTeams,"");
         _root.teamSearch(classes.Viewer._MC.searchTerm,page);
      }
   }
   function displaySearchResults(pNode, searchType)
   {
      classes.Viewer.showingSearchType = searchType;
      classes.ClipFuncs.removeAllClips(this.scrollerContent);
      this.scrollerContent.clear();
      classes.Viewer._MC.scrollerObj.setScrollToTop();
      this.profileElementsVisibility(false);
      this.ro1._visible = false;
      this.ro2._visible = false;
      this.paintOverlay();
      var _loc4_ = Number(pNode.firstChild.attributes.c);
      var _loc5_ = Number(pNode.firstChild.childNodes.length);
      classes.Viewer.totalSearchPages = Math.ceil(_loc4_ / 20);
      classes.Viewer.curSearchPage = Number(pNode.firstChild.attributes.p);
      var _loc6_ = 30;
      this.txtResultCount = "Your search returned " + _loc4_;
      if(_loc4_ > 1)
      {
         this.txtResultCount += " matches";
      }
      else
      {
         this.txtResultCount += " match";
      }
      this.txtResultCount += " for \'" + this.searchTerm + "\'";
      this.txtPagingNav = "";
      if(classes.Viewer.curSearchPage > 1)
      {
         this.txtPagingNav += "<a href=\"asfunction:classes.Viewer.searchJumpTo,1\"> &lt;&lt; </a>";
         this.txtPagingNav += "<a href=\"asfunction:classes.Viewer.searchJumpBack,1\"> &lt; </a>";
      }
      var _loc7_ = Math.max(1,classes.Viewer.curSearchPage - 10);
      var _loc8_ = Math.min(classes.Viewer.curSearchPage + 10,classes.Viewer.totalSearchPages);
      var _loc9_ = _loc7_;
      while(_loc9_ <= _loc8_)
      {
         if(_loc9_ == classes.Viewer.curSearchPage)
         {
            this.txtPagingNav += "<font color=\"#96989a\"><b> " + _loc9_ + " </b></font>";
         }
         else
         {
            this.txtPagingNav += "<a href=\"asfunction:classes.Viewer.searchJumpTo," + _loc9_ + "\"> " + _loc9_ + " </a>";
         }
         _loc9_ += 1;
      }
      if(classes.Viewer.curSearchPage < classes.Viewer.totalSearchPages)
      {
         this.txtPagingNav += "<a href=\"asfunction:classes.Viewer.searchJumpForward,1\"> &gt; </a>";
         this.txtPagingNav += "<a href=\"asfunction:classes.Viewer.searchJumpTo," + classes.Viewer.totalSearchPages + "\"> &gt;&gt; </a>";
      }
      trace(this.txtPagingNav);
      classes.Drawing.rect(this.scrollerContent,1,1,0,0);
      _loc9_ = 0;
      while(_loc9_ < _loc5_)
      {
         if(searchType == "teams")
         {
            classes.Drawing.teamListItem(this.scrollerContent,"item" + _loc9_,pNode.firstChild.childNodes[_loc9_].attributes.i,pNode.firstChild.childNodes[_loc9_].attributes.n,47,(_loc9_ + 1) * _loc6_,this.teamItemClick);
         }
         else if(searchType == "racers")
         {
            classes.Drawing.userListItem(this.scrollerContent,"item" + _loc9_,pNode.firstChild.childNodes[_loc9_].attributes.i,pNode.firstChild.childNodes[_loc9_].attributes.u,47,(_loc9_ + 1) * _loc6_,this.racerItemClick);
         }
         _loc9_ += 1;
      }
      classes.Drawing.rect(this.scrollerContent,1,1,0,0,0,this.scrollerContent._height + 10);
      this.scrollerObj.refreshScroller();
   }
   function displaySearchEmpty()
   {
      this.txtResultCount = "No matches found for \'" + this.searchTerm + "\'";
      this.searchMessage("No matches found.");
   }
   function searchMessage(str)
   {
      trace("searchMessage");
      var _loc3_ = undefined;
      if(this.scrollerContent.msg == undefined)
      {
         this.scrollerContent.createEmptyMovieClip("msg",this.scrollerContent.getNextHighestDepth());
         this.scrollerContent.msg.createTextField("fld",1,40,40,300,50);
         this.scrollerContent.msg.fld.embedFonts = true;
         this.scrollerContent.msg.fld._alpha = 80;
         _loc3_ = new TextFormat();
         _loc3_.font = "Arial";
         _loc3_.size = 14;
         _loc3_.color = 16777215;
         this.scrollerContent.msg.fld.setNewTextFormat(_loc3_);
      }
      this.scrollerContent.msg.fld.text = str;
   }
   function teamItemClick(tid)
   {
      trace("teamItemClick: " + tid);
      classes.Control.focusViewer(null,null,tid);
   }
   function racerItemClick(id)
   {
      trace("racerItemClick: " + id);
      classes.Control.focusViewer(id);
   }
   function hiSnav(idx)
   {
      classes.Viewer.__MC.snavHi.onEnterFrame = function()
      {
         this.ty = this._parent["snav" + idx]._y;
         this._y += (this.ty - this._y) / 3;
         if(Math.abs(this.ty - this._y) < 0.1)
         {
            this._y = this.ty;
            delete this.onEnterFrame;
         }
      };
   }
   function paintOverlay(clr)
   {
      if(clr == undefined || clr == "0" || clr == "000000")
      {
         clr = "7d7d7d";
      }
      this.myClr.setRGB(Number("0x" + clr));
      this.clrOverlay._alpha = 80;
   }
   function giveRemark(uID, uName)
   {
      classes.Control.__ROOT.attachMovie("dialogGiveRemark","dialogGiveRemark",classes.Control.__ROOT.getNextHighestDepth(),{_x:183,_y:183,uID:uID,uName:uName});
   }
   function remarkError(errorText)
   {
      classes.Control.__ROOT.dialogGiveRemark.contentMC.txtError = errorText;
      classes.Control.__ROOT.dialogGiveRemark.contentMC.gotoAndPlay("error");
   }
   function destroyMe()
   {
      _global.viewerPos = new flash.geom.Point(classes.Viewer.__MC._x,classes.Viewer.__MC._y);
      this.removeMovieClip();
   }
}
