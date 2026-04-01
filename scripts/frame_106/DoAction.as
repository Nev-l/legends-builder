stop();
trace("ROOT: frame_106 (main game) reached!");
this.attachMovie("frame","main",this.getNextHighestDepth());
classes.Frame._MC.showSupportButton(true);
classes.Frame._MC.showLimitedAccessAlert(false);
classes.data.TutorialData.init();
var controlMan = new classes.Control(this);
classes.RaceSound.soundsEnabled = true;
