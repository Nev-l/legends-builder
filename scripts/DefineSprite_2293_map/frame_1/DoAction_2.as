if(!classes.GlobalData.prefsObj.didViewRace)
{
   classes.GlobalData.prefsObj.didViewRace = 1;
   classes.GlobalData.savePrefsObj();
}
btnHelp.onRelease = function()
{
   tutorialObj = new classes.util.Tutorial(_parent,classes.data.TutorialData.arrIntro,true);
};
btnLeaderboard.onRelease = function()
{
   classes.Control.leaderboardMC.swapDepths(_root.getNextHighestDepth());
   classes.Control.leaderboardMC._visible = true;
   classes.Control.leaderboardMC._parent._visible = true;
   trace(classes.Control.leaderboardMC._parent);
   classes.Control.leaderboardMC.nowShowing();
};
btnDailyChallenge.onRelease = function()
{
   if(classes.Control.serverAvail() == true)
   {
      _root.imp.getDailyChallenge();
   }
};
if(!classes.GlobalData.prefsObj.didFirstRun)
{
   classes.GlobalData.prefsObj.didFirstRun = 1;
   classes.GlobalData.savePrefsObj();
}
for(§each§ in bubblesGroup)
{
   if(typeof bubblesGroup[eval("each")] == "movieclip" && eval("each").indexOf("Title") == -1)
   {
      bubblesGroup[eval("each")].idx = Number(eval("each").substring(eval("each").length - 1));
      bubblesGroup[eval("each")].onRollOver = function()
      {
         classes.Effects.bump(this,120);
      };
      bubblesGroup[eval("each")].onRollOut = function()
      {
         classes.Effects.bump(this,100);
      };
      bubblesGroup[eval("each")].onRelease = function()
      {
         animOnClick(this);
      };
   }
}
var maxLocations = 4;
if(_global.locationXML != undefined && _global.locationXML.firstChild != undefined && _global.locationXML.firstChild.childNodes.length > 0)
{
   maxLocations = _global.locationXML.firstChild.childNodes.length;
}
var myLoc = Math.round(Number(_global.loginXML.firstChild.firstChild.attributes.lid) / 100);
if(myLoc < 1)
{
   myLoc = 1;
}
if(myLoc > maxLocations)
{
   myLoc = maxLocations;
}
i = 1;
while(i <= 5)
{
   if(i > maxLocations)
   {
      this["hi" + i]._visible = false;
      bubblesGroup["home" + i]._visible = false;
      bubblesGroup["homeTitle" + i]._visible = false;
      bubblesGroup["shop" + i]._visible = false;
      bubblesGroup["dealer" + i]._visible = false;
      if(bubblesGroup["forSale" + i] != undefined)
      {
         bubblesGroup["forSale" + i]._visible = false;
      }
      i++;
   }
   else
   {
      bubblesGroup["shop" + i].onRelease = function()
      {
         classes.Frame._MC.goMainSection("shop",Number(this.idx * 100));
      };
      bubblesGroup["dealer" + i].onRelease = function()
      {
         classes.Frame._MC.goMainSection("dealer",Number(this.idx * 100));
      };
      if(myLoc == i)
      {
         this["hi" + i]._visible = true;
         bubblesGroup["home" + i].onRelease = function()
         {
            classes.Frame._MC.goMainSection("home",Number(this.idx * 100));
         };
      }
      else
      {
         this["hi" + i]._visible = false;
         bubblesGroup["home" + i]._visible = false;
         bubblesGroup["homeTitle" + i]._visible = false;
         if(i < myLoc)
         {
            bubblesGroup.attachMovie("forSaleDowngrade","forSale" + i,bubblesGroup.getNextHighestDepth(),{_x:bubblesGroup["home" + i]._x,_y:bubblesGroup["home" + i]._y});
            bubblesGroup["forSale" + i].toLoc = i;
            classes.Effects.roBump(bubblesGroup["forSale" + i]);
            bubblesGroup["forSale" + i].onRelease = function()
            {
               classes.SectionHome.showMove(this.toLoc * 100);
            };
         }
         else if(i == myLoc + 1)
         {
            bubblesGroup.attachMovie("forSaleUpgrade","forSale" + i,bubblesGroup.getNextHighestDepth(),{_x:bubblesGroup["home" + i]._x,_y:bubblesGroup["home" + i]._y});
            bubblesGroup["forSale" + i].toLoc = i;
            classes.Effects.roBump(bubblesGroup["forSale" + i]);
            bubblesGroup["forSale" + i].onRelease = function()
            {
               classes.SectionHome.showMove(this.toLoc * 100);
            };
         }
         else
         {
            bubblesGroup.attachMovie("forSaleUnavailable","forSale" + i,bubblesGroup.getNextHighestDepth(),{_x:bubblesGroup["home" + i]._x,_y:bubblesGroup["home" + i]._y});
         }
      }
      i++;
   }
}
bubblesGroup.raceTrack.onRelease = function()
{
   classes.Frame._MC.goMainSection("track");
};
bubblesGroup.impound.onRelease = function()
{
   classes.Frame._MC.goMainSection("impound");
};
bubblesGroup.usedcars.onRelease = function()
{
   classes.Frame._MC.goMainSection("classified");
};
bubblesGroup.team.onRelease = function()
{
   var _loc2_;
   if(Number(classes.GlobalData.attr.ti))
   {
      classes.Frame._MC.goMainSection("teamhq");
   }
   else
   {
      _loc2_ = "Sorry, you can not enter Team HQ unless you belong to a team.  To apply to an existing team, browse for teams in the Viewer, and click Join for those that interest you.\r\rTo create your own team, click Home on the main map, and then view your Team Status page.";
      classes.Control.dialogAlert("Not on a Team",_loc2_,CB_goToViewer);
   }
};
bubblesGroup.court.onRelease = function()
{
   classes.Frame._MC.goMainSection("newsRoom");
};
