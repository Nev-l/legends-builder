stop();
partDetail._visible = false;
customPlateForm._visible = false;
var selPartXML;
trace("license cat main xml: " + licMainCatXML);
trace("license cat xml: " + licCatXML);
trace("isVIP?: " + selectedCarXML.firstChild.attributes.iv);
if(selectedCarXML.firstChild.attributes.iv == 1)
{
   _root.displayAlert("warning","No Custom Plate","This is a VIP car and plates are not customizable.");
}
else
{
   var mb = new classes.ShopMenu(menuMC.shopMenu,locationID,licMainCatXML,licCatXML,null,onShopPartClick);
   menuMC.swapDepths(this.getNextHighestDepth());
}
var tfPlain = new TextFormat();
tfPlain.bold = false;
btnDiffCar.hot.onRelease = function()
{
   _root.attachMovie("dialogContainer","abc",_root.getNextHighestDepth(),{contentName:"dialogSelectCarContent",_context:this._parent._parent});
   clearInterval(this._parent.icn.si);
};
