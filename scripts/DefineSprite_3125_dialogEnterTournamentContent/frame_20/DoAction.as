errDialTime._visible = false;
fldDialTime.restrict = ".0-9";
nav2.onRelease = function()
{
   if(!Number(dialTime))
   {
      txtError = "You must enter a valid dial-in time.";
   }
   else
   {
      txtError = "";
      _root.updateDefaultCar(selCar);
      checkDone();
   }
};
