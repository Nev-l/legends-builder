btnActivatePoints.onRelease = function()
{
   if(pointsCode.length > 0)
   {
      trace("pointsCode: " + pointsCode);
      _root.activatePoints(pointsCode);
   }
};
btnWhatsPoints.onRelease = function()
{
   _root.displayAlert("helmet","Activating Purchase","Activate your Points or Membership order by typing your activation code here.  Points allow you to purchase new and exclusive items in the game, while membership offers many benefits such as discounted parts, exclusive items, and more!");
};
