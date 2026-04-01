stop();
var tftListXML;
if(!tftListXML)
{
   tftListXML = new XML();
   tftListXML.ignoreWhite = true;
}
tftListXML.onLoad = function(success)
{
   trace("tftListXML: " + success);
   var _loc3_ = undefined;
   var _loc4_ = undefined;
   var _loc5_ = undefined;
   var _loc6_ = undefined;
   var _loc7_ = undefined;
   var _loc8_ = undefined;
   var _loc9_ = undefined;
   var _loc10_ = undefined;
   var _loc11_ = undefined;
   if(success)
   {
      _loc4_ = this.firstChild.firstChild.childNodes[listNum].childNodes.length;
      _loc5_ = new Array();
      _loc8_ = 0;
      while(_loc8_ < _loc4_)
      {
         _loc9_ = this.firstChild.firstChild.childNodes[listNum].childNodes[_loc8_].attributes;
         _loc10_ = new Object();
         _loc10_.id = _loc9_.i;
         _loc10_.txtName = _loc9_.n;
         _loc10_.t = _loc9_.t;
         _loc11_ = Number(_loc9_.t);
         if(!_loc3_)
         {
            _loc3_ = _loc11_;
         }
         if(matchType == "br")
         {
            _loc10_.txtCol2 = "+" + _loc9_.t;
         }
         else
         {
            _loc10_.txtCol2 = _loc9_.t;
         }
         if(_loc11_ != _loc7_)
         {
            _loc6_ = _loc8_ + 1;
            _loc7_ = _loc11_;
         }
         _loc10_.txtRank = _loc6_ + ".";
         _loc5_.push(_loc10_);
         _loc8_ += 1;
      }
      buildLeaderboard(_loc5_);
   }
};
if(periodType != newPeriodType || periodNum != newPeriodNum || carType != newCarType || xmlNum != newXmlNum || isNewSection)
{
   periodType = newPeriodType;
   periodNum = newPeriodNum;
   carType = newCarType;
   xmlNum = newXmlNum;
   _root.leaderboardGetContent(listType,periodType,periodNum,null,xmlNum);
   isNewSection = false;
}
else
{
   tftListXML.onLoad(true);
}
