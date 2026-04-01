stop();
_global.testShowTestDriveExpiredOnDialogClose = false;
classes.Frame._MC.createMap();
classes.Frame._MC.showInitTabs();
classes.Frame._MC.overlay.emailIcon._visible = true;
classes.Frame._MC.overlay.carIcon._visible = true;
if(classes.ShopMenu2 != undefined && classes.ShopMenu2.__missingStoreTypePatch != true)
{
   classes.ShopMenu2.__missingStoreTypePatch = true;
   classes.ShopMenu2.prototype.init = function()
   {
      var _loc2_ = 0;
      if(this.partCatXML != undefined && this.partCatXML.firstChild != undefined)
      {
         this.partCatXML = new XML(this.partCatXML.toString());
         this.partCatXML.ignoreWhite = true;
         while(_loc2_ < this.partCatXML.firstChild.childNodes.length)
         {
            if(this.partCatXML.firstChild.childNodes[_loc2_].attributes.s == undefined || this.partCatXML.firstChild.childNodes[_loc2_].attributes.s == "")
            {
               this.partCatXML.firstChild.childNodes[_loc2_].attributes.s = String(this.storeType);
            }
            _loc2_ += 1;
         }
      }
      this.__MC._y = this.yShow;
      this.__MC.onEnterFrame = function()
      {
         if(this.hitTest(_root._xmouse,_root._ymouse))
         {
            this.objRef.showPanel();
            delete this.onEnterFrame;
         }
      };
      this.getCategoryAvailability(0,this.partXML);
      this.getCategory(0,0);
   };
}
if(classes.ShopMenu2CPR != undefined && classes.ShopMenu2CPR.__missingStoreTypePatch != true)
{
   classes.ShopMenu2CPR.__missingStoreTypePatch = true;
   classes.ShopMenu2CPR.prototype.init = function()
   {
      var _loc2_ = 0;
      if(this.partCatXML != undefined && this.partCatXML.firstChild != undefined)
      {
         this.partCatXML = new XML(this.partCatXML.toString());
         this.partCatXML.ignoreWhite = true;
         while(_loc2_ < this.partCatXML.firstChild.childNodes.length)
         {
            if(this.partCatXML.firstChild.childNodes[_loc2_].attributes.s == undefined || this.partCatXML.firstChild.childNodes[_loc2_].attributes.s == "")
            {
               this.partCatXML.firstChild.childNodes[_loc2_].attributes.s = "1";
            }
            _loc2_ += 1;
         }
      }
      this.__MC._y = this.yShow;
      this.__MC.onEnterFrame = function()
      {
         if(this.hitTest(_root._xmouse,_root._ymouse))
         {
            this.objRef.showPanel();
            delete this.onEnterFrame;
         }
      };
      this.getCategoryAvailability(0,this.partXML);
      this.getCategory(0,0);
   };
}
_root.openPracticeTrack = function()
{
   if(classes.GlobalData.getSelectedCarXML() == undefined)
   {
      _root.displayAlert("warning","Practice Track Error","Sorry, no active car is available for practice.");
      return undefined;
   }
   if(_root.practiceTrackMC != undefined)
   {
      _root.practiceTrackMC.removeMovieClip();
   }
   if(_root.eventHolder != undefined)
   {
      _root.eventHolder.removeMovieClip();
   }
   Object.registerClass("practiceTrack",classes.mc.TrackPractice);
   _root.attachMovie("practiceTrack","practiceTrackMC",_root.getNextHighestDepth());
   if(_root.practiceTrackMC == undefined)
   {
      _root.displayAlert("warning","Practice Track Error","Sorry, the practice track could not be opened in this build.");
      return undefined;
   }
   _root.practiceTrackMC._x = 0;
   _root.practiceTrackMC._y = 0;
   classes.Control.setMapButton("practice");
};
_root.practiceCreate = function(acid)
{
   if(classes.Control.serverAvail())
   {
      classes.Frame.serverLights(true);
      classes.GlobalData.currentAccountCarID = acid;
      legacyCall("executeCall \"practice\", \"acid=" + acid + "\"","practiceCreateCB","POST");
   }
};
_root.practiceCreateCB = function(s)
{
   function CB_getTwoRacersCars(pxml)
   {
      if(classes.mc.TrackPractice._mc != undefined && classes.mc.TrackPractice._mc.resetTrack != undefined)
      {
         classes.mc.TrackPractice._mc.resetTrack();
      }
      else if(_root.practiceTrackMC != undefined && _root.practiceTrackMC.resetTrack != undefined)
      {
         _root.practiceTrackMC.resetTrack();
      }
   }
   classes.Frame.serverLights(false);
   classes.Control.serverUnlock();
   if(Number(s) == 1)
   {
      classes.Lookup.addCallback("raceGetTwoRacersCars",this,CB_getTwoRacersCars,String(classes.GlobalData.currentAccountCarID));
      _root.raceGetTwoRacersCars(classes.GlobalData.currentAccountCarID);
      return undefined;
   }
   if(Number(s) == -1)
   {
      if(classes.GlobalData.priorSelectedCarID)
      {
         _root.updateDefaultCar(classes.GlobalData.priorSelectedCarID);
         classes.mc.TrackPractice._mc.selCarID = classes.GlobalData.priorSelectedCarID;
         classes.mc.TrackPractice._mc.selCarXML = new XML(classes.GlobalData.getSelectedCarXML().toString());
      }
      _root.markTestDriveExpiredAndDisplayWarning();
      return undefined;
   }
   _root.displayAlert("warning","Practice Track Error","Sorry, there was a problem creating the practice session.");
};
_root.practiceStatsCB = function(xmlStr)
{
   trace("practiceStatsCB: " + xmlStr);
};
_root.practiceFinishCB = function(et, ts)
{
   var _loc4_ = classes.mc.TrackPractice._mc != undefined ? classes.mc.TrackPractice._mc : _root.practiceTrackMC;
   if(_loc4_ != undefined && _loc4_.finishRace != undefined)
   {
      _loc4_.finishRace(et,ts);
      return undefined;
   }
   _root.displayAlert("warning","Practice Complete","ET: " + et + "\rTS: " + ts);
};
if(classes.Race != undefined && !classes.Race.__httpPracticeSoloRenderPatch)
{
   classes.Race.__httpPracticeSoloRenderPatch = true;
   classes.Race.prototype.__httpOriginalSetAmComp = classes.Race.prototype.setAmComp;
   classes.Race.prototype.setAmComp = function()
   {
      this.__httpOriginalSetAmComp();
      if(_global.chatObj == undefined || _global.chatObj.roomType != "PT" || this.amComp == undefined)
      {
         return undefined;
      }
      var _loc3_ = this.amComp;
      _loc3_.dCam = 0;
      this["car" + this.oppLane]._visible = false;
      if(this.gauge != undefined && this.gauge["car" + this.oppLane] != undefined)
      {
         this.gauge["car" + this.oppLane]._visible = false;
      }
      _loc3_.renderBothCars = function()
      {
         classes.Race._MC.setCarBounce(this.m,this.myObj.v);
         var _loc2_ = Math.min(this.myObj.d,1358);
         _loc2_ = Math.max(0,_loc2_);
         classes.Race._MC.showTrackAtPos(_loc2_);
         var _loc3_ = this.scaleLength + (this.myObj.d - _loc2_);
         if(_loc3_ < -4)
         {
            classes.Race._MC["car" + this.m]._visible = false;
            classes.Race._MC.hideWheels(this.m);
         }
         else
         {
            classes.Race._MC.renderCar(this.m,_loc3_);
            classes.Race._MC.turnWheels(this.m,this.myObj.d);
         }
         classes.Race._MC.gauge["car" + this.m]._y = (- this.myObj.d) / 1320 * classes.Race._MC.gauge.trackBar._height;
         classes.Race._MC["car" + this.r]._visible = false;
         if(classes.Race._MC.gauge != undefined && classes.Race._MC.gauge["car" + this.r] != undefined)
         {
            classes.Race._MC.gauge["car" + this.r]._visible = false;
         }
         var _loc4_ = (_loc2_ - this.dCam) * 30;
         this.dCam = _loc2_;
         classes.Race._MC.setScreenJitter(_loc4_);
      };
      _loc3_.onEnterFrame = function()
      {
         this.renderBothCars();
      };
   };
}
if(classes.Race != undefined && !classes.Race.__httpLiveStageRenderPatch)
{
   classes.Race.__httpLiveStageRenderPatch = true;
   classes.Race.prototype.__httpOriginalSetAmLive = classes.Race.prototype.setAmLive;
   classes.Race.prototype.setAmLive = function()
   {
      this.__httpOriginalSetAmLive();
      if(this.amLive == undefined)
      {
         return undefined;
      }
      this.amLive.onEnterFrame = function()
      {
         this.renderBothCars();
      };
   };
}
if(classes.RaceTreeLights != undefined && !classes.RaceTreeLights.__httpAuthoritativeTimerPatch)
{
   classes.RaceTreeLights.__httpAuthoritativeTimerPatch = true;
   classes.RaceTreeLights.prototype.__httpInitLightState = function()
   {
      var _loc2_ = new Array("pre1","pre2","staged1","staged2","amber11","amber21","amber31","green1","red1","amber12","amber22","amber32","green2","red2");
      var _loc3_ = 0;
      while(_loc3_ < _loc2_.length)
      {
         this[_loc2_[_loc3_]]._visible = false;
         this[_loc2_[_loc3_]].isOn = false;
         _loc3_ += 1;
      }
   };
   classes.RaceTreeLights.prototype.__httpGetRemainingStageSeconds = function()
   {
      var _loc2_ = _global.chatObj == undefined ? undefined : _global.chatObj.raceObj;
      var _loc3_ = new Date().getTime();
      if(_loc2_ != undefined && _loc2_.stageDeadlineTS != undefined && !isNaN(Number(_loc2_.stageDeadlineTS)))
      {
         return Math.max(0,Math.ceil((Number(_loc2_.stageDeadlineTS) - _loc3_) / 1000));
      }
      if(_loc2_ != undefined && _loc2_.timeToStage)
      {
         return Math.max(0,Number(_loc2_.timeToStage) - Math.floor((_loc3_ - Number(_loc2_.stageTS)) / 1000));
      }
      return 0;
   };
   classes.RaceTreeLights.prototype.init = function()
   {
      this.clearTimer();
      this.__httpInitLightState();
      this.ccTime = this.__httpGetRemainingStageSeconds();
      this.txtTime = this.ccTime > 0 ? String(this.ccTime) : "";
      if(this.ccTime > 0)
      {
         this.ccSI = _global.setTimeout(this,"count",250);
      }
      else if(!this._parent.isRaceView)
      {
         this.onTimeOut();
      }
   };
   classes.RaceTreeLights.prototype.count = function()
   {
      this.clearTimer();
      this.ccTime = this.__httpGetRemainingStageSeconds();
      this.txtTime = this.ccTime > 0 ? String(this.ccTime) : "";
      if(this.ccTime > 0)
      {
         this.ccSI = _global.setTimeout(this,"count",250);
      }
      else
      {
         this.onTimeOut();
      }
   };
   classes.RaceTreeLights.prototype.clearTimer = function()
   {
      _global.clearTimeout(this.ccSI);
      delete this.ccSI;
      this.txtTime = "";
   };
}
_root.httpRaceClearTreeSchedule = function()
{
   if(_global.httpRaceTreeSchedule == undefined)
   {
      _global.httpRaceTreeSchedule = new Array();
   }
   while(_global.httpRaceTreeSchedule.length > 0)
   {
      _global.clearTimeout(_global.httpRaceTreeSchedule.pop());
   }
};
_root.httpRaceResetTreeSequence = function(clearRed)
{
   var _loc2_ = new Array("amber1","amber2","amber3","green");
   var _loc3_ = 0;
   while(_loc3_ < _loc2_.length)
   {
      raceTreeMovie.setLight(0,_loc2_[_loc3_],false);
      _loc3_ += 1;
   }
   if(clearRed)
   {
      raceTreeMovie.setLight(0,"red",false);
   }
};
_root.httpRaceFireScheduledLight = function(lightName)
{
   if(raceTreeMovie == undefined || classes.RacePlay == undefined || classes.RacePlay._MC == undefined)
   {
      return undefined;
   }
   if(lightName == "green" && (raceTreeMovie.red1.isOn || raceTreeMovie.red2.isOn))
   {
      return undefined;
   }
   raceTreeMovie.setLight(0,lightName,true);
};
_root.httpRaceScheduleTreeLight = function(lightName, eventTS)
{
   var _loc5_ = Math.max(0,Number(eventTS) - new Date().getTime());
   if(_loc5_ <= 0)
   {
      _root.httpRaceFireScheduledLight(lightName);
      return undefined;
   }
   if(_global.httpRaceTreeSchedule == undefined)
   {
      _global.httpRaceTreeSchedule = new Array();
   }
   _global.httpRaceTreeSchedule.push(_global.setTimeout(_root,"httpRaceFireScheduledLight",_loc5_,lightName));
};
_root.httpRaceScheduleTreeFromStage = function(stageTS)
{
   var _loc3_ = Number(stageTS);
   if(isNaN(_loc3_))
   {
      return undefined;
   }
   _root.httpRaceClearTreeSchedule();
   _root.httpRaceResetTreeSequence(false);
   _root.httpRaceScheduleTreeLight("amber1",_loc3_ + 3000);
   _root.httpRaceScheduleTreeLight("amber2",_loc3_ + 3500);
   _root.httpRaceScheduleTreeLight("amber3",_loc3_ + 4000);
   _root.httpRaceScheduleTreeLight("green",_loc3_ + 4500);
};
_root.runEngineStart = function(bet)
{
   if(bet == undefined || bet == "")
   {
      bet = 0;
   }
   legacyCall("runEngineStart " + bet,"raceKOTHOKCB","POST");
};
_root.raceKOTHOKCB = function(bet, t, stageDeadlineTS)
{
   if(_global.chatObj.raceObj.r1Obj != undefined && classes.GlobalData.id == _global.chatObj.raceObj.r1Obj.id || _global.chatObj.raceObj.r2Obj != undefined && classes.GlobalData.id == _global.chatObj.raceObj.r2Obj.id)
   {
      classes.Control.setMapButton("racing");
      _global.chatObj.raceObj.imRacer = true;
   }
   _root.httpRaceClearTreeSchedule();
   if(raceTreeMovie != undefined)
   {
      _root.httpRaceResetTreeSequence(true);
      raceTreeMovie.clearTimer();
   }
   _global.chatObj.raceObj.bt = Number(bet);
   _global.chatObj.raceObj.stageTS = new Date().getTime();
   _global.chatObj.raceObj.timeToStage = Number(t);
   if(stageDeadlineTS != undefined && !isNaN(Number(stageDeadlineTS)))
   {
      _global.chatObj.raceObj.stageDeadlineTS = Number(stageDeadlineTS);
   }
   else
   {
      _global.chatObj.raceObj.stageDeadlineTS = Number(_global.chatObj.raceObj.stageTS) + Number(t) * 1000;
   }
   if(_global.chatObj.roomType != "PT")
   {
      _global.chatObj.raceRoomMC.showContainer();
   }
};
_root.runEngineStop = function()
{
   _root.httpRaceClearTreeSchedule();
   legacyCall("runEngineStop","runEngineControlCB","POST");
};
_root.runEngineControlCB = function()
{
};
_root.runEngineSetLightOnCB = function(position, lightName, lightTS)
{
   var _loc6_ = undefined;
   switch(position)
   {
      case "p":
         _loc6_ = _global.chatObj.raceRoomMC.container.myLane;
         break;
      case "o":
         _loc6_ = _global.chatObj.raceRoomMC.container.oppLane;
         break;
      case "1":
         _loc6_ = 1;
         break;
      case "2":
         _loc6_ = 2;
         break;
      case "b":
         _loc6_ = 0;
   }
   if(lightName == "staged" && (position == "p" || position == "b") && lightTS != undefined)
   {
      _global.chatObj.raceObj.stageTS = Number(lightTS);
      _global.chatObj.raceObj.timeToStage = 3;
      _global.chatObj.raceObj.stageDeadlineTS = Number(lightTS) + 3000;
      if(raceTreeMovie != undefined)
      {
         raceTreeMovie.init();
      }
      _root.httpRaceScheduleTreeFromStage(lightTS);
   }
   else if(lightName == "green" || lightName == "red")
   {
      _root.httpRaceClearTreeSchedule();
   }
   if(lightName == "red")
   {
      raceTreeMovie.setLight(_loc6_,"green",false);
      raceTreeMovie.setLight(_loc6_,lightName,true);
   }
   else
   {
      if((_loc6_ == 0 || _loc6_ == 1) && !raceTreeMovie.red1._visible)
      {
         raceTreeMovie.setLight(1,lightName,true);
      }
      if((_loc6_ == 0 || _loc6_ == 2) && !raceTreeMovie.red2._visible)
      {
         raceTreeMovie.setLight(2,lightName,true);
      }
   }
};
_root.runEngineSetLightOffCB = function(position, lightName, lightTS)
{
   var _loc6_ = undefined;
   switch(position)
   {
      case "p":
         _loc6_ = _global.chatObj.raceRoomMC.container.myLane;
         break;
      case "o":
         _loc6_ = _global.chatObj.raceRoomMC.container.oppLane;
         break;
      case "1":
         _loc6_ = 1;
         break;
      case "2":
         _loc6_ = 2;
         break;
      case "b":
         _loc6_ = 0;
   }
   if(lightName == "staged")
   {
      _root.httpRaceClearTreeSchedule();
      _root.httpRaceResetTreeSequence(false);
   }
   if(_loc6_ == 0 || _loc6_ == 1)
   {
      raceTreeMovie.setLight(1,lightName,false);
   }
   if(_loc6_ == 0 || _loc6_ == 2)
   {
      raceTreeMovie.setLight(2,lightName,false);
   }
};
_root.runEngineSetMyRTCB = function(rt)
{
   _root.httpRaceClearTreeSchedule();
   classes.RacePlay._MC.tripWire(classes.GlobalData.id,rt);
   if(rt < 0 && (_global.chatObj == undefined || _global.chatObj.roomType != "PT"))
   {
      classes.Control.ctourneyMC.finishCompRace(-1,-1);
   }
};
_root.raceStartTimeCB = function()
{
   _root.httpRaceClearTreeSchedule();
   if(raceTreeMovie != undefined)
   {
      raceTreeMovie.clearTimer();
   }
   classes.RacePlay._MC.onRaceStartTime();
};
var _loc1_;
if(_global.httpHudAttrCache != undefined)
{
   _loc1_ = _global.httpHudAttrCache;
}
else if(_global.loginAttrCache != undefined)
{
   _loc1_ = _global.loginAttrCache;
}
else if(_global.loginXML != undefined && _global.loginXML.firstChild != undefined && _global.loginXML.firstChild.firstChild != undefined)
{
   _loc1_ = _global.loginXML.firstChild.firstChild.attributes;
}
else if(classes.GlobalData.attr != undefined)
{
   _loc1_ = classes.GlobalData.attr;
}
if(_loc1_ != undefined)
{
   if(_root.setHttpHudAttrCache != undefined)
   {
      _root.setHttpHudAttrCache(_loc1_);
   }
   else
   {
      _global.httpHudAttrCache = new Object();
      for(var _loc3_ in _loc1_)
      {
         _global.httpHudAttrCache[_loc3_] = _loc1_[_loc3_];
      }
   }
   if(_root.ensureHttpLoginXmlFromCache != undefined)
   {
      _root.ensureHttpLoginXmlFromCache();
   }
   var _loc4_ = _global.loginXML != undefined && _global.loginXML.firstChild != undefined && _global.loginXML.firstChild.firstChild != undefined ? _global.loginXML.firstChild.firstChild.attributes : (_global.httpHudAttrCache != undefined ? _global.httpHudAttrCache : _loc1_);
   classes.GlobalData.attr = _loc4_;
   classes.GlobalData.role = !_loc4_.r ? 0 : Number(_loc4_.r);
   if(loadPrefsFile != undefined && getLocalAccountStoragePrefix != undefined)
   {
      var _loc2_ = getLocalAccountStoragePrefix();
      if(_global.activePrefsAccountKey != _loc2_)
      {
         loadPrefsFile();
      }
   }
   if(_root.main != undefined && _root.main.overlay != undefined)
   {
      _root.main.overlay.txtMoney = "$: " + classes.NumFuncs.commaFormat(Number(_loc4_.m));
      _root.main.overlay.txtPoints = "P: " + classes.NumFuncs.commaFormat(Number(_loc4_.p));
      _root.main.overlay.txtCred = "SC: " + _loc4_.sc;
      _root.main.overlay.txtEmail = _loc4_.im;
   }
   classes.GlobalData.updateInfo("m",_loc4_.m);
   classes.GlobalData.updateInfo("p",_loc4_.p);
   classes.GlobalData.updateInfo("sc",_loc4_.sc);
   classes.GlobalData.updateInfo("im",_loc4_.im);
   if(_root.getLocations != undefined)
   {
      _root.getLocations();
   }
   if(_root.refreshHttpHud != undefined)
   {
      setTimeout(_root.refreshHttpHud,50);
      setTimeout(_root.refreshHttpHud,250);
      setTimeout(_root.refreshHttpHud,700);
   }
}
trace("role:");
trace(classes.GlobalData.role);
if(classes.GlobalData.role == 1 || classes.GlobalData.role == 2 || classes.GlobalData.role == 8)
{
   trace("calling showModToolButton");
   classes.Frame._MC.showModToolButton(true);
}
else
{
   classes.Frame._MC.showModToolButton(false);
}
if(classes.GlobalData.prefsObj.didViewRace)
{
   _root.introHolder.init(_global.introData);
}
if(classes.GlobalData.prefsObj.dev)
{
   trace("dev!");
   _global.mainURL = _global.devURL;
}
