class classes.data.Validate
{
   function Validate()
   {
   }
   static function cleanMessage(inputStr)
   {
      var _loc2_ = "";
      var _loc3_ = undefined;
      var _loc4_ = 0;
      while(_loc4_ < inputStr.length)
      {
         _loc3_ = inputStr.charAt(_loc4_);
         if(classes.StringFuncs.isKeyboardChar(_loc3_))
         {
            _loc2_ += _loc3_;
         }
         _loc4_ += 1;
      }
      return _loc2_;
   }
}
