function pickSetting(pNum)
{
   setting = pNum;
   switch(setting)
   {
      case 5:
         selectedRace._y = btnBest._y;
         break;
      case 3:
         selectedRace._y = btnMed._y;
         break;
      case 1:
         selectedRace._y = btnLow._y;
         break;
      case 0:
         selectedRace._y = btnOff._y;
      default:
         return undefined;
   }
}
function pickWatchSetting(pNum)
{
   watchSetting = pNum;
   switch(watchSetting)
   {
      case 5:
         selectedWatch._y = btnWatchBest._y;
         break;
      case 3:
         selectedWatch._y = btnWatchMed._y;
         break;
      case 1:
         selectedWatch._y = btnWatchLow._y;
      default:
         return undefined;
   }
}
function showSample(pNum)
{
   switch(pNum)
   {
      case 5:
         samples.gotoAndStop(1);
         break;
      case 3:
         samples.gotoAndStop(2);
         break;
      case 1:
         samples.gotoAndStop(3);
      default:
         return undefined;
   }
}
