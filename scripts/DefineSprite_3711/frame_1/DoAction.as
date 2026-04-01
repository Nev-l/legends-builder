function showTrackGroup(stripNum)
{
   parkingGroup._visible = false;
   parkingGroup.gotoAndStop(1);
   stripGroup.idx = stripNum;
   stripGroup._y = this["btnStrip" + stripNum]._y;
   stripGroup._visible = true;
   resetFldClrs();
   this["fldClr" + stripNum].setRGB(16777215);
   stripGroup.gotoAndPlay("showMe");
}
function showParkingGroup()
{
   stripGroup._visible = false;
   stripGroup.gotoAndStop(1);
   resetFldClrs();
   fldClr1.setRGB(16777215);
   parkingGroup._visible = true;
   parkingGroup.gotoAndPlay("showMe");
}
function resetFldClrs()
{
   var _loc2_ = 2;
   while(_loc2_ <= 6)
   {
      if(stripGroup._visible == false || _loc2_ != stripGroup.idx)
      {
         this["fldClr" + _loc2_].setRGB(6250592);
      }
      _loc2_ += 1;
   }
   if(parkingGroup._visible == false)
   {
      fldClr1.setRGB(6250592);
   }
}
