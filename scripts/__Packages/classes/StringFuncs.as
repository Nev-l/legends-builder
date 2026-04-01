class classes.StringFuncs
{
   function StringFuncs()
   {
   }
   static function isNumeric(letter)
   {
      if(!letter.length)
      {
         return false;
      }
      var _loc2_ = letter.charCodeAt(0);
      if(_loc2_ >= 48 && _loc2_ <= 57)
      {
         return true;
      }
      return false;
   }
   static function isWordChar(letter)
   {
      if(!letter.length)
      {
         return false;
      }
      var _loc2_ = letter.charCodeAt(0);
      if(_loc2_ >= 65 && _loc2_ <= 90 || _loc2_ >= 97 && _loc2_ <= 122)
      {
         return true;
      }
      return false;
   }
   static function isKeyboardChar(letter)
   {
      var _loc2_ = " `~!@#$%\\^&*()_\\-+=[]{}|;:\'\",.<>/?\\";
      if(!letter.length)
      {
         return false;
      }
      var _loc3_ = letter.charCodeAt(0);
      if(_loc3_ >= 65 && _loc3_ <= 90 || _loc3_ >= 97 && _loc3_ <= 122 || _loc3_ >= 48 && _loc3_ <= 57)
      {
         return true;
      }
      var _loc4_ = 0;
      while(_loc4_ < _loc2_.length)
      {
         if(letter == _loc2_.charAt(_loc4_))
         {
            return true;
         }
         _loc4_ += 1;
      }
      return false;
   }
   static function unSpecialChars(str)
   {
      var _loc2_ = "";
      _loc2_ = str.split("&apos;").join("\'");
      return _loc2_;
   }
   static function escapeD(str)
   {
      var _loc2_ = str;
      _loc2_ = _loc2_.split("\"").join("\" & QUOTE & \"");
      return _loc2_;
   }
   static function escapeHTML(str)
   {
      var _loc2_ = str;
      _loc2_ = _loc2_.split("\r\n").join(" ");
      _loc2_ = _loc2_.split("\r").join("");
      _loc2_ = _loc2_.split("\n").join("");
      _loc2_ = _loc2_.split("&").join("&amp;");
      _loc2_ = _loc2_.split("<").join("&lt;");
      _loc2_ = _loc2_.split(">").join("&gt;");
      _loc2_ = _loc2_.split(String.fromCharCode(13)).join("<br/>");
      return _loc2_;
   }
   static function escapeAS(str)
   {
      var _loc2_ = "";
      _loc2_ = str.split("\"").join("\\\"");
      return _loc2_;
   }
   static function readCdata(str)
   {
      var _loc2_ = "";
      _loc2_ = classes.StringFuncs.strReplace(str,"&lt;","<");
      _loc2_ = classes.StringFuncs.strReplace(_loc2_,"&gt;",">");
      _loc2_ = classes.StringFuncs.strReplace(_loc2_,"&quot;","\"");
      _loc2_ = classes.StringFuncs.strReplace(_loc2_,"&apos;","\'");
      _loc2_ = classes.StringFuncs.strReplace(_loc2_,"&amp;","&");
      return _loc2_;
   }
   static function strReplace(str, findStr, replaceStr)
   {
      return str.split(findStr).join(replaceStr);
   }
   static function stripHTML(str)
   {
      var _loc2_ = undefined;
      var _loc3_ = undefined;
      _loc2_ = "";
      var _loc4_ = str.length;
      _loc3_ = 0;
      var _loc5_ = undefined;
      while(_loc3_ < _loc4_)
      {
         if(str.charAt(_loc3_) != "<")
         {
            _loc2_ += str.substr(_loc3_,1);
         }
         else
         {
            _loc5_ = str.substr(_loc3_).indexOf(">");
            _loc3_ += _loc5_;
         }
         _loc3_ += 1;
      }
      return _loc2_;
   }
   static function stripNLCR(str)
   {
      str = str.split("\n").join("");
      str = str.split("\r").join("");
      return str;
   }
   static function addLineBreaksAfterImg(str)
   {
      var _loc2_ = undefined;
      _loc2_ = "";
      var _loc3_ = str.indexOf("<img");
      var _loc4_ = undefined;
      var _loc5_ = undefined;
      var _loc6_ = undefined;
      var _loc7_ = undefined;
      var _loc8_ = undefined;
      var _loc9_ = undefined;
      var _loc10_ = undefined;
      var _loc11_ = undefined;
      var _loc12_ = undefined;
      while(_loc3_ != -1)
      {
         trace("found img!!!");
         _loc9_ = 0;
         _loc10_ = "";
         _loc4_ = str.indexOf("height=",_loc3_);
         _loc5_ = str.indexOf(">",_loc3_);
         if(_loc5_ > _loc4_ && _loc4_ != -1 && _loc5_ != -1)
         {
            _loc6_ = str.substring(0,_loc5_ + 1);
            _loc7_ = str.substring(_loc5_ + 1);
            _loc8_ = _loc4_ + 8;
            while(classes.StringFuncs.isNumeric(str.charAt(_loc8_)))
            {
               trace("isNumeric!");
               _loc10_ += str.charAt(_loc8_);
               _loc8_ += 1;
            }
            _loc9_ = Number(_loc10_);
            if(_loc9_ > 0)
            {
               _loc11_ = _loc9_ / 15;
               trace("numOfBreaks: " + _loc11_);
               _loc12_ = 0;
               while(_loc12_ < _loc11_)
               {
                  trace("numOfBreaks!");
                  _loc6_ = _loc6_.concat("<br />");
                  _loc12_ += 1;
               }
            }
            str = _loc6_.concat(_loc7_);
         }
         _loc3_ += 1;
         _loc3_ = str.indexOf("<img",_loc3_);
      }
      _loc2_ = str;
      trace("temp");
      trace(_loc2_);
      return _loc2_;
   }
   static function addHyperlinkHandler(str)
   {
      trace(str);
      str = str.split("href=\"").join("href=\"asfunction:_root.linkHandler,");
      trace(str);
      return str;
   }
   static function underlineHyperlinks(str)
   {
      var _loc2_ = undefined;
      _loc2_ = "";
      var _loc3_ = str.indexOf("href");
      var _loc4_ = undefined;
      var _loc5_ = undefined;
      var _loc6_ = undefined;
      var _loc7_ = undefined;
      var _loc8_ = undefined;
      var _loc9_ = undefined;
      while(_loc3_ != -1)
      {
         trace("found link");
         _loc9_ = "<u/>";
         _loc5_ = str.indexOf(">",_loc3_);
         _loc7_ = str.substring(0,_loc5_ + 1);
         _loc8_ = str.substring(_loc5_ + 1);
         _loc7_ = _loc7_.concat("<u>");
         str = _loc7_.concat(_loc8_);
         _loc6_ = str.indexOf("<",_loc3_);
         _loc7_ = str.substring(0,_loc6_);
         _loc8_ = str.substring(_loc6_);
         _loc7_ = _loc7_.concat("<u/>");
         str = _loc7_.concat(_loc8_);
         _loc3_ += 1;
         _loc3_ = str.indexOf("href",_loc3_);
      }
      _loc2_ = str;
      trace("temp");
      trace(_loc2_);
      return _loc2_;
   }
   static function addLineBreaksAfterParagraphTags(str)
   {
      str = str.split("</p>").join("</p><br/>");
      return str;
   }
   static function addLineBreaksInLists(str)
   {
      str = str.split("</li>").join("</li><br/>");
      return str;
   }
   static function fixHTMLForFlash(str)
   {
      trace(str);
      str = classes.StringFuncs.addLineBreaksAfterImg(str);
      str = classes.StringFuncs.addHyperlinkHandler(str);
      str = classes.StringFuncs.addLineBreaksAfterParagraphTags(str);
      str = classes.StringFuncs.addLineBreaksInLists(str);
      trace(str);
      return str;
   }
}
