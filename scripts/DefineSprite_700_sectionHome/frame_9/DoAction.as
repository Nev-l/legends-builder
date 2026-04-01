fldFundsMaxW = fldFunds._width;
fldPointsMaxW = fldPoints._width;
cityBG._visible = false;
i = 1;
while(i <= 4)
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
      profileMC.goProfilePage(this.idx);
   };
   i++;
}
btnHelp.onRelease = function()
{
   tutorialObj = new classes.util.Tutorial(_parent,classes.data.TutorialData.arrHome,true);
};
