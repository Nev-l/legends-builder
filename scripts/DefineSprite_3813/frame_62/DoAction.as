stop();
if(bg.ta != 100)
{
   front_back._visible = false;
}
partDetail._visible = false;
if(locationID > Number(classes.GlobalData.attr.lid))
{
   partDetail.priceGroup.togBuy._alpha = 50;
}
var selPartXML;
var mb = new classes.ShopMenu2CPR(menuMC.shopMenu,locationID,wheelCatXML,_global.partXML,partOwnAndUninstalledXML,selectedCarXML,onShopPartClick);
menuMC.swapDepths(this.getNextHighestDepth());
var tfPlain = new TextFormat();
tfPlain.bold = false;
if(isBack)
{
   front_back.nextFrame();
}
front_back.btnFront.onRelease = function()
{
   isBack = false;
   front_back.prevFrame();
   clearCar();
   classes.Drawing.carView(image_mc,cloneXML,100,"front");
};
front_back.btnBack.onRelease = function()
{
   isBack = true;
   front_back.nextFrame();
   clearCar();
   classes.Drawing.carView(image_mc,cloneXML,100,"back");
};
btnDiffCar.hot.onRelease = function()
{
   _root.attachMovie("dialogContainer","abc",_root.getNextHighestDepth(),{contentName:"dialogSelectCarContent",_context:this._parent._parent});
   clearInterval(this._parent.icn.si);
};
gear_ratio._visible = false;
