on(release){
   if(_parent.chipSetting < 5)
   {
      _parent.chipSetting += 1;
      _parent.AFMeter = _parent.chipSetting;
      saveAFRatioTimeout();
   }
}
