var tutorialObj;
btn1.onRelease = function()
{
   _root.practiceCreate(classes.mc.TrackPractice._mc.selCarID);
   tutorialObj = new classes.util.Tutorial(_parent,classes.data.TutorialData.arrControllingYourCar);
   this._parent._visible = false;
};
btn2.onRelease = function()
{
   _root.practiceCreate(classes.mc.TrackPractice._mc.selCarID);
   tutorialObj = new classes.util.Tutorial(_parent,classes.data.TutorialData.arrPreparingRace);
   this._parent._visible = false;
};
btn3.onRelease = function()
{
   _root.practiceCreate(classes.mc.TrackPractice._mc.selCarID);
   tutorialObj = new classes.util.Tutorial(_parent,classes.data.TutorialData.arrRacing);
   this._parent._visible = false;
};
btn4.onRelease = function()
{
   _root.practiceCreate(classes.mc.TrackPractice._mc.selCarID);
   tutorialObj = new classes.util.Tutorial(_parent,classes.data.TutorialData.arrAdvancedRacing);
   this._parent._visible = false;
};
