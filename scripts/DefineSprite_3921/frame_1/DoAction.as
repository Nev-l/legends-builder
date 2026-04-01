function onEnterFrame()
{
   AFMeter = _parent.AFMeter;
   if(AFmeter != _parent.chipSetting)
   {
      if(AFMeter < -5)
      {
         AFMeter = -5;
         leanBlink = 1;
      }
      AFframe = AFMeter + 7;
   }
   else
   {
      leanBlink = 0;
      AFframe = _parent.chipSetting + 7;
   }
   gotoAndStop(AFframe);
}
var AFframe = _parent.chipSetting + 7;
