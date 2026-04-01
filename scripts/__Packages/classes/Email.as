class classes.Email
{
   static var __context;
   static var __inboxList;
   static var viewedEmailID;
   static var viewedEmail;
   static var composeNum = 0;
   static var emailNum = 0;
   static var selectedEmails = [];
   function Email(_context, toUser)
   {
      classes.Email.__context = _context;
      with(_context)
      {
         var _loc2_ = 784;
         var _loc3_ = 397;
         var marginSide = 15;
         var marginTop = 41;
         var marginBtm = 28;
         var minFactor = 0.75;
         _context.createEmptyMovieClip("email",_context.getNextHighestDepth());
         _context.email.createEmptyMovieClip("bgGrad",_context.email.getNextHighestDepth());
         classes.Drawing.newBaseWindow(email.bgGrad,_loc2_,_loc3_,false);
         _context.email.createEmptyMovieClip("nav",_context.email.getNextHighestDepth());
         with(email)
         {
            var _loc4_ = 30;
            nav._x = marginSide;
            nav.attachMovie("tog_new","tog_new",nav.getNextHighestDepth());
            nav.attachMovie("tog_reply","tog_reply",nav.getNextHighestDepth());
            nav.attachMovie("tog_fw","tog_fw",nav.getNextHighestDepth());
            nav.attachMovie("tog_del","tog_del",nav.getNextHighestDepth());
            nav.tog_new._x = Math.floor(nav.tog_new._width / 2);
            nav.tog_reply._x = nav.tog_new._x + Math.floor(nav.tog_new._width / 2 + nav.tog_reply._width / 2) + _loc4_;
            nav.tog_fw._x = nav.tog_reply._x + Math.floor(nav.tog_reply._width / 2 + nav.tog_fw._width / 2) + _loc4_;
            nav.tog_del._x = nav.tog_fw._x + Math.floor(nav.tog_fw._width / 2 + nav.tog_del._width / 2) + _loc4_;
            nav._y = 6 + Math.floor(nav.tog_new._height / 2);
            classes.Email.enableContextBtns(false);
            with(nav)
            {
               classes.Effects.roBounce(tog_new);
               classes.Effects.roBounce(tog_reply);
               classes.Effects.roBounce(tog_fw);
               classes.Effects.roBounce(tog_del);
               tog_new.onRelease = function()
               {
                  this.onRollOut();
                  classes.Email.compose(_context,{to_user:"",subj:""});
               };
               tog_reply.onRelease = function()
               {
                  this.onRollOut();
                  var _loc2_ = "";
                  var _loc3_ = "";
                  if(classes.Email.viewedEmail.firstChild.attributes.fu.length)
                  {
                     _loc2_ = classes.Email.viewedEmail.firstChild.attributes.fu;
                  }
                  if(classes.Email.viewedEmail.firstChild.attributes.s.length)
                  {
                     if(classes.Email.viewedEmail.firstChild.attributes.s.substr(0,4).toUpperCase() != "RE: ")
                     {
                        _loc3_ += "RE: ";
                     }
                     _loc3_ += classes.StringFuncs.unSpecialChars(classes.Email.viewedEmail.firstChild.attributes.s);
                  }
                  classes.Email.compose(_context,{to_user:_loc2_,subj:_loc3_});
               };
               tog_fw.onRelease = function()
               {
                  this.onRollOut();
                  var _loc2_ = "";
                  var _loc3_ = "";
                  if(classes.Email.viewedEmail.firstChild.attributes.s.length)
                  {
                     _loc2_ = "FW: " + classes.StringFuncs.unSpecialChars(classes.Email.viewedEmail.firstChild.attributes.s);
                  }
                  if(classes.Email.viewedEmail.firstChild.firstChild.toString().length)
                  {
                     _loc3_ = "\r\r[Original Message]: \r" + classes.StringFuncs.unSpecialChars(classes.Email.viewedEmail.firstChild.firstChild.toString());
                  }
                  classes.Email.compose(_context,{to_user:"",subj:_loc2_,msg:_loc3_});
               };
               tog_del.onRelease = function()
               {
                  this.onRollOut();
                  classes.Email.deleteEmail(classes.Email.viewedEmailID);
               };
            }
         }
         email.attachMovie("togMinimize","togMinimize",email.getNextHighestDepth());
         email.togMinimize.btn.onRelease = function()
         {
            classes.Control.dockEmail();
         };
         classes.Drawing.addCornerResizer(email,"cornerHandle");
         var crn = email.corner;
         crn.ix = crn._x;
         crn.iy = crn._y;
         var mouseListener = new Object();
         crn.onPress = function()
         {
            this.startDrag(false,crn.ix * minFactor,crn.iy * minFactor,1000,800);
            mouseListener.onMouseMove = function()
            {
               email.refreshMe();
            };
            Mouse.addListener(mouseListener);
         };
         crn.onRelease = function()
         {
            this.stopDrag();
            Mouse.removeListener(mouseListener);
            email.refreshMe();
         };
         crn.onReleaseOutside = crn.onRelease;
         email.refreshMe = function()
         {
            var _loc1_ = 1 + (crn._x - crn.ix) / (crn.ix + crn._width);
            var _loc2_ = 1 + (crn._y - crn.iy) / (crn.iy + crn._height);
            if(_loc1_ >= minFactor)
            {
               email.bgGrad._width = crn._x + crn._width - email.bgGrad._x;
            }
            if(_loc2_ >= minFactor)
            {
               email.bgGrad._height = crn._y + crn._height - email.bgGrad._y;
            }
            if(email.togMinimize.getDepth() < email.nav.getDepth())
            {
               email.togMinimize.swapDepths(nav);
            }
            email.togMinimize._x = email.bgGrad._width - email.togMinimize._width - 6;
            email.togMinimize._y = 3;
            if(email.tb1 == undefined)
            {
               email.createEmptyMovieClip("tb1",email.getNextHighestDepth());
            }
            email.tb1._x = marginSide;
            email.tb1._y = marginTop;
            var _loc3_ = email.bgGrad._width - 2 * marginSide;
            var _loc4_ = email.bgGrad._height - marginTop - marginBtm;
            var _loc5_ = 78;
            var _loc6_ = 4;
            var _loc7_ = 43;
            classes.Drawing.insetBox(email.tb1,_loc3_,_loc4_,_loc5_,8556969);
            var _loc8_ = Math.round(email.tb1._width / 3);
            var _loc9_ = 5;
            with(email.tb1)
            {
               moveTo(0,_loc9_);
               beginFill(11123413);
               curveTo(0,0,_loc9_,0);
               lineTo(_loc8_,0);
               lineTo(_loc8_,63);
               lineTo(0,63);
               lineTo(0,_loc9_);
               endFill();
               moveTo(0,37);
               lineTo(_loc8_,37);
               beginFill(16777215);
               lineTo(_loc8_,_loc5_);
               lineTo(0,_loc5_);
               lineTo(0,37);
               endFill();
               if(email.tb1.tog_inbox == undefined)
               {
                  email.tb1.attachMovie("tog_inbox","tog_inbox",email.tb1.getNextHighestDepth());
                  tog_inbox.hot.onRelease = function()
                  {
                     activateTab(tog_inbox);
                  };
               }
               tog_inbox._x = 21;
               tog_inbox._y = 5;
               if(scroller == undefined)
               {
                  email.tb1.createEmptyMovieClip("scroller",email.tb1.getNextHighestDepth());
                  email.tb1.scroller.createEmptyMovieClip("scrollerContent",email.tb1.scroller.getNextHighestDepth());
                  email.tb1.scroller.scrollerObj = new controls.ScrollPane(email.tb1.scroller.scrollerContent,_loc8_ - 1,_loc4_ - 65 - 1);
               }
               scroller._x = 1;
               scroller._y = 65;
               scroller.scrollerObj.setSizeMask(_loc8_ - 1,_loc4_ - 65 - 1);
               scroller.scrollerObj.resetScroller(_loc4_ - 65 - 1,_loc8_ - 11);
               var _loc10_ = _loc8_ - 1;
               moveTo(0,_loc7_);
               beginFill(13687014);
               lineTo(_loc10_,_loc7_);
               lineTo(_loc10_,_loc7_ + 1);
               lineTo(0,_loc7_ + 1);
               lineTo(0,_loc7_);
               endFill();
               moveTo(0,_loc7_ + 1);
               beginFill(10662348);
               lineTo(_loc10_,_loc7_ + 1);
               lineTo(_loc10_,_loc7_ + 19);
               lineTo(0,_loc7_ + 19);
               lineTo(0,_loc7_ + 1);
               endFill();
               moveTo(0,_loc7_ + 19);
               beginFill(10461604);
               lineTo(_loc10_,_loc7_ + 19);
               lineTo(_loc10_,_loc7_ + 20);
               lineTo(0,_loc7_ + 20);
               lineTo(0,_loc7_ + 19);
               endFill();
            }
            if(email.tb1.inbxLine == undefined)
            {
               email.tb1.createEmptyMovieClip("inbxLine",email.tb1.getNextHighestDepth());
            }
            var _loc11_ = email.tb1.inbxLine;
            with(_loc11_)
            {
               clear();
               _x = _loc8_;
               lineStyle(undefined,0,100);
               beginFill(16777215);
               lineTo(_loc6_ + 2,0);
               lineTo(_loc6_ + 2,_loc4_);
               lineTo(0,_loc4_);
               lineTo(0,0);
               endFill();
               moveTo(1,0);
               beginFill(11386329);
               lineTo(1 + _loc6_,0);
               lineTo(1 + _loc6_,_loc4_);
               lineTo(1,_loc4_);
               lineTo(1,0);
               endFill();
            }
            email.tb1.viewTextWidth = _loc3_ - email.tb1.inbxLine._x - email.tb1.inbxLine._width;
            email.tb1.viewTextHeight = _loc4_ - _loc5_;
            email.tb1.headH = _loc5_;
            classes.Email.drawInbox(email.tb1.scroller.scrollerContent,_loc8_,_loc4_ - _loc7_ - 20 - 3);
            scroller.scrollerObj.refreshScroller();
            classes.Drawing.applyInsetBoxFilters(email.tb1);
            email.cornerHandle._x = crn._x;
            email.cornerHandle._y = crn._y;
            classes.Drawing.applyMainShad(email.bgGrad);
         };
         email.refreshMe();
         with(email.tb1)
         {
            activateTab = function(newtab)
            {
               var _loc2_ = [tog_inbox,tog_sent];
               var _loc3_ = 0;
               while(_loc3_ < _loc2_.length)
               {
                  if(_loc2_[_loc3_] == newtab)
                  {
                     _loc2_[_loc3_].hi._visible = true;
                     _loc2_[_loc3_].hot._visible = false;
                  }
                  else
                  {
                     _loc2_[_loc3_].hot._visible = true;
                     _loc2_[_loc3_].hi._visible = false;
                  }
                  _loc3_ += 1;
               }
            };
            activateTab(tog_inbox);
         }
         classes.Drawing.applyMainShad(email);
         email.bgGrad.onPress = function()
         {
            email.swapDepths(classes.Email.__context.getNextHighestDepth());
            email.startDrag(false);
         };
         email.bgGrad.onRelease = function()
         {
            email.stopDrag();
         };
         email.bgGrad.onReleaseOutside = email.bgGrad.onRelease;
         email.bgGrad.useHandCursor = false;
         setupInbox(email);
      }
      if(toUser.length)
      {
         classes.Email.compose(_context,{to_user:toUser,subj:""});
      }
   }
   static function compose(_context, initObj)
   {
      classes.Email.composeEmail(_context,initObj);
   }
   static function composeEmail(_context, initObj)
   {
      with(_context)
      {
         var iww = 600;
         var _loc2_ = 350;
         var marginSide = 15;
         var marginTop = 38;
         var marginBtm = 28;
         var headH = 78;
         var minFactor = 0.5;
         classes.Email.composeNum += 1;
         var tcompose = _context.createEmptyMovieClip("compose" + classes.Email.composeNum,_context.getNextHighestDepth());
         tcompose.composeNum = classes.Email.composeNum;
         tcompose._x = 60 + classes.Email.composeNum % 8 * 20;
         tcompose._y = 60 + classes.Email.composeNum % 8 * 15;
         tcompose.createEmptyMovieClip("bgGrad",tcompose.getNextHighestDepth());
         classes.Drawing.newBaseWindow(tcompose.bgGrad,iww,_loc2_,false);
         tcompose.bgGrad.onPress = function()
         {
            tcompose.swapDepths(_context.getNextHighestDepth());
            tcompose.startDrag(false);
         };
         tcompose.bgGrad.onRelease = function()
         {
            tcompose.stopDrag();
         };
         tcompose.bgGrad.onReleaseOutside = tcompose.bgGrad.onRelease;
         for(item in initObj)
         {
            tcompose[item] = initObj[item];
         }
         tcompose.bgGrad.useHandCursor = false;
         with(tcompose)
         {
            tcompose.createEmptyMovieClip("nav",tcompose.getNextHighestDepth());
            var _loc3_ = 30;
            nav._x = marginSide;
            nav.attachMovie("tog_send","tog_send",nav.getNextHighestDepth());
            nav.attachMovie("tog_closewin","tog_closewin",nav.getNextHighestDepth());
            nav.tog_send._x = Math.floor(nav.tog_send._width / 2);
            nav.tog_send._y = 6 + Math.floor(nav.tog_send._height / 2);
            nav.tog_closewin._x = iww - 38;
            nav.tog_closewin._y = 5;
            with(nav)
            {
               classes.Effects.roBounce(tog_send);
               tog_send.onRelease = function()
               {
                  if(this._parent._parent.to_user.length)
                  {
                     _root.sendEmail(this._parent._parent.to_user,this._parent._parent.subj,this._parent._parent.msg,this._parent._parent.composeNum);
                  }
                  else
                  {
                     _root.displayAlert("warning","E-mail Can Not Be Sent","\'To:\' can not be blank.  Please enter the receiver\'s user name in the \'To:\' field.");
                  }
               };
               tog_closewin.onRelease = function()
               {
                  this._parent._parent.removeMovieClip();
               };
            }
         }
         classes.Drawing.addCornerResizer(tcompose,"cornerHandle");
         var crn = tcompose.corner;
         crn.ix = crn._x;
         crn.iy = crn._y;
         var mouseListener = new Object();
         crn.onPress = function()
         {
            this.startDrag(false,crn.ix * minFactor,crn.iy * minFactor,1000,800);
            mouseListener.onMouseMove = function()
            {
               tcompose.refreshMe();
            };
            Mouse.addListener(mouseListener);
         };
         crn.onRelease = function()
         {
            this.stopDrag();
            Mouse.removeListener(mouseListener);
            tcompose.refreshMe();
         };
         crn.onReleaseOutside = crn.onRelease;
         setComposeScroller = function(scrollerContext, xx, hh)
         {
            with(scrollerContext)
            {
               scroller.scrollerObj.resetScroller(hh,xx);
               if(txt_msg.maxscroll > 1)
               {
                  scroller._visible = true;
               }
               else
               {
                  scroller._visible = false;
               }
            }
         };
         tcompose.refreshMe = function()
         {
            var _loc1_ = 1 + (crn._x - crn.ix) / (crn.ix + crn._width);
            var _loc2_ = 1 + (crn._y - crn.iy) / (crn.iy + crn._height);
            if(_loc1_ >= minFactor)
            {
               tcompose.bgGrad._width = crn._x + crn._width - tcompose.bgGrad._x;
            }
            if(_loc2_ >= minFactor)
            {
               tcompose.bgGrad._height = crn._y + crn._height - tcompose.bgGrad._y;
            }
            tcompose.nav.tog_closewin._x = tcompose.bgGrad._width - 38;
            if(tcompose.tb1 == undefined)
            {
               tcompose.createEmptyMovieClip("tb1",tcompose.getNextHighestDepth());
            }
            tcompose.tb1._x = marginSide;
            tcompose.tb1._y = marginTop;
            var _loc3_ = tcompose.bgGrad._width - 2 * marginSide;
            var _loc4_ = tcompose.bgGrad._height - marginTop - marginBtm;
            classes.Drawing.insetBox(tcompose.tb1,_loc3_,_loc4_,headH,11123413);
            with(tcompose.tb1)
            {
               var _loc5_ = 80;
               var _loc6_ = 9;
               var _loc7_ = 17;
               var _loc8_ = iww * minFactor - 2 * marginSide - _loc5_;
               var _loc9_ = Math.max(_loc8_,Math.round(0.6 * (_loc3_ - _loc5_)));
               var _loc10_ = 24;
               moveTo(_loc5_,_loc10_ + _loc6_);
               beginFill(16777215);
               curveTo(_loc5_,_loc10_,_loc5_ + _loc6_,_loc10_);
               lineTo(_loc5_ + _loc9_ - _loc6_,_loc10_);
               curveTo(_loc5_ + _loc9_,_loc10_,_loc5_ + _loc9_,_loc10_ + _loc6_);
               lineTo(_loc5_ + _loc9_,_loc10_ + _loc7_ - _loc6_);
               curveTo(_loc5_ + _loc9_,_loc10_ + _loc7_,_loc5_ + _loc9_ - _loc6_,_loc10_ + _loc7_);
               lineTo(_loc5_ + _loc6_,_loc10_ + _loc7_);
               curveTo(_loc5_,_loc10_ + _loc7_,_loc5_,_loc10_ + _loc7_ - _loc6_);
               lineTo(_loc5_,_loc10_ + _loc6_);
               endFill();
               if(txt_to == undefined)
               {
                  createTextField("txt_to",11,_loc5_ + _loc6_,_loc10_ - 1,_loc9_ - 2 * _loc6_,_loc7_);
                  txt_to.embedFonts = true;
                  txt_to.type = "input";
                  txt_to.tabIndex = 1;
                  txt_to.maxChars = 20;
                  var _loc11_ = new TextFormat();
                  _loc11_.font = "ArialBmp12";
                  _loc11_.size = 12;
                  _loc11_.color = 0;
                  txt_to.setNewTextFormat(_loc11_);
                  txt_to.variable = "_parent.to_user";
               }
               _loc10_ = 48;
               moveTo(_loc5_,_loc10_ + _loc6_);
               beginFill(16777215);
               curveTo(_loc5_,_loc10_,_loc5_ + _loc6_,_loc10_);
               lineTo(_loc5_ + _loc9_ - _loc6_,_loc10_);
               curveTo(_loc5_ + _loc9_,_loc10_,_loc5_ + _loc9_,_loc10_ + _loc6_);
               lineTo(_loc5_ + _loc9_,_loc10_ + _loc7_ - _loc6_);
               curveTo(_loc5_ + _loc9_,_loc10_ + _loc7_,_loc5_ + _loc9_ - _loc6_,_loc10_ + _loc7_);
               lineTo(_loc5_ + _loc6_,_loc10_ + _loc7_);
               curveTo(_loc5_,_loc10_ + _loc7_,_loc5_,_loc10_ + _loc7_ - _loc6_);
               lineTo(_loc5_,_loc10_ + _loc6_);
               endFill();
               if(txt_subj == undefined)
               {
                  createTextField("txt_subj",12,_loc5_ + _loc6_,_loc10_ - 1,_loc9_ - 2 * _loc6_,_loc7_);
                  txt_subj.embedFonts = true;
                  txt_subj.type = "input";
                  txt_subj.tabIndex = 2;
                  txt_subj.maxChars = 250;
                  txt_subj.restrict = classes.Lookup.keyboardRestrictChars;
                  _loc11_ = new TextFormat();
                  _loc11_.font = "ArialBmp12";
                  _loc11_.size = 12;
                  _loc11_.color = 0;
                  txt_subj.setNewTextFormat(_loc11_);
                  txt_subj.variable = "_parent.subj";
               }
               txt_to._width = _loc9_ - 2 * _loc6_;
               txt_subj._width = _loc9_ - 2 * _loc6_;
               if(txt_msg == undefined)
               {
                  createTextField("txt_msg",13,32,90,_loc3_ - 64,_loc4_ - 90 - 15);
                  txt_msg.embedFonts = true;
                  txt_msg.type = "input";
                  txt_msg.multiline = true;
                  txt_msg.wordWrap = true;
                  txt_msg.tabIndex = 3;
                  txt_subj.maxChars = 5000;
                  txt_msg.restrict = classes.Lookup.keyboardRestrictChars;
                  _loc11_ = new TextFormat();
                  _loc11_.font = "ArialBmp12";
                  _loc11_.size = 12;
                  _loc11_.color = 0;
                  txt_msg.setNewTextFormat(_loc11_);
                  txt_msg.variable = "_parent.msg";
                  tcompose.tb1.createEmptyMovieClip("scroller",tcompose.tb1.getNextHighestDepth());
                  scroller.scrollerObj = new controls.ScrollBar(txt_msg,_loc4_ - 65,0,78);
                  scroller._x = _loc3_ - 10;
                  scroller._visible = false;
                  txt_msg.onChanged = function()
                  {
                     var _loc1_ = tcompose.bgGrad._width - 2 * marginSide - 10;
                     setComposeScroller(tcompose.tb1,_loc1_,scroller._height);
                  };
               }
               setComposeScroller(tcompose.tb1,_loc3_ - 10,_loc4_ - 78);
               txt_msg._width = _loc3_ - 64;
               txt_msg._height = _loc4_ - 90 - 15;
            }
            classes.Drawing.applyInsetBoxFilters(tcompose.tb1);
            tcompose.cornerHandle._x = crn._x;
            tcompose.cornerHandle._y = crn._y;
            classes.Drawing.applyMainShad(tcompose);
         };
         tcompose.refreshMe();
         with(tcompose)
         {
            tcompose.attachMovie("icon_buddy","icon_buddy",tcompose.getNextHighestDepth());
            icon_buddy._x = tb1._x + 23;
            icon_buddy._y = tb1._y + 23;
            tcompose.createEmptyMovieClip("head_names",tcompose.getNextHighestDepth());
            head_names.createTextField("txt_head",1,0,0,78,56);
            head_names._x = tb1._x;
            head_names._y = icon_buddy._y;
            head_names.swapDepths(icon_buddy);
            with(head_names)
            {
               txt_head.embedFonts = true;
               txt_head.wordWrap = true;
               txt_head.multiline = true;
               var _loc4_ = new TextFormat();
               _loc4_.font = "Arial";
               _loc4_.bold = true;
               _loc4_.size = 13;
               _loc4_.leading = 10;
               _loc4_.align = "right";
               _loc4_.color = 16777215;
               txt_head.text = "To:\rSubject:";
               txt_head.setTextFormat(_loc4_);
            }
         }
      }
   }
   static function enableContextBtns(enable)
   {
      with(classes.Email.__context.email.nav)
      {
         tog_reply._visible = enable;
         tog_fw._visible = enable;
         tog_del._visible = enable;
      }
   }
   static function redrawInbox()
   {
      trace("redrawInbox");
      var _loc1_ = classes.Email.__context.email.tb1.scroller.scrollerContent;
      var _loc3_ = Math.round(classes.Email.__context.email.tb1._width / 3);
      var _loc4_ = classes.Email.__context.email.bgGrad._height - 41 - 28;
      var _loc2_ = _loc4_ - 43 - 20 - 3;
      classes.Email.drawInbox(_loc1_,_loc3_,_loc2_);
   }
   static function drawInbox(_context, inboxW, inboxH)
   {
      var _loc5_ = inboxW;
      classes.Email.emailNum = 0;
      with(_context)
      {
         if(_context.inbox == undefined)
         {
            _context.createEmptyMovieClip("inbox",_context.getNextHighestDepth());
            _context.inbox.cacheAsBitmap = true;
            classes.Email.__inboxList = _context.inbox;
         }
         for(every in _context.inbox)
         {
            if(every.indexOf("eitem") > -1)
            {
               _context.inbox[every].removeMovieClip();
               delete _context.inbox[every];
            }
         }
         var _loc6_ = 43;
         if(_loc6_ * _global.inbox_xml.firstChild.childNodes.length > inboxH)
         {
            _loc5_ -= 10;
         }
         var _loc7_ = 0;
         while(_loc7_ < _global.inbox_xml.firstChild.childNodes.length)
         {
            var _loc8_ = _global.inbox_xml.firstChild.childNodes[_loc7_];
            classes.Email.createEmailItem(inbox,_loc8_,_loc5_,_loc6_);
            if(_loc8_.attributes.i == classes.Email.selectedEmails[0])
            {
               if(_loc8_.attributes.i != classes.Email.viewedEmailID)
               {
                  classes.Email.getEmail(classes.Email.selectedEmails[0]);
               }
               else
               {
                  classes.Email.viewMail(classes.Email.viewedEmail);
               }
            }
            _loc7_ = _loc7_ + 1;
         }
         var _loc9_ = 0;
         while(_loc9_ < classes.Email.selectedEmails.length)
         {
            classes.Email.selectMail(classes.Email.selectedEmails[_loc9_]);
            _loc9_ = _loc9_ + 1;
         }
      }
      _context._parent.scrollerObj.refreshScroller();
   }
   static function createEmailItem(_context, xnode, cWidth, cHeight)
   {
      classes.Email.emailNum += 1;
      var _loc5_ = _context._height;
      _context.createEmptyMovieClip("eitem" + classes.Email.emailNum,_context.getNextHighestDepth());
      _context["eitem" + classes.Email.emailNum].id = xnode.attributes.i;
      _context["eitem" + classes.Email.emailNum].num = classes.Email.emailNum;
      with(_context["eitem" + classes.Email.emailNum])
      {
         var _loc6_ = xnode.attributes.fu;
         var _loc7_ = xnode.attributes.d;
         var _loc8_ = cHeight - 1;
         var _loc9_ = cWidth;
         var _loc10_ = 30;
         var _loc11_ = 40;
         _context["eitem" + classes.Email.emailNum].createEmptyMovieClip("hilite",_context["eitem" + classes.Email.emailNum].getNextHighestDepth());
         with(hilite)
         {
            beginFill(16777215);
            lineTo(_loc9_,0);
            lineTo(_loc9_,_loc8_);
            lineTo(0,_loc8_);
            lineTo(0,0);
            endFill();
         }
         _context["eitem" + classes.Email.emailNum].createEmptyMovieClip("line",_context["eitem" + classes.Email.emailNum].getNextHighestDepth());
         line._y = _loc8_;
         with(line)
         {
            beginFill(11386329);
            lineTo(_loc9_,0);
            lineTo(_loc9_,1);
            lineTo(0,1);
            lineTo(0,0);
            endFill();
         }
         _context["eitem" + classes.Email.emailNum].createEmptyMovieClip("textLayer",_context["eitem" + classes.Email.emailNum].getNextHighestDepth());
         with(textLayer)
         {
            var _loc12_ = new TextFormat();
            textLayer.createTextField("fld_subj",2,_loc11_,16,_loc9_ - _loc11_ - 10,20);
            fld_subj.embedFonts = true;
            fld_subj.selectable = false;
            fld_subj.html = true;
            _loc12_.size = 11;
            _loc12_.font = "ArialBmp11";
            _loc12_.kerning = true;
            fld_subj.setNewTextFormat(_loc12_);
            fld_subj.text = classes.StringFuncs.unSpecialChars(xnode.attributes.s);
            if(fld_subj.maxhscroll > 0)
            {
               textLayer.createTextField("fld_ellipsis",3,fld_subj._x + fld_subj._width,fld_subj._y,20,20);
               fld_ellipsis.embedFonts = true;
               fld_ellipsis.selectable = false;
               fld_ellipsis.setNewTextFormat(_loc12_);
               fld_ellipsis.text = "...";
            }
            textLayer.createTextField("fld_ts",4,_loc9_ - _loc10_,0,_loc10_,30);
            fld_ts.embedFonts = true;
            fld_ts.selectable = false;
            fld_ts.autoSize = "right";
            _loc12_.size = 12;
            _loc12_.align = "right";
            _loc12_.kerning = true;
            if(xnode.attributes.n == "1")
            {
               _loc12_.font = "ArialBmp12B";
            }
            else
            {
               _loc12_.font = "ArialBmp12";
            }
            fld_ts.setNewTextFormat(_loc12_);
            fld_ts.htmlText = classes.Email.convertTimestamp(_loc7_);
            textLayer.createTextField("fld_from",1,_loc11_,0,_loc9_ - _loc11_ - fld_ts._width,20);
            fld_from.embedFonts = true;
            fld_from.selectable = false;
            _loc12_.align = "left";
            _loc12_.size = 12;
            _loc12_.color = 0;
            _loc12_.kerning = true;
            if(xnode.attributes.n == "1")
            {
               _loc12_.font = "ArialBmp12B";
            }
            else
            {
               _loc12_.font = "ArialBmp12";
            }
            fld_from.setNewTextFormat(_loc12_);
            fld_from.text = _loc6_;
         }
         _context["eitem" + classes.Email.emailNum].attachMovie("email_icon","s_icon",_context["eitem" + classes.Email.emailNum].getNextHighestDepth());
         s_icon._x = 22;
         if(xnode.attributes.n == "1")
         {
            s_icon.read._visible = false;
            s_icon.unread._visible = true;
         }
         else
         {
            s_icon.read._visible = true;
            s_icon.unread._visible = false;
            _context["eitem" + classes.Email.emailNum].attachMovie("email_icon_read","s_icon",_context["eitem" + classes.Email.emailNum].getNextHighestDepth());
         }
         hilite.onRelease = function()
         {
            classes.Email.selectMail(id);
            classes.Email.getEmail(id);
         };
         _y = _loc5_;
      }
   }
   static function selectMail(xid)
   {
      var _listClip = classes.Email.__inboxList;
      var idNum = 0;
      classes.Email.selectedEmails[0] = xid;
      var ctWhite = new flash.geom.ColorTransform();
      ctWhite.rgb = 16777215;
      var ctBlack = new flash.geom.ColorTransform();
      ctBlack.rgb = 0;
      var ctHi = new flash.geom.ColorTransform();
      ctHi.rgb = 8375551;
      for(var each in _listClip)
      {
         if(eval("each").indexOf("eitem") > -1)
         {
            var trans = new flash.geom.Transform(_listClip[eval("each")].hilite);
            trans.colorTransform = ctWhite;
            var trans2 = new flash.geom.Transform(_listClip[eval("each")].textLayer);
            trans2.colorTransform = ctBlack;
            if(_listClip[eval("each")].id == xid)
            {
               idNum = _listClip[eval("each")].num;
            }
         }
      }
      with(_listClip["eitem" + idNum])
      {
         var tfmt = new TextFormat();
         tfmt.font = "ArialBmp12";
         textLayer.fld_from.setTextFormat(tfmt);
         textLayer.fld_ts.setTextFormat(tfmt);
         tfmt.font = "ArialBmp11";
         textLayer.fld_subj.setTextFormat(tfmt);
         var trans = new flash.geom.Transform(hilite);
         trans.colorTransform = ctHi;
         var trans2 = new flash.geom.Transform(textLayer);
         trans2.colorTransform = ctWhite;
         s_icon.unread._visible = false;
         s_icon.read._visible = true;
      }
   }
   static function getEmail(id)
   {
      if(id != classes.Email.viewedEmailID)
      {
         classes.Email.clearEmail();
         classes.Email.showRetrieveMsg();
         classes.Email.viewedEmailID = id;
         _root.getEmail(id);
      }
   }
   static function clearEmail()
   {
      with(classes.Email.__context.email.tb1.mailView)
      {
         fromLine.text = "";
         subjLine.text = "";
         msgArea.text = "";
         fld_scamWarn.removeTextField();
         delete fld_scamWarn;
         photo.removeMovieClip();
      }
   }
   static function showRetrieveMsg()
   {
      classes.Email.__context.email.tb1.mailView.msgArea.text = "\r\rRetrieving E-mail...";
   }
   static function viewMail(vnode)
   {
      classes.Email.viewedEmail = vnode;
      classes.Email.enableContextBtns(true);
      var _loc5_ = vnode.firstChild.attributes.i;
      var _loc6_ = 0;
      while(_loc6_ < _global.inbox_xml.firstChild.childNodes.length)
      {
         var _loc7_ = _global.inbox_xml.firstChild.childNodes[_loc6_];
         if(_loc7_.attributes.i == _loc5_)
         {
            if(_loc7_.attributes.n == 1)
            {
               _root.markEmailRead(_loc5_);
               _loc7_.attributes.n = 0;
               classes.GlobalData.updateInfo("im","count");
            }
         }
         _loc6_ = _loc6_ + 1;
      }
      if(classes.Email.__context.email.tb1.mailView == undefined)
      {
         classes.Email.__context.email.tb1.createEmptyMovieClip("mailView",classes.Email.__context.email.tb1.getNextHighestDepth());
      }
      with(classes.Email.__context.email.tb1.mailView)
      {
         _x = _parent.inbxLine._x + _parent.inbxLine._width;
         _y = _parent.inbxLine._y;
         var _loc8_ = _parent._parent.bgGrad._width - 30 - _x;
         var _loc9_ = 125;
         if(fld_scamWarn == undefined)
         {
            createTextField("fld_scamWarn",getNextHighestDepth(),_loc9_,4,248,50);
            fld_scamWarn.embedFonts = true;
            fld_scamWarn.selectable = false;
            fld_scamWarn.multiline = true;
            fld_scamWarn.wordWrap = true;
            var _loc10_ = new TextFormat();
            _loc10_.size = 10;
            _loc10_.font = "Arial";
            _loc10_.kerning = true;
            _loc10_.color = 16776960;
            fld_scamWarn.setNewTextFormat(_loc10_);
            fld_scamWarn.text = "Nitto will never ask for your personal information, passwords or credit card numbers in the game.";
         }
         if(fromLine == undefined)
         {
            createTextField("fromLine",getNextHighestDepth(),_loc9_,38,_loc8_ - _loc9_,40);
            fromLine.embedFonts = true;
            var _loc11_ = new TextFormat();
            _loc11_.font = "Arial";
            _loc11_.size = 12;
            _loc11_.color = 16777215;
            fromLine.setNewTextFormat(_loc11_);
         }
         fromLine._width = _loc8_ - _loc9_;
         fromLine.text = "From: " + classes.StringFuncs.unSpecialChars(vnode.firstChild.attributes.fu);
         if(subjLine == undefined)
         {
            createTextField("subjLine",getNextHighestDepth(),_loc9_,55,_loc8_ - _loc9_,40);
            subjLine.embedFonts = true;
            _loc11_ = new TextFormat();
            _loc11_.font = "Arial";
            _loc11_.bold = true;
            _loc11_.size = 13;
            _loc11_.color = 16777215;
            subjLine.setNewTextFormat(_loc11_);
         }
         subjLine._width = _loc8_ - _loc9_;
         subjLine.text = classes.StringFuncs.unSpecialChars(vnode.firstChild.attributes.s);
         if(msgArea == undefined)
         {
            createTextField("msgArea",getNextHighestDepth(),15,90,_loc8_ - 30,_parent.inbxLine._height - 90 - 15);
            msgArea.multiline = true;
            msgArea.wordWrap = true;
            _loc11_ = new TextFormat();
            _loc11_.font = "Arial";
            _loc11_.size = 12;
            _loc11_.color = 0;
            msgArea.setNewTextFormat(_loc11_);
            if(scroller == undefined)
            {
               createEmptyMovieClip("scroller",getNextHighestDepth());
               scroller.scrollerObj = new controls.ScrollBar(msgArea,_parent.viewTextHeight,_parent.viewTextWidth - 10,_parent.headH);
               scroller._visible = false;
            }
         }
         msgArea._width = _loc8_ - 30;
         msgArea._height = _parent.inbxLine._height - 90 - 15;
         msgArea.text = classes.StringFuncs.unSpecialChars(vnode.firstChild.firstChild.nodeValue);
         scroller.scrollerObj.resetScroller(_parent.viewTextHeight,_parent.viewTextWidth - 10,_parent.headH);
         setTimeout(classes.Drawing.portrait,100,_parent.mailView,vnode.firstChild.attributes.fi,1,10,7,1,true);
      }
   }
   static function convertTimestamp(ts)
   {
      var _loc2_ = "";
      var _loc3_ = ts.split(" ");
      var _loc4_ = _loc3_[0].split("/");
      var _loc5_ = _loc3_[1].split(":");
      if(_loc3_[2] == "PM" && _loc5_[0] != 12)
      {
         _loc5_[0] = Number(_loc5_[0]) + 12;
      }
      var _loc6_ = new Date(Number(_loc4_[2]),Number(_loc4_[0]) - 1,Number(_loc4_[1]),Number(_loc5_[0]),Number(_loc5_[1]),Number(_loc5_[2]));
      var _loc7_ = new Date();
      if(_loc6_.getFullYear() + _loc6_.getMonth() + _loc6_.getDate() != _loc7_.getFullYear() + _loc7_.getMonth() + _loc7_.getDate())
      {
         _loc2_ += _loc6_.getMonth() + 1 + "/" + _loc6_.getDate() + "/" + _loc6_.getFullYear().toString().substr(2,2) + " ";
      }
      var _loc8_ = classes.NumFuncs.getHoursAmPm(_loc6_.getHours());
      _loc2_ += _loc8_.hours + ":" + classes.NumFuncs.get2Mins(_loc6_.getMinutes()) + _loc8_.ampm;
      return _loc2_;
   }
   static function deleteEmail(id)
   {
      var _loc4_ = _global.inbox_xml.firstChild.childNodes.length;
      var _loc5_ = undefined;
      var _loc6_ = undefined;
      var _loc7_ = 0;
      while(_loc7_ < _loc4_)
      {
         if(_global.inbox_xml.firstChild.childNodes[_loc7_].attributes.i == id)
         {
            _global.inbox_xml.firstChild.childNodes[_loc7_].removeNode();
            _loc5_ = _loc7_;
            classes.Email.redrawInbox();
            break;
         }
         _loc7_ += 1;
      }
      _loc4_ = _global.inbox_xml.firstChild.childNodes.length;
      if(_loc5_ >= _loc4_)
      {
         _loc5_ = _loc4_ - 1;
      }
      _loc6_ = _global.inbox_xml.firstChild.childNodes[_loc5_].attributes.i;
      classes.Email.selectedEmails[0] = undefined;
      classes.Email.clearEmail();
      _root.deleteEmail(id);
   }
}
