stop();
var isChecked = false;
iconCheck._alpha = 0;
btnCheckbox.onRollOver = function()
{
   iconCheck._alpha = 50;
};
btnCheckbox.onRollOut = function()
{
   if(isChecked)
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
   if(!isChecked)
   {
      isChecked = true;
      iconCheck._alpha = 100;
   }
   else
   {
      isChecked = false;
      iconCheck._alpha = 0;
   }
};
