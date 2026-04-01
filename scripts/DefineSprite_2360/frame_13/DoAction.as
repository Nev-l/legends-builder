stop();
carPicker.setSelectedCar(carID);
front_back.btnFront.onRelease = function()
{
   isBack = false;
   front_back.prevFrame();
   gotoAndStop("front");
   carMC.clearCarView();
   classes.ClipFuncs.removeAllClips(carMC);
   classes.Drawing.carView(carMC,carXML,100,"front");
};
front_back.btnBack.onRelease = function()
{
   isBack = true;
   front_back.nextFrame();
   gotoAndStop("back");
   carMC.clearCarView();
   classes.ClipFuncs.removeAllClips(carMC);
   classes.Drawing.carView(carMC,carXML,100,"back");
};
