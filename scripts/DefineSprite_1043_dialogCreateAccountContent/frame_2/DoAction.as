stop();
carsNode = infoXML.firstChild;
setCar();
btnCarPrev.onRelease = function()
{
   selCarIdx--;
   if(selCarIdx < 0)
   {
      selCarIdx = carsNode.childNodes.length - 1;
   }
   setCar();
};
btnCarNext.onRelease = function()
{
   selCarIdx++;
   if(selCarIdx > carsNode.childNodes.length - 1)
   {
      selCarIdx = 0;
   }
   setCar();
};
btnWheelPrev.onRelease = function()
{
   selWheelIdx--;
   if(selWheelIdx < 0)
   {
      selWheelIdx = wheelsNode.childNodes.length - 1;
   }
   updateWheel();
};
btnWheelNext.onRelease = function()
{
   selWheelIdx++;
   if(selWheelIdx > wheelsNode.childNodes.length - 1)
   {
      selWheelIdx = 0;
   }
   updateWheel();
};
btnOK.btnLabel.text = "Continue";
btnOK.onRelease = function()
{
   gotoAndStop("ext");
   play();
   delete this.onRelease;
};
btnCancel.btnLabel.text = "Cancel";
btnCancel.onRelease = function()
{
   _parent.closeMe();
};
