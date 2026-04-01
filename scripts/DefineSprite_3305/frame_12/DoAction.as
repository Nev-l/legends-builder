btnReturn.onRelease = function()
{
   gotoAndStop("form");
   play();
};
btnCancel.onRelease = function()
{
   this._parent._parent.closeMe();
};
