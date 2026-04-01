trace("dialog carID: " + _parent.carID);
var carName = classes.Lookup.carModelName(_parent.carID);
msg = "Would you like to test drive a " + carName + "?\n\n";
msg += "You may purchase and install parts on your Test Drive car, but any part that’s on the car will be locked once the Test Drive session expires. You can unlock these parts if you purchase the car, but if you return the car to the system, all parts (including stock parts) that are on the car will be taken away. You can sell the spare parts back to the system before the Test Drive session expires. ANY GAME CASH OR POINTS SPENT ON MODIFYING A TEST DRIVE CAR WILL NOT BE REFUNDED.";
btnBuy.btnLabel.text = "Buy";
btnBuy.onRelease = function()
{
   classes.Frame._MC.goMainSection("dealer",_parent.loc,_parent.carID);
   _parent.closeMe();
};
btnAccept.btnLabel.text = "Accept";
btnAccept.onRelease = function()
{
   _root.acceptTestDrive();
   enableButtons(false);
};
btnDecline.txt = "Decline";
btnDecline.onRelease = function()
{
   _root.rejectTestDrive();
   _parent.closeMe();
};
btnLearnMore.onRelease = function()
{
   _root.openTestDriveFAQURL();
};
