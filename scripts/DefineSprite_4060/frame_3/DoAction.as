stop();
hideAllButtons();
hideAllContent();
contentArray.splice(0);
leftButtonArray.splice(0);
aryRepair.splice(0);
for(§each§ in this.engineRepairContent)
{
   this[eval("each")].removeMovieClip();
}
trace("oilFlush: " + oilFlush);
nitrousRefill._visible = oilFlush._visible = secondaryBox._visible = noDamageText._visible = false;
priceGroup.togBuy.onRelease = function()
{
   repairItem("m");
};
pointsGroup.togBuy.onRelease = function()
{
   repairItem("p");
};
btnDiffCar.hot.onRelease = function()
{
   _root.attachMovie("dialogContainer","abc",_root.getNextHighestDepth(),{contentName:"dialogSelectCarContent",_context:this._parent._parent});
   clearInterval(this._parent.icn.si);
};
_root.getRepairParts(selCar);
