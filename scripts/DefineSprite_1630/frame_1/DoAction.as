finishOverlay._visible = false;
SCChange._visible = false;
gaugeCheer1._xscale = 0;
gaugeBoo1._xscale = 0;
gaugeCheer2._xscale = 0;
gaugeBoo2._xscale = 0;
if(_global.chatObj.raceRoomMC.isTeamRivals)
{
   SCChange.swapDepths(this.getNextHighestDepth());
   SCChange.removeMovieClip();
   gaugeCheer1.swapDepths(this.getNextHighestDepth());
   gaugeCheer1.removeMovieClip();
   gaugeCheer2.swapDepths(this.getNextHighestDepth());
   gaugeCheer2.removeMovieClip();
   gaugeBoo1.swapDepths(this.getNextHighestDepth());
   gaugeBoo1.removeMovieClip();
   gaugeBoo2.swapDepths(this.getNextHighestDepth());
   gaugeBoo2.removeMovieClip();
}
raceTimes1._visible = false;
raceTimes2._visible = false;
