stop();
this.onRelease = function()
{
   _parent.container._visible = false;
   _parent.chartVisibility(true);
   nextFrame();
};
