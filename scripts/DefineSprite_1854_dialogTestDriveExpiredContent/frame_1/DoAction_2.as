stop();
var carXML = classes.GlobalData.getTestDriveCarXML();
var carName = carXML.attributes.n;
var carMoneyPrice = carXML.attributes.p;
var carPointPrice = carXML.attributes.pp;
trace("carMoneyPrice: " + carMoneyPrice);
trace("carPointPrice: " + carPointPrice);
if(classes.GlobalData.testDriveCarExpired == true)
{
   btnClose._visible = true;
   tog1.txt = "Remove";
   btnClose.txt = "Close";
   expired._visible = true;
   timeRemaining._visible = false;
   tog1.btn.onRelease = function()
   {
      disableButtons();
      _root.removeTestDriveCar();
   };
   btnClose.btn.onRelease = function()
   {
      _parent.closeMe();
   };
}
else
{
   btnClose._visible = false;
   tog1.txt = "Close";
   expired._visible = false;
   timeRemaining._visible = true;
   var testDriveCarXML = classes.GlobalData.getTestDriveCarXML();
   var testDriveCarTimeRemaining = Number(testDriveCarXML.attributes.rh);
   timeRemaining.theText.text = "You have " + testDriveCarTimeRemaining + " hours left in your test drive";
   tog1.btn.onRelease = function()
   {
      _parent.closeMe();
   };
}
viewThumb._visible = true;
viewThumb.clearCarView();
classes.Drawing.carView(viewThumb,new XML(carXML.toString()),25);
priceGroup.togBuy.txt = "Pay";
pointsGroup.togBuy.txt = "Pay";
priceGroup.txtPrice = "$" + classes.NumFuncs.commaFormat(Number(carMoneyPrice));
pointsGroup.txtPoints = classes.NumFuncs.commaFormat(Number(carPointPrice));
classes.Effects.roBump(priceGroup.togBuy);
classes.Effects.roBump(pointsGroup.togBuy);
priceGroup.togBuy.onRelease = function()
{
   disableButtons();
   _root.buyTestDriveCar("m");
};
pointsGroup.togBuy.onRelease = function()
{
   disableButtons();
   _root.buyTestDriveCar("p");
};
if(Number(carPointPrice) == -1)
{
   pointsGroup._visible = false;
}
if(Number(carMoneyPrice) == -1)
{
   priceGroup._visible = false;
}
