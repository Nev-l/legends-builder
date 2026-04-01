var shopName = "Paint";
_global.shopPaintMC = this;
var carXML;
var cloneXML;
getSelectedCarXML();
cloneCarXML();
var accountCarID = Number(carXML.firstChild.attributes.i);
var carID = carXML.firstChild.attributes.ci;
var isBack = false;
classes.Drawing.carView(carHolder,cloneXML,100,!isBack ? "front" : "back");
tfInit = new TextFormat();
tfInit.color = 16777215;
tfNA = new TextFormat();
tfNA.color = 6710886;
var locationID = _parent.locationID;
var cartArray = new Array();
var columns = 20;
var xSpacing = 20;
var xIndent = 8;
var yIndent = 28;
var paintSwatchContainer = this.createEmptyMovieClip("paintSwatchContainer",this.getNextHighestDepth());
paintSwatchContainer._y = 155;
priceDescription._y = paintSwatchContainer._y - 20;
var paintSwatchArray = new Array();
var isWholeCar = true;
var paintMenuContainer = this.createEmptyMovieClip("paintMenuContainer",this.getNextHighestDepth());
var paintMenuArray = new Array();
var paintMenuX = 163;
var paintMenuY = 127;
var paintMenuYSpacing = 14;
var selectedButton = btnFull;
btnFull.txt = "Full car paint job";
btnFull.partCategoryID = -2;
btnSpecific.txt = "Body panel specific";
btnFull.onRollOver = function()
{
   setHiAnim(menuMC.shopMenu.hiRO0,this._y - menuMC._y - menuMC.shopMenu._y);
};
btnFull.onRollOut = btnFull.onDragOut = function()
{
   setHiAnim(menuMC.shopMenu.hiRO0,menuMC.shopMenu.hiRO0.by);
};
btnFull.onRelease = function()
{
   btnSpecific.fld.setTextFormat(tfInit);
   this.fld.setTextFormat(tfNA);
   setHiAnim(menuMC.shopMenu.hiRO1,menuMC.shopMenu.hiRO1.by);
   setHiAnim(menuMC.shopMenu.hiSel1,menuMC.shopMenu.hiSel1.by);
   setHiAnim(menuMC.shopMenu.hiSel0,this._y - menuMC._y - menuMC.shopMenu._y);
   menuMC.dot1._visible = true;
   menuMC.txtHead1 = btnFull.txt;
   isWholeCar = true;
   selectedButton = this;
   drawMenu();
};
btnSpecific.onRollOver = function()
{
   menuMC.shopMenu.hiRO0.ty = this._y - menuMC._y - menuMC.shopMenu._y;
};
btnSpecific.onRollOut = btnSpecific.onDragOut = function()
{
   menuMC.shopMenu.hiRO0.ty = menuMC.shopMenu.hiRO0.by;
};
btnSpecific.onRelease = function()
{
   btnFull.fld.setTextFormat(tfInit);
   this.fld.setTextFormat(tfNA);
   setHiAnim(menuMC.shopMenu.hiRO1,menuMC.shopMenu.hiRO1.by);
   setHiAnim(menuMC.shopMenu.hiSel1,menuMC.shopMenu.hiSel1.by);
   setHiAnim(menuMC.shopMenu.hiSel0,this._y - menuMC._y - menuMC.shopMenu._y);
   menuMC.dot1._visible = true;
   menuMC.txtHead1 = btnSpecific.txt;
   isWholeCar = false;
   drawMenu();
};
drawSwatches();
drawMenu();
with(menuMC.shopMenu)
{
   hiSel0.by = hiSel0._y;
   hiRO0.by = hiRO0._y;
   hiSel1.by = hiSel1._y;
   hiRO1.by = hiRO1._y;
}
priceGroup.togBuy.onRelease = function()
{
   var _loc2_ = 0;
   var _loc3_ = 0;
   while(_loc3_ < cartArray.length)
   {
      _loc2_ += cartArray[_loc3_].price;
      _loc3_ += 1;
   }
   if(_loc2_)
   {
      startBuyPaint("m",_loc2_);
   }
   else
   {
      _root.displayAlert("warning","No Paint Selected","You have not selected any custom paint to purchase.  Select paint colors from the menu before clicking the \'Buy\' button.");
   }
};
pointsGroup.togBuy.onRelease = function()
{
   var _loc2_ = 0;
   var _loc3_ = 0;
   while(_loc3_ < cartArray.length)
   {
      _loc2_ += cartArray[_loc3_].pointPrice;
      _loc3_ += 1;
   }
   if(_loc2_)
   {
      startBuyPaint("p",_loc2_);
   }
   else
   {
      _root.displayAlert("warning","No Paint Selected","You have not selected any custom paint to purchase.  Select paint colors from the menu before clicking the \'Buy\' button.");
   }
};
