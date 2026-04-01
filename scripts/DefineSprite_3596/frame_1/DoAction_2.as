function checkForData()
{
   trace("checkForData");
   if(_global.chatObj.userListXML != undefined && _global.chatObj.teamXML != undefined)
   {
      trace("made it!");
      userListXML = _global.chatObj.userListXML;
      teamXML = _global.chatObj.teamXML;
      createUserList();
      classes.Chat.createWindow(chatWindow,_global.newRoomName);
      classes.InterviewChat.createWindow(chatWindowInterview,_global.newRoomName);
      _root.GetElectionInterviewList();
   }
}
function userLeaves(uid)
{
   userList.scrollerContent["item" + uid].removeMovieClip();
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
      if(uid == _global.chatObj.queueXML.firstChild.childNodes[_loc3_].attributes.i || uid == _global.chatObj.queueXML.firstChild.childNodes[_loc3_].attributes.ci)
      {
         _global.chatObj.queueXML.firstChild.childNodes[_loc3_].removeNode();
         break;
      }
      _loc3_ += 1;
   }
   classes.RivalsChallengePanel.clearChallengesFrom(uid);
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
         _loc13_ = userListGroup.scrollContent.attachMovie("userListItem","item" + _loc2_.firstChild.childNodes[_loc5_].attributes.i,userListGroup.scrollContent.getNextHighestDepth(),{_x:190,_y:80,userID:_loc2_.firstChild.childNodes[_loc5_].attributes.i,userName:_loc2_.firstChild.childNodes[_loc5_].attributes.un,tf:_loc2_.firstChild.childNodes[_loc5_].attributes.tf});
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
   if(userID && userName.length)
   {
      _loc5_ = new XML();
      _loc6_ = _loc5_.createElement("u");
      _loc6_.attributes.i = userID;
      _loc6_.attributes.un = userName;
      _loc6_.attributes.ti = teamID;
      _global.chatObj.userListXML.firstChild.appendChild(_loc6_);
      drawUserList();
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
   var _loc6_ = 20;
   var _loc7_ = queueXML.firstChild.childNodes.length;
   var _loc8_ = 7;
   if(container.linkName == "raceAnnounce" || container.linkName == "racePlay")
   {
      raceInProgress = true;
   }
   if(!_loc7_)
   {
      queueGroup._visible = false;
   }
   else
   {
      queueGroup._visible = true;
   }
   _loc8_ = Math.min(_loc8_,_loc7_);
   var _loc9_ = undefined;
   var _loc10_ = undefined;
   var _loc11_ = undefined;
   var _loc12_ = undefined;
   var _loc13_ = undefined;
   var _loc14_ = undefined;
   var _loc15_ = undefined;
   var _loc16_ = undefined;
   if(!classes.RacePlay._MC.myLane)
   {
      _loc9_ = false;
      _loc10_ = new Array();
      var tID;
      for(var _loc17_ in queueGroup)
      {
         if(_loc17_.indexOf("queueItem") > -1)
         {
            _loc9_ = false;
            _loc11_ = 0;
            while(_loc11_ < _loc8_)
            {
               tID = queueXML.firstChild.childNodes[_loc11_].attributes.icid + "_" + queueXML.firstChild.childNodes[_loc11_].attributes.cicid;
               if(queueGroup[_loc17_].id == tID)
               {
                  _loc9_ = true;
                  _loc10_.push(tID);
                  break;
               }
               _loc11_ += 1;
            }
            if(!_loc9_)
            {
               queueGroup[_loc17_].removeMovieClip();
            }
         }
      }
      _loc11_ = 0;
      while(_loc11_ < _loc8_)
      {
         tID = queueXML.firstChild.childNodes[_loc11_].attributes.icid + "_" + queueXML.firstChild.childNodes[_loc11_].attributes.cicid;
         _loc9_ = false;
         _loc14_ = 0;
         while(_loc14_ < _loc10_.length)
         {
            if(_loc10_[_loc14_] == tID)
            {
               _loc9_ = true;
               break;
            }
            _loc14_ += 1;
         }
         if(!_loc9_)
         {
            _loc12_ = "";
            _loc13_ = "";
            _loc14_ = 0;
            while(_loc14_ < _loc5_.firstChild.childNodes.length)
            {
               if(queueXML.firstChild.childNodes[_loc11_].attributes.i == _loc5_.firstChild.childNodes[_loc14_].attributes.i)
               {
                  _loc12_ = _loc5_.firstChild.childNodes[_loc14_].attributes.un;
               }
               if(queueXML.firstChild.childNodes[_loc11_].attributes.ci == _loc5_.firstChild.childNodes[_loc14_].attributes.i)
               {
                  _loc13_ = _loc5_.firstChild.childNodes[_loc14_].attributes.un;
               }
               _loc14_ += 1;
            }
            _loc15_ = queueGroup.attachMovie("rivalsListItem","queueItem" + tID,queueGroup.getNextHighestDepth(),{id:tID,uID1:queueXML.firstChild.childNodes[_loc11_].attributes.i,userName1:_loc12_,carID1:queueXML.firstChild.childNodes[_loc11_].attributes.icid,uID2:queueXML.firstChild.childNodes[_loc11_].attributes.ci,carID2:queueXML.firstChild.childNodes[_loc11_].attributes.cicid,userName2:_loc13_});
            _loc15_.car1.onRelease = function()
            {
               classes.Control.focusViewer(this._parent.uID1,this._parent.carID1);
            };
            _loc15_.car2.onRelease = function()
            {
               classes.Control.focusViewer(this._parent.uID2,this._parent.carID2);
            };
            _loc16_ = function(d, carID)
            {
               var _loc3_ = 0;
               while(_loc3_ < queueXML.firstChild.childNodes.length)
               {
                  if(carID == queueXML.firstChild.childNodes[_loc3_].attributes.icid)
                  {
                     classes.Drawing.carView(queueGroup["queueItem" + tID].car1,new XML(d),24);
                     break;
                  }
                  if(carID == queueXML.firstChild.childNodes[_loc3_].attributes.cicid)
                  {
                     classes.Drawing.carView(queueGroup["queueItem" + tID].car2,new XML(d),24);
                     break;
                  }
                  _loc3_ += 1;
               }
            };
            classes.Lookup.addCallback("getRacersCars",this,_loc16_,String(queueXML.firstChild.childNodes[_loc11_].attributes.icid));
            classes.Lookup.addCallback("getRacersCars",this,_loc16_,String(queueXML.firstChild.childNodes[_loc11_].attributes.cicid));
            _root.getRacersCars(queueXML.firstChild.childNodes[_loc11_].attributes.icid + "," + queueXML.firstChild.childNodes[_loc11_].attributes.cicid);
         }
         queueGroup["queueItem" + tID]._y = _loc11_ * _loc6_;
         _loc11_ += 1;
      }
      if(_loc7_ > _loc8_)
      {
         queueGroup.txtTotal = "..." + _loc7_;
      }
      else
      {
         queueGroup.txtTotal = "";
      }
   }
}
function updateQueue(d, remove)
{
   var _loc4_ = new XML(d);
   var _loc5_ = _loc4_.firstChild.attributes.icid;
   var _loc6_ = _loc4_.firstChild.attributes.cicid;
   if(remove)
   {
      removeQueueNode(_loc5_,_loc6_);
   }
   else
   {
      _global.chatObj.queueXML.firstChild.appendChild(_loc4_.firstChild);
   }
   drawQueue();
}
function removeQueueNode(car1ID, car2ID)
{
   var _loc4_ = 0;
   while(_loc4_ < _global.chatObj.queueXML.firstChild.childNodes.length)
   {
      if(_global.chatObj.queueXML.firstChild.childNodes[_loc4_].attributes.icid == car1ID && _global.chatObj.queueXML.firstChild.childNodes[_loc4_].attributes.cicid == car2ID)
      {
         _global.chatObj.queueXML.firstChild.childNodes[_loc4_].removeNode();
         break;
      }
      _loc4_ += 1;
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
      bottomStatic.bmp.draw(panelOut,new flash.geom.Matrix(1,0,0,1,panelOut._x,panelOut._y - btmBG._y),_loc4_,"normal");
      bottomStatic.bmp.draw(panelIn,new flash.geom.Matrix(1,0,0,1,panelIn._x,panelIn._y - btmBG._y),_loc4_,"normal");
      bottomStatic.attachBitmap(bottomStatic.bmp,1);
   }
   btmBG._visible = isVisible;
   userListGroup._visible = isVisible;
   chatWindow._visible = isVisible;
   queueGroup._visible = isVisible;
   usersBG._visible = isVisible;
   panelOut._visible = isVisible;
   panelIn._visible = isVisible;
   userListHeads._visible = isVisible;
}
function showChallengerNew(showSecond)
{
   _root.abc.closeMe();
   _root.attachMovie("dialogContainer","abc",_root.getNextHighestDepth(),{contentName:"dialogRivalNewContent"});
   _root.abc.dialog = "dialogRivalNew";
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
      _root.chatRIVLeave();
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
   if(_root.abc.dialog == "dialogRivalNew")
   {
      _root.abc.dialog = "dialogRivalNew";
      with(_root.abc.contentMC)
      {
         btnStage.btnLabel.text = "Stage Up";
         btnStage.onRelease = function()
         {
            clearInterval(this._parent.timer.countSI);
            _root.raceRIVOK();
            this._parent._parent.closeMe();
         };
         btnChicken._visible = true;
         txtMsg = "This is your last chance to back out of this race without penalty.  Stage Up to continue or Chicken Out!";
      }
      onTimeOut = function()
      {
         _global.chatObj.raceRoomMC.showTimedOut();
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
function showChickenOut()
{
   _root.abc.closeMe();
   _root.attachMovie("dialogContainer","abc",_root.getNextHighestDepth(),{contentName:"dialogChickenOutContent"});
   _root.abc.addButton("OK");
   optimizeBottom(true);
}
function showTimedOut()
{
   _root.abc.closeMe();
   _root.attachMovie("dialogContainer","abc",_root.getNextHighestDepth(),{contentName:"dialogTimedOutContent"});
   _root.abc.addButton("OK");
   optimizeBottom(true);
}
function showContainer(linkName, type)
{
   this.container.removeMovieClip();
   var _loc5_ = undefined;
   if(linkName.length)
   {
      this.attachMovie(linkName,"container",this.getNextHighestDepth(),{linkName:linkName,type:type});
   }
   else
   {
      _loc5_ = Number(_global.chatObj.raceObj.bt);
      if(_loc5_ == -1)
      {
         type = "pinks";
      }
      else if(_loc5_ > 0)
      {
         type = "money";
      }
      else
      {
         type = "friendly";
      }
      this.attachMovie("raceAnnounce","container",this.getNextHighestDepth(),{linkName:"raceAnnounce",type:type});
   }
   if(containerMask == undefined)
   {
      this.createEmptyMovieClip("containerMask",this.getNextHighestDepth());
      classes.Drawing.rect(containerMask,800,344,0,0);
   }
   container._x = 0;
   container._y = 0;
   container.setMask(containerMask);
   container.swapDepths(panelOut);
   panelIn.swapDepths(this.getNextHighestDepth());
}
function CB_listUsers()
{
   var _loc4_ = new Array();
   var _loc5_ = new Array();
   var _loc6_ = undefined;
   var _loc7_ = 0;
   while(_loc7_ < _global.chatObj.userListXML.firstChild.childNodes.length)
   {
      _loc6_ = Number(_global.chatObj.userListXML.firstChild.childNodes[_loc7_].attributes.ti);
      if(_loc6_)
      {
         _loc4_.push(_loc6_);
      }
      _loc7_ += 1;
   }
   var _loc8_ = undefined;
   var _loc9_ = undefined;
   var _loc10_ = undefined;
   var _loc11_ = undefined;
   var _loc12_ = undefined;
   var _loc13_ = undefined;
   if(_loc4_.length)
   {
      _loc4_.sort();
      _loc8_ = new Array();
      _loc7_ = 0;
      while(_loc7_ < _global.chatObj.teamsXML.firstChild.childNodes.length)
      {
         _loc8_.push(_global.chatObj.teamsXML.firstChild.childNodes[_loc7_].attributes.i);
         _loc7_ += 1;
      }
      _loc7_ = 0;
      while(_loc7_ < _loc4_.length)
      {
         if(!_loc9_ || _loc5_[_loc5_.length - 1] != _loc9_)
         {
            _loc5_.push(_loc4_[_loc7_]);
         }
         _loc9_ = _loc4_[_loc7_];
         _loc7_ += 1;
      }
      _loc11_ = _loc5_.length - 1;
      _loc7_ = _loc11_;
      while(_loc7_ >= 0)
      {
         _loc10_ = false;
         _loc12_ = 0;
         while(_loc12_ < _loc8_.length)
         {
            if(_loc5_[_loc7_] == _loc8_[_loc12_])
            {
               _loc10_ = true;
            }
            _loc12_ += 1;
         }
         if(_loc10_)
         {
            _loc5_.splice(_loc7_,1);
         }
         _loc7_ -= 1;
      }
      if(_loc5_.length)
      {
         _loc13_ = function(d)
         {
            _global.chatObj.teamXML = new XML(d);
            checkForData();
         };
         delete _global.chatObj.teamXML;
         classes.Lookup.addCallback("teamInfo",this,_loc13_,"");
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
   var _loc5_ = new XML(xmlStr);
   _global.chatObj.raceObj.lastResultsXML = _loc5_;
   _global.chatObj.raceObj.r1Obj.h = _loc5_.firstChild.attributes.h1;
   _global.chatObj.raceObj.r2Obj.h = _loc5_.firstChild.attributes.h2;
   if(_loc5_.firstChild.attributes.wid == "-2")
   {
      container.wid = -2;
      container.racer1Obj.RT = "FOUL";
      container.racer2Obj.RT = "FOUL";
      container.victor = 0;
   }
   else
   {
      container.wid = _loc5_.firstChild.attributes.wid;
      container.racer1Obj.RT = _loc5_.firstChild.attributes.rt1;
      container.racer2Obj.RT = _loc5_.firstChild.attributes.rt2;
      if(_loc5_.firstChild.attributes.wid == container.racer1Obj.id)
      {
         container.victor = 1;
      }
      else if(_loc5_.firstChild.attributes.wid == container.racer2Obj.id)
      {
         container.victor = -1;
      }
      else
      {
         container.victor = 0;
      }
   }
   container.racer1Obj.ET = _loc5_.firstChild.attributes.et1;
   container.racer1Obj.TS = _loc5_.firstChild.attributes.ts1;
   container.racer2Obj.ET = _loc5_.firstChild.attributes.et2;
   container.racer2Obj.TS = _loc5_.firstChild.attributes.ts2;
   container.racer1Obj.scc = _loc5_.firstChild.attributes.c1;
   container.racer2Obj.scc = _loc5_.firstChild.attributes.c2;
   container.racer1Obj.sc = Number(container.racer1Obj.sc) + Number(_loc5_.firstChild.attributes.c1);
   container.racer2Obj.sc = Number(container.racer2Obj.sc) + Number(_loc5_.firstChild.attributes.c2);
   if(classes.GlobalData.id == _loc5_.firstChild.attributes.r1id)
   {
      classes.GlobalData.updateInfo("sc",container.racer1Obj.sc);
      classes.GlobalData.updateInfo("m",Number(classes.GlobalData.attr.m) + Number(_loc5_.firstChild.attributes.m1));
      if(_global.chatObj.raceObj.bt == -1)
      {
         _root.getCars();
      }
   }
   else if(classes.GlobalData.id == _loc5_.firstChild.attributes.r2id)
   {
      classes.GlobalData.updateInfo("sc",container.racer2Obj.sc);
      classes.GlobalData.updateInfo("m",Number(classes.GlobalData.attr.m) + Number(_loc5_.firstChild.attributes.m2));
      if(_global.chatObj.raceObj.bt == -1)
      {
         _root.getCars();
      }
   }
   classes.Chat.enableWindow();
   optimizeBottom(true);
   classes.Control.setMapButton("race");
   if(classes.GlobalData.id == _loc5_.firstChild.attributes.r1id || classes.GlobalData.id == _loc5_.firstChild.attributes.r2id)
   {
      container.showFinish();
   }
   else
   {
      _global.setTimeout(this,"doShowFinish",5000);
   }
}
function doShowFinish()
{
   container.showFinish(3000);
}
function showWaiting()
{
   showContainer("waitRivals");
}
var bottomStatic;
