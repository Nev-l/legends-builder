stop();
btnOK.onRelease = function()
{
   nextFrame();
};
txtNote = "When posting your car for sale, you will not be able to race or modify it until the listing has ended.  Your listing will last for six days.\r\r";
txtNote += "You will be charged a non-refundable fee of $" + (_global.loginXML.firstChild.firstChild.attributes.mb != 1 ? _global.usedCarXML.firstChild.attributes.p : _global.usedCarXML.firstChild.attributes.mp) + " for listing the car.  When someone buys your car, you will be charged a secure transaction fee of " + Number(_global.usedCarXML.firstChild.attributes.c) * 100 + "% of the sale price (" + Number(_global.usedCarXML.firstChild.attributes.mc) * 100 + "% for members!).  If instead you agree to trade your car, you will be charged a flat $" + _global.usedCarXML.firstChild.attributes.t + " for the secure trade ($" + _global.usedCarXML.firstChild.attributes.mt + " for members!).";
