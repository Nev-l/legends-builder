function setupDetailLeft()
{
   detailLeft.hwidth = 132;
   var _loc2_ = new Date(Number(detailObj.d) * 1000);
   detailLeft.fldDay.text = classes.NumFuncs.dayName(_loc2_.getDay()).toUpperCase();
   detailLeft.fldDate.text = _loc2_.getDate();
   detailLeft.fldTime.text = detailObj.tstr;
   detailLeft.onEnterFrame = function()
   {
      this.fldDay._xscale = 100 * this.hwidth / this.fldDay._width;
      this.fldTime._xscale = 100 * this.hwidth / this.fldTime._width;
      delete this.onEnterFrame;
   };
}
function setCountdownTime()
{
   var _loc2_ = undefined;
   var _loc3_ = undefined;
   var _loc4_ = undefined;
   var _loc5_ = undefined;
   if(Number(detailObj.de))
   {
      _loc2_ = Number(detailObj.de) * 1000 - (Number(new Date()) + classes.GlobalData.serverTimeOffset);
      if(_loc2_ > 0)
      {
         _loc3_ = classes.NumFuncs.get2Mins(Math.floor(_loc2_ / 60000)) + ":";
         _loc3_ += classes.NumFuncs.get2Mins(Math.floor(_loc2_ % 60000 / 1000)) + ".";
         _loc4_ = String(_loc2_ % 1000).substr(0,2);
         if(_loc4_.length == 1)
         {
            _loc4_ = "0" + _loc4_;
         }
         _loc3_ += _loc4_;
         countdownGroup.fldTimeLeft.text = _loc3_;
         _loc3_ = null;
      }
      else if(_loc2_ > -60000)
      {
         if(!countdownGroup.postQualFlag)
         {
            countdownGroup.postQualFlag = true;
            countdownGroup.txtHead = "WAITING FOR FINAL RUNS:";
         }
         if(!qualFlag && !spectateFlag)
         {
            qualFlag = true;
            _root.htQualifyOK(detailObj.i);
         }
         _loc5_ = _loc2_ + 60000;
         _loc3_ = classes.NumFuncs.get2Mins(Math.floor(_loc5_ / 60000)) + ":";
         _loc3_ += classes.NumFuncs.get2Mins(Math.floor(_loc5_ % 60000 / 1000)) + ".";
         _loc4_ = String(_loc5_ % 1000).substr(0,2);
         if(_loc4_.length == 1)
         {
            _loc4_ = "0" + _loc4_;
         }
         _loc3_ += _loc4_;
         countdownGroup.fldTimeLeft.text = _loc3_;
         _loc3_ = null;
      }
      else
      {
         countdownGroup.txtHead = "QUALIFYING ROUND OVER.";
         countdownGroup.fldTimeLeft.text = "00:00.00";
         if(qualFlag)
         {
            fldPrepMsg.text = prepMsg;
            btnSpectate.onRelease();
         }
         delete countdownGroup.onEnterFrame;
      }
   }
   else
   {
      countdownGroup.fldTimeLeft.text = " OPEN";
      delete countdownGroup.onEnterFrame;
   }
}
function processTop32(d)
{
   leadersXML = new XML();
   leadersXML.ignoreWhite = true;
   leadersXML.parseXML(d);
   if(spectateFlag)
   {
      createLeaderboard();
   }
   else
   {
      gotoAndStop("leaders");
      play();
   }
}
function initRoom()
{
   _global.chatObj.raceRoomMC = this;
   _global.chatObj.raceObj = new Object();
   roundsArr = new Array();
   tourneyType = "tourneyL";
   delete htLeadersArr;
   playerRank = 0;
   currentMatch = 0;
   tourneyID = _global.sectionTrackMC.tourneyID;
}
function createLeaderboard()
{
   trace("createLeaderboard");
   leadersNodes = leadersXML.firstChild.childNodes;
   rankingBoardGroup.rankingBoardMC.removeMovieClip();
   scrollerObj.destroy();
   rankingBoardMC = rankingBoardGroup.createEmptyMovieClip("rankingBoardMC",1);
   if(raceRoomInitFlag)
   {
      scrollerObj = new controls.ScrollPane(rankingBoardMC,327,216,null,null,315);
   }
   else
   {
      scrollerObj = new controls.ScrollPane(rankingBoardMC,327,323,null,null,315);
   }
   var i = 0;
   while(i < leadersNodes.length)
   {
      with(rankingBoardMC)
      {
         var tattr = leadersNodes[i].attributes;
         var tmpRank = rankingBoardMC.attachMovie("tournamentRankItemBracket","rank" + tattr.i,rankingBoardMC.getNextHighestDepth());
         tmpRank.aid = Number(tattr.i);
         tmpRank.username.text = tattr.u;
         tmpRank.rt.text = classes.NumFuncs.zeroFill(Number(tattr.rt),3);
         tmpRank.rtVal = Number(tattr.rt);
         tmpRank.et.text = classes.NumFuncs.zeroFill(Number(tattr.et),3);
         if(Number(detailObj.b))
         {
            tmpRank.bt.text = classes.NumFuncs.zeroFill(Number(tattr.bt),3);
         }
         else
         {
            tmpRank.diff._x = tmpRank.bt._x;
         }
         tmpRank.total = Number(tattr.rt) + Number(tattr.et) - Number(tattr.bt);
         sortRankingBoard();
      }
      i++;
   }
}
function addLeader(d)
{
   var _loc2_ = new XML(d);
   leadersXML.firstChild.appendChild(_loc2_.firstChild.firstChild);
   if(qualFlag && qualStatus == undefined)
   {
      return undefined;
   }
   var _loc3_ = leadersXML.firstChild.lastChild.attributes;
   var _loc4_ = rankingBoardMC.attachMovie("tournamentRankItemBracket","rank" + _loc3_.i,rankingBoardMC.getNextHighestDepth());
   _loc4_.aid = Number(_loc3_.i);
   _loc4_.username.text = _loc3_.u;
   _loc4_.rt.text = classes.NumFuncs.zeroFill(Number(_loc3_.rt),3);
   _loc4_.rtVal = Number(_loc3_.rt);
   _loc4_.et.text = classes.NumFuncs.zeroFill(Number(_loc3_.et),3);
   if(Number(detailObj.b))
   {
      _loc4_.bt.text = classes.NumFuncs.zeroFill(Number(_loc3_.bt),3);
   }
   else
   {
      _loc4_.diff._x = _loc4_.bt._x;
   }
   _loc4_.total = Number(_loc3_.rt) + Number(_loc3_.et) - Number(_loc3_.bt);
   sortRankingBoard();
}
function removeLeader(aid)
{
   if(qualFlag && qualStatus == undefined)
   {
      return undefined;
   }
   for(var _loc2_ in rankingBoardMC)
   {
      if(rankingBoardMC[_loc2_].aid == aid)
      {
         rankingBoardMC[_loc2_].removeMovieClip();
      }
   }
   sortRankingBoard();
   if(aid == classes.GlobalData.id)
   {
      gotoAndStop("prelimsOut");
      play();
   }
}
function sortRankingBoard()
{
   var _loc2_ = new Array();
   var _loc3_ = 0;
   for(§each§ in rankingBoardMC)
   {
      if(typeof rankingBoardMC[eval("each")] == "movieclip")
      {
         if(_loc3_)
         {
            _loc3_ = Math.min(_loc3_,rankingBoardMC[eval("each")].total);
         }
         else
         {
            _loc3_ = rankingBoardMC[eval("each")].total;
         }
         _loc2_.push({total:rankingBoardMC[eval("each")].total,rt:rankingBoardMC[eval("each")].rtVal,n:rankingBoardMC[eval("each")].username.text,mc:rankingBoardMC[eval("each")]});
      }
   }
   _loc2_.sortOn(["total","rt","n"],[Array.NUMERIC,Array.NUMERIC,Array.NUMERIC]);
   var _loc1_;
   if(Number(detailObj.b))
   {
      _loc1_ = 0;
      while(_loc1_ < _loc2_.length)
      {
         _loc2_[_loc1_].d = _loc2_[_loc1_].total - 0.5;
         _loc1_ += 1;
      }
   }
   else
   {
      _loc1_ = 0;
      while(_loc1_ < _loc2_.length)
      {
         _loc2_[_loc1_].d = _loc2_[_loc1_].total - _loc3_;
         _loc1_ += 1;
      }
   }
   _loc1_ = 0;
   while(_loc1_ < _loc2_.length)
   {
      _loc2_[_loc1_].mc.diff.text = "+" + classes.NumFuncs.zeroFill(_loc2_[_loc1_].d,3);
      _loc2_[_loc1_].mc.rank.text = String(_loc1_ + 1) + ".";
      _loc2_[_loc1_].mc.curRank = _loc1_ + 1;
      _loc2_[_loc1_].mc._y = _loc1_ * 16;
      _loc2_[_loc1_].mc.gotoAndStop(_loc1_ % 2 + 1);
      _loc1_ += 1;
   }
   scrollerObj.refreshScroller();
   showMyRank();
}
function showMyRank()
{
   var _loc1_ = 0;
   for(§each§ in rankingBoardMC)
   {
      if(rankingBoardMC[eval("each")].aid == classes.GlobalData.id)
      {
         _loc1_ = rankingBoardMC[eval("each")].curRank;
      }
   }
   if(_loc1_)
   {
      timesGroup.rankGroup.txtRank = _loc1_;
      if(Math.floor(_loc1_ / 10) == 1)
      {
         timesGroup.rankGroup.txtExt = "TH";
      }
      else if(_loc1_ % 10 == 1)
      {
         timesGroup.rankGroup.txtExt = "ST";
      }
      else if(_loc1_ % 10 == 2)
      {
         timesGroup.rankGroup.txtExt = "ND";
      }
      else if(_loc1_ % 10 == 3)
      {
         timesGroup.rankGroup.txtExt = "RD";
      }
      else
      {
         timesGroup.rankGroup.txtExt = "TH";
      }
   }
   else
   {
      timesGroup.rankGroup.txtRank = "--";
      timesGroup.rankGroup.txtExt = "";
   }
}
function clearLeaderboard()
{
   rankingBoardGroup.rankingBoardMC.removeMovieClip();
   scrollerObj.destroy();
}
function finishQual(s, et, ts, carChanged)
{
   container.crossWire(classes.GlobalData.id,et,ts);
   qualStatus = s;
   qualRT = Number(classes.RacePlay._MC.racer1Obj.RT);
   qualET = et;
   optimizeBottom(true);
   _global.setTimeout(this,"goPrelims",4000,carChanged);
}
function goPrelims(carChanged)
{
   _root.raceSound.stopSound();
   container.removeMovieClip();
   clearLeaderboard();
   countdownGroup.removeMovieClip();
   loadinBG.removeMovieClip();
   if(carChanged)
   {
      classes.Lookup.addCallback("getOneCar",this,CB_updateCarChange,String(selCarID));
      _root.getOneCar(selCarID);
   }
   gotoAndStop("restart");
   play();
}
function CB_updateCarChange(pxml)
{
   trace("CB_updateCarChange...");
   trace(pxml.toString());
   classes.GlobalData.replaceCarNode(pxml.toString());
}
function displayTimes()
{
   if(qualRT > 0 && qualET > 0)
   {
      timesGroup.txt = classes.NumFuncs.zeroFill(qualRT,3) + "\r" + classes.NumFuncs.zeroFill(qualET,3);
   }
   else
   {
      timesGroup.txt = "FOUL\r--";
   }
   timesGroup.txtCont = "";
}
function startRaceRoom(d)
{
   matchTreeXML = new XML();
   matchTreeXML.ignoreWhite = true;
   matchTreeXML.parseXML(d);
   var _loc3_ = undefined;
   var _loc4_ = 0;
   while(_loc4_ < matchTreeXML.firstChild.firstChild.childNodes.length)
   {
      if(matchTreeXML.firstChild.firstChild.childNodes[_loc4_].childNodes[0].attributes.i == classes.GlobalData.id || matchTreeXML.firstChild.firstChild.childNodes[_loc4_].childNodes[1].attributes.i == classes.GlobalData.id)
      {
         _loc3_ = true;
         break;
      }
      _loc4_ += 1;
   }
   if(spectateFlag)
   {
      txtRankTitle = "";
      txtRankHead = "";
      countdownGroup._visible = false;
      countdownGroup.removeMovieClip();
      rankingBoardGroup.removeMovieClip();
      createChart();
      if(!raceRoomFlag)
      {
         loadRaceBG();
      }
      else
      {
         this.showContainer("raceTourneyIntro",tourneyType);
      }
   }
   else if(_loc3_)
   {
      gotoAndStop("raceRoom");
      play();
   }
   else
   {
      gotoAndStop("prelimsOut");
      play();
   }
}
function CB_listUsers()
{
   userListXML = _global.chatObj.userListXML;
   createUserList();
   classes.Chat.createWindow(chatWindow,_global.newRoomName);
   if(!raceRoomFlag)
   {
      loadRaceBG();
   }
}
function loadRaceBG()
{
   var loadListener = new Object();
   loadListener.onLoadComplete = function(target_mc)
   {
      gotoAndStop("raceRoomCont");
      play();
      delete loadListener;
   };
   loadListener.onLoadError = function()
   {
      gotoAndStop("raceRoomCont");
      play();
      delete loadListener;
   };
   var _loc1_ = new MovieClipLoader();
   _loc1_.addListener(loadListener);
   _loc1_.loadClip("cache/tournaments/eib_" + tourneyScheduleID + ".swf",raceBG);
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
   trace("trackroom_ drawUserList");
   var _loc5_;
   var _loc2_;
   for(var _loc12_ in userListGroup.scrollContent)
   {
      _loc5_ = false;
      if(_loc12_.indexOf("item") > -1)
      {
         _loc2_ = 0;
         while(_loc2_ < userListXML.firstChild.childNodes.length)
         {
            if(userListGroup.scrollContent[_loc12_].userID == userListXML.firstChild.childNodes[_loc2_].attributes.i)
            {
               _loc5_ = true;
               break;
            }
            _loc2_ += 1;
         }
      }
      if(!_loc5_)
      {
         userListGroup.scrollContent[_loc12_].removeMovieClip();
      }
   }
   var _loc4_;
   var _loc15_;
   var _loc16_;
   var _loc13_ = new Array();
   var _loc14_;
   _loc2_ = 0;
   var _loc3_;
   var _loc7_;
   var _loc6_;
   while(_loc2_ < userListXML.firstChild.childNodes.length)
   {
      if(!userListGroup.scrollContent["item" + userListXML.firstChild.childNodes[_loc2_].attributes.i])
      {
         _loc3_ = userListGroup.scrollContent.attachMovie("userListItem","item" + userListXML.firstChild.childNodes[_loc2_].attributes.i,userListGroup.scrollContent.getNextHighestDepth(),{_x:190,_y:80,userID:userListXML.firstChild.childNodes[_loc2_].attributes.i,userName:userListXML.firstChild.childNodes[_loc2_].attributes.un,tf:userListXML.firstChild.childNodes[_loc2_].attributes.tf,tid:userListXML.firstChild.childNodes[_loc2_].attributes.tid});
         _loc7_ = classes.Lookup.getMemberColor(Number(userListXML.firstChild.childNodes[_loc2_].attributes.ms));
         _loc6_ = new TextFormat();
         _loc6_.color = _loc7_;
         _loc3_.fld.setTextFormat(_loc6_);
         classes.Drawing.portrait(_loc3_,userListXML.firstChild.childNodes[_loc2_].attributes.i,2,0,0,4);
         _loc4_ = _loc3_.photo;
         _loc4_._xscale = 25;
         _loc4_._yscale = 25;
         _loc4_._x = 100;
         _loc3_.onRelease = function()
         {
            classes.Control.focusViewer(this.userID);
         };
         if(userListXML.firstChild.childNodes[_loc2_].attributes.iv == 1)
         {
            _loc3_._alpha = 50;
         }
      }
      _loc2_ += 1;
   }
   orderUserList();
}
function orderUserList()
{
   userListGroup.scrollContent.clear();
   var vMargin = 9;
   var vSpace = 24;
   var orderArr = new Array();
   var rightOrderArr = new Array();
   var i = 0;
   while(i < userListXML.firstChild.childNodes.length)
   {
      orderArr.push({id:userListXML.firstChild.childNodes[i].attributes.i,teamID:userListXML.firstChild.childNodes[i].attributes.ti,uName:userListXML.firstChild.childNodes[i].attributes.un});
      i++;
   }
   orderArr.sortOn("uName",Array.CASEINSENSITIVE);
   var yPointerL = -10;
   var yPointerR = vMargin;
   var cTeamID;
   var cTeamTop;
   i = 0;
   while(i < orderArr.length)
   {
      userListGroup.scrollContent["item" + orderArr[i].id]._y = yPointerR;
      userListGroup.scrollContent["item" + orderArr[i].id]._x = 190;
      yPointerR += vSpace;
      userListGroup.scrollContent["item" + orderArr[i].id].swapDepths(0);
      userListGroup.scrollContent["item" + orderArr[i].id].swapDepths(i + 1);
      i++;
   }
   with(userListGroup.scrollContent)
   {
      moveTo(0,0);
      beginFill(0,0);
      lineTo(10,0);
      lineTo(10,_height + vMargin);
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
   trace("lookupUserName: " + uid);
   var _loc2_ = "";
   username = classes.Lookup.buddyName(uid);
   var _loc3_ = undefined;
   if(!_loc2_.length)
   {
      _loc3_ = 0;
      while(_loc3_ < matchTreeXML.firstChild.firstChild.childNodes.length)
      {
         if(matchTreeXML.firstChild.firstChild.childNodes[_loc3_].childNodes[0].attributes.i == uid)
         {
            _loc2_ = matchTreeXML.firstChild.firstChild.childNodes[_loc3_].childNodes[0].attributes.u;
            break;
         }
         if(matchTreeXML.firstChild.firstChild.childNodes[_loc3_].childNodes[1].attributes.i == uid)
         {
            _loc2_ = matchTreeXML.firstChild.firstChild.childNodes[_loc3_].childNodes[1].attributes.u;
            break;
         }
         _loc3_ += 1;
      }
   }
   trace("...lookupUserName: " + _loc2_);
   return _loc2_;
}
function showTimedOut()
{
   trace("showTimedOut ht");
   _root.raceSound.stopSound();
   optimizeBottom(true);
   if(!qualStatus || qualStatus < 1)
   {
      qualStatus = -1;
      countdownGroup.removeMovieClip();
      gotoAndStop("restart");
      play();
      classes.Control.dialogContainer("dialogTourneyTimedOutContent");
      _root.abc.addButton("OK");
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
}
function onRaceResults(xmlStr)
{
   trace("onRaceResults ht");
   var _loc4_ = new XML(xmlStr);
   var _loc5_ = _loc4_.firstChild.attributes;
   _global.chatObj.raceObj.lastResultsXML = _loc4_;
   if(_global.chatObj.raceObj.r1Obj.id == _loc5_.r1id)
   {
      trace("first is match");
      _global.chatObj.raceObj.r1Obj.et = Number(_loc5_.et1);
      _global.chatObj.raceObj.r1Obj.rt = Number(_loc5_.rt1);
      _global.chatObj.raceObj.r1Obj.ts = Number(_loc5_.ts1);
      _global.chatObj.raceObj.r1Obj.scc = Number(_loc5_.c1);
      _global.chatObj.raceObj.r1Obj.sc = Number(_global.chatObj.raceObj.r1Obj.sc) + _global.chatObj.raceObj.r1Obj.scc;
   }
   if(_global.chatObj.raceObj.r2Obj.id == _loc5_.r2id)
   {
      trace("second is match");
      _global.chatObj.raceObj.r2Obj.et = Number(_loc5_.et2);
      _global.chatObj.raceObj.r2Obj.rt = Number(_loc5_.rt2);
      _global.chatObj.raceObj.r2Obj.ts = Number(_loc5_.ts2);
      _global.chatObj.raceObj.r2Obj.scc = Number(_loc5_.c2);
      _global.chatObj.raceObj.r2Obj.sc = Number(_global.chatObj.raceObj.r2Obj.sc) + _global.chatObj.raceObj.r2Obj.scc;
   }
   _global.chatObj.raceObj.r1Obj.h = _loc4_.firstChild.attributes.h1;
   _global.chatObj.raceObj.r2Obj.h = _loc4_.firstChild.attributes.h2;
   if(_loc4_.firstChild.attributes.wid == "-2")
   {
      container.wid = -2;
      container.racer1Obj.RT = "FOUL";
      container.racer2Obj.RT = "FOUL";
      container.victor = 0;
   }
   else
   {
      container.wid = _loc4_.firstChild.attributes.wid;
      container.racer1Obj.RT = _loc4_.firstChild.attributes.rt1;
      container.racer2Obj.RT = _loc4_.firstChild.attributes.rt2;
      if(_loc4_.firstChild.attributes.wid == container.racer1Obj.id)
      {
         container.victor = 1;
      }
      else if(_loc4_.firstChild.attributes.wid == container.racer2Obj.id)
      {
         container.victor = -1;
      }
      else
      {
         container.victor = 0;
      }
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
   classes.Chat.enableWindow();
   optimizeBottom(true);
   if(classes.GlobalData.id == _loc4_.firstChild.attributes.r1id || classes.GlobalData.id == _loc4_.firstChild.attributes.r2id)
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
function createChart()
{
   trace("createChart _ " + chart + ", " + chartMask);
   drawChart(chart,chartMask,chartThumb,chartThumbSelector,chartThumb._width);
   chartVisibility(false);
   togChart._visible = true;
   var _loc5_;
   var _loc4_;
   var _loc3_;
   var _loc2_;
   var _loc1_;
   if(matchTreeXML.firstChild.childNodes.length > 1)
   {
      trace("is late");
      _loc2_ = 0;
      while(_loc2_ < matchTreeXML.firstChild.childNodes.length)
      {
         _loc5_ = Number(matchTreeXML.firstChild.childNodes[_loc2_].attributes.i);
         _loc1_ = 0;
         while(_loc1_ < matchTreeXML.firstChild.childNodes[_loc2_].childNodes.length)
         {
            _loc4_ = Number(matchTreeXML.firstChild.childNodes[_loc2_].childNodes[_loc1_].attributes.i);
            _loc3_ = Number(matchTreeXML.firstChild.childNodes[_loc2_].childNodes[_loc1_].attributes.w);
            if(_loc3_ != 0)
            {
               updateChartMatch(_loc5_,_loc4_,_loc3_);
            }
            _loc1_ += 1;
         }
         _loc2_ += 1;
      }
   }
}
function chartVisibility(isVisible)
{
   chart._visible = isVisible;
   chartThumb._visible = isVisible;
   chartThumbSelector._visible = isVisible;
   raceBG._visible = isVisible;
   ticker._visible = isVisible;
   txtRound._visible = isVisible;
   txtMatch._visible = isVisible;
   if(isVisible)
   {
      togChart.nextFrame();
   }
   else
   {
      togChart.prevFrame();
   }
}
function tickerIntro()
{
   if(ticker.__count)
   {
      return undefined;
   }
   if(spectateFlag)
   {
      ticker.addText("Welcome all spectators!");
   }
   else
   {
      ticker.addText("Welcome all racers and spectators!");
   }
   var _loc1_ = matchTreeXML.firstChild.childNodes.length;
   if(_loc1_ > 1)
   {
      if(_loc1_ <= 4)
      {
         ticker.addText("Round " + _loc1_ + " is in progress.");
      }
      else
      {
         ticker.addText("The tournament has ended.");
      }
   }
   else
   {
      ticker.addText("All Round 1 matches run at once.  Note, any racer without an opponent automatically advances.");
   }
}
function optimizeBottom(isVisible)
{
   trace("optimizeBottom...");
   var _loc3_ = undefined;
   if(isVisible)
   {
      bottomStatic.bmp.dispose();
      bottomStatic.removeMovieClip();
      delete bottomStatic;
   }
   else if(!bottomStatic)
   {
      bottomStatic = this.createEmptyMovieClip("bottomStatic",this.getNextHighestDepth());
      bottomStatic._y = 300;
      bottomStatic.bmp.dispose();
      bottomStatic.bmp = new flash.display.BitmapData(800,300,true,0);
      _loc3_ = new flash.geom.ColorTransform(0.5,0.5,0.5,1,0,0,0,0);
      bottomStatic.bmp.draw(btmBG,new flash.geom.Matrix(1,0,0,1,btmBG._x,btmBG._y - 300),_loc3_,"normal");
      bottomStatic.bmp.draw(loadinBG,new flash.geom.Matrix(1,0,0,1,loadinBG._x,loadinBG._y - 300),_loc3_,"normal");
      bottomStatic.bmp.draw(loadin,new flash.geom.Matrix(1,0,0,1,loadin._x,loadin._y - 300),_loc3_,"normal");
      bottomStatic.bmp.draw(usersBG,new flash.geom.Matrix(1,0,0,1,usersBG._x,usersBG._y - 300),_loc3_,"normal");
      bottomStatic.bmp.draw(userListHeads,new flash.geom.Matrix(1,0,0,1,userListHeads._x,userListHeads._y - 300),_loc3_,"normal");
      bottomStatic.bmp.draw(userListGroup,new flash.geom.Matrix(1,0,0,1,userListGroup._x,userListGroup._y - 300),_loc3_,"normal");
      bottomStatic.bmp.draw(chatWindow,new flash.geom.Matrix(1,0,0,1,chatWindow._x,chatWindow._y - 300),_loc3_,"normal");
      bottomStatic.attachBitmap(bottomStatic.bmp,1);
   }
   loadin._visible = isVisible;
   loadinBG._visible = isVisible;
   btmBG._visible = isVisible;
   usersBG._visible = isVisible;
   userListHeads._visible = isVisible;
   userListGroup._visible = isVisible;
   chatWindow._visible = isVisible;
   togChart._visible = isVisible;
}
function racePositions()
{
   matchArr = new Array();
   var _loc1_ = 0;
   while(_loc1_ < matchTreeXML.firstChild.firstChild.childNodes.length)
   {
      matchArr.push(matchTreeXML.firstChild.firstChild.childNodes[_loc1_].childNodes[0].attributes);
      matchArr[matchArr.length - 1].pos = _loc1_ + 1;
      matchArr.push(matchTreeXML.firstChild.firstChild.childNodes[_loc1_].childNodes[1].attributes);
      matchArr[matchArr.length - 1].pos = _loc1_ + 1;
      _loc1_ += 1;
   }
}
function goLoserPage()
{
   _global.setTimeout(this,"goLoserPageTimeout",4000);
}
function goLoserPageTimeout()
{
   stopAllSounds();
   this.showContainer("raceTournamentLose");
}
function goWinOneAndContinue(winAmt)
{
   trace("goWinOneAndContinue: " + winAmt);
   var _loc4_ = _global.chatObj.raceObj.oppObj;
   roundsArr.push({oppName:_loc4_.un,RT:_loc4_.rt,ET:_loc4_.et,TS:_loc4_.ts,timeDiff:0,winAmt:winAmt});
   _global.setTimeout(this,"goWinOneAndContinueTimeout",4000);
}
function goWinOneAndContinueTimeout()
{
   container.removeMovieClip();
   stopAllSounds();
   this.showContainer("raceTournamentWinOne",tourneyType);
}
function goWinnerPage(winAmt)
{
   trace("goWinnerPage: " + winAmt);
   var _loc4_ = _global.chatObj.raceObj.oppObj;
   roundsArr.push({oppName:_loc4_.un,RT:_loc4_.rt,ET:_loc4_.et,TS:_loc4_.ts,timeDiff:0,winAmt:winAmt});
   _global.setTimeout(this,"goWinnerPageTimeout",4000);
}
function goWinnerPageTimeout()
{
   container.removeMovieClip();
   stopAllSounds();
   this.showContainer("raceTournamentWin",tourneyType);
}
function drawChart(chartmc, maskmc, thumbmc, thumbselectormc, thumbwidth)
{
   var _loc6_ = 50;
   chartMC = chartmc;
   maskMC = maskmc;
   thumbMC = thumbmc;
   thumbSelectorMC = thumbselectormc;
   thumbSelectorMC.onPress = function()
   {
      this.pressed = true;
      this.startDrag(false,thumbMC._x,thumbMC._y,thumbMC._x + thumbMC._width - this._width,thumbMC._y + thumbMC._height - this._height);
      this.onEnterFrame = function()
      {
         chartMC._x = maskMC._x + (thumbMC._x - this._x) * chartMC._width / thumbMC._width;
         chartMC._y = maskMC._y + (thumbMC._y - this._y) * chartMC._height / thumbMC._height;
      };
   };
   thumbSelectorMC.onRelease = thumbSelectorMC.onReleaseOutside = function()
   {
      this.pressed = false;
      this.stopDrag();
      delete this.onEnterFrame;
   };
   thumbWidth = thumbwidth;
   chartMC._x = maskmc._x;
   chartMC._y = maskmc._y;
   depth = 10000;
   racePositions();
   var _loc7_ = 0;
   var _loc8_ = undefined;
   while(_loc7_ < matchArr.length)
   {
      _loc8_ = chartMC.attachMovie("tournamentTreeItem","item" + _loc7_,depth--);
      if(_loc7_ < 16)
      {
         _loc8_._x = 0;
         _loc8_._y = Math.floor(_loc7_ / 2) * 15 + _loc6_ * _loc7_;
         _loc8_.gotoAndStop(1);
         aryChart.push({mc:_loc8_,round:1,side:"L"});
      }
      else
      {
         _loc8_._x = 2400;
         _loc8_._y = Math.floor((_loc7_ - 16) / 2) * 15 + _loc6_ * (_loc7_ - 16);
         _loc8_.gotoAndStop(2);
         aryChart.push({mc:_loc8_,round:1,side:"R"});
      }
      _loc8_.idx = _loc7_;
      _loc8_.id = matchArr[_loc7_].i;
      _loc8_.username.text = matchArr[_loc7_].u;
      _loc8_.fldStatus.text = "RACING...";
      _loc8_.avatar._xscale = _loc8_.avatar._yscale = 50;
      classes.Drawing.portrait(_loc8_.avatar,_loc8_.id,1);
      _loc7_ += 1;
   }
   var _loc9_ = 1;
   while(_loc9_ <= 4)
   {
      _loc7_ = 0;
      while(_loc7_ < aryChart.length)
      {
         if(aryChart[_loc7_].round == _loc9_)
         {
            drawChartLine(chartMC,aryChart[_loc7_].mc,aryChart[_loc7_ + 1].mc,_loc9_,aryChart[_loc7_].side);
         }
         _loc7_ += 2;
      }
      _loc9_ += 1;
   }
   thumbSelectorMC._x = thumbMC._x;
   thumbSelectorMC._y = thumbMC._y;
   chartMC.cacheAsBitmap = true;
   chartVisibility(true);
}
function drawChartLine(mc, mcA, mcB, round, side)
{
   var _loc6_ = (mcB._y - mcA._y) / 2;
   mc.lineStyle(10,16777215,30,true,"normal","square","miter");
   var _loc7_ = undefined;
   var _loc8_ = undefined;
   var _loc9_ = undefined;
   if(side == "L")
   {
      _loc7_ = -28;
      _loc8_ = -10;
      mc.moveTo(mcA._x + mcA._width + _loc7_,mcA._y + mcA._height / 2 + _loc8_);
      mc.lineTo(mcA._x + mcA._width + 5 + _loc7_,mcA._y + mcA._height / 2 + _loc8_);
      mc.lineTo(mcA._x + mcA._width + 5 + _loc7_ + _loc6_ * 0.6,mcA._y + _loc6_ + mcA._height / 2 + _loc8_);
      mc.lineTo(mcA._x + mcA._width + 5 + _loc7_,mcB._y + mcB._height / 2 + _loc8_);
      mc.lineTo(mcA._x + mcA._width + _loc7_,mcB._y + mcB._height / 2 + _loc8_);
      _loc9_ = mc.attachMovie("tournamentTreeItem","item" + (round + 1) + "_" + aryChart.length,depth--);
      _loc9_._x = mcA._x + mcA._width + 5 + _loc7_ + _loc6_ * 0.6;
      _loc9_._y = mcA._y + _loc6_ + mcA._height / 2 + _loc8_ - 42;
      _loc9_.gotoAndStop(1);
   }
   else
   {
      _loc7_ = 28;
      _loc8_ = -10;
      mc.moveTo(mcA._x + _loc7_,mcA._y + mcA._height / 2 + _loc8_);
      mc.lineTo(mcA._x - 5 + _loc7_,mcA._y + mcA._height / 2 + _loc8_);
      mc.lineTo(mcA._x - 5 + _loc7_ - _loc6_ * 0.6,mcA._y + _loc6_ + mcA._height / 2 + _loc8_);
      mc.lineTo(mcA._x - 5 + _loc7_,mcB._y + mcB._height / 2 + _loc8_);
      mc.lineTo(mcA._x + _loc7_,mcB._y + mcB._height / 2 + _loc8_);
      _loc9_ = mc.attachMovie("tournamentTreeItem","item" + (round + 1) + "_" + aryChart.length,depth--);
      _loc9_._x = mcA._x - mcA._width - 5 + _loc7_ - _loc6_ * 0.6;
      _loc9_._y = mcA._y + _loc6_ + mcA._height / 2 + _loc8_ - 42;
      _loc9_.gotoAndStop(2);
   }
   _loc9_.idx = aryChart.length;
   aryChart.push({mc:_loc9_,round:round + 1,side:side});
   mcA.child = mcB.child = _loc9_;
}
function animateChart(round, match)
{
   trace("animateChart: " + round + ", " + match + " _ t[" + new Date() + "]");
   container.removeMovieClip();
   chartVisibility(true);
   txtRound.text = "ROUND " + (Number(round) + 1);
   txtMatch.text = "MATCH " + (Number(match) + 1);
   var _loc3_ = 0;
   var _loc4_ = 0;
   while(_loc4_ < round)
   {
      _loc3_ += Math.pow(2,5 - _loc4_);
      _loc4_ += 1;
   }
   _loc3_ += match * 2;
   var _loc5_ = undefined;
   var _loc6_ = undefined;
   var _loc7_ = undefined;
   var _loc8_ = undefined;
   if(round == 4)
   {
      var destX = maskMC._x + (maskMC._width - chartMC._width) / 2;
      var destY = maskMC._y + (maskMC._height - chartMC._height) / 2;
   }
   else
   {
      if(aryChart[_loc3_].side == "L")
      {
         _loc5_ = aryChart[_loc3_].mc._x;
         _loc6_ = aryChart[_loc3_].mc._y;
         _loc7_ = aryChart[_loc3_].mc.child._x + aryChart[_loc3_].mc.child._width;
         _loc8_ = aryChart[_loc3_ + 1].mc._y + aryChart[_loc3_ + 1].mc._height;
      }
      else
      {
         _loc5_ = aryChart[_loc3_].mc.child._x;
         _loc6_ = aryChart[_loc3_].mc._y;
         _loc7_ = aryChart[_loc3_].mc._x + aryChart[_loc3_].mc._width;
         _loc8_ = aryChart[_loc3_ + 1].mc._y + aryChart[_loc3_ + 1].mc._height;
      }
      var destX = - _loc5_ + maskMC._x + (maskMC._width - (_loc7_ - _loc5_)) / 2;
      if(destX > maskMC._x)
      {
         destX = maskMC._x;
      }
      else if(destX < maskMC._x + maskMC._width - chartMC._width)
      {
         destX = maskMC._x + maskMC._width - chartMC._width;
      }
      var destY = - _loc6_ + maskMC._y + (maskMC._height - (_loc8_ - _loc6_)) / 2;
      if(destY > maskMC._y)
      {
         destY = maskMC._y;
      }
      else if(destY < maskMC._y + maskMC._height - chartMC._height)
      {
         destY = maskMC._y + maskMC._height - chartMC._height;
      }
   }
   var scale = thumbWidth / chartMC._width;
   chartMC.onEnterFrame = function()
   {
      if(!this.dragFlag)
      {
         this._x += (destX - this._x) / 5;
         this._y += (destY - this._y) / 5;
         if(!thumbSelectorMC.pressed)
         {
            thumbSelectorMC._x = thumbMC._x + (maskMC._x - chartMC._x) * scale;
            thumbSelectorMC._y = thumbMC._y + (maskMC._y - chartMC._y) * scale;
         }
         if(Math.abs(this._x - destX) < 1 && Math.abs(this._y - destY) < 1)
         {
            this._x = destX;
            this._y = destY;
            delete this.onEnterFrame;
         }
      }
   };
}
function updateChartMatch(round, match, wid)
{
   trace("updateChartMatch: r[" + round + "], m[" + match + "], w[" + wid + "]");
   txtRankTitle = "";
   txtRankHead = "";
   countdownGroup.removeMovieClip();
   rankingBoardGroup.removeMovieClip();
   var _loc4_ = undefined;
   var _loc5_ = undefined;
   var _loc6_ = undefined;
   var _loc7_ = 0;
   var _loc8_ = 0;
   while(_loc8_ < round)
   {
      _loc7_ += Math.pow(2,5 - _loc8_);
      _loc8_ += 1;
   }
   _loc7_ += match * 2;
   _loc5_ = aryChart[_loc7_].mc.id;
   _loc6_ = aryChart[_loc7_ + 1].mc.id;
   var _loc9_ = "";
   if(wid == -1)
   {
      _loc4_ = 0;
      aryChart[_loc7_].mc.fldStatus.text = "";
      aryChart[_loc7_ + 1].mc.fldStatus.text = "";
   }
   else if(wid == _loc5_)
   {
      _loc4_ = 1;
      _loc9_ = "Round " + (round + 1) + " Match " + (match + 1) + ": " + aryChart[_loc7_].mc.username.text;
      if(_loc6_ > 0)
      {
         _loc9_ += " defeats " + aryChart[_loc7_ + 1].mc.username.text + ".";
         aryChart[_loc7_].mc.fldStatus.text = "WINNER";
         aryChart[_loc7_ + 1].mc.fldStatus.text = "LOSER";
      }
      else
      {
         _loc9_ += " advances.";
         aryChart[_loc7_].mc.fldStatus.text = "ADVANCES";
         aryChart[_loc7_ + 1].mc.fldStatus.text = "";
      }
   }
   else if(wid == _loc6_)
   {
      _loc4_ = -1;
      _loc9_ = "Round " + (round + 1) + " Match " + (match + 1) + ": " + aryChart[_loc7_ + 1].mc.username.text;
      if(_loc5_ > 0)
      {
         _loc9_ += " defeats " + aryChart[_loc7_].mc.username.text + ".";
         aryChart[_loc7_].mc.fldStatus.text = "LOSER";
         aryChart[_loc7_ + 1].mc.fldStatus.text = "WINNER";
      }
      else
      {
         _loc9_ += " advances.";
         aryChart[_loc7_].mc.fldStatus.text = "";
         aryChart[_loc7_ + 1].mc.fldStatus.text = "ADVANCES";
      }
   }
   else
   {
      _loc4_ = 0;
      aryChart[_loc7_].mc.fldStatus.text = "";
      aryChart[_loc7_ + 1].mc.fldStatus.text = "";
   }
   aryChart[_loc7_].mc.child.id = aryChart[_loc7_].mc.id;
   if(!aryChart[_loc7_].mc.isDrawn)
   {
      stageChartWin(aryChart[_loc7_],aryChart[_loc7_ + 1],_loc4_);
      if(wid > 0)
      {
         stageTickerText(_loc9_);
      }
      if(round > 0)
      {
         if(round == 4 && match == 0)
         {
            tourneyWinnerID = Number(wid);
            stageFinalAnim();
         }
         else
         {
            stageChartAnim(round,match);
         }
      }
      aryChart[_loc7_].mc.isDrawn = true;
   }
}
function stageTickerText(txt)
{
   trace("stageTickerText: " + txt);
   if(!txt.length)
   {
      return undefined;
   }
   _global.setTimeout(this,"doTickerText",22000,txt);
}
function doTickerText(txt)
{
   trace("doTickerText: " + txt);
   tickerIntro();
   ticker.addText(txt);
}
function stageChartAnim(round, match)
{
   trace("stageChartAnim t[" + new Date() + "]");
   var _loc5_ = 22000;
   _global.clearTimeout(animChartWinST);
   animChartWinST = _global.setTimeout(this,"animateChart",_loc5_,round,match);
   _global.clearTimeout(drawChartWinST);
   drawChartWinST = _global.setTimeout(this,"drawChartWin",_loc5_ + 800);
}
function stageFinalAnim()
{
   trace("stageFinalAnim t[" + new Date() + "]");
   var _loc3_ = 23000;
   _global.clearTimeout(finalWinST);
   finalWinST = _global.setTimeout(this,"finalWin",_loc3_);
}
function finalWin()
{
   this.showContainer("raceTournamentWin",tourneyType);
}
function drawChartWin()
{
   trace("drawChartWin t[" + new Date() + "]");
   if(stagedWinPlayer1)
   {
      drawWinner(stagedWinPlayer1,stagedWinPlayer2,stagedWinDoesPlayer1Win);
   }
   delete stagedWinPlayer1;
   delete stagedWinPlayer2;
   delete stagedWinDoesPlayer1Win;
}
function stageChartWin(player1, player2, doesPlayer1Win)
{
   trace("stageChartWin: " + player1 + ", " + player2 + ", " + doesPlayer1Win);
   if(stagedWinPlayer1)
   {
      trace("stageChartWin _ stagedWinPlayer1 is true");
      drawWinner(stagedWinPlayer1,stagedWinPlayer2,stagedWinDoesPlayer1Win);
   }
   stagedWinPlayer1 = player1;
   stagedWinPlayer2 = player2;
   stagedWinDoesPlayer1Win = doesPlayer1Win;
}
function drawWinner(player1, player2, doesPlayer1Win)
{
   trace("~~~~~~drawWinner: " + player1.mc.id + ", " + player2.mc.id + ", " + doesPlayer1Win);
   var _loc4_ = undefined;
   var _loc5_ = undefined;
   var _loc6_ = undefined;
   if(doesPlayer1Win == 1)
   {
      player1.mc.child.id = player1.mc.id;
      player1.mc.child.username.text = player1.mc.username.text;
      player1.mc.child.avatar._xscale = player1.mc.child.avatar._yscale = 50;
      classes.Drawing.portrait(player1.mc.child.avatar,player1.mc.child.id,1);
      player2.mc.cross.gotoAndStop(2);
      chartMC.lineStyle(10,16777215,100,true,"normal","square","miter");
      _loc4_ = (player2.mc._y - player1.mc._y) / 2;
      if(player1.idx == 57)
      {
         return undefined;
      }
      if(player1.side == "L")
      {
         _loc5_ = -28;
         _loc6_ = -10;
         chartMC.moveTo(player1.mc._x + player1.mc._width + _loc5_,player1.mc._y + player1.mc._height / 2 + _loc6_);
         chartMC.lineTo(player1.mc._x + player1.mc._width + 5 + _loc5_,player1.mc._y + player1.mc._height / 2 + _loc6_);
         chartMC.lineTo(player1.mc._x + player1.mc._width + 5 + _loc5_ + _loc4_ * 0.6,player1.mc._y + _loc4_ + player1.mc._height / 2 + _loc6_);
         chartMC.lineTo(player1.mc._x + player1.mc._width + 20 + _loc5_ + _loc4_ * 0.6,player1.mc._y + _loc4_ + player1.mc._height / 2 + _loc6_);
      }
      else
      {
         _loc5_ = 28;
         _loc6_ = -10;
         chartMC.moveTo(player1.mc._x + _loc5_,player1.mc._y + player1.mc._height / 2 + _loc6_);
         chartMC.lineTo(player1.mc._x - 5 + _loc5_,player1.mc._y + player1.mc._height / 2 + _loc6_);
         chartMC.lineTo(player1.mc._x - 5 + _loc5_ - _loc4_ * 0.6,player1.mc._y + _loc4_ + player1.mc._height / 2 + _loc6_);
         chartMC.lineTo(player1.mc._x - 20 + _loc5_ - _loc4_ * 0.6,player1.mc._y + _loc4_ + player1.mc._height / 2 + _loc6_);
      }
   }
   else if(doesPlayer1Win == 0)
   {
      player1.mc.cross.gotoAndStop(2);
      player2.mc.cross.gotoAndStop(2);
   }
   else if(doesPlayer1Win == -1)
   {
      player1.mc.child.id = player2.mc.id;
      player1.mc.child.username.text = player2.mc.username.text;
      player1.mc.child.avatar._xscale = player1.mc.child.avatar._yscale = 50;
      classes.Drawing.portrait(player1.mc.child.avatar,player1.mc.child.id,1);
      player1.mc.cross.gotoAndStop(2);
      chartMC.lineStyle(10,16777215,100,true,"normal","square","miter");
      _loc4_ = (player2.mc._y - player1.mc._y) / 2;
      if(player2.idx == 59)
      {
         return undefined;
      }
      if(player1.side == "L")
      {
         _loc5_ = -28;
         _loc6_ = -10;
         chartMC.moveTo(player2.mc._x + player2.mc._width + _loc5_,player2.mc._y + player2.mc._height / 2 + _loc6_);
         chartMC.lineTo(player2.mc._x + player2.mc._width + 5 + _loc5_,player2.mc._y + player2.mc._height / 2 + _loc6_);
         chartMC.lineTo(player1.mc._x + player1.mc._width + 5 + _loc5_ + _loc4_ * 0.6,player1.mc._y + _loc4_ + player1.mc._height / 2 + _loc6_);
         chartMC.lineTo(player1.mc._x + player1.mc._width + 20 + _loc5_ + _loc4_ * 0.6,player1.mc._y + _loc4_ + player1.mc._height / 2 + _loc6_);
      }
      else
      {
         _loc5_ = 28;
         _loc6_ = -10;
         chartMC.moveTo(player2.mc._x + _loc5_,player2.mc._y + player2.mc._height / 2 + _loc6_);
         chartMC.lineTo(player2.mc._x - 5 + _loc5_,player2.mc._y + player2.mc._height / 2 + _loc6_);
         chartMC.lineTo(player1.mc._x - 5 + _loc5_ - _loc4_ * 0.6,player1.mc._y + _loc4_ + player1.mc._height / 2 + _loc6_);
         chartMC.lineTo(player1.mc._x - 20 + _loc5_ - _loc4_ * 0.6,player1.mc._y + _loc4_ + player1.mc._height / 2 + _loc6_);
      }
   }
}
function showContainer(linkName, type)
{
   container.removeMovieClip();
   if(linkName == "racePlay")
   {
      chartVisibility(false);
      txtRound.text = "";
      txtMatch.text = "";
      raceBG._visible = false;
   }
   else
   {
      raceBG._visible = true;
   }
   if(linkName.length)
   {
      this.attachMovie(linkName,"container",1,{linkName:linkName,type:type});
   }
   if(containerMask == undefined)
   {
      this.createEmptyMovieClip("containerMask",2);
      classes.Drawing.rect(containerMask,800,344,0,0);
   }
   container._x = 0;
   container._y = 0;
   container.setMask(containerMask);
}
function randRange(min, max)
{
   var _loc3_ = Math.floor(Math.random() * (max - min + 1)) + min;
   return _loc3_;
}
function formatDecimal(n)
{
   var _loc2_ = undefined;
   try
   {
      _loc2_ = Math.round(n * 100).toString();
      switch(_loc2_.length)
      {
         case 0:
            return "0.00";
         case 1:
            return "0.0" + _loc2_;
         case 2:
            return "0." + _loc2_;
         default:
            return _loc2_.substr(0,_loc2_.length - 2) + "." + _loc2_.substr(_loc2_.length - 2,2);
      }
   }
   catch(e:String)
   {
      return "0.00";
   }
}
function getMonthAsString(month)
{
   var _loc2_ = new Array("January","February","March","April","May","June","July","August","September","October","November","December");
   return _loc2_[month];
}
function goNextRace(round, match)
{
   trace("ht goNextRace: t[" + new Date() + "]");
   animateChart(round,match);
   _global.setTimeout(this,"announceNextRace",3000);
}
function announceNextRace()
{
   chartVisibility(false);
   this.showContainer("raceAnnounce",tourneyType);
}
var bottomStatic;
var chartMC;
var maskMC;
var thumbMC;
var thumbSelectorMC;
var thumbWidth;
var thumbBitmapData;
var aryChart = new Array();
var depth;
var animChartWinST;
var drawChartWinST;
var finalWinST;
var stagedWinPlayer1;
var stagedWinPlayer2;
var stagedWinDoesPlayer1Win;
