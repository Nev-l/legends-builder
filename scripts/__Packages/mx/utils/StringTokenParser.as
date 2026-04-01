class mx.utils.StringTokenParser
{
   var _source;
   var _skipChars;
   static var tkEOF = -1;
   static var tkSymbol = 0;
   static var tkString = 1;
   static var tkInteger = 2;
   static var tkFloat = 3;
   var _index = 0;
   var _token = "";
   function StringTokenParser(source, skipChars)
   {
      this._source = source;
      this._skipChars = skipChars != undefined ? skipChars : null;
   }
   function get token()
   {
      return this._token;
   }
   function getPos()
   {
      return this._index;
   }
   function nextToken()
   {
      var _loc2_ = undefined;
      var _loc3_ = undefined;
      var _loc4_ = this._source.length;
      this.skipBlanks();
      if(this._index >= _loc4_)
      {
         return mx.utils.StringTokenParser.tkEOF;
      }
      _loc3_ = this._source.charCodeAt(this._index);
      if(_loc3_ >= 65 && _loc3_ <= 90 || _loc3_ >= 97 && _loc3_ <= 122 || _loc3_ >= 192 && _loc3_ <= Infinity || _loc3_ == 95)
      {
         _loc2_ = this._index;
         this._index += 1;
         _loc3_ = this._source.charCodeAt(this._index);
         while((_loc3_ >= 65 && _loc3_ <= 90 || _loc3_ >= 97 && _loc3_ <= 122 || _loc3_ >= 48 && _loc3_ <= 57 || _loc3_ >= 192 && _loc3_ <= Infinity || _loc3_ == 95) && this._index < _loc4_)
         {
            this._index += 1;
            _loc3_ = this._source.charCodeAt(this._index);
         }
         this._token = this._source.substring(_loc2_,this._index);
         return mx.utils.StringTokenParser.tkSymbol;
      }
      if(_loc3_ == 34 || _loc3_ == 39)
      {
         this._index += 1;
         _loc2_ = this._index;
         _loc3_ = this._source.charCodeAt(_loc2_);
         while(_loc3_ != 34 && _loc3_ != 39 && this._index < _loc4_)
         {
            this._index += 1;
            _loc3_ = this._source.charCodeAt(this._index);
         }
         this._token = this._source.substring(_loc2_,this._index);
         this._index += 1;
         return mx.utils.StringTokenParser.tkString;
      }
      var _loc5_ = undefined;
      if(_loc3_ == 45 || _loc3_ >= 48 && _loc3_ <= 57)
      {
         _loc5_ = mx.utils.StringTokenParser.tkInteger;
         _loc2_ = this._index;
         this._index += 1;
         _loc3_ = this._source.charCodeAt(this._index);
         while(_loc3_ >= 48 && _loc3_ <= 57 && this._index < _loc4_)
         {
            this._index += 1;
            _loc3_ = this._source.charCodeAt(this._index);
         }
         if(this._index < _loc4_)
         {
            if(_loc3_ >= 48 && _loc3_ <= 57 || _loc3_ == 46 || _loc3_ == 43 || _loc3_ == 45 || _loc3_ == 101 || _loc3_ == 69)
            {
               _loc5_ = mx.utils.StringTokenParser.tkFloat;
            }
            while((_loc3_ >= 48 && _loc3_ <= 57 || _loc3_ == 46 || _loc3_ == 43 || _loc3_ == 45 || _loc3_ == 101 || _loc3_ == 69) && this._index < _loc4_)
            {
               this._index += 1;
               _loc3_ = this._source.charCodeAt(this._index);
            }
         }
         this._token = this._source.substring(_loc2_,this._index);
         return _loc5_;
      }
      this._token = this._source.charAt(this._index);
      this._index += 1;
      return mx.utils.StringTokenParser.tkSymbol;
   }
   function skipBlanks()
   {
      var _loc2_ = undefined;
      if(this._index < this._source.length)
      {
         _loc2_ = this._source.charAt(this._index);
         while(_loc2_ == " " || this._skipChars != null && this.skipChar(_loc2_))
         {
            this._index += 1;
            _loc2_ = this._source.charAt(this._index);
         }
      }
   }
   function skipChar(ch)
   {
      var _loc3_ = 0;
      while(_loc3_ < this._skipChars.length)
      {
         if(ch == this._skipChars[_loc3_])
         {
            return true;
         }
         _loc3_ += 1;
      }
      return false;
   }
}
