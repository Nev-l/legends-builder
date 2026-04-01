function getGaugeID(carXML)
{
   trace("getGaugeID");
   var _loc2_ = 0;
   var _loc3_ = 0;
   while(_loc3_ < carXML.firstChild.childNodes.length)
   {
      if(carXML.firstChild.childNodes[_loc3_].attributes.ci == 172)
      {
         trace("found gaugeID!");
         _loc2_ = carXML.firstChild.childNodes[_loc3_].attributes.di;
         trace(_loc2_);
         break;
      }
      _loc3_ += 1;
   }
   return _loc2_;
}
