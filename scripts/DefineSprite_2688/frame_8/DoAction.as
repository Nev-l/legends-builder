stop();
queueGroup._visible = false;
panelOut.swapDepths(this.getNextHighestDepth());
panelIn.swapDepths(this.getNextHighestDepth());
this.createEmptyMovieClip("maskMC1",this.getNextHighestDepth());
this.createEmptyMovieClip("maskMC2",this.getNextHighestDepth());
panelOut.setMask(maskMC1);
panelIn.setMask(maskMC2);
classes.Drawing.rect(maskMC1,800,600);
classes.Drawing.rect(maskMC2,800,600);
trace("in rivals room, " + _global.newbieRoom);
if(_global.newbieRoom == true)
{
   trace("newbie room true");
   btnEarnFreePoints._visible = true;
   btmFade.y = 488.7;
   btmFade.height = 111.3;
}
else
{
   trace("newbie room false");
   btnEarnPoints._visible = false;
   btmFade.y = 505;
   btmFade.height = 95;
}
_root.chatListUsers();
_root.chatRIVGet();
if(!classes.GlobalData.prefsObj.didViewRace)
{
   classes.GlobalData.prefsObj.didViewRace = 1;
   classes.GlobalData.savePrefsObj();
   tutorialObj = new classes.util.Tutorial(classes.Frame._MC,classes.data.TutorialData.arrRivalsTrack,true);
   trace("didn\'t view race");
}
btnEarnPoints.onRelease = function()
{
   trace("btnEarnPoints released!");
   _root.openPointsURL();
};
