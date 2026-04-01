onClipEvent(enterFrame){
   AFMeter = _parent._parent.AFMeter;
   if(AFmeter != _parent._parent.chipSetting)
   {
      if(AFMeter < -5)
      {
         AFMeter = -5;
         _parent.leanBlink = 1;
      }
      _parent.AFframe = AFMeter + 7;
   }
   else
   {
      _parent.leanBlink = 0;
      _parent.AFframe = _parent._parent.chipSetting + 7;
   }
   _parent.gotoAndStop(_parent.AFframe);
}
