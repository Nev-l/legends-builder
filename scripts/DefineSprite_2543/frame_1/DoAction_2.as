function prepLeaderboard()
{
   trace("listType[" + listType + "], periodType[" + newPeriodType + "], periodNum[" + newPeriodNum + "]");
   scrollerGroup.removeMovieClip();
   scrollerGroup = this.createEmptyMovieClip("scrollerGroup",this.getNextHighestDepth());
   scrollerGroup._x = 291;
   scrollerGroup._y = 196;
   scrollerGroup.createEmptyMovieClip("scrollerContent",scrollerGroup.getNextHighestDepth());
   scrollerGroup.scrollerObj = new controls.ScrollPane(scrollerGroup.scrollerContent,459,341);
   var _loc2_ = 0;
   while(_loc2_ < listTypeXML.firstChild.childNodes.length)
   {
      if(listType == listTypeXML.firstChild.childNodes[_loc2_].attributes.id)
      {
         txtHead = "<b>" + listTypeXML.firstChild.childNodes[_loc2_].attributes.n + "</b>";
      }
      _loc2_ += 1;
   }
   prepColumnHeaders();
   gotoAndPlay(listType);
}
function removeExtraDropdowns()
{
   ddRaceType.destroy();
   ddCarType.destroy();
   ddEngineType.destroy();
   dropdownGroup2.removeMovieClip();
   delete dropdownGroup2;
   dropdownGroup3.removeMovieClip();
   delete dropdownGroup3;
}
function prepColumnHeaders()
{
   if(listType == "sc")
   {
      if(newPeriodType == "All")
      {
         txtColHead1 = "SC Score";
         txtColHead2 = "Level";
         txtColHead3 = "";
      }
      else
      {
         txtColHead1 = "";
         txtColHead2 = "SC Gain";
         txtColHead3 = "";
      }
   }
   else if(listType == "ba")
   {
      if(newPeriodType == "All")
      {
         txtColHead1 = "Net Wealth";
         txtColHead2 = "Cars";
         txtColHead3 = "Residence";
      }
      else
      {
         txtColHead1 = "Wealth Gain";
         txtColHead2 = "Cars";
         txtColHead3 = "Residence";
      }
   }
   else if(listType == "ks")
   {
      txtColHead1 = "Streak";
      txtColHead2 = "Race Type";
      txtColHead3 = "";
   }
   else if(listType == "fc")
   {
      txtColHead1 = "Best ET";
      txtColHead2 = "Car";
      txtColHead3 = "Engine Type";
   }
}
function buildLeaderboard(listArr)
{
   var _loc2_ = 22;
   var _loc3_ = Math.min(topCount,listArr.length);
   trace("top: " + _loc3_);
   var _loc4_ = 0;
   var _loc5_ = undefined;
   while(_loc4_ < _loc3_)
   {
      _loc5_ = listArr[_loc4_];
      _loc5_._y = _loc4_ * _loc2_;
      scrollerGroup.scrollerContent.attachMovie("leaderboardItem","item" + _loc4_,scrollerGroup.scrollerContent.getNextHighestDepth(),_loc5_);
      _loc4_ += 1;
   }
   scrollerGroup.scrollerObj.refreshScroller();
}
function getCarName(cid)
{
   var _loc2_ = menuXML.idMap.carMenu;
   var _loc3_ = 0;
   while(_loc3_ < _loc2_.childNodes.length)
   {
      if(_loc2_.childNodes[_loc3_].attributes.cid == cid)
      {
         return _loc2_.childNodes[_loc3_].attributes.n;
      }
      _loc3_ += 1;
   }
   return "";
}
function getEngineTypeName(e)
{
   var _loc2_ = "";
   switch(e)
   {
      case "n":
         _loc2_ = "NA";
         break;
      case "t":
         _loc2_ = "Turbo";
         break;
      case "s":
         _loc2_ = "SC";
   }
   return _loc2_;
}
