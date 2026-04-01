stop();
blur._alpha = 0;
blur.stop();
var straight;
trace("race trackMov setting race quality");
hiGraphicTrack.stop();
lowGraphicTrack.stop();
if(classes.Race._MC.isSpectator == true)
{
   if(classes.GlobalData.prefsObj.spectateQuality <= 1)
   {
      showWireframeTrack();
   }
   else
   {
      showHiResTrack();
   }
}
else if(classes.GlobalData.prefsObj.raceQuality <= 1)
{
   showWireframeTrack();
}
else
{
   showHiResTrack();
}
straight.stop();
_global.trackMovMC = straight;
if(!classes.RacePlay._MC.myLane)
{
   classes.RacePlay._MC.showTrackAtPos(1331);
}
