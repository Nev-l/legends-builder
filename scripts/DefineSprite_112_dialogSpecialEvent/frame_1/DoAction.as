function enableButtons(enable)
{
   btnDecideLater.enabled = enable;
   btnDecline.enabled = enable;
   var _loc2_ = 0;
   while(_loc2_ < buttonsArray.length)
   {
      buttonsArray[_loc2_].enabled = enable;
      _loc2_ += 1;
   }
}
