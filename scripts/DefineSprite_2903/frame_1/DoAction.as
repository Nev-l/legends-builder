function initRoom()
{
   _global.chatObj = new Object();
   _global.chatObj.roomType = "CT";
   _global.chatObj.raceRoomMC = this;
   classes.ClipFuncs.removeAllClips(this);
   chart.removeMovieClip();
   chartThumb.removeMovieClip();
   stopAllSounds();
   roundsArr = new Array();
   tourneyType = "";
   delete aryCompTourney;
   playerRank = 0;
   currentMatch = 0;
   tourneyID = _global.sectionTrackMC.tourneyID;
}
function startRoom()
{
   if(!tourneyID)
   {
      trace("CRITICAL: No tournamentID detected!");
      return undefined;
   }
   switch(tourneyID)
   {
      case 1:
         tourneyType = "tourneyA";
         populateComputerQualification(900);
         _root.ctJoin(1);
         return undefined;
      case 2:
         tourneyType = "tourneyS";
         populateComputerQualification(400);
         _root.ctJoin(2);
         return undefined;
      case 3:
         tourneyType = "tourneyP";
         populateComputerQualification(100);
         _root.ctJoin(3);
         return undefined;
      default:
         trace("CRITICAL: should not be handling LT from here");
         return undefined;
   }
}
function populateComputerQualification(difficulty)
{
   aryCompTourney = new Array();
   var _loc2_ = compXML.firstChild;
   var _loc3_ = 0;
   var _loc4_ = undefined;
   var _loc5_ = undefined;
   var _loc6_ = undefined;
   var _loc7_ = undefined;
   var _loc8_ = undefined;
   var _loc9_ = undefined;
   var _loc10_ = undefined;
   var _loc11_ = undefined;
   while(_loc3_ < _loc2_.childNodes.length)
   {
      _loc4_ = Number(_loc2_.childNodes[_loc3_].attributes.w);
      _loc5_ = Number(_loc2_.childNodes[_loc3_].attributes.hp);
      _loc6_ = Math.round(Math.pow(_loc4_ / _loc5_,0.3333333333333333) * 5.825 * 1000) / 1000;
      _loc7_ = randRange(500,500 + Math.floor(difficulty / 2)) / 1000;
      _loc8_ = _loc6_ + randRange(0,100 + difficulty) / 1000;
      _loc9_ = Math.round(Math.pow(_loc5_ / _loc4_,0.3333333333333333) * 234 * 100) / 100;
      _loc10_ = _loc7_ + _loc8_ - _loc6_;
      _loc11_ = String(100 + Math.floor(Math.random() * 900));
      aryCompTourney.push({id:_loc2_.childNodes[_loc3_].attributes.i,n:_loc2_.childNodes[_loc3_].attributes.u,bt:_loc6_,rt:_loc7_,et:_loc8_,ts:_loc9_,total:_loc10_,racerNum:_loc11_,type:"C"});
      _loc3_ += 1;
   }
}
function addPlayerQualification(tmpBT, tmpRT, tmpET, tmpTS)
{
   var _loc5_ = tmpRT + tmpET - tmpBT;
   var _loc6_ = {id:classes.GlobalData.id,n:classes.GlobalData.uname,bt:tmpBT,rt:tmpRT,et:tmpET,ts:tmpTS,total:_loc5_,type:"H"};
   var _loc7_ = new Array();
   var _loc8_ = 0;
   while(_loc8_ < aryCompTourney.length)
   {
      _loc7_.push(aryCompTourney[_loc8_]);
      _loc8_ += 1;
   }
   _loc7_.push(_loc6_);
   _loc7_.sortOn(["total","rt","n"],[Array.NUMERIC,Array.NUMERIC,Array.NUMERIC]);
   _loc8_ = 0;
   while(_loc8_ < _loc7_.length)
   {
      if(_loc7_[_loc8_].type == "H")
      {
         playerRank = _loc8_ + 1;
         classes.Debug.writeLn("Player Rank = " + playerRank);
         break;
      }
      _loc8_ += 1;
   }
   false;
   aryCompTourney.push(_loc6_);
   rankingAnimEnabled = true;
}
function assignRacePosition()
{
   aryCompTourney.sortOn(["total","rt","n"],[Array.NUMERIC,Array.NUMERIC,Array.NUMERIC]);
   var _loc1_ = 0;
   while(_loc1_ < aryCompTourney.length)
   {
      aryCompTourney[_loc1_].fRank = _loc1_ + 1;
      if(_loc1_ < 16)
      {
         aryCompTourney[_loc1_].pos = _loc1_ + 1;
      }
      else
      {
         aryCompTourney[_loc1_].pos = 32 - _loc1_;
      }
      _loc1_ += 1;
   }
   aryCompTourney.sortOn(["pos","fRank"],[Array.NUMERIC,Array.NUMERIC]);
}
function buildRankingBoard()
{
   this.createEmptyMovieClip("rankingBoardGroup",this.getNextHighestDepth());
   panel.swapDepths(this.getNextHighestDepth());
   this.createEmptyMovieClip("panelMask",this.getNextHighestDepth());
   classes.Drawing.rect(panelMask,800,600,0,0);
   panel.setMask(panelMask);
   rankingBoardGroup._x = 211;
   rankingBoardGroup._y = 270;
   rankingBoardMC = rankingBoardGroup.createEmptyMovieClip("rankingBoardMC",1);
   rankingBoardMC.i = 0;
   scrollerObj = new controls.ScrollPane(rankingBoardMC,255,323,null,null,255);
   rankingAnimEnabled = true;
   setRankingBoardAnim(Math.floor(Math.random() * 3000));
}
function setRankingBoardAnim(delay)
{
   if(rankingBoardMC.i < 31)
   {
      _global.setTimeout(this,"rankingBoardAnimStep",delay);
   }
   else if(playerRank)
   {
      _global.setTimeout(this,"gotoAndPlay",4000,"chart");
   }
}
function rankingBoardAnimStep()
{
   with(rankingBoardMC)
   {
      var tmpRank = attachMovie("tournamentRankItem","rank" + i,rankingBoardMC.getNextHighestDepth());
      tmpRank.username.text = aryCompTourney[i].n;
      tmpRank.rt.text = formatDecimal(aryCompTourney[i].rt);
      tmpRank.rtVal = aryCompTourney[i].rt;
      tmpRank.et.text = formatDecimal(aryCompTourney[i].et);
      tmpRank.total = aryCompTourney[i].total;
      tmpRank.i = i;
      sortRankingBoard();
      i++;
   }
   if(rankingAnimEnabled)
   {
      setRankingBoardAnim(50 + Math.floor(Math.random() * 500));
   }
}
function sortRankingBoard()
{
   var _loc3_ = new Array();
   var _loc5_;
   for(§each§ in rankingBoardMC)
   {
      if(typeof rankingBoardMC[eval("each")] == "movieclip")
      {
         if(_loc5_)
         {
            _loc5_ = Math.min(_loc5_,rankingBoardMC[eval("each")].total);
         }
         else
         {
            _loc5_ = rankingBoardMC[eval("each")].total;
         }
         _loc3_.push({d:rankingBoardMC[eval("each")].total - _loc5_,total:rankingBoardMC[eval("each")].total,rt:rankingBoardMC[eval("each")].rtVal,n:rankingBoardMC[eval("each")].username.text,mc:rankingBoardMC[eval("each")]});
      }
   }
   _loc3_.sortOn(["total","rt","n"],[Array.NUMERIC,Array.NUMERIC,Array.NUMERIC]);
   var _loc2_ = 0;
   while(_loc2_ < _loc3_.length)
   {
      if(_loc2_)
      {
         _loc3_[_loc2_].mc.diff.text = "+" + formatDecimal(_loc3_[_loc2_].d);
      }
      else
      {
         _loc3_[_loc2_].mc.diff.text = "";
      }
      _loc3_[_loc2_].mc.rank.text = String(_loc2_ + 1) + ".";
      _loc3_[_loc2_].mc.curRank = _loc2_ + 1;
      _loc3_[_loc2_].mc._y = _loc2_ * 16;
      _loc3_[_loc2_].mc.gotoAndStop(_loc2_ % 2 + 1);
      _loc2_ += 1;
   }
   scrollerObj.refreshScroller();
   _global.debugTourneyRankings = "";
   var _loc4_ = 0;
   while(_loc4_ < _loc3_.length)
   {
      _global.debugTourneyRankings += _loc3_[_loc4_].mc.curRank + ". " + _loc3_[_loc4_].n + ", " + _loc3_[_loc4_].total + ", " + _loc3_[_loc4_].rt + "\n";
      _loc4_ += 1;
   }
   showMyRank();
}
function showMyRank()
{
   var _loc1_ = 0;
   for(§each§ in rankingBoardMC)
   {
      if(rankingBoardMC[eval("each")]._name == "myRank")
      {
         _loc1_ = rankingBoardMC[eval("each")].curRank;
      }
   }
   if(_loc1_)
   {
      rank.text = _loc1_ + " ";
      if(Math.floor(playerRank / 10) == 1)
      {
         rankext.text = "th";
      }
      else if(_loc1_ % 10 == 1)
      {
         rankext.text = "st";
      }
      else if(_loc1_ % 10 == 2)
      {
         rankext.text = "nd";
      }
      else if(_loc1_ % 10 == 3)
      {
         rankext.text = "rd";
      }
      else
      {
         rankext.text = "th";
      }
   }
}
function finishCompRace(et, ts)
{
   container.crossWire(classes.GlobalData.id,et,ts);
   if(!playerRank)
   {
      addPlayerQualification(_global.chatObj.raceObj.bt,classes.RacePlay._MC.racer1Obj.RT,et,ts);
      if(et < _global.chatObj.raceObj.bt)
      {
         _global.setTimeout(this,"goNotQualified",4000);
         classes.Control.setMapButton("nonrace");
      }
      else
      {
         _global.setTimeout(this,"goQualified",4000);
      }
   }
}
function goNotQualified()
{
   this.gotoAndPlay("computerNotQualified");
}
function goQualified()
{
   this.gotoAndPlay("computerQualified");
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
function goWonOneDone()
{
   container.removeMovieClip();
   stopAllSounds();
   trace("goWonOneDone");
   computerRaceHumanFinish(10,0.5,10,200);
}
function lookupUserName(uid)
{
   var _loc2_ = "";
   var _loc3_ = 0;
   while(_loc3_ < aryCompTourney.length)
   {
      if(aryCompTourney[_loc3_].id == uid)
      {
         _loc2_ = aryCompTourney[_loc3_].n;
         break;
      }
      _loc3_ += 1;
   }
   return _loc2_;
}
function lookupRacerNum(uid)
{
   var _loc2_ = "";
   var _loc3_ = 0;
   while(_loc3_ < aryCompTourney.length)
   {
      if(aryCompTourney[_loc3_].id == uid)
      {
         _loc2_ = aryCompTourney[_loc3_].racerNum;
         break;
      }
      _loc3_ += 1;
   }
   return _loc2_;
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
   assignRacePosition();
   var _loc7_ = 0;
   var _loc8_ = undefined;
   while(_loc7_ < aryCompTourney.length)
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
      _loc8_.id = aryCompTourney[_loc7_].id;
      _loc8_.username.text = aryCompTourney[_loc7_].n;
      _loc8_.avatar._xscale = _loc8_.avatar._yscale = 50;
      classes.Drawing.portrait(_loc8_.avatar,_loc8_.id,1);
      trace("fRank: " + aryCompTourney[_loc7_].fRank + ", pos: " + aryCompTourney[_loc7_].pos + ", n: " + aryCompTourney[_loc7_].n);
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
   thumbSelectorMC._xscale = thumbSelectorMC._yscale = thumbWidth / chartMC._width * 100;
   thumbSelectorMC._x = thumbMC._x;
   thumbSelectorMC._y = thumbMC._y;
   refreshThumb();
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
   aryChart.push({mc:_loc9_,round:round + 1,side:side});
   mcA.child = mcB.child = _loc9_;
}
function animateChart(round, a1id, a2id)
{
   trace("animateChart: " + round + ", " + a1id + ", " + a2id + " _ " + aryChart.length);
   var _loc4_ = -1;
   var _loc5_ = 0;
   while(_loc5_ < aryChart.length)
   {
      if(aryChart[_loc5_].round == round)
      {
         if(aryChart[_loc5_].mc.id == a1id && aryChart[_loc5_ + 1].mc.id == a2id)
         {
            _loc4_ = _loc5_;
            break;
         }
         if(aryChart[_loc5_].mc.id == a2id && aryChart[_loc5_ + 1].mc.id == a1id)
         {
            _loc4_ = _loc5_;
            break;
         }
      }
      _loc5_ += 2;
   }
   var _loc6_ = undefined;
   var _loc7_ = undefined;
   var _loc8_ = undefined;
   var _loc9_ = undefined;
   if(_loc4_ >= 0)
   {
      if(round == 5)
      {
         var destX = maskMC._x + (maskMC._width - chartMC._width) / 2;
         var destY = maskMC._y + (maskMC._height - chartMC._height) / 2;
      }
      else
      {
         if(aryChart[_loc4_].side == "L")
         {
            _loc6_ = aryChart[_loc4_].mc._x;
            _loc7_ = aryChart[_loc4_].mc._y;
            _loc8_ = aryChart[_loc4_].mc.child._x + aryChart[_loc4_].mc.child._width;
            _loc9_ = aryChart[_loc4_ + 1].mc._y + aryChart[_loc4_ + 1].mc._height;
         }
         else
         {
            _loc6_ = aryChart[_loc4_].mc.child._x;
            _loc7_ = aryChart[_loc4_].mc._y;
            _loc8_ = aryChart[_loc4_].mc._x + aryChart[_loc4_].mc._width;
            _loc9_ = aryChart[_loc4_ + 1].mc._y + aryChart[_loc4_ + 1].mc._height;
         }
         var destX = - _loc6_ + maskMC._x + (maskMC._width - (_loc8_ - _loc6_)) / 2;
         if(destX > maskMC._x)
         {
            destX = maskMC._x;
         }
         else if(destX < maskMC._x + maskMC._width - chartMC._width)
         {
            destX = maskMC._x + maskMC._width - chartMC._width;
         }
         var destY = - _loc7_ + maskMC._y + (maskMC._height - (_loc9_ - _loc7_)) / 2;
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
      };
   }
}
function updateChartMatch(round, a1id, a2id, a1bt, a1rt, a1et, a1ts, a2bt, a2rt, a2et, a2ts)
{
   trace("updateChartMatch: " + a1id);
   var _loc12_ = -1;
   var _loc13_ = undefined;
   var _loc14_ = a1et - a1bt + a1rt;
   var _loc15_ = a2et - a2bt + a1rt;
   if(_loc14_ < 0.5 || a1rt == -1)
   {
      if(_loc15_ < 0.5 || a2rt == -1)
      {
         _loc13_ = 0;
      }
      else
      {
         _loc13_ = -1;
      }
   }
   else if(_loc15_ < 0.5 || a2rt == -1)
   {
      _loc13_ = 1;
   }
   else if(_loc14_ < _loc15_)
   {
      _loc13_ = 1;
   }
   else
   {
      _loc13_ = -1;
   }
   var _loc16_ = 0;
   while(_loc16_ < aryChart.length)
   {
      if(aryChart[_loc16_].round == round)
      {
         if(aryChart[_loc16_].mc.id == a1id && aryChart[_loc16_ + 1].mc.id == a2id)
         {
            _loc12_ = _loc16_;
            aryChart[_loc16_].mc.child.id = aryChart[_loc16_].mc.id;
            break;
         }
         if(aryChart[_loc16_].mc.id == a2id && aryChart[_loc16_ + 1].mc.id == a1id)
         {
            _loc12_ = _loc16_;
            aryChart[_loc16_].mc.child.id = aryChart[_loc16_ + 1].mc.id;
            _loc13_ *= -1;
            break;
         }
      }
      _loc16_ += 2;
   }
   if(_loc12_ >= 0)
   {
      drawWinner(aryChart[_loc12_],aryChart[_loc12_ + 1],_loc13_);
   }
}
function drawWinner(player1, player2, doesPlayer1Win)
{
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
   refreshThumb();
}
function refreshThumb()
{
   var _loc1_ = thumbWidth / chartMC._width;
   thumbBitmapData.dispose();
   thumbBitmapData = new flash.display.BitmapData(thumbWidth,chartMC._height * _loc1_,true,16777215);
   thumbMC.attachBitmap(thumbBitmapData,thumbMC.getNextHighestDepth());
   var _loc2_ = new flash.geom.Matrix();
   _loc2_.scale(_loc1_,_loc1_);
   thumbBitmapData.draw(chartMC,_loc2_);
}
function showContainer(linkName, type)
{
   container.removeMovieClip();
   if(linkName.length)
   {
      this.attachMovie(linkName,"container",this.getNextHighestDepth(),{linkName:linkName,type:type});
   }
   if(containerMask == undefined)
   {
      this.createEmptyMovieClip("containerMask",this.getNextHighestDepth());
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
function computerChartAnimationSwitch(turnOn)
{
   trace("computerChartAnimationSwitch");
   clearInterval(computerChartAnimationInterval);
   if(turnOn)
   {
      chart._visible = true;
      computerChartAnimationInterval = setInterval(computerChartAnimation,1000);
   }
}
function computerChartAnimation()
{
   var _loc2_ = undefined;
   var _loc3_ = undefined;
   var _loc4_ = 0;
   while(_loc4_ < aryCompTourney.length)
   {
      if(aryCompTourney[_loc4_].id == aryChart[currentMatch].mc.id)
      {
         _loc2_ = aryCompTourney[_loc4_];
      }
      else if(aryCompTourney[_loc4_].id == aryChart[currentMatch + 1].mc.id)
      {
         _loc3_ = aryCompTourney[_loc4_];
      }
      _loc4_ += 1;
   }
   txtRound.text = "ROUND " + aryChart[currentMatch].round;
   txtMatch.text = "MATCH " + (currentMatch / 2 + 1);
   animateChart(aryChart[currentMatch].round,aryChart[currentMatch].mc.id,aryChart[currentMatch + 1].mc.id);
   if(_loc2_.type == "H")
   {
      computerChartAnimationSwitch(false);
      _global.setTimeout(fetchComputerRace,1000,1,_loc3_.id);
   }
   else if(_loc3_.type == "H")
   {
      computerChartAnimationSwitch(false);
      _global.setTimeout(fetchComputerRace,1000,2,_loc2_.id);
   }
   else
   {
      _global.setTimeout(updateChartMatch,800,aryChart[currentMatch].round,aryChart[currentMatch].mc.id,aryChart[currentMatch + 1].mc.id,_loc2_.bt,_loc2_.rt,_loc2_.et,_loc2_.ts,_loc3_.bt,_loc3_.rt,_loc3_.et,_loc3_.ts);
      currentMatch += 2;
      if(currentMatch > aryChart.length)
      {
         computerChartAnimationSwitch(false);
      }
   }
}
function computerRaceHumanFinish(bt, rt, et, ts)
{
   var _loc5_ = undefined;
   var _loc6_ = undefined;
   var _loc7_ = 0;
   while(_loc7_ < aryCompTourney.length)
   {
      if(aryCompTourney[_loc7_].id == aryChart[currentMatch].mc.id)
      {
         _loc5_ = aryCompTourney[_loc7_];
         if(_loc5_.type == "H")
         {
            _loc5_.bt = bt;
            _loc5_.rt = rt;
            _loc5_.et = et;
            _loc5_.ts = ts;
         }
      }
      else if(aryCompTourney[_loc7_].id == aryChart[currentMatch + 1].mc.id)
      {
         _loc6_ = aryCompTourney[_loc7_];
         if(_loc6_.type == "H")
         {
            _loc6_.bt = bt;
            _loc6_.rt = rt;
            _loc6_.et = et;
            _loc6_.ts = ts;
         }
      }
      _loc7_ += 1;
   }
   txtRound.text = "ROUND " + aryChart[currentMatch].round;
   txtMatch.text = "MATCH " + (currentMatch / 2 + 1);
   updateChartMatch(aryChart[currentMatch].round,aryChart[currentMatch].mc.id,aryChart[currentMatch + 1].mc.id,_loc5_.bt,_loc5_.rt,_loc5_.et,_loc5_.ts,_loc6_.bt,_loc6_.rt,_loc6_.et,_loc6_.ts);
   currentMatch += 2;
   if(currentMatch > aryChart.length)
   {
      computerChartAnimationSwitch(false);
   }
   else
   {
      computerChartAnimationSwitch(true);
   }
}
function fetchComputerRace(myLane, caid)
{
   delete _global.chatObj.raceObj.r1Obj;
   delete _global.chatObj.raceObj.r2Obj;
   delete _global.chatObj.raceObj.oppObj;
   _global.chatObj.raceObj["r" + myLane + "Obj"] = _global.chatObj.raceObj.myObj;
   _root.ctRequest(caid);
}
function CB_ctRequest(txml, b)
{
   var _loc6_ = txml.firstChild.attributes;
   _global.chatObj.raceObj.bkDiff = b;
   _global.chatObj.raceObj.oppObj = new Object();
   _global.chatObj.raceObj.oppObj.id = _loc6_.cid;
   _global.chatObj.raceObj.oppObj.cid = _loc6_.cacid;
   _global.chatObj.raceObj.oppObj.un = lookupUserName(_loc6_.cid);
   _global.chatObj.raceObj.oppObj.racerNum = lookupRacerNum(_loc6_.cid);
   _global.chatObj.raceObj.oppObj.et = Number(_loc6_.et);
   _global.chatObj.raceObj.oppObj.rt = Number(_loc6_.rt);
   _global.chatObj.raceObj.oppObj.ts = Number(_loc6_.ts);
   _global.chatObj.raceObj.oppObj.bt = Number(_loc6_.bt);
   _global.chatObj.raceObj.oppObj.ppArr = _loc6_.pp.split(",");
   var _loc7_ = 1;
   while(_loc7_ < _global.chatObj.raceObj.oppObj.ppArr.length)
   {
      _global.chatObj.raceObj.oppObj.ppArr[_loc7_] = Number(_global.chatObj.raceObj.oppObj.ppArr[_loc7_ - 1]) + Number(_global.chatObj.raceObj.oppObj.ppArr[_loc7_]);
      _loc7_ += 1;
   }
   if(_global.chatObj.raceObj.r1Obj)
   {
      _global.chatObj.raceObj.r1Obj.racerNum = myRacerNum;
      _global.chatObj.raceObj.r2Obj = _global.chatObj.raceObj.oppObj;
   }
   else if(_global.chatObj.raceObj.r2Obj)
   {
      _global.chatObj.raceObj.r2Obj.racerNum = myRacerNum;
      _global.chatObj.raceObj.r1Obj = _global.chatObj.raceObj.oppObj;
   }
   classes.Lookup.addCallback("raceGetTwoRacersCars",this,CB_getTwoRacersCars,_global.chatObj.raceObj.r1Obj.cid + "," + _global.chatObj.raceObj.r2Obj.cid);
   _root.raceGetTwoRacersCars(_global.chatObj.raceObj.r1Obj.cid,_global.chatObj.raceObj.r2Obj.cid);
}
function CB_getTwoRacersCars(txml)
{
   _global.chatObj.twoRacersCarsXML = txml;
   chart._visible = false;
   this.showContainer("raceAnnounce",tourneyType);
}
var chartMC;
var maskMC;
var thumbMC;
var thumbSelectorMC;
var thumbWidth;
var thumbBitmapData;
var aryChart = new Array();
var depth;
