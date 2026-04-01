stop();
var dropdownGroup1 = this.attachMovie("leaderboardDropdownGroup","dropdownGroup1",this.getNextHighestDepth());
dropdownGroup1._x = 50;
dropdownGroup1._y = 150;
dropdownGroup1.txtHeader = "Period:";
var ddPeriod = new classes.ui.SweetDropdown2b(dropdownGroup1,"ddBase","Arial","Arial",128,0,true,undefined,18);
var ddPeriodListener = new Object();
ddPeriodListener.onItemChanged = function(o)
{
   newPeriodType = periodXML.childNodes[o.value].attributes.t;
   newPeriodNum = periodXML.childNodes[o.value].attributes.c;
   prepLeaderboard();
};
ddPeriod.addListener(ddPeriodListener);
ddPeriod.x = 10;
ddPeriod.y = 23;
var periodXML = menuXML.idMap.periodMenu;
var arrPeriod = new Array();
var i = 0;
while(i < periodXML.childNodes.length)
{
   arrPeriod.push({label:periodXML.childNodes[i].attributes.n,value:i});
   i++;
}
var i = 0;
while(i < arrPeriod.length)
{
   ddPeriod.addItem(arrPeriod[i]);
   i++;
}
ddPeriod.renderItems();
