function checkForData()
{
   trace("checkForData");
   if(_global.chatObj.userListXML != undefined && _global.chatObj.teamXML != undefined && _global.chatObj.queueXML != undefined)
   {
      trace("checked OK");
      userListXML = _global.chatObj.userListXML;
      teamXML = _global.chatObj.teamXML;
      queueXML = _global.chatObj.queueXML;
      createUserList();
      drawQueue();
      classes.Chat.createWindow(chatWindow,_global.newRoomName);
      if(container == undefined)
      {
         if(_global.chatObj.raceObj.inp)
         {
            delete _global.chatObj.raceObj.inp;
            startChallenge();
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
      k = 0;
      while(k < _global.chatObj.queueXML.firstChild.childNodes[_loc3_].childNodes.length)
      {
         if(uid == _global.chatObj.queueXML.firstChild.childNodes[_loc3_].childNodes[k].attributes.ai1 || uid === _global.chatObj.queueXML.firstChild.childNodes[_loc3_].childNodes[k].attributes.ai2)
         {
            _global.chatObj.queueXML.firstChild.childNodes[_loc3_].removeNode();
            break;
         }
         k++;
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
   trace("drawUserList");
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
   var _loc16_ = undefined;
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
         _loc13_.cacheAsBitmap = true;
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
            _loc16_ = userListGroup.scrollContent.attachMovie("teamListItem","team" + _loc9_,userListGroup.scrollContent.getNextHighestDepth(),{_x:40,teamID:_loc9_,teamName:_loc10_});
            classes.Drawing.portrait(_loc16_,0,2,0,0,4);
            _loc8_ = _loc16_.photo;
            _loc8_._xscale = 25;
            _loc8_._yscale = 25;
            _loc16_.cacheAsBitmap = true;
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
   trace("drawQueue");
   var _loc3_ = _global.chatObj.queueXML;
   var _loc4_ = _global.chatObj.userListXML;
   var _loc5_ = 53;
   var _loc6_ = _loc3_.firstChild.childNodes.length;
   var _loc7_ = 3;
   if(container.linkName == "raceAnnounce" || container.linkName == "racePlay")
   {
      raceInProgress = true;
   }
   if(!_loc6_)
   {
      queueGroup._visible = false;
   }
   else
   {
      queueGroup._visible = true;
   }
   _loc7_ = Math.min(_loc7_,_loc6_);
   var _loc8_ = undefined;
   var _loc9_ = undefined;
   var _loc10_ = undefined;
   var _loc11_ = undefined;
   var _loc12_ = undefined;
   var _loc13_ = undefined;
   var _loc14_ = undefined;
   var _loc15_ = undefined;
   if(!classes.RacePlay._MC.myLane)
   {
      _loc8_ = false;
      _loc9_ = new Array();
      for(var _loc16_ in queueGroup)
      {
         if(_loc16_.indexOf("queueItem") > -1)
         {
            _loc8_ = false;
            _loc11_ = 0;
            while(_loc11_ < _loc7_)
            {
               _loc10_ = _loc3_.firstChild.childNodes[_loc11_].attributes.id;
               if(queueGroup[_loc16_].id == _loc10_)
               {
                  _loc8_ = true;
                  _loc9_.push(_loc10_);
                  break;
               }
               _loc11_ += 1;
            }
            if(!_loc8_)
            {
               queueGroup[_loc16_].removeMovieClip();
            }
         }
      }
      _loc11_ = 0;
      while(_loc11_ < _loc7_)
      {
         _loc10_ = _loc3_.firstChild.childNodes[_loc11_].attributes.id;
         _loc8_ = false;
         _loc14_ = 0;
         while(_loc14_ < _loc9_.length)
         {
            if(_loc9_[_loc14_] == _loc10_)
            {
               _loc8_ = true;
               break;
            }
            _loc14_ += 1;
         }
         if(!_loc8_)
         {
            trace("ADD TO QUEUE: " + _loc10_);
            _loc12_ = _loc3_.firstChild.childNodes[_loc11_].attributes.ti1;
            _loc13_ = _loc3_.firstChild.childNodes[_loc11_].attributes.ti2;
            _loc15_ = queueGroup.attachMovie("teamRiv_queueItem","queueItem" + _loc10_,queueGroup.getNextHighestDepth(),{id:_loc10_,ti1:_loc12_,teamName1:lookupTeamName(_loc12_),ti2:_loc13_,teamName2:lookupTeamName(_loc13_),count:_loc3_.firstChild.childNodes[_loc11_].childNodes.length});
            _loc15_.createEmptyMovieClip("pic1",_loc15_.getNextHighestDepth());
            _loc15_.pic1._x = 113;
            _loc15_.pic1._xscale = _loc15_.pic1._yscale = 25;
            _loc15_.createEmptyMovieClip("pic2",_loc15_.getNextHighestDepth());
            _loc15_.pic2._y = 24;
            _loc15_.pic2._xscale = _loc15_.pic2._yscale = 25;
            classes.Drawing.portrait(_loc15_.pic1,_loc12_,2,0,0,4,false,"teamavatars");
            classes.Drawing.portrait(_loc15_.pic2,_loc13_,2,0,0,4,false,"teamavatars");
            _loc15_.cacheAsBitmap = true;
         }
         queueGroup["queueItem" + _loc10_]._y = _loc11_ * _loc5_;
         _loc11_ += 1;
      }
      if(_loc6_ > _loc7_)
      {
         fldMoreCount.text = "..." + _loc6_;
      }
      else
      {
         fldMoreCount.text = "";
      }
   }
}
function updateQueue(d, remove)
{
   var _loc4_ = new XML();
   _loc4_.ignoreWhite = true;
   _loc4_.parseXML(d);
   if(remove)
   {
      removeQueueNode(_loc4_.firstChild.attributes.id);
   }
   else
   {
      _global.chatObj.queueXML.firstChild.appendChild(_loc4_.firstChild);
   }
   drawQueue();
}
function removeQueueNode(id)
{
   var _loc3_ = 0;
   while(_loc3_ < _global.chatObj.queueXML.firstChild.childNodes.length)
   {
      if(_global.chatObj.queueXML.firstChild.childNodes[_loc3_].attributes.id == id)
      {
         _global.chatObj.queueXML.firstChild.childNodes[_loc3_].removeNode();
         break;
      }
      _loc3_ += 1;
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
   usersBG._visible = isVisible;
   userListHeads._visible = isVisible;
   userListGroup._visible = isVisible;
   chatWindow._visible = isVisible;
   queueGroup._visible = isVisible;
   panelOut._visible = isVisible;
   panelIn._visible = isVisible;
}
function showChallengerNew(showSecond, isBracket)
{
   trace("TEAM showChallengerNew:: isbrkt: " + isBracket);
   _root.abc.closeMe();
   _root.attachMovie("dialogContainer","abc",_root.getNextHighestDepth(),{contentName:"dialogRivalNewContent",txtMsg:"It\'s time to get on the track and represent your team.  Stage Up to continue or Chicken Out!",txtHead:"Your race is up next!",isBracket:isBracket});
   _root.abc.dialog = "dialogRivalNew";
   var _loc5_ = undefined;
   var _loc6_ = 0;
   while(_loc6_ < _global.chatObj.challengeXML.firstChild.childNodes.length)
   {
      _loc5_ = _global.chatObj.challengeXML.firstChild.childNodes[_loc6_].attributes;
      if(classes.GlobalData.id == _loc5_.ai1)
      {
         classes.GlobalData.setMyRaceCarNode(Number(_loc5_.aci1));
         break;
      }
      if(classes.GlobalData.id == _loc5_.ai2)
      {
         classes.GlobalData.setMyRaceCarNode(Number(_loc5_.aci2));
         break;
      }
      _loc6_ = _loc6_ + 1;
   }
   classes.ClipFuncs.newClip(_root.abc.contentMC,"viewLogo",24,158,50);
   classes.Drawing.carLogo(_root.abc.contentMC.viewLogo,_global.chatObj.myRaceCarNode.attributes.ci);
   classes.ClipFuncs.newClip(_root.abc.contentMC,"viewThumb",250,132);
   classes.Drawing.carView(_root.abc.contentMC.viewThumb,new XML(_global.chatObj.myRaceCarNode.toString()),28,"front");
   classes.ClipFuncs.newClip(_root.abc.contentMC,"viewPlate",27,193);
   classes.Drawing.plateView(_root.abc.contentMC.viewPlate,Number(_global.chatObj.myRaceCarNode.attributes.pi),_global.chatObj.myRaceCarNode.attributes.pn,30,true);
   _root.abc.contentMC.isBracket = isBracket;
   with(_root.abc.contentMC)
   {
      btnStage.btnLabel.text = "Stage Up";
      btnStage.onRelease = function()
      {
         if(this._parent.isBracket && !Number(this._parent.dialInGroup.txtDialIn))
         {
            this._parent.txtDialError = "Invalid dial-in";
         }
         else
         {
            _root.teamRivalsOK(this._parent.dialInGroup.txtDialIn);
            this.enabled = false;
            this._parent.btnChicken.enabled = false;
         }
      };
      btnChicken.btnLabel.text = "Chicken Out";
      btnChicken.onRelease = function()
      {
         clearInterval(this._parent.timer.countSI);
         this._parent._parent.closeMe();
      };
   }
   onTimeOut = function()
   {
      trace("TEAM onTimeOut");
      _root.abc.contentMC.btnChicken.enabled = false;
      _root.abc.contentMC.btnStage.enabled = false;
   };
   var _loc7_ = 2;
   if(_global.chatObj.newRaceTS)
   {
      _loc7_ += Math.ceil((new Date() - _global.chatObj.newRaceTS) / 1000);
   }
   _root.abc.addTimer(_global.chatObj.raceObj.timeToRespond - _loc7_,onTimeOut);
}
function showChallengerNew2()
{
   trace("showChallengerNew2 (do nothing in Team... why is this firing?)");
}
function showCanceledOut()
{
   _root.abc.closeMe();
   _root.attachMovie("dialogContainer","abc",_root.getNextHighestDepth(),{contentName:"dialogTimedOutContent",txtTitle:"Challenge Canceled",txt:"One of the racers chickened out!  This team challenge is canceled."});
   _root.abc.addButton("OK");
   optimizeBottom(true);
   showWaiting();
}
function showTimedOut()
{
   _root.abc.closeMe();
   _root.attachMovie("dialogContainer","abc",_root.getNextHighestDepth(),{contentName:"dialogTimedOutContent",txt:"One or more of the racers backed out!  This team challenge is canceled."});
   _root.abc.addButton("OK");
   optimizeBottom(true);
}
function showContainer(linkName, tobj)
{
   trace("showContainer: " + linkName);
   this.container.removeMovieClip();
   if(tobj == undefined)
   {
      tobj = new Object();
   }
   tobj.linkName = linkName;
   if(linkName.length)
   {
      this.attachMovie(linkName,"container",this.getNextHighestDepth(),tobj);
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
function onRaceResults(d)
{
   trace("onRaceResults [" + new Date().getTime() + "]");
   if(_global.chatObj.raceObj.isRacer)
   {
      trace("...onRaceResults - isracer");
      do_onRaceResults(d);
   }
   else
   {
      trace("...onRaceResults - notracer");
      _global.setTimeout(this,"do_onRaceResults",6000,d);
   }
}
function do_onRaceResults(d)
{
   trace("do_onRaceResults [" + new Date().getTime() + "]");
   var _loc3_ = new XML(d);
   _global.chatObj.challengeXML.firstChild.attributes.td = Number(_loc3_.firstChild.attributes.td);
   _global.chatObj.viewMC.racer1Obj.h = _loc3_.firstChild.attributes.h1;
   _global.chatObj.viewMC.racer2Obj.h = _loc3_.firstChild.attributes.h2;
   if(_loc3_.firstChild.attributes.wid == "-2")
   {
      _global.chatObj.viewMC.wid = -2;
      _global.chatObj.viewMC.racer1Obj.RT = "FOUL";
      _global.chatObj.viewMC.racer2Obj.RT = "FOUL";
      _global.chatObj.viewMC.victor = 0;
   }
   else
   {
      _global.chatObj.viewMC.wid = _loc3_.firstChild.attributes.wid;
      _global.chatObj.viewMC.racer1Obj.RT = _loc3_.firstChild.attributes.rt1;
      _global.chatObj.viewMC.racer2Obj.RT = _loc3_.firstChild.attributes.rt2;
      if(_loc3_.firstChild.attributes.wid == _global.chatObj.viewMC.racer1Obj.id)
      {
         _global.chatObj.viewMC.victor = 1;
      }
      else if(_loc3_.firstChild.attributes.wid == _global.chatObj.viewMC.racer2Obj.id)
      {
         _global.chatObj.viewMC.victor = -1;
      }
      else
      {
         _global.chatObj.viewMC.victor = 0;
      }
   }
   _global.chatObj.viewMC.racer1Obj.ET = _loc3_.firstChild.attributes.et1;
   _global.chatObj.viewMC.racer1Obj.TS = _loc3_.firstChild.attributes.ts1;
   _global.chatObj.viewMC.racer2Obj.ET = _loc3_.firstChild.attributes.et2;
   _global.chatObj.viewMC.racer2Obj.TS = _loc3_.firstChild.attributes.ts2;
   _global.chatObj.viewMC.racer1Obj.tt = Number(_loc3_.firstChild.attributes.tt1);
   _global.chatObj.viewMC.racer2Obj.tt = Number(_loc3_.firstChild.attributes.tt2);
   _global.chatObj.viewMC.matchTD = Number(_loc3_.firstChild.attributes.td);
   _global.chatObj.viewMC.runningTimeDiff = Number(_loc3_.firstChild.attributes.td);
   _global.chatObj.viewMC.racer1Obj.scc = 0;
   _global.chatObj.viewMC.racer2Obj.scc = 0;
   _global.chatObj.viewMC.racer1Obj.sc = Number(_global.chatObj.raceObj.r1Obj.sc);
   _global.chatObj.viewMC.racer2Obj.sc = Number(_global.chatObj.raceObj.r2Obj.sc);
   if(_global.chatObj.raceObj.isRacer)
   {
      _global.chatObj.viewMC.showFinish(2000);
   }
   else
   {
      _global.chatObj.viewMC.showFinish(3000);
   }
}
function setRacerOK(d)
{
   var _loc3_ = new XML(d);
   var _loc4_ = undefined;
   if(container.linkName == "teamRivAnnounce")
   {
      _loc4_ = 1;
      while(_loc4_ <= 2)
      {
         j = 1;
         while(j <= 4)
         {
            if(container["team" + _loc4_ + "Pos" + j].accountID && container["team" + _loc4_ + "Pos" + j].accountID == _loc3_.firstChild.attributes.i)
            {
               _global.chatObj.challengeXML.firstChild.childNodes[j - 1].attributes["bt" + _loc4_] = _loc3_.firstChild.attributes.bt;
               container["team" + _loc4_ + "Pos" + j].statusBulb.gotoAndStop(2);
               if(Number(_loc3_.firstChild.attributes.bt))
               {
                  container["team" + _loc4_ + "Pos" + j].dialIn = "Dial In: " + classes.NumFuncs.zeroFill(Number(_loc3_.firstChild.attributes.bt),3);
               }
               container["team" + _loc4_ + "Car" + j].fadeUp();
            }
            j++;
         }
         _loc4_ += 1;
      }
   }
}
function startChallenge()
{
   showContainer("racePlay");
}
function showWaiting()
{
   showContainer("waitTeamRivals");
}
var bottomStatic;
