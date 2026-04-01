stop();
priceGroup.togBuy.txt = "Pay";
pointsGroup.togBuy.txt = "Pay";
priceGroup.txtPrice = "$" + classes.NumFuncs.commaFormat(Number(xNode.attributes.f));
pointsGroup.txtPoints = classes.NumFuncs.commaFormat(Number(xNode.attributes.pf));
classes.Effects.roBump(priceGroup.togBuy);
classes.Effects.roBump(pointsGroup.togBuy);
priceGroup.togBuy.onRelease = function()
{
   _root.moveLocation(lid,"m");
   _parent.closeMe();
};
pointsGroup.togBuy.onRelease = function()
{
   _root.moveLocation(lid,"p");
   _parent.closeMe();
};
if(!Number(xNode.attributes.pf))
{
   pointsGroup._visible = false;
}
