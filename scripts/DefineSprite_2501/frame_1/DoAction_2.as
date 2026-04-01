trackMapTourneyHi._visible = false;
stripGroup._visible = false;
stripGroup.gotoAndStop(1);
stripGroupTourney._visible = false;
stripGroupTourney.gotoAndStop(1);
parkingGroup._visible = false;
parkingGroup.gotoAndStop(1);
if(classes.GlobalData.prefsObj.didViewRace)
{
   btnHelp.onRelease = function()
   {
      tutorialObj = new classes.util.Tutorial(_parent,classes.data.TutorialData.arrSectionRaceTrack,true);
   };
   if(!classes.GlobalData.prefsObj.didViewTrack)
   {
      classes.GlobalData.prefsObj.didViewTrack = 1;
      classes.GlobalData.savePrefsObj();
      btnHelp.onRelease();
   }
   fldClr1 = new Color(fld1);
   var i = 1;
   while(i <= 8)
   {
      this["fldClr" + i] = new Color(this["fld" + i]);
      this["btnStrip" + i].idx = i;
      this["btnStrip" + i].onRollOver = function()
      {
         this._parent["fldClr" + this.idx].setRGB(16777215);
      };
      this["btnStrip" + i].onRollOut = function()
      {
         resetFldClrs();
      };
      this["btnStrip" + i].onRelease = function()
      {
         showTrackGroup(this.idx);
      };
      i++;
   }
   btnParking.onRollOver = function()
   {
      fldClr1.setRGB(16777215);
   };
   btnParking.onRollOut = function()
   {
      resetFldClrs();
   };
   btnParking.onRelease = function()
   {
      showParkingGroup();
   };
   btnStrip4.onRelease = function()
   {
      showTourneyGroup();
   };
   btnStrip7.onRelease = function()
   {
      classes.Control.leaderboardMC.swapDepths(this.getNextHighestDepth());
      classes.Control.leaderboardMC._visible = true;
      classes.Control.leaderboardMC._parent._visible = true;
      trace("woooboy");
      trace(classes.Control.leaderboardMC._parent);
      classes.Control.leaderboardMC.nowShowing();
   };
   btnStrip2.onRelease = function()
   {
      _parent.gotoAndPlay("practice");
   };
}
