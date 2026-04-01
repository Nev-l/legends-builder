class mx.xpath.FilterStack
{
   var __expr;
   var __ops;
   function FilterStack(filterVal)
   {
      this.__expr = new Array();
      this.__ops = new Array();
      var _loc3_ = new mx.utils.StringTokenParser(filterVal);
      var _loc4_ = _loc3_.nextToken();
      var _loc5_ = undefined;
      var _loc6_ = _loc3_.token;
      while(_loc4_ != mx.utils.StringTokenParser.tkEOF)
      {
         if(_loc6_ == "@")
         {
            _loc4_ = _loc3_.nextToken();
            _loc6_ = _loc3_.token;
            _loc5_ = new mx.xpath.FilterExpr(true,_loc6_,null);
            this.__expr.splice(0,0,_loc5_);
            if(_loc3_.nextToken() == mx.utils.StringTokenParser.tkSymbol)
            {
               if(_loc3_.token == "=")
               {
                  _loc4_ = _loc3_.nextToken();
                  _loc5_.value = _loc3_.token;
               }
            }
         }
         else if(_loc6_ == "and" || _loc6_ == "or")
         {
            this.__ops.splice(0,0,_loc6_);
         }
         else if(_loc6_ != ")" && _loc6_ != "(")
         {
            _loc5_ = new mx.xpath.FilterExpr(false,_loc6_,null);
            this.__expr.splice(0,0,_loc5_);
            if(_loc3_.nextToken() == mx.utils.StringTokenParser.tkSymbol)
            {
               if(_loc3_.token == "=")
               {
                  _loc4_ = _loc3_.nextToken();
                  _loc5_.value = _loc3_.token;
               }
            }
         }
         _loc4_ = _loc3_.nextToken();
         _loc6_ = _loc3_.token;
      }
   }
   function get exprs()
   {
      return this.__expr;
   }
   function get ops()
   {
      return this.__ops;
   }
}
