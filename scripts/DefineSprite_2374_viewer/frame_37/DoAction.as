clrOverlay._x = 112;
clrOverlay._width = 658;
goProfilePage(1);
i = 1;
while(i <= 2)
{
   this["snav" + i].idx = i;
   this["snav" + i].onRollOver = function()
   {
      hiSnav(this.idx);
   };
   this["snav" + i].onRollOut = function()
   {
      hiSnav(selSnav);
   };
   this["snav" + i].onDragOut = this["snav" + i].onRollOut;
   this["snav" + i].onRelease = function()
   {
      if(Number(this.idx) > 1)
      {
         goProfilePage(this.idx);
      }
      else
      {
         gotoAndStop("profile");
         play();
      }
   };
   i++;
}
btnGiveRemark.onRelease = function()
{
   if(classes.Lookup.getBuddyNode(uID) != undefined)
   {
      giveRemark(uID,uName);
   }
   else
   {
      _root.displayAlert("warning","Not Allowed","Sorry, you must be this person\'s buddy to leave a remark.");
   }
};
