stop();
this.onRelease = function()
{
   classes.Frame.globalSound.setVolume(50);
   classes.RaceSound.soundsEnabled = true;
   _root.raceSound.enableLoadedSounds();
   prevFrame();
};
