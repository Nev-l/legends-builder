stop();
var fcListXML;
if(!fcListXML)
{
   fcListXML = new XML();
   fcListXML.ignoreWhite = true;
}
fcListXML.onLoad = function(success)
{
   trace("fcListXML: " + success);
   var _loc3_ = undefined;
   var _loc4_ = undefined;
   var _loc5_ = undefined;
   var _loc6_ = undefined;
   var _loc7_ = undefined;
   var _loc8_ = undefined;
   var _loc9_ = undefined;
   var _loc10_ = undefined;
   var _loc11_ = undefined;
   var _loc12_ = undefined;
   var _loc13_ = undefined;
   var _loc14_ = undefined;
   var _loc15_ = undefined;
   if(success)
   {
      _loc4_ = new Array();
      _loc6_ = this.firstChild.childNodes.length;
      _loc7_ = 0;
      while(_loc7_ < _loc6_)
      {
         if(this.firstChild.childNodes[_loc7_].attributes.e == engineType || engineType == "o")
         {
            _loc5_ = this.firstChild.childNodes[_loc7_];
            _loc8_ = _loc5_.childNodes.length;
            trace("e: " + _loc5_.attributes.e);
            _loc9_ = 0;
            while(_loc9_ < _loc8_)
            {
               _loc10_ = _loc5_.childNodes[_loc9_].attributes;
               _loc11_ = {i:_loc10_.i,n:_loc10_.n,tf:_loc10_.tf,e:_loc5_.attributes.e,et:Number(_loc10_.et),c:_loc10_.c,ac:_loc10_.ac};
               _loc4_.push(_loc11_);
               _loc9_ += 1;
            }
         }
         _loc7_ += 1;
      }
      _loc4_.sortOn("et",Array.NUMERIC);
      _loc12_ = new Array();
      _loc6_ = _loc4_.length;
      _loc7_ = 0;
      while(_loc7_ < _loc6_)
      {
         _loc10_ = _loc4_[_loc7_];
         _loc11_ = new Object();
         _loc11_.id = _loc10_.i;
         _loc11_.txtName = _loc10_.n;
         _loc11_.tf = _loc10_.tf;
         _loc15_ = Number(_loc10_.et);
         if(!_loc3_)
         {
            _loc3_ = _loc15_;
         }
         _loc11_.txtCol1 = classes.NumFuncs.zeroFill(_loc15_,3);
         _loc11_.txtCol2 = getCarName(Number(_loc10_.c));
         _loc11_.acid = Number(_loc10_.ac);
         _loc11_.txtCol3 = getEngineTypeName(_loc10_.e);
         if(_loc15_ != _loc14_)
         {
            _loc13_ = _loc7_ + 1;
            _loc14_ = _loc15_;
         }
         _loc11_.txtRank = _loc13_ + ".";
         _loc12_.push(_loc11_);
         _loc7_ += 1;
      }
      buildLeaderboard(_loc12_);
   }
};
if(periodType != newPeriodType || periodNum != newPeriodNum || carType != newCarType || isNewSection)
{
   periodType = newPeriodType;
   periodNum = newPeriodNum;
   carType = newCarType;
   _root.leaderboardGetContent(listType,periodType,periodNum,carType);
   isNewSection = false;
}
else
{
   fcListXML.onLoad(true);
}
