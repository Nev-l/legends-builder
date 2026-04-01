function prepLeaderboard()
{
   trace("listType[" + listType + "], periodType[" + newPeriodType + "], periodNum[" + newPeriodNum + "]");
   scrollerGroup.removeMovieClip();
   trace("ALPHA SET TO 0");
   scrollerGroup._alpha = 0;
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
         if(headerMatchType != "")
         {
            txtHead = "<b>" + listTypeXML.firstChild.childNodes[_loc2_].attributes.n + ": " + headerMatchType + " - " + headerRaceType + "</b>";
         }
         else
         {
            txtHead = "<b>" + listTypeXML.firstChild.childNodes[_loc2_].attributes.n + "</b>";
         }
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
   if(listType == "tsc")
   {
      if(newPeriodType == "All")
      {
         txtColHead1 = "";
         txtColHead2 = "SC Score";
         txtColHead3 = "";
      }
      else
      {
         txtColHead1 = "";
         txtColHead2 = "SC Gain";
         txtColHead3 = "";
      }
   }
   else if(listType == "tba")
   {
      if(newPeriodType == "All")
      {
         txtColHead1 = "";
         txtColHead2 = "Net Wealth";
         txtColHead3 = "";
      }
      else
      {
         txtColHead1 = "";
         txtColHead2 = "Wealth Gain";
         txtColHead3 = "";
      }
   }
   else if(listType == "tft")
   {
      txtColHead1 = "";
      txtColHead2 = "Time";
      txtColHead3 = "";
   }
}
function buildLeaderboard(listArr)
{
   var _loc2_ = 22;
   var _loc3_ = Math.min(topCount,listArr.length);
   trace("top: " + _loc3_);
   trace("ALPHA SET TO 100");
   scrollerGroup._alpha = 100;
   var _loc4_ = 0;
   var _loc5_ = undefined;
   while(_loc4_ < _loc3_)
   {
      _loc5_ = listArr[_loc4_];
      _loc5_._y = _loc4_ * _loc2_;
      _loc5_.isTeam = true;
      _loc5_.isBracket = true;
      scrollerGroup.scrollerContent.attachMovie("leaderboardItem","item" + _loc4_,scrollerGroup.scrollerContent.getNextHighestDepth(),_loc5_);
      _loc4_ += 1;
   }
   scrollerGroup.scrollerObj.refreshScroller();
}
