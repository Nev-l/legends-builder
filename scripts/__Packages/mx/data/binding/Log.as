class mx.data.binding.Log
{
   var level;
   var name;
   static var NONE = -1;
   static var BRIEF = 0;
   static var VERBOSE = 1;
   static var DEBUG = 2;
   static var INFO = 2;
   static var WARNING = 1;
   static var ERROR = 0;
   var showDetails = false;
   var nestLevel = 0;
   function Log(logLevel, logName)
   {
      this.level = logLevel != undefined ? logLevel : mx.data.binding.Log.BRIEF;
      this.name = this.name != undefined ? this.name : "";
   }
   function logInfo(msg, level)
   {
      if(level == undefined)
      {
         level = mx.data.binding.Log.BRIEF;
      }
      this.onLog(this.getDateString() + " " + this.name + ": " + mx.data.binding.ObjectDumper.toString(msg));
   }
   function logData(target, message, info, level)
   {
      if(level == undefined)
      {
         level = mx.data.binding.Log.VERBOSE;
      }
      var _loc6_ = this.name.length <= 0 ? " " : " " + this.name + ": ";
      var _loc7_ = target != null ? target + ": " : "";
      if(_loc7_.indexOf("_level0.") == 0)
      {
         _loc7_ = _loc7_.substr(8);
      }
      var _loc8_ = this.getDateString() + _loc6_ + _loc7_ + mx.data.binding.Log.substituteIntoString(message,info,50);
      var _loc9_ = undefined;
      if(this.showDetails && info != null)
      {
         _loc8_ += "\n    " + mx.data.binding.ObjectDumper.toString(info);
      }
      else
      {
         _loc9_ = 0;
         while(_loc9_ < this.nestLevel)
         {
            _loc8_ = "    " + _loc8_;
            _loc9_ += 1;
         }
      }
      this.onLog(_loc8_);
   }
   function onLog(message)
   {
      trace(message);
   }
   function getDateString()
   {
      var _loc1_ = new Date();
      return _loc1_.getMonth() + 1 + "/" + _loc1_.getDate() + " " + _loc1_.getHours() + ":" + _loc1_.getMinutes() + ":" + _loc1_.getSeconds();
   }
   static function substituteIntoString(message, info, maxlen, rawDataType)
   {
      var _loc5_ = "";
      if(info == null)
      {
         return message;
      }
      var _loc6_ = message.split("<");
      if(_loc6_ == null)
      {
         return message;
      }
      _loc5_ += _loc6_[0];
      var _loc7_ = 1;
      var _loc8_ = undefined;
      var _loc9_ = undefined;
      var _loc10_ = undefined;
      var _loc11_ = undefined;
      var _loc12_ = undefined;
      var _loc13_ = undefined;
      var _loc14_ = undefined;
      while(_loc7_ < _loc6_.length)
      {
         _loc8_ = _loc6_[_loc7_].split(">");
         _loc9_ = _loc8_[0].split(".");
         _loc10_ = info;
         _loc11_ = rawDataType;
         _loc12_ = 0;
         while(_loc12_ < _loc9_.length)
         {
            _loc13_ = _loc9_[_loc12_];
            if(_loc13_ != "")
            {
               _loc11_ = mx.data.binding.FieldAccessor.findElementType(_loc11_,_loc13_);
               _loc14_ = new mx.data.binding.FieldAccessor(null,null,_loc10_,_loc13_,_loc11_,null,null);
               _loc10_ = _loc14_.getValue();
            }
            _loc12_ += 1;
         }
         if(typeof _loc10_ != "string")
         {
            _loc10_ = mx.data.binding.ObjectDumper.toString(_loc10_);
         }
         if(_loc10_.indexOf("_level0.") == 0)
         {
            _loc10_ = _loc10_.substr(8);
         }
         if(maxlen != null && _loc10_.length > maxlen)
         {
            _loc10_ = _loc10_.substr(0,maxlen) + "...";
         }
         _loc5_ += _loc10_;
         _loc5_ += _loc8_[1];
         _loc7_ += 1;
      }
      var _loc15_ = _loc5_.split("&gt;");
      _loc5_ = _loc15_.join(">");
      _loc15_ = _loc5_.split("&lt;");
      _loc5_ = _loc15_.join("<");
      return _loc5_;
   }
}
