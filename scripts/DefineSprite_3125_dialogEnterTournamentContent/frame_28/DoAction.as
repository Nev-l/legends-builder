viewThumb._visible = false;
priceGroup.txtPrice = "$" + _parent.mp;
priceGroup.togBuy.txt = "Select";
pointsGroup.txtPoints = _parent.pp;
pointsGroup.togBuy.txt = "Select";
classes.Effects.icnStandardRO(priceGroup.togBuy);
priceGroup.togBuy.onRelease = function()
{
   payType = "m";
   gotoAndStop("confirm");
   play();
};
classes.Effects.icnStandardRO(pointsGroup.togBuy);
pointsGroup.togBuy.onRelease = function()
{
   payType = "p";
   gotoAndStop("confirm");
   play();
};
if(_parent.mp < 0)
{
   priceGroup._visible = false;
}
if(_parent.pp < 0)
{
   pointsGroup._visible = false;
}
if(_parent.mp < 0 && _parent.pp < 0)
{
   fldMsg.text = "This event can not be entered because it has no payment options.";
}
