hit.onRollOver = function()
{
   icn.onEnterFrame = function()
   {
      this.nextFrame();
      if(this._currentframe == this._totalframes)
      {
         delete this.onEnterFrame;
      }
   };
};
hit.onRollOut = function()
{
   icn.onEnterFrame = function()
   {
      this.prevFrame();
      if(this._currentframe == 1)
      {
         delete this.onEnterFrame;
      }
   };
};
hit.onRelease = function()
{
   _root.attachMovie("dialogContainer","abc",_root.getNextHighestDepth(),{contentName:"dialogCreateRoomContent",typeID:_parent.idx});
};
