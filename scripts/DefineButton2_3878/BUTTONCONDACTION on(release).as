on(release){
   if(_parent.boostSetting < _parent.maxPsi)
   {
      _parent.boostSetting += 1;
      boostDisplay = _parent.boostSetting + "/" + _parent.maxPsi;
      saveBoostTimeout();
   }
}
