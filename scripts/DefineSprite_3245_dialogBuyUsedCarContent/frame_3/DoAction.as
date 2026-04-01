stop();
if(s == 1)
{
   alertIcon.gotoAndStop("keyplus");
   msg = "You have successfully purchased this car.";
   _root.getCars();
   classes.SectionClassified._mc.gotoAndPlay("browse");
}
else
{
   alertIcon.gotoAndStop("warning");
}
btnClose.btnLabel.text = "Close";
btnClose.onRelease = function()
{
   this._parent._parent.closeMe();
};
