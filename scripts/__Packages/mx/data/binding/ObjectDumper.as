class mx.data.binding.ObjectDumper
{
   var inProgress;
   function ObjectDumper()
   {
      this.inProgress = new Array();
   }
   static function toString(obj, showFunctions, showUndefined, showXMLstructures, maxLineLength, indent)
   {
      var _loc7_ = new mx.data.binding.ObjectDumper();
      if(maxLineLength == undefined)
      {
         maxLineLength = 100;
      }
      if(indent == undefined)
      {
         indent = 0;
      }
      return _loc7_.realToString(obj,showFunctions,showUndefined,showXMLstructures,maxLineLength,indent);
   }
   function realToString(obj, showFunctions, showUndefined, showXMLstructures, maxLineLength, indent)
   {
      var _loc8_ = 0;
      while(_loc8_ < this.inProgress.length)
      {
         if(this.inProgress[_loc8_] == obj)
         {
            return "***";
         }
         _loc8_ += 1;
      }
      this.inProgress.push(obj);
      indent += 1;
      var _loc9_ = typeof obj;
      var _loc10_ = undefined;
      var _loc11_ = undefined;
      var _loc12_ = undefined;
      var _loc13_ = undefined;
      var _loc14_ = undefined;
      var _loc15_ = undefined;
      var _loc16_ = undefined;
      if(obj instanceof XMLNode && showXMLstructures != true)
      {
         _loc10_ = obj.toString();
      }
      else if(obj instanceof Date)
      {
         _loc10_ = obj.toString();
      }
      else if(_loc9_ == "object")
      {
         _loc11_ = new Array();
         if(obj instanceof Array)
         {
            _loc10_ = "[";
            _loc12_ = 0;
            while(_loc12_ < obj.length)
            {
               _loc11_.push(_loc12_);
               _loc12_ += 1;
            }
         }
         else
         {
            _loc10_ = "{";
            for(_loc12_ in obj)
            {
               _loc11_.push(_loc12_);
            }
            _loc11_.sort();
         }
         _loc13_ = "";
         _loc14_ = 0;
         while(_loc14_ < _loc11_.length)
         {
            _loc15_ = obj[_loc11_[_loc14_]];
            _loc16_ = true;
            if(typeof _loc15_ == "function")
            {
               _loc16_ = showFunctions == true;
            }
            if(typeof _loc15_ == "undefined")
            {
               _loc16_ = showUndefined == true;
            }
            if(_loc16_)
            {
               _loc10_ += _loc13_;
               if(!(obj instanceof Array))
               {
                  _loc10_ += _loc11_[_loc14_] + ": ";
               }
               _loc10_ += this.realToString(_loc15_,showFunctions,showUndefined,showXMLstructures,maxLineLength,indent);
               _loc13_ = ", `";
            }
            _loc14_ += 1;
         }
         if(obj instanceof Array)
         {
            _loc10_ += "]";
         }
         else
         {
            _loc10_ += "}";
         }
      }
      else if(_loc9_ == "function")
      {
         _loc10_ = "function";
      }
      else if(_loc9_ == "string")
      {
         _loc10_ = "\"" + obj + "\"";
      }
      else
      {
         _loc10_ = String(obj);
      }
      if(_loc10_ == "undefined")
      {
         _loc10_ = "-";
      }
      this.inProgress.pop();
      return mx.data.binding.ObjectDumper.replaceAll(_loc10_,"`",_loc10_.length >= maxLineLength ? "\n" + this.doIndent(indent) : "");
   }
   static function replaceAll(str, from, to)
   {
      var _loc4_ = str.split(from);
      var _loc5_ = "";
      var _loc6_ = "";
      var _loc7_ = 0;
      while(_loc7_ < _loc4_.length)
      {
         _loc5_ += _loc6_ + _loc4_[_loc7_];
         _loc6_ = to;
         _loc7_ += 1;
      }
      return _loc5_;
   }
   function doIndent(indent)
   {
      var _loc2_ = "";
      var _loc3_ = 0;
      while(_loc3_ < indent)
      {
         _loc2_ += "     ";
         _loc3_ += 1;
      }
      return _loc2_;
   }
}
