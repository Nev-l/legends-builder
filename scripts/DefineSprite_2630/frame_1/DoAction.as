function checkForData()
{
   var _loc2_ = undefined;
   if(_global.chatObj.userListXML != undefined && _global.chatObj.teamXML != undefined && _global.chatObj.queueXML != undefined)
   {
      userListXML = _global.chatObj.userListXML;
      teamXML = _global.chatObj.teamXML;
      queueXML = _global.chatObj.queueXML;
      createUserList();
      if(_global.chatObj.raceObj.inp)
      {
         _global.chatObj.raceObj.r1Obj.un = lookupUserName(_global.chatObj.raceObj.r1Obj.id);
         _global.chatObj.raceObj.r2Obj.un = lookupUserName(_global.chatObj.raceObj.r2Obj.id);
         _global.chatObj.raceObj.r1Obj.tn = lookupTeamName(_global.chatObj.raceObj.r1Obj.ti);
         _global.chatObj.raceObj.r2Obj.tn = lookupTeamName(_global.chatObj.raceObj.r2Obj.ti);
         _loc2_ = 0;
         while(_loc2_ < queueXML.firstChild.childNodes.length)
         {
            if(queueXML.firstChild.childNodes[_loc2_].attributes.icid == _global.chatObj.raceObj.r1Obj.cid and queueXML.firstChild.childNodes[_loc2_].attributes.cicid == _global.chatObj.raceObj.r2Obj.cid)
            {
               queueXML.firstChild.childNodes[_loc2_].removeNode();
               break;
            }
            _loc2_ += 1;
         }
      }
      drawQueue();
      classes.Chat.createWindow(chatWindow,_global.newRoomName);
      if(container == undefined)
      {
         if(_global.chatObj.raceObj.inp)
         {
            showContainer("raceAnnounce","inProgress");
            delete _global.chatObj.raceObj.inp;
         }
         else
         {
            showWaiting();
         }
      }
   }
}
function userLeaves(uid)
{
   var _loc3_ = 0;
   while(_loc3_ < _global.chatObj.userListXML.firstChild.childNodes.length)
   {
      if(uid == _global.chatObj.userListXML.firstChild.childNodes[_loc3_].attributes.i)
      {
         _global.chatObj.userListXML.firstChild.childNodes[_loc3_].removeNode();
         break;
      }
      _loc3_ += 1;
   }
   _loc3_ = 0;
   while(_loc3_ < _global.chatObj.queueXML.firstChild.childNodes.length)
   {
      if(uid == _global.chatObj.queueXML.firstChild.childNodes[_loc3_].attributes.i)
      {
         _global.chatObj.queueXML.firstChild.childNodes[_loc3_].removeNode();
         break;
      }
      _loc3_ += 1;
   }
   container.removeVotes(uid);
}
function createUserList()
{
   if(userListGroup.scrollContent == undefined)
   {
      userListGroup.createEmptyMovieClip("scrollContent",1);
      userListGroup.scrollerObj = new controls.ScrollPane(userListGroup.scrollContent,333,232,null,null,322);
   }
   drawUserList();
}
function drawUserList()
{
   var _loc2_ = _global.chatObj.userListXML;
   var _loc3_ = undefined;
   var _loc4_ = undefined;
   var _loc5_ = undefined;
   var _loc6_ = undefined;
   for(var _loc7_ in userListGroup.scrollContent)
   {
      classes.Debug.writeLn(_loc7_);
      _loc3_ = false;
      if(_loc7_.indexOf("item") > -1)
      {
         _loc5_ = 0;
         while(_loc5_ < _loc2_.firstChild.childNodes.length)
         {
            if(userListGroup.scrollContent[_loc7_].userID == _loc2_.firstChild.childNodes[_loc5_].attributes.i)
            {
               _loc3_ = true;
               break;
            }
            _loc5_ += 1;
         }
      }
      else if(_loc7_.indexOf("team") > -1)
      {
         _loc4_ = 0;
         _loc6_ = 0;
         while(_loc6_ < _loc2_.firstChild.childNodes.length)
         {
            if(userListGroup.scrollContent[_loc7_].teamID == _loc2_.firstChild.childNodes[_loc6_].attributes.ti)
            {
               _loc4_ += 1;
            }
            _loc6_ += 1;
         }
         if(_loc4_ > 1)
         {
            _loc3_ = true;
         }
      }
      if(!_loc3_)
      {
         userListGroup.scrollContent[_loc7_].removeMovieClip();
      }
   }
   var _loc8_ = undefined;
   var _loc9_ = undefined;
   var _loc10_ = undefined;
   var _loc11_ = new Array();
   var _loc12_ = undefined;
   _loc5_ = 0;
   var _loc13_ = undefined;
   var _loc14_ = undefined;
   var _loc15_ = undefined;
   while(_loc5_ < _loc2_.firstChild.childNodes.length)
   {
      if(!userListGroup.scrollContent["item" + _loc2_.firstChild.childNodes[_loc5_].attributes.i])
      {
         _loc13_ = userListGroup.scrollContent.attachMovie("userListItem","item" + _loc2_.firstChild.childNodes[_loc5_].attributes.i,userListGroup.scrollContent.getNextHighestDepth(),{_x:190,_y:80,userID:_loc2_.firstChild.childNodes[_loc5_].attributes.i,userName:_loc2_.firstChild.childNodes[_loc5_].attributes.un,tf:_loc2_.firstChild.childNodes[_loc5_].attributes.tf,tid:_loc2_.firstChild.childNodes[_loc5_].attributes.tid});
         _loc14_ = classes.Lookup.getMemberColor(Number(_loc2_.firstChild.childNodes[_loc5_].attributes.ms));
         _loc15_ = new TextFormat();
         _loc15_.color = _loc14_;
         _loc13_.fld.setTextFormat(_loc15_);
         classes.Drawing.portrait(_loc13_,_loc2_.firstChild.childNodes[_loc5_].attributes.i,2,0,0,4);
         _loc8_ = _loc13_.photo;
         _loc8_._xscale = 25;
         _loc8_._yscale = 25;
         _loc8_._x = 100;
         _loc13_.onRelease = function()
         {
            classes.Control.focusViewer(this.userID);
         };
         if(_loc2_.firstChild.childNodes[_loc5_].attributes.iv == 1)
         {
            _loc13_._alpha = 50;
         }
      }
      _loc9_ = Number(_loc2_.firstChild.childNodes[_loc5_].attributes.ti);
      if(_loc9_ && !userListGroup.scrollContent["team" + _loc9_])
      {
         _loc12_ = false;
         _loc6_ = 0;
         while(_loc6_ < _loc11_.length)
         {
            if(_loc9_ == _loc11_[_loc6_])
            {
               _loc12_ = true;
            }
            _loc6_ += 1;
         }
         if(!_loc12_)
         {
            _loc11_.push(_loc9_);
         }
         else
         {
            _loc10_ = "";
            _loc6_ = 0;
            while(_loc6_ < teamXML.firstChild.childNodes.length)
            {
               if(teamXML.firstChild.childNodes[_loc6_].attributes.i == _loc9_)
               {
                  _loc10_ = teamXML.firstChild.childNodes[_loc6_].attributes.n;
                  break;
               }
               _loc6_ += 1;
            }
            userListGroup.scrollContent.attachMovie("teamListItem","team" + _loc9_,userListGroup.scrollContent.getNextHighestDepth(),{_x:40,teamID:_loc9_,teamName:_loc10_});
            classes.Drawing.portrait(userListGroup.scrollContent["team" + _loc9_],0,2,0,0,4);
            _loc8_ = userListGroup.scrollContent["team" + _loc9_].photo;
            _loc8_._xscale = 25;
            _loc8_._yscale = 25;
         }
      }
      _loc5_ += 1;
   }
   orderUserList();
}
function orderUserList()
{
   var _loc2_ = _global.chatObj.userListXML;
   userListGroup.scrollContent.clear();
   var _loc3_ = 9;
   var _loc4_ = 24;
   var _loc5_ = new Array();
   var _loc6_ = new Array();
   var _loc7_ = 0;
   while(_loc7_ < _loc2_.firstChild.childNodes.length)
   {
      _loc5_.push({id:_loc2_.firstChild.childNodes[_loc7_].attributes.i,teamID:_loc2_.firstChild.childNodes[_loc7_].attributes.ti,uName:_loc2_.firstChild.childNodes[_loc7_].attributes.un});
      _loc7_ = _loc7_ + 1;
   }
   _loc5_.sortOn(["teamID","uName"],[Array.NUMERIC,Array.CASEINSENSITIVE]);
   var _loc8_ = -10;
   var _loc9_ = _loc3_;
   var _loc10_ = undefined;
   var _loc11_ = undefined;
   var _loc12_ = undefined;
   _loc7_ = 0;
   while(_loc7_ < _loc5_.length)
   {
      if(_loc5_[_loc7_].teamID && userListGroup.scrollContent["team" + _loc5_[_loc7_].teamID] != undefined)
      {
         if(_loc11_ != _loc5_[_loc7_].teamID)
         {
            if(_loc11_)
            {
               _loc8_ += 10;
               classes.Drawing.rect(userListGroup.scrollContent,164,_loc8_ - _loc12_,16777215,15,10,_loc12_,8,1,16777215,40);
            }
            _loc11_ = _loc5_[_loc7_].teamID;
            _loc8_ += 17;
            userListGroup.scrollContent["team" + _loc11_]._y = _loc8_;
            _loc8_ += 17;
            _loc12_ = _loc8_;
            _loc8_ += 8;
         }
         userListGroup.scrollContent["item" + _loc5_[_loc7_].id]._y = _loc8_;
         userListGroup.scrollContent["item" + _loc5_[_loc7_].id]._x = 41;
         _loc8_ += _loc4_;
      }
      else
      {
         _loc6_.push(_loc5_[_loc7_]);
      }
      userListGroup.scrollContent["item" + _loc5_[_loc7_].id].swapDepths(0);
      userListGroup.scrollContent["item" + _loc5_[_loc7_].id].swapDepths(_loc7_ + 1);
      _loc7_ = _loc7_ + 1;
   }
   if(_loc11_)
   {
      _loc8_ += 10;
      classes.Drawing.rect(userListGroup.scrollContent,164,_loc8_ - _loc12_,16777215,15,10,_loc12_,8,1,16777215,40);
   }
   _loc6_.sortOn("uName",Array.CASEINSENSITIVE);
   _loc7_ = 0;
   while(_loc7_ < _loc5_.length)
   {
      userListGroup.scrollContent["item" + _loc6_[_loc7_].id]._y = _loc9_;
      userListGroup.scrollContent["item" + _loc6_[_loc7_].id]._x = 190;
      _loc9_ += _loc4_;
      userListGroup.scrollContent["item" + _loc6_[_loc7_].id].swapDepths(0);
      userListGroup.scrollContent["item" + _loc6_[_loc7_].id].swapDepths(_loc7_ + 1);
      _loc7_ = _loc7_ + 1;
   }
   with(userListGroup.scrollContent)
   {
      moveTo(0,0);
      beginFill(0,0);
      lineTo(10,0);
      lineTo(10,_height + _loc3_);
      endFill();
   }
   userListGroup.scrollerObj.refreshScroller();
   if(!userListGroup.scrollerObj._BASE._visible)
   {
      userListGroup.scrollerObj.setScrollToTop();
   }
}
function removeUser(uID)
{
   var _loc3_ = 0;
   while(_loc3_ < _global.chatObj.userListXML.firstChild.childNodes.length)
   {
      if(uID == _global.chatObj.userListXML.firstChild.childNodes[_loc3_].attributes.i)
      {
         _global.chatObj.userListXML.firstChild.childNodes[_loc3_].removeNode();
         drawUserList();
         break;
      }
      _loc3_ += 1;
   }
}
function addUser(userID, userName, teamID)
{
   var _loc5_ = undefined;
   var _loc6_ = undefined;
   var _loc7_ = undefined;
   if(userID && userName.length)
   {
      _loc5_ = new XML();
      _loc6_ = _loc5_.createElement("u");
      _loc6_.attributes.i = userID;
      _loc6_.attributes.un = userName;
      _loc6_.attributes.ti = teamID;
      _loc7_ = _loc6_.cloneNode(true);
      _global.chatObj.userListXML.firstChild.appendChild(_loc6_);
      classes.Lookup.addUserName(userID,userName);
      drawUserList();
   }
}
function optimizeBottom(isVisible)
{
   trace("optimizeBottom...");
   var _loc3_ = undefined;
   var _loc4_ = undefined;
   if(isVisible)
   {
      bottomStatic.bmp.dispose();
      bottomStatic.removeMovieClip();
      delete bottomStatic;
   }
   else if(!bottomStatic)
   {
      bottomStatic = this.createEmptyMovieClip("bottomStatic",this.getNextHighestDepth());
      bottomStatic._y = 344;
      bottomStatic.bmp.dispose();
      bottomStatic.bmp = new flash.display.BitmapData(800,256,false,0);
      _loc3_ = new flash.geom.Matrix(1,0,0,1,0,-344);
      _loc4_ = new flash.geom.ColorTransform(0.5,0.5,0.5,1,0,0,0,0);
      bottomStatic.bmp.draw(btmBG,new flash.geom.Matrix(),_loc4_,"normal");
      bottomStatic.bmp.draw(usersBG,new flash.geom.Matrix(1,0,0,1,usersBG._x,usersBG._y - btmBG._y),_loc4_,"normal");
      bottomStatic.bmp.draw(userListHeads,new flash.geom.Matrix(1,0,0,1,userListHeads._x,userListHeads._y - btmBG._y),_loc4_,"normal");
      bottomStatic.bmp.draw(userListGroup,new flash.geom.Matrix(1,0,0,1,userListGroup._x,userListGroup._y - btmBG._y),_loc4_,"normal");
      bottomStatic.bmp.draw(chatWindow,new flash.geom.Matrix(1,0,0,1,chatWindow._x,chatWindow._y - btmBG._y),_loc4_,"normal");
      bottomStatic.bmp.draw(queueGroup,new flash.geom.Matrix(1,0,0,1,queueGroup._x,queueGroup._y - btmBG._y),_loc4_,"normal");
      bottomStatic.bmp.draw(joinPanel,new flash.geom.Matrix(1,0,0,1,joinPanel._x,joinPanel._y - btmBG._y),_loc4_,"normal");
      bottomStatic.attachBitmap(bottomStatic.bmp,1);
   }
   btmBG._visible = isVisible;
   userListGroup._visible = isVisible;
   chatWindow._visible = isVisible;
   queueGroup._visible = isVisible;
   usersBG._visible = isVisible;
   joinPanel._visible = isVisible;
   userListHeads._visible = isVisible;
}
function showKingInfo()
{
   trace("showKingInfo ... " + kingObj.carXML);
   kingGroup._visible = false;
   var _loc1_ = kingObj.ks;
   if(_loc1_ > 0)
   {
      if(_loc1_ > 1)
      {
         kingGroup.txtStreak = "x" + _loc1_;
      }
      else
      {
         kingGroup.txtStreak = "";
      }
      if(kingGroup.kingID != kingObj.id)
      {
         kingGroup.kingID = kingObj.id;
         kingGroup.txtName = lookupUserName(kingObj.id);
         if(kingGroup.photo == undefined)
         {
            kingGroup.createEmptyMovieClip("photo",kingGroup.getNextHighestDepth());
            kingGroup.photo._xscale = kingGroup.photo._yscale = 25;
            kingGroup.photo._x = 119;
         }
         kingGroup.photo.photo.removeMovieClip();
         classes.Drawing.portrait(kingGroup.photo,kingObj.id,2,0,0,4);
         kingGroup.photo.onRelease = function()
         {
            classes.Control.focusViewer(kingObj.id);
         };
         if(kingObj.carXML != undefined)
         {
            kingCarXML = kingObj.carXML;
            if(kingGroup.thumb == undefined)
            {
               kingGroup.createEmptyMovieClip("thumb",kingGroup.getNextHighestDepth());
               kingGroup.thumb._xscale = -100;
               kingGroup.thumb._x = 87;
            }
            classes.Drawing.carView(kingGroup.thumb,kingCarXML,15);
            kingGroup.thumb.onRelease = function()
            {
               classes.Control.focusViewer(kingObj.id,kingObj.cid);
            };
         }
         kingGroup.kingIcon.swapDepths(kingGroup.getNextHighestDepth());
      }
      kingGroup._visible = true;
   }
}
function lookupUserName(uid)
{
   return classes.Lookup.buddyName(uid);
}
function lookupTeamID(uid)
{
   var _loc3_ = 0;
   while(_loc3_ < _global.chatObj.userListXML.firstChild.childNodes.length)
   {
      if(_global.chatObj.userListXML.firstChild.childNodes[_loc3_].attributes.i == uid)
      {
         return Number(_global.chatObj.userListXML.firstChild.childNodes[_loc3_].attributes.ti);
      }
      _loc3_ += 1;
   }
   return 0;
}
function lookupTeamName(tid)
{
   var _loc3_ = "";
   var _loc4_ = 0;
   while(_loc4_ < _global.chatObj.teamXML.firstChild.childNodes.length)
   {
      if(_global.chatObj.teamXML.firstChild.childNodes[_loc4_].attributes.i == tid)
      {
         _loc3_ = _global.chatObj.teamXML.firstChild.childNodes[_loc4_].attributes.n;
         break;
      }
      _loc4_ += 1;
   }
   return _loc3_;
}
function drawQueue(raceInProgress)
{
   var queueXML = _global.chatObj.queueXML;
   var _loc5_ = _global.chatObj.userListXML;
   var _loc6_ = 31;
   queueGroup.fldNumbers.autoSize = true;
   var _loc7_ = queueXML.firstChild.childNodes.length;
   var _loc8_ = 0;
   var _loc9_ = 7;
   var _loc10_ = new Array();
   if(container.linkName == "raceAnnounce" || container.linkName == "racePlay")
   {
      raceInProgress = true;
   }
   var _loc11_ = undefined;
   var _loc12_ = undefined;
   var _loc13_ = undefined;
   var _loc14_ = undefined;
   var _loc15_ = undefined;
   var _loc16_ = undefined;
   var _loc17_ = undefined;
   var _loc18_ = undefined;
   var _loc19_ = undefined;
   var _loc20_ = undefined;
   var _loc21_ = undefined;
   if(!classes.RacePlay._MC.myLane)
   {
      if(Number(queueXML.firstChild.firstChild.attributes.ks) > 0)
      {
         _loc8_ = 1;
         _loc11_ = function(d)
         {
            trace("CB_kingCar: " + d);
            var _loc3_ = new XML(d);
            if(_global.chatObj.raceRoomMC.kingObj.cid == _loc3_.firstChild.attributes.i)
            {
               _global.chatObj.raceRoomMC.kingObj.carXML = new XML(d);
               _global.chatObj.raceRoomMC.showKingInfo();
            }
            classes.Lookup.addToRaceCarsXML(_loc3_.firstChild);
         };
         _loc12_ = Number(queueXML.firstChild.firstChild.attributes.ci);
         _loc10_.push(_loc12_);
         classes.Lookup.addCallback("getRacersCars",this,_loc11_,String(_loc12_));
      }
      if(raceInProgress)
      {
         _loc8_ = 2;
      }
      if(_loc7_ <= _loc8_)
      {
         queueGroup._visible = false;
      }
      else
      {
         queueGroup._visible = true;
      }
      _loc9_ = Math.min(_loc9_ + _loc8_,_loc7_);
      _loc13_ = false;
      _loc14_ = new Array();
      for(var _loc22_ in queueGroup)
      {
         if(_loc22_.indexOf("queueItem") > -1)
         {
            _loc13_ = false;
            _loc16_ = _loc8_;
            while(_loc16_ < _loc9_)
            {
               if(queueGroup[_loc22_].userID == queueXML.firstChild.childNodes[_loc16_].attributes.i)
               {
                  _loc13_ = true;
                  _loc14_.push(queueXML.firstChild.childNodes[_loc16_].attributes.i);
                  break;
               }
               _loc16_ += 1;
            }
            if(!_loc13_)
            {
               queueGroup[_loc22_].removeMovieClip();
            }
         }
      }
      _loc16_ = _loc8_;
      while(_loc16_ < _loc9_)
      {
         _loc13_ = false;
         if(queueXML.firstChild.childNodes[_loc16_].attributes.i == classes.GlobalData.id)
         {
            _loc15_ = _loc16_ - _loc8_ + 1;
         }
         _loc17_ = 0;
         while(_loc17_ < _loc14_.length)
         {
            if(_loc14_[_loc17_] == queueXML.firstChild.childNodes[_loc16_].attributes.i)
            {
               _loc13_ = true;
               break;
            }
            _loc17_ += 1;
         }
         if(!_loc13_)
         {
            _loc18_ = "";
            _loc17_ = 0;
            while(_loc17_ < _loc5_.firstChild.childNodes.length)
            {
               if(queueXML.firstChild.childNodes[_loc16_].attributes.i == _loc5_.firstChild.childNodes[_loc17_].attributes.i)
               {
                  _loc18_ = _loc5_.firstChild.childNodes[_loc17_].attributes.un;
               }
               _loc17_ += 1;
            }
            _loc19_ = queueGroup.attachMovie("queueListItem","queueItem" + queueXML.firstChild.childNodes[_loc16_].attributes.i,queueGroup.getNextHighestDepth(),{userID:queueXML.firstChild.childNodes[_loc16_].attributes.i,userName:_loc18_,carID:queueXML.firstChild.childNodes[_loc16_].attributes.ci});
            _loc19_.onRelease = function()
            {
               classes.Control.focusViewer(this.userID,this.carID);
            };
            _loc20_ = _loc19_.createEmptyMovieClip("thumb",1);
            _loc20_._x = 95;
            _loc21_ = function(d)
            {
               trace("CB_queueCar");
               var _loc2_ = new XML(d);
               var _loc3_ = _loc2_.firstChild.attributes.i;
               var _loc4_ = 0;
               while(_loc4_ < queueXML.firstChild.childNodes.length)
               {
                  if(queueXML.firstChild.childNodes[_loc4_].attributes.ci == _loc3_)
                  {
                     classes.Drawing.carView(queueGroup["queueItem" + queueXML.firstChild.childNodes[_loc4_].attributes.i].thumb,new XML(_loc2_.toString()),9.7);
                     break;
                  }
                  _loc4_ += 1;
               }
               classes.Lookup.addToRaceCarsXML(_loc2_.firstChild);
            };
            _loc12_ = Number(queueXML.firstChild.childNodes[_loc16_].attributes.ci);
            _loc10_.push(_loc12_);
            classes.Lookup.addCallback("getRacersCars",chatKOTHUsersCB,_loc21_,String(_loc12_));
         }
         queueGroup["queueItem" + queueXML.firstChild.childNodes[_loc16_].attributes.i]._y = (_loc16_ - _loc8_) * _loc6_;
         _loc16_ += 1;
      }
      if(_loc10_.length)
      {
         _root.getRacersCars(_loc10_);
      }
      _loc9_ = _loc7_ - _loc8_;
      queueGroup.txtNumbers = "";
      _loc16_ = 2;
      while(_loc16_ <= Math.min(_loc9_,7))
      {
         queueGroup.txtNumbers += _loc16_ + "\n";
         _loc16_ += 1;
      }
      if(_loc9_ > 7)
      {
         queueGroup.txtTotal = "..." + _loc9_;
      }
      else
      {
         queueGroup.txtTotal = "";
      }
      queueGroup.btmFade.swapDepths(queueGroup.getNextHighestDepth());
      joinPanel.panel.togLineUp.txtMyPos = "";
      if(_loc15_)
      {
         joinPanel.panel.togLineUp.txtMyPos = _loc15_;
      }
   }
}
function updateQueue(userID, userName, remove)
{
   var _loc5_ = undefined;
   var _loc6_ = undefined;
   if(remove)
   {
      removeQueueNode(userID);
   }
   else
   {
      _loc5_ = new XML();
      _loc6_ = _loc5_.createElement("u");
      _loc6_.attributes.i = userID;
      _loc6_.attributes.un = userName;
      _global.chatObj.queueXML.firstChild.appendChild(_loc6_);
   }
   drawQueue();
}
function removeQueueNode(userID)
{
   var _loc3_ = 0;
   while(_loc3_ < _global.chatObj.queueXML.firstChild.childNodes.length)
   {
      if(_global.chatObj.queueXML.firstChild.childNodes[_loc3_].attributes.i == userID)
      {
         _global.chatObj.queueXML.firstChild.childNodes[_loc3_].removeNode();
         if(userID == classes.GlobalData.id)
         {
            joinPanel.panel.togLineUp.gotoAndStop(1);
            joinPanel.panel.togLineUp._visible = true;
         }
         break;
      }
      _loc3_ += 1;
   }
}
function showChallengerNew(showSecond)
{
   _root.abc.closeMe();
   _root.attachMovie("dialogContainer","abc",_root.getNextHighestDepth(),{contentName:"dialogChallengerNewContent"});
   _root.abc.dialog = "dialogChallengerNew";
   classes.ClipFuncs.newClip(_root.abc.contentMC,"viewLogo",24,158,50);
   classes.Drawing.carLogo(_root.abc.contentMC.viewLogo,_global.chatObj.myRaceCarNode.attributes.ci);
   classes.ClipFuncs.newClip(_root.abc.contentMC,"viewThumb",250,132);
   classes.Drawing.carView(_root.abc.contentMC.viewThumb,new XML(_global.chatObj.myRaceCarNode.toString()),28,"front");
   classes.ClipFuncs.newClip(_root.abc.contentMC,"viewPlate",27,193);
   classes.Drawing.plateView(_root.abc.contentMC.viewPlate,Number(_global.chatObj.myRaceCarNode.attributes.pi),_global.chatObj.myRaceCarNode.attributes.pn,30,true);
   with(_root.abc.contentMC)
   {
      btnChicken._visible = false;
      btnStage.btnLabel.text = "OK";
      btnChicken.btnLabel.text = "Chicken Out";
      timer._visible = false;
      bet = 0;
   }
   _root.abc.contentMC.btnStage.onRelease = function()
   {
      this._parent._parent.closeMe();
   };
   _root.abc.contentMC.btnChicken.onRelease = function()
   {
      clearInterval(this._parent.timer.countSI);
      _root.chatKOTHLeave();
      this._parent._parent.closeMe();
      showChickenOut();
   };
   if(showSecond)
   {
      showChallengerNew2();
   }
}
function showChallengerNew2()
{
   if(_root.abc.dialog == "dialogChallengerNew")
   {
      _root.abc.dialog = "dialogChallengerNew2";
      with(_root.abc.contentMC)
      {
         btnStage.btnLabel.text = "Stage Up";
         btnStage.onRelease = function()
         {
            clearInterval(this._parent.timer.countSI);
            _root.raceKOTHOK(this._parent.bet);
            this._parent._parent.closeMe();
         };
         btnChicken._visible = true;
         if(Number(_global.chatObj.queueXML.firstChild.firstChild.attributes.ks) > 0)
         {
            gotoAndStop("bet");
            play();
         }
         else
         {
            txtMsg = "This is a no-bet match since there is no King. The winner of this match will set a new bet limit.";
         }
      }
      onTimeOut = function()
      {
         if(_root.abc.contentName == "dialogChallengerNewContent")
         {
            _root.abc.closeMe();
         }
      };
      var _loc3_ = 2;
      if(_global.chatObj.newRaceTS)
      {
         _loc3_ += Math.ceil((new Date() - _global.chatObj.newRaceTS) / 1000);
      }
      _root.abc.addTimer(_global.chatObj.raceObj.timeToRespond - _loc3_,onTimeOut);
   }
   else
   {
      showChallengerNew(true);
   }
}
function showKingOption()
{
   _root.abc.closeMe();
   var _loc3_ = _root.attachMovie("dialogContainer","abc",_root.getNextHighestDepth(),{contentName:"dialogKingOptionContent"});
   _loc3_.contentMC.timer._visible = false;
   _loc3_.contentMC.txtStreak = "x" + _global.chatObj.queueXML.firstChild.firstChild.attributes.ks;
   classes.ClipFuncs.newClip(_root.abc.contentMC,"viewLogo",24,158,50);
   classes.Drawing.carLogo(_root.abc.contentMC.viewLogo,_global.chatObj.myRaceCarNode.attributes.ci);
   classes.ClipFuncs.newClip(_root.abc.contentMC,"viewThumb",250,132);
   classes.Drawing.carView(_root.abc.contentMC.viewThumb,new XML(_global.chatObj.myRaceCarNode.toString()),28,"front");
   classes.ClipFuncs.newClip(_root.abc.contentMC,"viewPlate",27,193);
   classes.Drawing.plateView(_root.abc.contentMC.viewPlate,Number(_global.chatObj.myRaceCarNode.attributes.pi),_global.chatObj.myRaceCarNode.attributes.pn,30,true);
   _loc3_.contentMC.btnContinue.onRelease = function()
   {
      var _loc4_ = undefined;
      var _loc5_ = undefined;
      if(_global.chatObj.roomType == "KOTHH" || Number(this._parent.dialInGroup.txtDialIn))
      {
         this._parent.txtDialError = "";
         _loc4_ = Number(this._parent.dialInGroup.txtDialIn);
         if(_global.chatObj.roomType == "KOTHH")
         {
            _loc4_ = 0;
         }
         _loc5_ = Number(_global.chatObj.raceRoomMC.kingObj.bet);
         if(_loc5_ > Number(classes.GlobalData.attr.m))
         {
            _loc5_ = Number(classes.GlobalData.attr.m);
         }
         _root.chatKOTHKingContinue(_loc5_,_loc4_);
         this._parent._parent.closeMe();
      }
      else
      {
         this._parent.txtDialError = "Invalid dial-in time.";
      }
   };
   _loc3_.contentMC.btnCancel.onRelease = function()
   {
      _root.chatKOTHLeave();
      this._parent._parent.closeMe();
   };
   onTimeOut = function()
   {
      if(_root.abc.contentName == "dialogKingOptionContent")
      {
         _root.abc.closeMe();
      }
   };
   _loc3_.addTimer(20,onTimeOut);
}
function showKingNew()
{
   joinPanel.panel.togLineUp.gotoAndStop("king");
   joinPanel.panel.togLineUp._visible = true;
   _root.abc.closeMe();
   _root.attachMovie("dialogContainer","abc",_root.getNextHighestDepth(),{contentName:"dialogKingNewContent"});
   _root.abc.contentMC.timer._visible = false;
   _root.abc.contentMC.btnContinue.onRelease = function()
   {
      var _loc4_ = undefined;
      var _loc5_ = undefined;
      if(_global.chatObj.roomType == "KOTHH" || Number(this._parent.dialInGroup.txtDialIn))
      {
         this._parent.txtDialError = "";
         _loc4_ = Number(this._parent.dialInGroup.txtDialIn);
         if(_global.chatObj.roomType == "KOTHH")
         {
            _loc4_ = 0;
         }
         _loc5_ = Number(this._parent.bet);
         if(_loc5_ > Number(classes.GlobalData.attr.m))
         {
            _loc5_ = Number(classes.GlobalData.attr.m);
            if(_loc5_ < 0)
            {
               _loc5_ = 0;
            }
            this._parent.bet = _loc5_;
         }
         _global.chatObj.raceRoomMC.kingObj.bet = _loc5_;
         _root.chatKOTHKingContinue(_loc5_,_loc4_);
         this._parent._parent.closeMe();
      }
      else
      {
         this._parent.txtDialError = "Invalid dial-in time.";
      }
   };
   _root.abc.contentMC.btnCancel.onRelease = function()
   {
      _root.chatKOTHLeave();
      this._parent._parent.closeMe();
   };
   onTimeOut = function()
   {
      if(_root.abc.contentName == "dialogKingNewContent")
      {
         _root.abc.closeMe();
      }
   };
   _root.abc.addTimer(20,onTimeOut);
}
function showKingChallenge()
{
   _root.abc.closeMe();
   _root.attachMovie("dialogContainer","abc",_root.getNextHighestDepth(),{contentName:"dialogKingChallengeContent"});
   _root.abc.contentMC.timer._visible = false;
   classes.ClipFuncs.newClip(_root.abc.contentMC,"viewLogo",24,158,50);
   classes.Drawing.carLogo(_root.abc.contentMC.viewLogo,_global.chatObj.myRaceCarNode.attributes.ci);
   classes.ClipFuncs.newClip(_root.abc.contentMC,"viewThumb",250,132);
   classes.Drawing.carView(_root.abc.contentMC.viewThumb,new XML(_global.chatObj.myRaceCarNode.toString()),28,"front");
   classes.ClipFuncs.newClip(_root.abc.contentMC,"viewPlate",27,193);
   classes.Drawing.plateView(_root.abc.contentMC.viewPlate,Number(_global.chatObj.myRaceCarNode.attributes.pi),_global.chatObj.myRaceCarNode.attributes.pn,30,true);
   with(_root.abc.contentMC)
   {
      btnContinue.btnLabel.text = "Stage Up";
      btnCancel.btnLabel.text = "Chicken Out";
   }
   _root.abc.createEmptyMovieClip("viewThumb",_root.abc.getNextHighestDepth());
   _root.abc.viewThumb._x = 264;
   _root.abc.viewThumb._y = 143;
   _root.abc.contentMC.btnContinue.onRelease = function()
   {
      _root.raceKOTHOK();
      this._parent._parent.closeMe();
   };
   _root.abc.contentMC.btnCancel.onRelease = function()
   {
      _root.chatKOTHLeave();
      this._parent._parent.closeMe();
   };
   onTimeOut = function()
   {
      if(_root.abc.contentName == "dialogKingChallengeContent")
      {
         _root.abc.closeMe();
      }
   };
   _root.abc.addTimer(20,onTimeOut);
}
function showChickenOut()
{
   _root.abc.closeMe();
   _root.attachMovie("dialogContainer","abc",_root.getNextHighestDepth(),{contentName:"dialogChickenOutContent"});
   _root.abc.addButton("OK");
   joinPanel.panel.togLineUp.gotoAndStop(1);
   joinPanel.panel.togLineUp._visible = true;
   optimizeBottom(true);
}
function showTimedOut(custMsg)
{
   _root.abc.closeMe();
   _root.attachMovie("dialogContainer","abc",_root.getNextHighestDepth(),{contentName:"dialogTimedOutContent",txt:custMsg});
   _root.abc.addButton("OK");
   joinPanel.panel.togLineUp.gotoAndStop(1);
   joinPanel.panel.togLineUp._visible = true;
   optimizeBottom(true);
}
function showContainer(linkName, type)
{
   this.container.removeMovieClip();
   if(linkName.length)
   {
      this.attachMovie(linkName,"container",this.getNextHighestDepth(),{linkName:linkName,type:type});
   }
   else
   {
      this.attachMovie("raceAnnounce","container",this.getNextHighestDepth(),{linkName:"raceAnnounce",type:"king"});
   }
   if(containerMask == undefined)
   {
      this.createEmptyMovieClip("containerMask",this.getNextHighestDepth());
      classes.Drawing.rect(containerMask,800,344,0,50);
   }
   container._x = 0;
   container._y = 0;
   container.setMask(containerMask);
   container.swapDepths(kingGroup);
   joinPanel.swapDepths(kingGroup);
}
function CB_listUsers()
{
   var _loc4_ = new Array();
   var _loc5_ = new Array();
   var _loc6_ = 0;
   while(_loc6_ < _global.chatObj.userListXML.firstChild.childNodes.length)
   {
      if(Number(_global.chatObj.userListXML.firstChild.childNodes[_loc6_].attributes.ti))
      {
         _loc4_.push(_global.chatObj.userListXML.firstChild.childNodes[_loc6_].attributes.ti);
      }
      _loc6_ += 1;
   }
   var _loc7_ = undefined;
   var _loc8_ = undefined;
   if(_loc4_.length >= 1)
   {
      _loc4_.sort();
      _loc7_ = "";
      _loc6_ = 0;
      while(_loc6_ < _loc4_.length)
      {
         if(_loc7_ != _loc4_[_loc6_])
         {
            _loc5_.push(_loc4_[_loc6_]);
         }
         _loc7_ = _loc4_[_loc6_];
         _loc6_ += 1;
      }
      if(_loc5_.length)
      {
         _loc8_ = function(d)
         {
            _global.chatObj.teamXML = new XML(d);
            checkForData();
         };
         delete _global.chatObj.teamXML;
         classes.Lookup.addCallback("teamInfo",this,_loc8_,"");
         _root.teamInfo(_loc5_.toString());
      }
      else
      {
         _global.chatObj.teamXML = new XML();
         checkForData();
      }
   }
   else
   {
      _global.chatObj.teamXML = new XML();
      checkForData();
   }
}
function onRaceResults(xmlStr)
{
   trace("onRaceResults");
   var _loc4_ = new XML(xmlStr);
   _global.chatObj.raceObj.lastResultsXML = _loc4_;
   _global.chatObj.raceObj.r1Obj.h = _loc4_.firstChild.attributes.h1;
   _global.chatObj.raceObj.r2Obj.h = _loc4_.firstChild.attributes.h2;
   if(_loc4_.firstChild.attributes.wid == "-2")
   {
      container.wid = -2;
      kingObj.id = 0;
      kingObj.ks = 0;
      kingObj.username = "";
      kingObj.carXML = undefined;
      container.racer1Obj.RT = "FOUL";
      container.racer2Obj.RT = "FOUL";
      container.victor = 0;
   }
   else if(_loc4_.firstChild.attributes.wid == "-1")
   {
      container.victor = 0;
      kingObj.id = 0;
      kingObj.ks = 0;
      kingObj.username = "";
      kingObj.carXML = undefined;
   }
   else
   {
      container.wid = _loc4_.firstChild.attributes.wid;
      kingObj.id = _loc4_.firstChild.attributes.wid;
      if(kingObj.id == _global.chatObj.raceObj.r1Obj.id)
      {
         kingObj.cid = _global.chatObj.raceObj.r1Obj.cid;
      }
      else if(kingObj.id == _global.chatObj.raceObj.r2Obj.id)
      {
         kingObj.cid = _global.chatObj.raceObj.r2Obj.cid;
      }
      else
      {
         kingObj.cid = 0;
      }
      kingObj.username = lookupUserName(kingObj.id);
      container.racer1Obj.RT = _loc4_.firstChild.attributes.rt1;
      container.racer2Obj.RT = _loc4_.firstChild.attributes.rt2;
      if(_loc4_.firstChild.attributes.wid == container.racer1Obj.id)
      {
         container.victor = 1;
         kingObj.bt = container.racer1Obj.bt;
      }
      else if(_loc4_.firstChild.attributes.wid == container.racer2Obj.id)
      {
         container.victor = -1;
         kingObj.bt = container.racer2Obj.bt;
      }
   }
   if((classes.GlobalData.id == _loc4_.firstChild.attributes.r1id || classes.GlobalData.id == _loc4_.firstChild.attributes.r2id) && classes.GlobalData.id != _loc4_.firstChild.attributes.wid)
   {
      joinPanel.panel.togLineUp.gotoAndStop(1);
      joinPanel.panel.togLineUp._visible = true;
   }
   container.racer1Obj.ET = _loc4_.firstChild.attributes.et1;
   container.racer1Obj.TS = _loc4_.firstChild.attributes.ts1;
   container.racer2Obj.ET = _loc4_.firstChild.attributes.et2;
   container.racer2Obj.TS = _loc4_.firstChild.attributes.ts2;
   container.racer1Obj.scc = _loc4_.firstChild.attributes.c1;
   container.racer2Obj.scc = _loc4_.firstChild.attributes.c2;
   container.racer1Obj.sc = Number(container.racer1Obj.sc) + Number(_loc4_.firstChild.attributes.c1);
   container.racer2Obj.sc = Number(container.racer2Obj.sc) + Number(_loc4_.firstChild.attributes.c2);
   if(classes.GlobalData.id == _loc4_.firstChild.attributes.r1id)
   {
      classes.GlobalData.updateInfo("sc",container.racer1Obj.sc);
      classes.GlobalData.updateInfo("m",Number(classes.GlobalData.attr.m) + Number(_loc4_.firstChild.attributes.m1));
   }
   else if(classes.GlobalData.id == _loc4_.firstChild.attributes.r2id)
   {
      classes.GlobalData.updateInfo("sc",container.racer2Obj.sc);
      classes.GlobalData.updateInfo("m",Number(classes.GlobalData.attr.m) + Number(_loc4_.firstChild.attributes.m2));
   }
   if(kingObj.id == _loc4_.firstChild.attributes.r1id)
   {
      removeQueueNode(_loc4_.firstChild.attributes.r2id);
      _global.chatObj.queueXML.firstChild.childNodes[0].attributes.sc = Number(_global.chatObj.queueXML.firstChild.childNodes[0].attributes.sc) + Number(_loc4_.firstChild.attributes.c1);
      kingObj.sc = _global.chatObj.queueXML.firstChild.childNodes[0].attributes.sc;
   }
   else if(kingObj.id == _loc4_.firstChild.attributes.r2id)
   {
      removeQueueNode(_loc4_.firstChild.attributes.r1id);
      _global.chatObj.queueXML.firstChild.childNodes[0].attributes.sc = Number(_global.chatObj.queueXML.firstChild.childNodes[0].attributes.sc) + Number(_loc4_.firstChild.attributes.c2);
      kingObj.sc = _global.chatObj.queueXML.firstChild.childNodes[0].attributes.sc;
   }
   else
   {
      removeQueueNode(_loc4_.firstChild.attributes.r2id);
      removeQueueNode(_loc4_.firstChild.attributes.r1id);
      kingObj.sc = 0;
   }
   var _loc5_ = undefined;
   if(kingObj.id)
   {
      if(Number(_global.chatObj.queueXML.firstChild.childNodes[0].attributes.ks))
      {
         _global.chatObj.queueXML.firstChild.childNodes[0].attributes.ks = Number(_global.chatObj.queueXML.firstChild.childNodes[0].attributes.ks) + 1;
      }
      else
      {
         _global.chatObj.queueXML.firstChild.childNodes[0].attributes.ks = 1;
      }
      kingObj.ks = _global.chatObj.queueXML.firstChild.childNodes[0].attributes.ks;
      if(kingObj.id == container.racer1Obj.id)
      {
         _loc5_ = 0;
      }
      else if(kingObj.id == container.racer2Obj.id)
      {
         _loc5_ = 1;
      }
      trace("----- GETTING KING CAR...");
      trace(classes.Lookup.getRaceCarNode(kingObj.cid).toString());
      kingObj.carXML = new XML(classes.Lookup.getRaceCarNode(kingObj.cid).toString());
   }
   if(classes.GlobalData.id == kingObj.id)
   {
      classes.Control.setMapButton("king");
   }
   else
   {
      classes.Control.setMapButton("race");
   }
   classes.Chat.enableWindow();
   optimizeBottom(true);
   if(classes.GlobalData.id == _loc4_.firstChild.attributes.r1id || classes.GlobalData.id == _loc4_.firstChild.attributes.r2id)
   {
      if(container.linkName == "racePlay")
      {
         container.showFinish();
      }
      else
      {
         _global.setTimeout(this,"doShowFinish",2000);
      }
   }
   else
   {
      _global.setTimeout(this,"doShowFinish",5000);
   }
}
function initKingObj()
{
   delete kingObj;
   kingObj = new Object();
}
function doShowFinish()
{
   if(container.linkName == "racePlay")
   {
      container.showFinish(3000);
   }
   else if(kingObj.id <= 0)
   {
      initKingObj();
      showKingInfo();
      showContainer("raceNoWinner");
   }
   else
   {
      showKingInfo();
      showContainer("raceWinnerKOTH");
   }
}
function showWaiting()
{
   if(_global.chatObj.roomType == "KOTHH")
   {
      showContainer("waitKOTHH2H");
   }
   else if(_global.chatObj.roomType == "KOTHB")
   {
      showContainer("waitKOTHBKT");
   }
}
var bottomStatic;
