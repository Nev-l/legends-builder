stop();
this.onRelease = function()
{
   classes.Frame.globalSound.setVolume(0);
   classes.RaceSound.soundsEnabled = false;
   _root.raceSound.disableLoadedSounds();
   nextFrame();
};
