var lid = _parent.locationID;
trace("lid: " + lid);
updateName();
updateIcons();
updateArrows();
var i = 1;
while(i <= 5)
{
   iconsLineup["placeIcon" + i].gotoAndStop(i);
   iconsLineup["placeIconR" + i].gotoAndStop(i);
   iconsLineup["placeIcon" + i].idx = i;
   iconsLineup["placeIconR" + i].idx = i;
   iconsLineup["placeIcon" + i].onRelease = function()
   {
      updateSwitcher(this.idx * 100);
   };
   iconsLineup["placeIconR" + i].onRelease = iconsLineup["placeIcon" + i].onRelease;
   i++;
}
arrowNext.doOnClick = function()
{
   if(lid >= 500)
   {
      updateSwitcher(100);
   }
   else
   {
      updateSwitcher(lid + 100);
   }
};
arrowPrev.doOnClick = function()
{
   if(lid <= 100)
   {
      updateSwitcher(500);
   }
   else
   {
      updateSwitcher(lid - 100);
   }
};
