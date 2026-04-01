stop();
var showLeft;
raceOverlay.swapDepths(20);
if(!_global.chatObj.raceRoomMC.isTeamRivals)
{
   raceOverlay.raceCheerGaugesCover._visible = false;
}
gauge.swapDepths(14);
gauge._visible = false;
gaugeStaging.swapDepths(16);
raceResultsOverlay.swapDepths(30);
raceResultsOverlay._visible = false;
raceResultsTimes.swapDepths(31);
raceResultsTimes._visible = false;
voteBtns._visible = false;
if(_global.chatObj.raceRoomMC.isTeamRivals)
{
   voteBtns.swapDepths(this.getNextHighestDepth());
   voteBtns.removeMovieClip();
}
if(Number(racer1Obj.bt) > 0)
{
   dialin1.txt = classes.NumFuncs.zeroFill(Number(racer1Obj.bt),3);
}
else
{
   dialin1.swapDepths(this.getNextHighestDepth());
   dialin1.removeMovieClip();
}
if(Number(racer2Obj.bt) > 0)
{
   dialin2.txt = classes.NumFuncs.zeroFill(Number(racer2Obj.bt),3);
}
else
{
   dialin2._visible = false;
   dialin2.swapDepths(this.getNextHighestDepth());
   dialin2.removeMovieClip();
}
if(isSpectator)
{
   tree._visible = false;
   gaugeStaging._visible = false;
   gaugeStaging.swapDepths(this.getNextHighestDepth());
   gaugeStaging.removeMovieClip();
   if(!classes.Control.htourneyMC.spectateFlag)
   {
      voteBtns._visible = true;
   }
   var controlsMC;
}
else
{
   car1._visible = true;
   car2._visible = true;
}
var hasControl;
var hasSpecialGauge = classes.GlobalData.hasShiftLightGauge;
var selectedCarRPM = classes.GlobalData.getSelCarRPM();
var raceControlsID;
trace("hasSpecialGauge: " + hasSpecialGauge);
trace("selected car rpm: " + selectedCarRPM);
if(user1Obj.uID == classes.GlobalData.id)
{
   _root.runEngineStart();
   showLeft = true;
   gaugeStaging.pointer.pointer2._visible = false;
   raceControlsID = getGaugeID(tCarXML1);
}
else if(user2Obj.uID == classes.GlobalData.id)
{
   _root.runEngineStart();
   showLeft = false;
   gaugeStaging.pointer.pointer1._visible = false;
   gaugeStaging._x = 789;
   gauge._x = 784;
   raceControlsID = getGaugeID(tCarXML2);
}
loadThisFile = "cache/car/rc.swf";
this.attachMovie("raceControlMCCache","controlsMC",15,{_y:163,left:showLeft});
var mclListener = new Object();
mclListener.onLoadInit = function(target_mc)
{
   trace("rc.swf loaded");
   trace(this);
   trace(selectedCarRPM);
   trace(raceControlsID);
   controlsMC._visible = false;
   controlsMC.clipLoaded(showLeft,selectedCarRPM,raceControlsID,hasSpecialGauge,classes.GlobalData.temp);
   delete rc_mcl;
   delete mclListener;
   trace(classes.RacePlay._MC);
   trace(controlsMC);
   trace(controlsMC._parent);
   trace(classes.RacePlay._MC.racer1Obj.td);
   hasControl = classes.RacePlay._MC.hasLaunchControl(classes.GlobalData.id,classes.GlobalData.getSelectedCarXML());
   controlsMC.showLaunchControl(hasControl);
   trace("controlMC: " + controlsMC);
   _root.raceEngineInit(controlsMC,tree);
};
mclListener.onLoadError = function(target_mc)
{
   _root.displayAlert("warning","Missing Files","A file is missing from your cache folder:\r\r" + loadThisFile + "\r\rThe game will not function without this file.  Please close the game and re-install it by running the original installer.  Or you can download the latest installer at www.NittoLegends.com.  Note: Re-installing will not affect your account in any way.  You may continue to use your existing account.");
};
var rc_mcl = new MovieClipLoader();
rc_mcl.addListener(mclListener);
rc_mcl.loadClip(loadThisFile,classes.RaceControls._mcHolder);
if(!user2Obj.uID)
{
   gauge.car2._visible = false;
}
gauge.car1.clr = new Color(gauge.car1.body);
gauge.car1.clr.setRGB(Number("0x" + tCarXML1.firstChild.attributes.cc));
gauge.car2.clr = new Color(gauge.car2.body);
gauge.car2.clr.setRGB(Number("0x" + tCarXML2.firstChild.attributes.cc));
if(!_global.chatObj.raceRoomMC.isTeamRivals)
{
   this.createEmptyMovieClip("racerBubbles",23);
   this.createEmptyMovieClip("racerBubblesMask",24);
   racerBubblesMask._y = 50;
   classes.Drawing.rect(racerBubblesMask,800,400);
   racerBubbles.setMask(racerBubblesMask);
   var shadFilter = new flash.filters.DropShadowFilter(8,45,0,0.6,10,10,1,1);
   var bubblesFilters = [];
   bubblesFilters.push(shadFilter);
   racerBubbles.filters = bubblesFilters;
}
voteBtns.btnCheer1.onRelease = function()
{
   this._visible = false;
   voteBtns.btnBoo1._visible = false;
   _root.chatCheerVote(1,user1Obj.uID);
};
voteBtns.btnCheer2.onRelease = function()
{
   this._visible = false;
   voteBtns.btnBoo2._visible = false;
   _root.chatCheerVote(1,user2Obj.uID);
};
voteBtns.btnBoo1.onRelease = function()
{
   voteBtns.btnCheer1._visible = false;
   this._visible = false;
   _root.chatCheerVote(0,user1Obj.uID);
};
voteBtns.btnBoo2.onRelease = function()
{
   voteBtns.btnCheer2._visible = false;
   this._visible = false;
   _root.chatCheerVote(0,user2Obj.uID);
};
if(_parent.opponentPrestaged)
{
   trace("opponentPrestaged oppLane: " + oppLane);
   classes.RaceTreeLights._MC.setLight(oppLane,"pre",true);
   classes.RaceTreeLights._MC.setLight(oppLane,"staged",true);
   renderCar(oppLane,13);
}
