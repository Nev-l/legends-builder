fldFundsMaxW = fldFunds._width;
var teamAttr = _global.teamXML.firstChild.firstChild.attributes;
setFundsField(teamAttr.tf);
var canChange = _global.loginXML.firstChild.firstChild.attributes.tr != 1 ? false : true;
teamAvatar.attachMovie("teamInfo","teamInfo",1,{tID:teamAttr.i,tName:teamAttr.n,tCred:teamAttr.sc,canChange:canChange,teamXML:_global.teamXML});
var tattr = _global.teamXML.firstChild.firstChild.attributes;
txtStats = "Wins: " + tattr.tw + "    " + "Losses: " + tattr.tl;
if(_global.teamXML.firstChild.firstChild.attributes.bg && _global.teamXML.firstChild.firstChild.attributes.bg != "000000")
{
   paintOverlay(_global.teamXML.firstChild.firstChild.attributes.bg);
}
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
      _root.debug += this.idx + "/r";
      goPage(this.idx);
   };
   i++;
}
btnHelp.onRelease = function()
{
   tutorialObj = new classes.util.Tutorial(_parent,classes.data.TutorialData.arrTeamHQ,true);
};
goPage(2);
