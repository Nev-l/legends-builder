class mx.data.kinds.Data extends mx.data.binding.DataAccessor
{
   var property;
   var location;
   var component;
   function Data()
   {
      super();
   }
   function getTypedValue(requestedType)
   {
      var _loc3_ = undefined;
      var _loc4_ = this.getFieldAccessor().getValue();
      var _loc5_ = null;
      var _loc6_ = undefined;
      if(_loc4_ != null)
      {
         if(_loc4_ instanceof Array)
         {
            _loc5_ = "Array";
         }
         else if(_loc4_ instanceof XMLNode || _loc4_ instanceof XMLNode)
         {
            _loc5_ = "XML";
         }
         else
         {
            _loc6_ = typeof _loc4_;
            _loc5_ = _loc6_.charAt(0).toUpperCase() + _loc6_.slice(1);
         }
      }
      else
      {
         _loc4_ = null;
      }
      _loc3_ = new mx.data.binding.TypedValue(_loc4_,_loc5_,null);
      return _loc3_;
   }
   function getGettableTypes()
   {
      return null;
   }
   function setTypedValue(newValue)
   {
      this.getFieldAccessor().setValue(newValue.value,newValue);
      return null;
   }
   function getSettableTypes()
   {
      return null;
   }
   function getFieldAccessor()
   {
      return this.component.createFieldAccessor(this.property,this.location,false);
   }
}
