stop();
front_back.btnFront.onRelease = function()
{
   isBack = false;
   front_back.prevFrame();
   classes.Drawing.clearThisCarsBmps(carHolder);
   classes.Drawing.carView(carHolder,cloneXML,100,!isBack ? "front" : "back");
};
front_back.btnBack.onRelease = function()
{
   isBack = true;
   front_back.nextFrame();
   classes.Drawing.clearThisCarsBmps(carHolder);
   classes.Drawing.carView(carHolder,cloneXML,100,!isBack ? "front" : "back");
};
btnDiffCar.hot.onRelease = function()
{
   _root.attachMovie("dialogContainer","abc",_root.getNextHighestDepth(),{contentName:"dialogSelectCarContent",_context:this._parent._parent});
   clearInterval(this._parent.icn.si);
};
