class classes.SectionTeamHQ extends classes.SectionClip
{
   var myClr;
   var clrOverlay;
   var selSnav;
   var snavDown;
   var ty;
   var onEnterFrame;
   var teamFundsDisplay;
   var selfNode;
   var txtOwnership;
   var btnWithdraw;
   var btnDisburse;
   var btnDeposit;
   var scrollerContent;
   var scrollerObj;
   var btnQuitTeam;
   var teamArr;
   var txtFunds;
   var snavHi;
   var image_bitmap;
   var img_mc;
   var badgeArray;
   static var _MC;
   static var disburseObj;
   static var withdrawalObj;
   static var depositObj;
   static var genericObj;
   function SectionTeamHQ()
   {
      super();
      classes.SectionTeamHQ._MC = this;
      this.cacheAsBitmap = true;
      this.myClr = new Color(this.clrOverlay);
   }
   function goPage(idx)
   {
      this.selSnav = idx;
      this.hiSnav(idx);
      this.snavDown.onEnterFrame = function()
      {
         this.ty = this._parent["snav" + idx]._y;
         this._y += (this.ty - this._y) / 3;
         if(Math.abs(this.ty - this._y) < 0.1)
         {
            this._y = this.ty;
            delete this.onEnterFrame;
         }
      };
      classes.ClipFuncs.removeAllClips(this);
      switch(idx)
      {
         case 1:
            this.gotoAndPlay("main");
            break;
         case 2:
            this.gotoAndPlay("members");
            break;
         case 3:
            this.gotoAndPlay("applications");
            break;
         case 4:
            this.gotoAndPlay("funds");
            break;
         case 5:
            this.gotoAndPlay("trophies");
         default:
            return undefined;
      }
   }
   function drawFunds(txml, rxml)
   {
      this.teamFundsDisplay.txt = "$" + classes.NumFuncs.commaFormat(Number(txml.attributes.tf));
      var _loc4_ = 0;
      while(_loc4_ < txml.childNodes.length)
      {
         if(txml.childNodes[_loc4_].attributes.i == classes.GlobalData.id)
         {
            this.selfNode = txml.childNodes[_loc4_];
            if(this.selfNode.attributes.tr == 1 || this.selfNode.attributes.tr == 2)
            {
               this.txtOwnership = "";
               this.btnWithdraw._visible = false;
               classes.SectionTeamHQ.disburseObj = {contentName:"dialogFundsDisburseContent",teamFunds:txml.attributes.tf};
               this.btnDisburse.onRelease = function()
               {
                  _root.abc.closeMe();
                  _root.attachMovie("dialogContainer","abc",_root.getNextHighestDepth(),classes.SectionTeamHQ.disburseObj);
               };
            }
            else
            {
               this.txtOwnership = this.selfNode.attributes.po + "% ownership : $" + this.selfNode.attributes.fu;
               this.btnDisburse._visible = false;
               classes.SectionTeamHQ.withdrawalObj = {contentName:"dialogFundsWithdrawContent",teamFunds:txml.attributes.tf,myTeamFunds:this.selfNode.attributes.fu,myPO:this.selfNode.attributes.po};
               this.btnWithdraw.onRelease = function()
               {
                  _root.abc.closeMe();
                  _root.attachMovie("dialogContainer","abc",_root.getNextHighestDepth(),classes.SectionTeamHQ.withdrawalObj);
               };
            }
            classes.SectionTeamHQ.depositObj = {contentName:"dialogFundsDepositContent",teamFunds:txml.attributes.tf,myTeamFunds:this.selfNode.attributes.fu,myPO:this.selfNode.attributes.po};
            if(this.selfNode.attributes.tr == 1 || this.selfNode.attributes.tr == 2)
            {
               classes.SectionTeamHQ.depositObj.isLeader = true;
            }
            this.btnDeposit.onRelease = function()
            {
               _root.abc.closeMe();
               _root.attachMovie("dialogContainer","abc",_root.getNextHighestDepth(),classes.SectionTeamHQ.depositObj);
            };
            break;
         }
         _loc4_ += 1;
      }
      if(this.scrollerContent == undefined)
      {
         this.scrollerContent = this.createEmptyMovieClip("scrollerContent",this.getNextHighestDepth());
      }
      this.scrollerContent._x = 125;
      this.scrollerContent._y = 284;
      this.scrollerObj.destroy();
      this.scrollerObj = new controls.ScrollPane(this.scrollerContent,662,308,null,466,790,125);
      _loc4_ = 0;
      var _loc5_ = undefined;
      var _loc6_ = undefined;
      while(_loc4_ < rxml.childNodes.length)
      {
         _loc5_ = {_x:0,_y:_loc4_ * 21,date:rxml.childNodes[_loc4_].attributes.d,description:classes.Lookup.transactionName(Number(rxml.childNodes[_loc4_].attributes.t)),uName:rxml.childNodes[_loc4_].attributes.u};
         _loc6_ = rxml.childNodes[_loc4_].attributes.t;
         if(_loc6_ == 3 || _loc6_ == 4 || _loc6_ == 6)
         {
            _loc5_.deposit = "+$" + rxml.childNodes[_loc4_].attributes.a;
         }
         else
         {
            _loc5_.withdrawal = "-$" + Math.abs(rxml.childNodes[_loc4_].attributes.a);
         }
         this.scrollerContent.attachMovie("teamFundsLineItem","teamFundsLineItemMC" + _loc4_,this.scrollerContent.getNextHighestDepth(),_loc5_);
         _loc4_ += 1;
      }
      this.scrollerObj.refreshScroller();
      this.stop();
   }
   function drawApplications(txml, leaderMsg)
   {
      if(this.scrollerContent == undefined)
      {
         this.scrollerContent = this.createEmptyMovieClip("scrollerContent",this.getNextHighestDepth());
         this.scrollerContent._x = 140;
         this.scrollerContent._y = 176;
      }
      this.scrollerObj = new controls.ScrollPane(this.scrollerContent,647,416,null,466,790,125);
      var _loc5_ = 42;
      var _loc6_ = new TextFormat();
      _loc6_.font = "ArialBmp9";
      _loc6_.size = 9;
      _loc6_.color = 16777215;
      var _loc7_ = undefined;
      var _loc8_ = undefined;
      var _loc9_ = 0;
      while(_loc9_ < txml.childNodes.length)
      {
         _loc7_ = txml.childNodes[_loc9_].attributes;
         if(_loc7_.s != "Declined")
         {
            this.scrollerContent.attachMovie("userInfo50","applicant" + _loc9_,this.scrollerContent.getNextHighestDepth(),{_y:_loc5_,scale:50,uID:_loc7_.i,uName:_loc7_.u,uCred:_loc7_.sc});
            this.scrollerContent["applicant" + _loc9_].fldTitleET.text = "BEST AVG ET:";
            this.scrollerContent["applicant" + _loc9_].fldET.text = _loc7_.et <= 0 ? "N/A" : classes.NumFuncs.zeroFill(Math.round(_loc7_.et * 1000) / 1000,3);
            this.scrollerContent.attachMovie("applicantOptions","options" + _loc9_,this.scrollerContent.getNextHighestDepth(),{uID:_loc7_.i,_x:91,_y:_loc5_ + 42});
            classes.Drawing.rect(this.scrollerContent,2,40,0,0,0,_loc5_ + 42 + 21);
            if(_loc7_.s == "Accepted")
            {
               this.scrollerContent["options" + _loc9_].gotoAndStop(2);
            }
            else if(_global.loginXML.firstChild.firstChild.attributes.tr != 1 && _global.loginXML.firstChild.firstChild.attributes.tr != 2)
            {
               this.scrollerContent["options" + _loc9_]._visible = false;
            }
            this.scrollerContent.createTextField("comment" + _loc9_,this.scrollerContent.getNextHighestDepth(),219,_loc5_ + 4,160,70);
            _loc8_ = this.scrollerContent["comment" + _loc9_];
            _loc8_.embedFonts = true;
            _loc8_.multiline = true;
            _loc8_.selectable = false;
            _loc8_.wordWrap = true;
            _loc8_.setNewTextFormat(_loc6_);
            _loc8_.text = _loc7_.n;
            _loc5_ += 83;
         }
         _loc9_ += 1;
      }
      this.scrollerContent.attachMovie("leaderMessage","leaderMessage",this.scrollerContent.getNextHighestDepth(),{_x:435,_y:190});
      this.scrollerContent.leaderMessage.fld.text = unescape(leaderMsg);
      this.scrollerObj.refreshScroller();
   }
   function drawMembers(txml)
   {
      var _loc4_ = 0;
      while(_loc4_ < txml.childNodes.length)
      {
         if(txml.childNodes[_loc4_].nodeName == "tm" && txml.childNodes[_loc4_].attributes.i == classes.GlobalData.id)
         {
            this.selfNode = txml.childNodes[_loc4_];
            classes.SectionTeamHQ.genericObj = {contentName:"dialogTeamQuitContent",myTeamFunds:this.selfNode.attributes.fu,myPO:this.selfNode.attributes.po};
            this.btnQuitTeam.onRelease = function()
            {
               _root.abc.closeMe();
               _root.attachMovie("dialogContainer","abc",_root.getNextHighestDepth(),classes.SectionTeamHQ.genericObj);
            };
            break;
         }
         _loc4_ += 1;
      }
      this.teamArr = new Array();
      var _loc5_ = undefined;
      _loc4_ = 0;
      while(_loc4_ < txml.childNodes.length)
      {
         if(txml.childNodes[_loc4_].nodeName == "tm")
         {
            _loc5_ = txml.childNodes[_loc4_].attributes;
            this.teamArr.push(_loc5_);
         }
         _loc4_ += 1;
      }
      if(this.scrollerContent == undefined)
      {
         this.scrollerContent = this.createEmptyMovieClip("scrollerContent",this.getNextHighestDepth());
         this.scrollerContent._x = 140;
         this.scrollerContent._y = 176;
         this.scrollerObj = new controls.ScrollPane(this.scrollerContent,647,416,null,466,790,125);
      }
      var _loc6_ = this.scrollerContent.createEmptyMovieClip("officers",this.scrollerContent.getNextHighestDepth());
      var _loc7_ = 0;
      var _loc8_ = new TextFormat();
      _loc8_.font = "Arial";
      _loc8_.bold = true;
      _loc8_.size = 11.5;
      _loc8_.color = 16777215;
      _loc4_ = 0;
      while(_loc4_ < this.teamArr.length)
      {
         if(this.teamArr[_loc4_].tr == 1)
         {
            _loc6_.createTextField("headLeader",_loc6_.getNextHighestDepth(),0,0,300,40);
            _loc6_.headLeader.embedFonts = true;
            _loc6_.headLeader._alpha = 80;
            _loc6_.headLeader.selectable = false;
            _loc6_.headLeader.setNewTextFormat(_loc8_);
            _loc6_.headLeader.text = "Team Leader:";
            _loc6_.attachMovie("userInfo50","teamLeader",_loc6_.getNextHighestDepth(),{scale:50,uID:this.teamArr[_loc4_].i,uName:this.teamArr[_loc4_].un,uCred:this.teamArr[_loc4_].sc});
            _loc6_.teamLeader.fldTitleET.text = "BEST AVG ET:";
            _loc6_.teamLeader.fldET.text = this.teamArr[_loc4_].et <= 0 ? "N/A" : classes.NumFuncs.zeroFill(Math.round(this.teamArr[_loc4_].et * 1000) / 1000,3);
            _loc6_.teamLeader.fldOwnership.text = !Number(this.teamArr[_loc4_].po) ? "" : this.teamArr[_loc4_].po + "% owner: $" + this.teamArr[_loc4_].fu;
            _loc6_.teamLeader._x = 23;
            _loc6_.teamLeader._y = 20;
            if(_global.loginXML.firstChild.firstChild.attributes.tr == 1)
            {
               _loc6_.attachMovie("btnLeaderStepDown","btnLeaderStepDown",_loc6_.getNextHighestDepth());
               _loc6_.btnLeaderStepDown._x = 90;
               _loc6_.btnLeaderStepDown._y = _loc7_;
               _loc6_.btnLeaderStepDown.onRelease = function()
               {
                  _root.abc.closeMe();
                  _root.attachMovie("dialogContainer","abc",_root.getNextHighestDepth(),{contentName:"dialogTeamLeaderStepDownContent"});
               };
            }
            _loc7_ += 100;
            break;
         }
         _loc4_ += 1;
      }
      var _loc9_ = undefined;
      var _loc10_ = undefined;
      if(_loc6_.headCoLeaders == undefined)
      {
         _loc9_ = _loc6_.createTextField("headCoLeaders",_loc6_.getNextHighestDepth(),0,0,300,40);
         _loc9_.embedFonts = true;
         _loc9_.selectable = false;
         _loc9_._alpha = 80;
         _loc9_._y = _loc7_;
         _loc9_.setNewTextFormat(_loc8_);
         _loc9_.text = "Team Co-Leaders:";
         if(_global.loginXML.firstChild.firstChild.attributes.tr == 1)
         {
            _loc10_ = _loc6_.attachMovie("btnModifyMember","btnModifyCoLeader",_loc6_.getNextHighestDepth());
            _loc10_._x = 112;
            _loc10_._y = _loc7_;
            _loc10_.onRelease = function()
            {
               _root.abc.closeMe();
               _root.attachMovie("dialogContainer","abc",_root.getNextHighestDepth(),{contentName:"dialogTeamRoleContent",filterByType:2});
            };
         }
         _loc7_ += 18;
      }
      var _loc11_ = 0;
      _loc4_ = 0;
      var _loc12_ = undefined;
      while(_loc4_ < this.teamArr.length)
      {
         if(this.teamArr[_loc4_].tr == 2)
         {
            _loc11_ += 1;
            _loc12_ = _loc6_.attachMovie("userInfo50","teamCoLeader" + _loc11_,_loc6_.getNextHighestDepth(),{scale:50,uID:this.teamArr[_loc4_].i,uName:this.teamArr[_loc4_].un,uCred:this.teamArr[_loc4_].sc});
            _loc12_.fldTitleET.text = "BEST AVG ET:";
            _loc12_.fldET.text = this.teamArr[_loc4_].et <= 0 ? "N/A" : classes.NumFuncs.zeroFill(Math.round(this.teamArr[_loc4_].et * 1000) / 1000,3);
            _loc12_.fldOwnership.text = !Number(this.teamArr[_loc4_].po) ? "" : this.teamArr[_loc4_].po + "% owner: $" + this.teamArr[_loc4_].fu;
            _loc12_._x = 23;
            _loc12_._y = _loc7_;
            _loc7_ += 78;
         }
         _loc4_ += 1;
      }
      if(_loc11_ == 0)
      {
         _loc6_.headCoLeaders.text += "  (None)";
         _loc6_.btnModifyCoLeader._visible = false;
         _loc7_ += 14;
      }
      if(_loc6_.headDealers == undefined)
      {
         _loc6_.createTextField("headDealers",_loc6_.getNextHighestDepth(),0,0,300,40);
         _loc6_.headDealers.embedFonts = true;
         _loc6_.headDealers.selectable = false;
         _loc6_.headDealers._alpha = 80;
         _loc6_.headDealers._y = _loc7_;
         _loc6_.headDealers.setNewTextFormat(_loc8_);
         _loc6_.headDealers.text = "Team Dealers:";
         if(_global.loginXML.firstChild.firstChild.attributes.tr == 1 || _global.loginXML.firstChild.firstChild.attributes.tr == 2)
         {
            _loc10_ = _loc6_.attachMovie("btnModifyMember","btnModifyDealer",_loc6_.getNextHighestDepth());
            _loc10_._x = 112;
            _loc10_._y = _loc7_;
            _loc10_.onRelease = function()
            {
               _root.abc.closeMe();
               _root.attachMovie("dialogContainer","abc",_root.getNextHighestDepth(),{contentName:"dialogTeamRoleContent",filterByType:3});
            };
         }
         _loc7_ += 18;
      }
      var _loc13_ = 0;
      _loc4_ = 0;
      while(_loc4_ < this.teamArr.length)
      {
         if(this.teamArr[_loc4_].tr == 3)
         {
            _loc13_ += 1;
            _loc12_ = _loc6_.attachMovie("userInfo50","teamDealer" + _loc13_,_loc6_.getNextHighestDepth(),{scale:50,uID:this.teamArr[_loc4_].i,uName:this.teamArr[_loc4_].un,uCred:this.teamArr[_loc4_].sc});
            _loc12_.fldTitleET.text = "BEST AVG ET:";
            _loc12_.fldET.text = this.teamArr[_loc4_].et <= 0 ? "N/A" : classes.NumFuncs.zeroFill(Math.round(this.teamArr[_loc4_].et * 1000) / 1000,3);
            _loc12_.fldOwnership.text = Number(this.teamArr[_loc4_].po) <= 0 ? "" : this.teamArr[_loc4_].po + "% owner: $" + this.teamArr[_loc4_].fu;
            if(Number(this.teamArr[_loc4_].mbp) > -1)
            {
               _loc12_.fldDealerPerc.text = "Allowed to bet: " + this.teamArr[_loc4_].mbp + "%";
            }
            _loc12_._x = 23;
            _loc12_._y = _loc7_;
            _loc7_ += 76;
         }
         _loc4_ += 1;
      }
      if(_loc13_ == 0)
      {
         _loc6_.headDealers.text += "  (None)";
         _loc6_.btnModifyDealer._visible = false;
      }
      this.drawRegularsPage();
      this.scrollerObj.refreshScroller();
   }
   function drawRegularsPage(pg)
   {
      if(!pg)
      {
         pg = 1;
      }
      this.clearRegulars();
      var _loc4_ = new TextFormat();
      _loc4_.font = "Arial";
      _loc4_.bold = true;
      _loc4_.color = 16777215;
      _loc4_.size = 11.5;
      if(this.scrollerContent.regularsGroup == undefined)
      {
         this.scrollerContent.createEmptyMovieClip("regularsGroup",this.getNextHighestDepth());
         this.scrollerContent.regularsGroup._x = 304;
         this.scrollerContent.regularsGroup._y = 24;
         this.scrollerContent.regularsGroup.createTextField("headRegulars",this.scrollerContent.regularsGroup.getNextHighestDepth(),-22,-24,300,40);
         this.scrollerContent.regularsGroup.headRegulars.embedFonts = true;
         this.scrollerContent.regularsGroup.headRegulars.selectable = false;
         this.scrollerContent.regularsGroup.headRegulars._alpha = 80;
         this.scrollerContent.regularsGroup.headRegulars.setNewTextFormat(_loc4_);
         this.scrollerContent.regularsGroup.headRegulars.text = "Team Members:";
         if(_global.loginXML.firstChild.firstChild.attributes.tr == 1 || _global.loginXML.firstChild.firstChild.attributes.tr == 2)
         {
            var _loc5_ = this.scrollerContent.regularsGroup.attachMovie("btnModifyMember","btnModifyMember",this.scrollerContent.regularsGroup.getNextHighestDepth());
            _loc5_._x = 82;
            _loc5_._y = -24;
            _loc5_.onRelease = function()
            {
               _root.attachMovie("dialogContainer","abc",_root.getNextHighestDepth(),{contentName:"dialogTeamRoleContent",filterByType:4});
            };
            _loc5_ = this.scrollerContent.regularsGroup.attachMovie("btnRemoveMember","btnRemoveMember",this.scrollerContent.regularsGroup.getNextHighestDepth());
            _loc5_._x = 214;
            _loc5_._y = -24;
            _loc5_.onRelease = function()
            {
               _root.abc.closeMe();
               _root.attachMovie("dialogContainer","abc",_root.getNextHighestDepth(),{contentName:"dialogTeamRemoveContent"});
            };
         }
      }
      var _loc6_ = 77;
      var _loc7_ = 104;
      var _loc8_ = 4;
      var _loc9_ = 3;
      var _loc10_ = (pg - 1) * _loc8_ * _loc9_;
      var _loc11_ = undefined;
      var _loc12_ = undefined;
      var _loc13_ = new Array();
      var _loc14_ = 0;
      while(_loc14_ < this.teamArr.length)
      {
         if(this.teamArr[_loc14_].tr == 4)
         {
            _loc13_.push(this.teamArr[_loc14_]);
         }
         _loc14_ = _loc14_ + 1;
      }
      var _loc15_ = Math.min(_loc8_ * _loc9_,_loc13_.length - _loc10_);
      _loc14_ = 0;
      while(_loc14_ < _loc15_)
      {
         _loc11_ = _loc14_ % _loc8_ * _loc6_;
         _loc12_ = Math.floor(_loc14_ / _loc8_) * _loc7_;
         this.scrollerContent.regularsGroup.attachMovie("_blank","buddy" + _loc14_,this.scrollerContent.regularsGroup.getNextHighestDepth(),{_x:_loc11_,_y:_loc12_,id:_loc13_[_loc14_ + _loc10_].i});
         this.scrollerContent.regularsGroup["buddy" + _loc14_].attachMovie("_blank","pic",1,{_xscale:50,_yscale:50});
         classes.Drawing.portrait(this.scrollerContent.regularsGroup["buddy" + _loc14_].pic,this.scrollerContent.regularsGroup["buddy" + _loc14_].id,1,0,0,2);
         with(this.scrollerContent.regularsGroup["buddy" + _loc14_])
         {
            pic.onRelease = function()
            {
               classes.Control.focusViewer(this._parent.id);
            };
            createTextField("uname",2,-2,41,_width + 20,30);
            uname.embedFonts = true;
            uname.autoSize = true;
            _loc4_.size = 9;
            uname.setNewTextFormat(_loc4_);
            createTextField("financials",3,-2,53,_width + 20,50);
            financials.embedFonts = true;
            financials.selectable = false;
            financials.autoSize = true;
            financials.multiline = true;
            financials._alpha = 80;
            _loc4_.size = 10;
            financials.setNewTextFormat(_loc4_);
         }
         this.scrollerContent.regularsGroup["buddy" + _loc14_].uname.text = _loc13_[_loc14_ + _loc10_].un;
         if(Number(_loc13_[_loc14_ + _loc10_].po) > 0)
         {
            this.scrollerContent.regularsGroup["buddy" + _loc14_].financials.text = _loc13_[_loc14_ + _loc10_].po + "% owner\r" + "$" + _loc13_[_loc14_ + _loc10_].fu;
         }
         _loc14_ = _loc14_ + 1;
      }
      this.drawRegularsPaging(pg,_loc13_.length);
   }
   function drawRegularsPaging(curPage, totalCount)
   {
      var _loc4_ = 12;
      var _loc5_ = Math.ceil(totalCount / _loc4_);
      this.scrollerContent.regularsGroup.pagingGroup.removeMovieClip();
      this.scrollerContent.regularsGroup.attachMovie("_blank","pagingGroup",this.scrollerContent.regularsGroup.getNextHighestDepth(),{_x:0,_y:306});
      with(this.scrollerContent.regularsGroup.pagingGroup)
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
               classes.SectionTeamHQ._MC.drawRegularsPage(this.gotoPage);
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
         if(curPage != _loc5_ && _loc5_ != 0)
         {
            _loc6_.color = 16777215;
            fldNext.gotoPage = curPage + 1;
            fldNext.onRelease = function()
            {
               classes.SectionTeamHQ._MC.drawRegularsPage(this.gotoPage);
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
               fldPaging.htmlText += "<a href=\"asfunction:classes.SectionTeamHQ._MC.drawRegularsPage," + _loc7_ + "\"><u>" + _loc7_ + "</u></a> ";
            }
            _loc7_ = _loc7_ + 1;
         }
      }
   }
   function clearRegulars()
   {
      for(var _loc2_ in this.scrollerContent.regularsGroup)
      {
         if(typeof this.scrollerContent.regularsGroup[_loc2_] == "movieclip" && this.scrollerContent.regularsGroup[_loc2_] != this.scrollerContent.regularsGroup.pagingGroup)
         {
            this.scrollerContent.regularsGroup[_loc2_].removeMovieClip();
            delete this.scrollerContent.regularsGroup[_loc2_];
         }
      }
   }
   function setFundsField(amt)
   {
      if(amt > 1000000)
      {
         this.txtFunds = "Funds: $" + classes.NumFuncs.commaFormat(amt);
      }
      else
      {
         this.txtFunds = "Funds: $" + amt;
      }
   }
   function hiSnav(idx)
   {
      this.snavHi.onEnterFrame = function()
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
   function getGridColorPoint(clr)
   {
      var _loc3_ = undefined;
      var _loc4_ = 12;
      var _loc5_ = undefined;
      var _loc6_ = undefined;
      var _loc7_ = undefined;
      var _loc8_ = 0;
      var _loc9_ = undefined;
      while(_loc8_ < 16)
      {
         _loc9_ = 0;
         while(_loc9_ < 7)
         {
            _loc5_ = 1 + _loc8_ * _loc4_;
            _loc6_ = 1 + _loc9_ * _loc4_;
            _loc3_ = this.image_bitmap.getPixel(_loc5_,_loc6_);
            if(_loc3_ == clr)
            {
               _loc7_ = new flash.geom.Point(_loc5_ - 1,_loc6_ - 1);
               break;
            }
            _loc9_ += 1;
         }
         if(_loc3_ == clr)
         {
            break;
         }
         _loc8_ += 1;
      }
      return _loc7_;
   }
   function setGridColorHilite(pp)
   {
      if(pp != undefined)
      {
         this.img_mc.hilite._x = pp.x;
         this.img_mc.hilite._y = pp.y;
         this.img_mc.hilite._visible = true;
      }
      else
      {
         this.img_mc.hilite._visible = false;
      }
   }
   function paintOverlay(clr)
   {
      this.myClr.setRGB(Number("0x" + clr));
      this.clrOverlay._alpha = 80;
   }
   function drawBadges(bxml)
   {
      this.badgeArray = new Array();
      var _loc3_ = undefined;
      var _loc4_ = 0;
      while(_loc4_ < bxml.childNodes.length)
      {
         if(bxml.childNodes[_loc4_].nodeName == "b")
         {
            _loc3_ = bxml.childNodes[_loc4_].attributes;
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
      pg = Number(pg);
      trace("drawMyBadges(" + pg + ")");
      this.scrollerObj.setScrollToTop();
      this.scrollerContent.badgesGroup.removeMovieClip();
      this.scrollerContent.createEmptyMovieClip("badgesGroup",this.scrollerContent.getNextHighestDepth());
      var _loc4_ = 157;
      var _loc5_ = 113;
      var _loc6_ = 4;
      var _loc7_ = 3;
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
      var _loc4_ = 12;
      var _loc5_ = Math.ceil(this.badgeArray.length / _loc4_);
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
            fldPrev.onRelease = function()
            {
               classes.SectionTeamHQ._MC.drawMyBadges(this.gotoPage);
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
               classes.SectionTeamHQ._MC.drawMyBadges(this.gotoPage);
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
               fldPaging.htmlText += "<a href=\"asfunction:classes.SectionTeamHQ._MC.drawMyBadges," + _loc7_ + "\"><u>" + _loc7_ + "</u></a> ";
            }
            _loc7_ = _loc7_ + 1;
         }
      }
      this.scrollerContent.badgesGroup.pagingGroup._x = 178;
   }
}
