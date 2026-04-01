stop();
delete checkProgress;
btnClose.btnLabel.text = "Close";
btnClose.onRelease = function()
{
   _parent.closeMe();
};
