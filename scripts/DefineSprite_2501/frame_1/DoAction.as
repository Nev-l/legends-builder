function showTrackGroup(stripNum)
{
   parkingGroup._visible = false;
   parkingGroup.gotoAndStop(1);
   stripGroupTourney._visible = false;
   stripGroupTourney.gotoAndStop(1);
   stripGroup.idx = stripNum;
   stripGroup._y = this["btnStrip" + stripNum]._y;
   stripGroup._visible = true;
   resetFldClrs();
   this["fldClr" + stripNum].setRGB(16777215);
   stripGroup.gotoAndPlay("showMe");
}
function showTourneyGroup()
{
   parkingGroup._visible = false;
   parkingGroup.gotoAndStop(1);
   stripGroup._visible = false;
   stripGroup.gotoAndStop(1);
   resetFldClrs();
   fldClr4.setRGB(16777215);
   stripGroupTourney._visible = true;
   stripGroupTourney.gotoAndPlay("showMe");
}
function showParkingGroup()
{
   stripGroup._visible = false;
   stripGroup.gotoAndStop(1);
   stripGroupTourney._visible = false;
   stripGroupTourney.gotoAndStop(1);
   resetFldClrs();
   fldClr1.setRGB(16777215);
   parkingGroup._visible = true;
   parkingGroup.gotoAndPlay("showMe");
}
function resetFldClrs()
{
   var _loc2_ = 1;
   while(_loc2_ <= 8)
   {
      if(_loc2_ != 1 && _loc2_ != 4 && (stripGroup._visible == false || _loc2_ != stripGroup.idx))
      {
         this["fldClr" + _loc2_].setRGB(4473924);
      }
      _loc2_ += 1;
   }
   if(stripGroupTourney._visible == false)
   {
      fldClr4.setRGB(4473924);
   }
   if(parkingGroup._visible == false)
   {
      fldClr1.setRGB(4473924);
   }
}
