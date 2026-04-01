if(!dropdownGroup2)
{
   var dropdownGroup2 = this.attachMovie("leaderboardDropdownGroup","dropdownGroup2",this.getNextHighestDepth());
   dropdownGroup2._x = 50;
   dropdownGroup2._y = 205;
   dropdownGroup2.txtHeader = "Car:";
   var ddCarType = new classes.ui.SweetDropdown2b(dropdownGroup2,"ddBase","Arial","Arial",144,0,true,undefined,18);
   var ddCarTypeListener = new Object();
   ddCarTypeListener.onItemChanged = function(o)
   {
      newCarType = o.value;
      trace("carType: " + carType);
      prepLeaderboard();
   };
   ddCarType.addListener(ddCarTypeListener);
   ddCarType.x = 10;
   ddCarType.y = 23;
   var carsXML = menuXML.idMap.carMenu;
   var arrCarType = new Array();
   var i = 0;
   while(i < carsXML.childNodes.length)
   {
      arrCarType.push({label:carsXML.childNodes[i].attributes.n,value:carsXML.childNodes[i].attributes.cid});
      i++;
   }
   var i = 0;
   while(i < arrCarType.length)
   {
      ddCarType.addItem(arrCarType[i]);
      i++;
   }
   ddCarType.renderItems();
}
if(!dropdownGroup3)
{
   var dropdownGroup3 = this.attachMovie("leaderboardDropdownGroup","dropdownGroup3",this.getNextHighestDepth());
   dropdownGroup3._x = 50;
   dropdownGroup3._y = 260;
   dropdownGroup3.txtHeader = "Engine Type:";
   var ddEngineType = new classes.ui.SweetDropdown2b(dropdownGroup3,"ddBase","Arial","Arial",72,0,true,undefined,18);
   var ddEngineTypeListener = new Object();
   ddEngineTypeListener.onItemChanged = function(o)
   {
      engineType = o.value;
      trace("engineType: " + engineType);
      prepLeaderboard();
   };
   ddEngineType.addListener(ddEngineTypeListener);
   ddEngineType.x = 10;
   ddEngineType.y = 23;
   var arrEngineType = new Array();
   arrEngineType.push({label:"Overall",value:"o"});
   arrEngineType.push({label:"Naturally Aspirated",value:"n"});
   arrEngineType.push({label:"Turbocharged",value:"t"});
   arrEngineType.push({label:"Supercharged",value:"s"});
   var i = 0;
   while(i < arrEngineType.length)
   {
      ddEngineType.addItem(arrEngineType[i]);
      i++;
   }
   ddEngineType.renderItems();
}
dropdownGroup2.swapDepths(this.getNextHighestDepth());
dropdownGroup1.swapDepths(this.getNextHighestDepth());
