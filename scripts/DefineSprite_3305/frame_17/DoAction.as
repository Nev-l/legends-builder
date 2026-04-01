btnClose.onRelease = function()
{
   _root.getUserRemarks(uID);
   this._parent._parent.closeMe();
};
