on(release){
   if(_parent.boostSetting > 0)
   {
      _parent.boostSetting--;
      boostDisplay = _parent.boostSetting + "/" + _parent.maxPsi;
      saveBoostTimeout();
   }
}
