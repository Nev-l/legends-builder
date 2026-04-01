stop();
var showOnLoadMouse = true;
trace("soldOutSign visibility: ");
soldOutSign._visible = false;
trace(soldOutSign._visible);
if(skipToCar)
{
   showOnLoadMouse = false;
}
var mb = new classes.ShopMenu(menuMC.shopMenu,locationID,_global.dealerXML,_global.dealerCarsXML,null,onShopPartClick,showOnLoadMouse);
var selCarNum;
var selCarXML;
var selCarClr;
delete selCarXML;
var tfPlain = new TextFormat();
tfPlain.bold = false;
carDetail.priceGroup._visible = true;
carDetail._visible = false;
if(locationID > Number(classes.GlobalData.attr.lid))
{
   carDetail.priceGroup.togBuy._alpha = 50;
}
if(isBack)
{
   carDetail.front_back.nextFrame();
}
carDetail.front_back.btnFront.onRelease = function()
{
   isBack = false;
   carDetail.front_back.prevFrame();
   onSwatchClick(selCarClr);
};
carDetail.front_back.btnBack.onRelease = function()
{
   isBack = true;
   carDetail.front_back.nextFrame();
   onSwatchClick(selCarClr);
};
this.createEmptyMovieClip("image_mc",this.getNextHighestDepth());
image_mc._x = 220;
image_mc._y = 155;
menuMC.swapDepths(this.getNextHighestDepth());
soldOutSign.swapDepths(image_mc);
soldOutSign._visible = false;
var columns = 8;
var xSpacing = 22;
var xIndent = 8;
var yIndent = 30;
if(paintSwatchContainer == undefined)
{
   paintSwatchContainer = this.createEmptyMovieClip("paintSwatchContainer",this.getNextHighestDepth());
}
paintSwatchContainer._x = 738;
paintSwatchContainer.by = 510;
paintSwatchContainer._y = paintSwatchContainer.by;
drawSwatches();
var initialCarId;
if(skipToCar)
{
   initialCarId = skipToCar;
}
else if(_global.dealerCarsXML != undefined && _global.dealerCarsXML.firstChild != undefined)
{
   var _loc1_ = 0;
   while(_loc1_ < _global.dealerCarsXML.firstChild.childNodes.length)
   {
      if(Number(_global.dealerCarsXML.firstChild.childNodes[_loc1_].attributes.l) == Number(locationID))
      {
         initialCarId = _global.dealerCarsXML.firstChild.childNodes[_loc1_].attributes.i;
         break;
      }
      _loc1_ += 1;
   }
   if(initialCarId == undefined && _global.dealerCarsXML.firstChild.childNodes.length > 0)
   {
      initialCarId = _global.dealerCarsXML.firstChild.childNodes[0].attributes.i;
   }
}
if(initialCarId != undefined)
{
   onShopPartClick(initialCarId);
}
