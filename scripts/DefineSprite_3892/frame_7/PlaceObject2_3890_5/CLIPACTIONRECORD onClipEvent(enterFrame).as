onClipEvent(enterFrame){
   _parent.flow = Math.round(_parent._parent.AFMeter);
   if(_parent._parent.AFmaxIcon == 1)
   {
      this._alpha = 100;
   }
   else
   {
      this._alpha = 20;
   }
}
