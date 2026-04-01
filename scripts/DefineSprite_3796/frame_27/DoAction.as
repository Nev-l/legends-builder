stop();
if(shoppingFor == "Car")
{
   boxShoppingForEngine._visible = false;
}
else if(shoppingFor == "Engine")
{
   front_back._visible = false;
   var ei;
   var nm = "";
   var i = 0;
   while(i < enginePartXML.firstChild.childNodes.length)
   {
      if(enginePartXML.firstChild.childNodes[i].attributes.i == selAeid)
      {
         ei = enginePartXML.firstChild.childNodes[i].attributes.ei;
         nm = enginePartXML.firstChild.childNodes[i].attributes.n;
         break;
      }
      i++;
   }
   boxShoppingForEngine.txtEngineName = nm;
   if(ei)
   {
      boxShoppingForEngine.loadin.loadMovie(_global.assetPath + "/parts/m" + ei + ".swf");
   }
}
partDetail._visible = false;
if(locationID > Number(classes.GlobalData.attr.lid))
{
   partDetail.priceGroup.togBuy._alpha = 50;
}
var selPartXML;
if(shoppingFor == "Engine")
{
   var mb = new classes.ShopMenu2(menuMC.shopMenu,locationID,_global.partCatXML,_global.partXML,partOwnAndUninstalledXML,null,onShopPartClick,storeType);
}
else
{
   var mb = new classes.ShopMenu2(menuMC.shopMenu,locationID,_global.partCatXML,_global.partXML,partOwnAndUninstalledXML,selectedCarXML,onShopPartClick,storeType);
}
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
   _root.attachMovie("dialogContainer","abc",_root.getNextHighestDepth(),{contentName:"dialogSelectCarAndEngineContent",_context:this._parent._parent});
   clearInterval(this._parent.icn.si);
};
gear_ratio._visible = false;
browseGraphics._visible = false;
shopUGGGroup._visible = false;
browseGaugeGraphics._visible = false;
