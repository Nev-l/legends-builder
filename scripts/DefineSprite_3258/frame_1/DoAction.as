stop();
var isPrivate = false;
iconCheck._alpha = 0;
btnCheckbox.onRollOver = function()
{
   iconCheck._alpha = 50;
};
btnCheckbox.onRollOut = function()
{
   if(isPrivate)
   {
      iconCheck._alpha = 100;
   }
   else
   {
      iconCheck._alpha = 0;
   }
};
btnCheckbox.onRelease = function()
{
   if(!isPrivate)
   {
      isPrivate = true;
      iconCheck._alpha = 100;
      nextFrame();
   }
   else
   {
      isPrivate = false;
      iconCheck._alpha = 0;
      prevFrame();
   }
};
