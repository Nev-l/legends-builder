class mx.data.binding.DataAccessor
{
   var dataAccessor;
   var component;
   var property;
   var location;
   var type;
   function DataAccessor()
   {
   }
   function getAnyTypedValue(suggestedTypes)
   {
      var _loc3_ = 0;
      var _loc4_ = undefined;
      while(_loc3_ < suggestedTypes.length)
      {
         _loc4_ = this.getTypedValue(suggestedTypes[_loc3_]);
         if(_loc4_ != null)
         {
            return _loc4_;
         }
         _loc3_ += 1;
      }
      _loc4_ = this.getTypedValue();
      _loc3_ = 0;
      var _loc5_ = undefined;
      while(_loc3_ < suggestedTypes.length)
      {
         _loc5_ = suggestedTypes[_loc3_];
         if(_loc5_ == "String")
         {
            return new mx.data.binding.TypedValue(String(_loc4_.value),_loc5_);
         }
         if(_loc5_ == "Number")
         {
            return new mx.data.binding.TypedValue(Number(_loc4_.value),_loc5_);
         }
         if(_loc5_ == "Boolean")
         {
            return new mx.data.binding.TypedValue(Boolean(_loc4_.value),_loc5_);
         }
         _loc3_ += 1;
      }
      return _loc4_;
   }
   function setAnyTypedValue(newValue)
   {
      var _loc3_ = this.getSettableTypes();
      if(_loc3_ == null || -1 != mx.data.binding.DataAccessor.findString(newValue.typeName,_loc3_))
      {
         return this.setTypedValue(newValue);
      }
      var _loc4_ = 0;
      var _loc5_ = undefined;
      var _loc6_ = undefined;
      var _loc7_ = undefined;
      while(_loc4_ < _loc3_.length)
      {
         _loc5_ = _loc3_[_loc4_];
         if(_loc5_ == "String")
         {
            return this.setTypedValue(new mx.data.binding.TypedValue(String(newValue.value),_loc5_));
         }
         if(_loc5_ == "Number")
         {
            _loc6_ = Number(newValue.value);
            _loc7_ = this.setTypedValue(new mx.data.binding.TypedValue(_loc6_,_loc5_));
            if(_loc6_.toString() == "NaN")
            {
               return ["Failed to convert \'" + newValue.value + "\' to a number"];
            }
            return _loc7_;
         }
         if(_loc5_ == "Boolean")
         {
            return this.setTypedValue(new mx.data.binding.TypedValue(Boolean(newValue.value),_loc5_));
         }
         _loc4_ += 1;
      }
      return this.dataAccessor.setTypedValue(newValue);
   }
   function getTypedValue(requestedType)
   {
      var _loc3_ = this.dataAccessor.getTypedValue(requestedType);
      return _loc3_;
   }
   function getGettableTypes()
   {
      return null;
   }
   function setTypedValue(newValue)
   {
      return this.dataAccessor.setTypedValue(newValue);
   }
   function getSettableTypes()
   {
      return null;
   }
   function findLastAccessor()
   {
      return this.dataAccessor != null ? this.dataAccessor.findLastAccessor() : this;
   }
   function setupDataAccessor(component, property, location)
   {
      this.component = component;
      this.property = property;
      this.location = location;
      this.type = component.findSchema(property,location);
   }
   static function findString(str, arr)
   {
      var _loc3_ = str.toLowerCase();
      var _loc4_ = 0;
      while(_loc4_ < arr.length)
      {
         if(arr[_loc4_].toLowerCase() == _loc3_)
         {
            return _loc4_;
         }
         _loc4_ += 1;
      }
      return -1;
   }
   static function conversionFailed(newValue, target)
   {
      return "Failed to convert to " + target + ": \'" + newValue.value + "\'";
   }
}
