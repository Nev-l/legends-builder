cityBG._visible = false;
i = 1;
while(i <= 5)
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
      accountMC.goAccountPage(this.idx);
   };
   i++;
}
btnHelp.onRelease = function()
{
   helpBubble = createEmptyMovieClip("helpBubble",getNextHighestDepth());
   var _loc2_ = new Array();
   _loc2_.push(new Array(103,252,185,295,"This is the Account section where you can change your password, register or change your real-world email address, or check your Membership and Points status.  Use the buttons on the left to navigate the Account pages."));
   tutorialObj = new classes.util.Tutorial(helpBubble,_loc2_,true);
   helpBubble.onRelease = function()
   {
      this.removeMovieClip();
   };
};
