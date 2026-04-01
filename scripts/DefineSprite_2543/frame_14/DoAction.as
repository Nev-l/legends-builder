if(!dropdownGroup2)
{
   var dropdownGroup2 = this.attachMovie("leaderboardDropdownGroup","dropdownGroup2",this.getNextHighestDepth());
   dropdownGroup2._x = 50;
   dropdownGroup2._y = 205;
   dropdownGroup2.txtHeader = "Race Type:";
   var ddRaceType = new classes.ui.SweetDropdown2b(dropdownGroup2,"ddBase","Arial","Arial",54,0,true,undefined,18);
   var ddRaceTypeListener = new Object();
   ddRaceTypeListener.onItemChanged = function(o)
   {
      raceType = o.value;
      prepLeaderboard();
   };
   ddRaceType.addListener(ddRaceTypeListener);
   ddRaceType.x = 10;
   ddRaceType.y = 23;
   var arrRaceType = new Array();
   arrRaceType.push({label:"Overall",value:"a"});
   arrRaceType.push({label:"Bracket",value:"b"});
   arrRaceType.push({label:"Head to Head",value:"h"});
   var i = 0;
   while(i < arrRaceType.length)
   {
      ddRaceType.addItem(arrRaceType[i]);
      i++;
   }
   ddRaceType.renderItems();
}
dropdownGroup1.swapDepths(this.getNextHighestDepth());
