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
      newRaceType = o.value;
      trace("raceType: " + newRaceType);
      if(newRaceType == "f2v2")
      {
         listNum = 0;
         headerRaceType = "2 v 2";
      }
      else if(newRaceType == "f3v3")
      {
         listNum = 1;
         headerRaceType = "3 v 3";
      }
      else if(newRaceType == "f4v4")
      {
         listNum = 2;
         headerRaceType = "4 v 4";
      }
      prepLeaderboard();
   };
   ddRaceType.addListener(ddRaceTypeListener);
   ddRaceType.x = 10;
   ddRaceType.y = 23;
   var arrRaceType = new Array();
   arrRaceType.push({label:"2 vs 2",value:"f2v2"});
   arrRaceType.push({label:"3 vs 3",value:"f3v3"});
   arrRaceType.push({label:"4 vs 4",value:"f4v4"});
   var i = 0;
   while(i < arrRaceType.length)
   {
      ddRaceType.addItem(arrRaceType[i]);
      i++;
   }
   ddRaceType.renderItems();
}
if(!dropdownGroup3)
{
   var dropdownGroup3 = this.attachMovie("leaderboardDropdownGroup","dropdownGroup3",this.getNextHighestDepth());
   dropdownGroup3._x = 50;
   dropdownGroup3._y = 260;
   dropdownGroup3.txtHeader = "Match Type:";
   var ddMatchType = new classes.ui.SweetDropdown2b(dropdownGroup3,"ddBase","Arial","Arial",36,0,true,undefined,18);
   var ddMatchTypeListener = new Object();
   ddMatchTypeListener.onItemChanged = function(o)
   {
      matchType = o.value;
      trace("matchType: " + matchType);
      if(matchType == "h2h")
      {
         newXmlNum = 0;
         headerMatchType = "Head to Head";
      }
      else if(matchType == "br")
      {
         newXmlNum = 1;
         headerMatchType = "Bracket";
      }
      prepLeaderboard();
   };
   ddMatchType.addListener(ddMatchTypeListener);
   ddMatchType.x = 10;
   ddMatchType.y = 23;
   var arrMatchType = new Array();
   arrMatchType.push({label:"Head To Head",value:"h2h"});
   arrMatchType.push({label:"Bracket",value:"br"});
   var i = 0;
   while(i < arrMatchType.length)
   {
      ddMatchType.addItem(arrMatchType[i]);
      i++;
   }
   ddMatchType.renderItems();
}
dropdownGroup2.swapDepths(this.getNextHighestDepth());
dropdownGroup1.swapDepths(this.getNextHighestDepth());
