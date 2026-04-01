function clearHelp()
{
   helpBubble.removeMovieClip();
   panel.helpBubble.removeMovieClip();
}
function oppCarsCB(txml)
{
   oppCarsXML = new XML();
   oppCarsXML = txml;
   var _loc2_ = 0;
   while(_loc2_ < oppCarsXML.firstChild.childNodes.length)
   {
      if(oppCarsXML.firstChild.childNodes[_loc2_].attributes.i == oppCarsXML.firstChild.attributes.dc)
      {
         selOppCarXML = oppCarsXML.firstChild.childNodes[_loc2_];
         selOppCar = Number(selOppCarXML.attributes.i);
      }
      _loc2_ += 1;
   }
   if(!selOppCar)
   {
      selOppCarXML = oppCarsXML.firstChild.childNodes[0];
      selOppCar = Number(selOppCarXML.attributes.i);
   }
   gotoAndStop("oppCar");
   play();
}
function loadPlate(pid, seq)
{
   classes.Drawing.plateView(plate,pid,seq,45,true,true);
}
function goOppUser(oid, oname)
{
   oppID = oid;
   oppName = oname;
   gotoAndStop("oppCarLU");
   play();
}
function drawTeamList()
{
   var _loc4_;
   var _loc3_;
   for(var _loc8_ in teamList)
   {
      _loc4_ = false;
      if(_loc8_.indexOf("item") > -1)
      {
         _loc3_ = 0;
         while(_loc3_ < teamListXML.firstChild.childNodes.length)
         {
            if(teamList[_loc8_].teamID == teamListXML.firstChild.childNodes[_loc3_].attributes.i)
            {
               _loc4_ = true;
               break;
            }
            _loc3_ += 1;
         }
      }
      if(!_loc4_)
      {
         teamList[_loc8_].removeMovieClip();
      }
   }
   if(!teamListXML.firstChild.childNodes.length)
   {
      fldNoTeams.text = "NO QUALIFYING TEAMS FOUND.";
      return undefined;
   }
   _loc3_ = 0;
   var _loc2_;
   while(_loc3_ < teamListXML.firstChild.childNodes.length)
   {
      if(teamList["item" + teamListXML.firstChild.childNodes[_loc3_].attributes.i] == undefined)
      {
         _loc2_ = teamList.attachMovie("teamListSelectorItem","item" + teamListXML.firstChild.childNodes[_loc3_].attributes.i,teamList.getNextHighestDepth(),{teamID:teamListXML.firstChild.childNodes[_loc3_].attributes.i,teamName:teamListXML.firstChild.childNodes[_loc3_].attributes.n,userName:teamListXML.firstChild.childNodes[_loc3_].attributes.l,teamCred:teamListXML.firstChild.childNodes[_loc3_].attributes.sc,maxBet:"max bet: $" + classes.NumFuncs.commaFormat(Number(teamListXML.firstChild.childNodes[_loc3_].attributes.mb))});
         _loc2_.createEmptyMovieClip("teamPic",_loc2_.getNextHighestDepth());
         classes.Drawing.portrait(_loc2_.teamPic,teamListXML.firstChild.childNodes[_loc3_].attributes.i,2,0,0,2,false,"teamavatars");
         _loc2_.teamPic.photo._xscale = 50;
         _loc2_.teamPic.photo._yscale = 50;
         _loc2_.createEmptyMovieClip("userPic",_loc2_.getNextHighestDepth());
         classes.Drawing.portrait(_loc2_.userPic,teamListXML.firstChild.childNodes[_loc3_].attributes.li,2,0,0,4);
         _loc2_.userPic.photo._xscale = 25;
         _loc2_.userPic.photo._yscale = 25;
         _loc2_.userPic._x = 155;
         _loc2_.userPic._y = -1;
         _loc2_.onRelease = function()
         {
            selTeam = Number(this.teamID);
            selTeamName = this.teamName;
            gotoAndStop("type");
            play();
         };
      }
      _loc3_ += 1;
   }
   orderTeamList();
}
function orderTeamList()
{
   teamList.clear();
   var vMargin = 6;
   var vSpace = 54;
   var orderArr = new Array();
   var i = 0;
   while(i < teamListXML.firstChild.childNodes.length)
   {
      if(teamListXML.firstChild.childNodes[i].attributes.i != classes.GlobalData.attr.ti)
      {
         orderArr.push({id:teamListXML.firstChild.childNodes[i].attributes.i,teamID:teamListXML.firstChild.childNodes[i].attributes.ti,tName:teamListXML.firstChild.childNodes[i].attributes.n});
      }
      i++;
   }
   orderArr.sortOn(["tName"]);
   var yPointer = vMargin;
   var tCounter;
   i = 0;
   while(i < orderArr.length)
   {
      teamList["item" + orderArr[i].id]._y = yPointer;
      yPointer += vSpace;
      teamList["item" + orderArr[i].id].swapDepths(0);
      teamList["item" + orderArr[i].id].swapDepths(i + 1);
      i++;
   }
   with(teamList)
   {
      moveTo(0,0);
      beginFill(0,0);
      lineTo(10,0);
      lineTo(10,_height + vMargin);
      endFill();
   }
   teamList.maskH = listMask._height;
   teamList.maskT = listMask._y;
   teamList._y = maskT;
   if(teamList._height - 20 > listMask._height)
   {
      teamList.onEnterFrame = function()
      {
         if(listMask.hitTest(_root._xmouse,_root._ymouse,false))
         {
            this.frac = (this._parent._ymouse - this.maskT) / this.maskH;
            this._y = this.maskT - (this._height - this.maskH - 20) * this.frac;
         }
      };
   }
   else
   {
      delete teamList.onEnterFrame;
      teamList._y = maskT;
   }
}
function onBtnAddClick()
{
   trace(this.teamIdx + ", " + this.idx);
   popSelectCar._visible = false;
   if(this.teamIdx == 1)
   {
      popSelectRacer._x = 13;
      popSelectRacer.bg.pointer._xscale = 100;
      popSelectRacer.bg.pointer._x = 147;
   }
   else
   {
      popSelectRacer._x = 610;
      popSelectRacer.bg.pointer._xscale = -100;
      popSelectRacer.bg.pointer._x = 0;
   }
   popSelectRacer.bg.pointer._y = this._y - popSelectRacer._y + 8;
   var _loc3_ = getChallengeObject();
   var _loc4_ = new XML(_global.chatObj.userListXML.toString());
   var _loc5_ = 0;
   var _loc6_ = undefined;
   while(_loc5_ < _loc4_.firstChild.childNodes.length)
   {
      if(_loc4_.firstChild.childNodes[_loc5_].attributes.ti != this.teamID)
      {
         _loc4_.firstChild.childNodes[_loc5_].removeNode();
         _loc5_ -= 1;
      }
      else
      {
         _loc6_ = 0;
         while(_loc6_ < _loc3_["team" + this.teamIdx + "RacersArr"].length)
         {
            trace("j " + _loc6_ + ": " + _loc4_.firstChild.childNodes[_loc5_].attributes.i + " == " + _loc3_["team" + this.teamIdx + "RacersArr"][_loc6_]);
            if(_loc4_.firstChild.childNodes[_loc5_].attributes.i == _loc3_["team" + this.teamIdx + "RacersArr"][_loc6_])
            {
               _loc4_.firstChild.childNodes[_loc5_].removeNode();
               _loc5_ -= 1;
               break;
            }
            _loc6_ += 1;
         }
      }
      _loc5_ += 1;
   }
   popSelectRacer.drawUserList(_loc4_);
   popSelectRacer.teamIdx = this.teamIdx;
   popSelectRacer.idx = this.idx;
   popSelectRacer._visible = true;
}
function getChallengeObject()
{
   var _loc2_ = new Object();
   _loc2_.team1RacersArr = new Array();
   _loc2_.team1CarsArr = new Array();
   _loc2_.team2RacersArr = new Array();
   _loc2_.team2CarsArr = new Array();
   var _loc3_ = 1;
   var _loc4_ = undefined;
   while(_loc3_ <= 2)
   {
      _loc4_ = 1;
      while(_loc4_ <= 4)
      {
         if(this["team" + _loc3_ + "Slot" + _loc4_]._visible)
         {
            _loc2_["team" + _loc3_ + "RacersArr"][_loc4_ - 1] = this["team" + _loc3_ + "Slot" + _loc4_].userID;
            _loc2_["team" + _loc3_ + "CarsArr"][_loc4_ - 1] = this["team" + _loc3_ + "Slot" + _loc4_].selCar;
         }
         _loc4_ += 1;
      }
      _loc3_ += 1;
   }
   return _loc2_;
}
function checkMatches()
{
   var _loc2_ = getChallengeObject();
   var _loc3_ = true;
   var _loc4_ = 0;
   while(_loc4_ < _loc2_.team1RacersArr.length)
   {
      if(!_loc2_.team1RacersArr[_loc4_] && !_loc2_.team2RacersArr[_loc4_])
      {
         _loc2_.team1RacersArr.splice(0,1);
         _loc2_.team1CarsArr.splice(0,1);
         _loc2_.team2RacersArr.splice(0,1);
         _loc2_.team2CarsArr.splice(0,1);
         _loc4_ -= 1;
      }
      else if(!_loc2_.team1RacersArr[_loc4_] || !_loc2_.team2RacersArr[_loc4_])
      {
         _root.displayAlert("warning","Missing Opponent","One of the matches only has one racer.  Please make sure every match you set up has two racers, one for each team.");
         return undefined;
      }
      _loc4_ += 1;
   }
   if(_loc2_.team1RacersArr.length < 2)
   {
      _root.displayAlert("warning","Not Enough Matches","You must set up at least two matches to create a team challenge.");
      return undefined;
   }
   trace(selTeam + ", " + _loc2_.team1RacersArr.toString() + ", " + _loc2_.team2RacersArr.toString() + ", " + _loc2_.team1CarsArr.toString() + ", " + _loc2_.team2CarsArr.toString() + ", " + betAmount + ", " + (raceType != 2 ? 1 : 0));
   var _loc5_ = false;
   _loc4_ = 0;
   while(_loc4_ < _loc2_.team1RacersArr.length)
   {
      if(!Number(_loc2_.team1RacersArr[_loc4_]))
      {
         _loc5_ = true;
      }
      _loc4_ += 1;
   }
   _loc4_ = 0;
   while(_loc4_ < _loc2_.team2RacersArr.length)
   {
      if(!Number(_loc2_.team2RacersArr[_loc4_]))
      {
         _loc5_ = true;
      }
      _loc4_ += 1;
   }
   _loc4_ = 0;
   while(_loc4_ < _loc2_.team1CarsArr.length)
   {
      if(!Number(_loc2_.team1CarsArr[_loc4_]))
      {
         _loc5_ = true;
      }
      _loc4_ += 1;
   }
   _loc4_ = 0;
   while(_loc4_ < _loc2_.team2CarsArr.length)
   {
      if(!Number(_loc2_.team2CarsArr[_loc4_]))
      {
         _loc5_ = true;
      }
      _loc4_ += 1;
   }
   if(_loc5_)
   {
      trace("error in values");
      return undefined;
   }
   if(_loc2_.team1RacersArr.length == _loc2_.team1CarsArr.length && _loc2_.team1RacersArr.length == _loc2_.team2RacersArr.length && _loc2_.team1RacersArr.length == _loc2_.team2CarsArr.length)
   {
      gotoAndStop("sending");
      play();
      _root.teamRivalsRequest(selTeam,_loc2_.team1RacersArr.toString(),_loc2_.team2RacersArr.toString(),_loc2_.team1CarsArr.toString(),_loc2_.team2CarsArr.toString(),betAmount,raceType != 2 ? 1 : 0,betType != 2 ? 0 : 1);
   }
   else
   {
      _root.displayAlert("warning","Error Setting Up Matches","There is some error in the challenge you created.  Please fix the error and try again.");
   }
}
