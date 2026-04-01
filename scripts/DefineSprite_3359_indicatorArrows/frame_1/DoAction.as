function scrollRight()
{
   this.onEnterFrame = function()
   {
      if(_parent.indicatorGroup._x + scrollStep < _parent.indicatorMask._x)
      {
         _parent.indicatorGroup._x += scrollStep;
      }
      else
      {
         _parent.indicatorGroup._x = _parent.indicatorMask._x;
      }
   };
}
function scrollLeft()
{
   this.onEnterFrame = function()
   {
      checkPos = _parent.indicatorMask._x + _parent.indicatorMask._width - _parent.indicatorGroup._width;
      if(_parent.indicatorGroup._x - scrollStep > checkPos)
      {
         _parent.indicatorGroup._x -= scrollStep;
      }
      else
      {
         _parent.indicatorGroup._x = checkPos;
      }
   };
}
function stopScroll()
{
   delete this.onEnterFrame;
}
