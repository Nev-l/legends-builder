stop();
panel._visible = false;
panel.cacheAsBitmap = true;
panel.btn.onRelease = function()
{
   play();
};
drawIncomingList();
