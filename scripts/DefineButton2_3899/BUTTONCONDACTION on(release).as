on(release){
   if(_parent.chipSetting > -5)
   {
      _parent.chipSetting--;
      _parent.AFMeter = _parent.chipSetting;
      saveAFRatioTimeout();
   }
}
