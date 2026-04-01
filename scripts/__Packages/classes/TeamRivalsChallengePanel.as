class classes.TeamRivalsChallengePanel extends MovieClip
{
   var panel;
   var clr;
   var id;
   var detailNode;
   static var _MC;
   static var arrList;
   function TeamRivalsChallengePanel()
   {
      super();
      classes.TeamRivalsChallengePanel._MC = this;
      this.init();
   }
   function init()
   {
      this.panel.cover.useHandCursor = false;
      if(!_global.chatObj.challengesXML.firstChild.childNodes.length)
      {
         this.panel._visible = false;
      }
   }
   static function addChallenge(xmlStr)
   {
      var _loc3_ = new XML(xmlStr);
      if(!_global.chatObj.challengesXML)
      {
         _global.chatObj.challengesXML = new XML("<chall></chall>");
      }
      _global.chatObj.challengesXML.firstChild.appendChild(_loc3_.firstChild);
      classes.TeamRivalsChallengePanel._MC.drawIncomingList();
   }
   static function removeChallenge(id)
   {
      trace("removeChallenge: " + id);
      var _loc3_ = undefined;
      var _loc4_ = 0;
      while(_loc4_ < _global.chatObj.challengesXML.firstChild.childNodes.length)
      {
         if(id == _global.chatObj.challengesXML.firstChild.childNodes[_loc4_].attributes.id)
         {
            _global.chatObj.challengesXML.firstChild.childNodes[_loc4_].removeNode();
            _loc3_ = true;
            break;
         }
         _loc4_ += 1;
      }
      if(_loc3_ && !classes.RacePlay._MC.myLane)
      {
         classes.TeamRivalsChallengePanel._MC.drawIncomingList();
      }
   }
   static function clearChallenges()
   {
      _global.chatObj.challengesXML = new XML("<chall></chall>");
      classes.TeamRivalsChallengePanel._MC.drawIncomingList();
   }
   static function clearChallengesFrom(uid)
   {
      trace("clearChallengesFrom: " + uid);
      var _loc3_ = undefined;
      var _loc4_ = 0;
      var _loc5_ = undefined;
      while(_loc4_ < _global.chatObj.challengesXML.firstChild.childNodes.length)
      {
         _loc3_ = _global.chatObj.challengesXML.firstChild.childNodes[_loc4_];
         if(_loc3_.attributes.ai1 == uid)
         {
            classes.TeamRivalsChallengePanel.removeChallenge(_loc3_.attributes.id);
         }
         else
         {
            _loc5_ = 0;
            while(_loc5_ < _loc3_.childNodes.length)
            {
               if(_loc3_.childNodes[_loc5_].attributes.ai1 == uid || _loc3_.childNodes[_loc5_].attributes.ai2 == uid)
               {
                  classes.TeamRivalsChallengePanel.removeChallenge(_loc3_.attributes.id);
               }
               _loc5_ += 1;
            }
         }
         _loc4_ += 1;
      }
   }
   function drawIncomingList()
   {
      trace("drawIncomingList");
      if(classes.RacePlay._MC.myLane)
      {
         return undefined;
      }
      classes.TeamRivalsChallengePanel.arrList = _global.chatObj.challengesXML.firstChild.childNodes;
      var _loc3_ = undefined;
      var _loc4_ = undefined;
      for(var _loc5_ in this.panel.rivalsList)
      {
         _loc3_ = false;
         _loc4_ = 0;
         while(_loc4_ < classes.TeamRivalsChallengePanel.arrList.length)
         {
            if(classes.TeamRivalsChallengePanel.arrList[_loc4_].attributes.id == this.panel.rivalsList[_loc5_].id)
            {
               _loc3_ = true;
            }
            _loc4_ += 1;
         }
         if(!_loc3_)
         {
            trace("caught & remove: " + _loc5_);
            this.panel.rivalsList[_loc5_].removeMovieClip();
         }
      }
      var _loc6_ = 0;
      var _loc7_ = undefined;
      while(_loc6_ < classes.TeamRivalsChallengePanel.arrList.length)
      {
         if(this.panel.rivalsList["item" + classes.TeamRivalsChallengePanel.arrList[_loc6_].attributes.id] == undefined)
         {
            trace("creating: item" + classes.TeamRivalsChallengePanel.arrList[_loc6_].attributes.id);
            _loc7_ = this.panel.rivalsList.attachMovie("teamRivalsListItem","item" + classes.TeamRivalsChallengePanel.arrList[_loc6_].attributes.id,this.panel.rivalsList.getNextHighestDepth(),{id:classes.TeamRivalsChallengePanel.arrList[_loc6_].attributes.id,userName:classes.Lookup.buddyName(classes.TeamRivalsChallengePanel.arrList[_loc6_].attributes.ai1),teamName:this._parent.lookupTeamName(classes.TeamRivalsChallengePanel.arrList[_loc6_].attributes.ti1),teamID:classes.TeamRivalsChallengePanel.arrList[_loc6_].attributes.ti1});
            _loc7_._x = -3;
            classes.Drawing.portrait(_loc7_,classes.TeamRivalsChallengePanel.arrList[_loc6_].attributes.ai1,2,0,0,4,false,"teamavatars");
            _loc7_.photo._xscale = _loc7_.photo._yscale = 25;
            _loc7_.photo._x = 115;
            this.panel.rivalsList["item" + classes.TeamRivalsChallengePanel.arrList[_loc6_].attributes.id].onRollOver = this.panel.rivalsList["item" + classes.TeamRivalsChallengePanel.arrList[_loc6_].attributes.id].onDragOver = function()
            {
               this.clr = new Color(this);
               this.clr.setTransform({rb:80,gb:80,bb:80});
            };
            this.panel.rivalsList["item" + classes.TeamRivalsChallengePanel.arrList[_loc6_].attributes.id].onRollOut = this.panel.rivalsList["item" + classes.TeamRivalsChallengePanel.arrList[_loc6_].attributes.id].onDragOut = function()
            {
               this.clr.setTransform({rb:0,gb:0,bb:0});
            };
            this.panel.rivalsList["item" + classes.TeamRivalsChallengePanel.arrList[_loc6_].attributes.id].onRelease = function()
            {
               this.clr.setTransform({rb:0,gb:0,bb:0});
               classes.TeamRivalsChallengePanel._MC.showDetail(this.id);
            };
            _loc7_.cacheAsBitmap = true;
         }
         _loc6_ += 1;
      }
      this.orderIncomingList();
   }
   function orderIncomingList()
   {
      var _loc2_ = 30;
      var _loc3_ = classes.TeamRivalsChallengePanel.arrList.length;
      if(!_loc3_)
      {
         _loc3_ = 0;
      }
      var _loc4_ = 0;
      while(_loc4_ < _loc3_)
      {
         this.panel.rivalsList["item" + classes.TeamRivalsChallengePanel.arrList[_loc4_].attributes.id]._y = _loc4_ * _loc2_;
         _loc4_ += 1;
      }
      this.panel.txtCount = "(" + _loc3_ + ")";
      if(_loc3_ > 0)
      {
         this.panel._visible = true;
      }
      else if(this._currentframe == 1)
      {
         this.panel._visible = false;
      }
   }
   function showDetail(id)
   {
      var _loc3_ = 0;
      while(_loc3_ < classes.TeamRivalsChallengePanel.arrList.length)
      {
         trace(classes.TeamRivalsChallengePanel.arrList[_loc3_].attributes.id);
         if(classes.TeamRivalsChallengePanel.arrList[_loc3_].attributes.id == id)
         {
            this.detailNode = classes.TeamRivalsChallengePanel.arrList[_loc3_];
            break;
         }
         _loc3_ += 1;
      }
      this.gotoAndPlay("detail");
   }
}
