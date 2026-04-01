stop();
var i = 1;
while(i <= 2)
{
   var j = 1;
   while(j <= 4)
   {
      var tItem = this["team" + i + "Pos" + j];
      if(tItem.num)
      {
         tItem._visible = true;
      }
      j++;
   }
   i++;
}
var i = 1;
while(i <= 2)
{
   var tItem = this["userPic" + i];
   classes.Drawing.portrait(tItem.holder,tItem.teamID,2,0,0,1,false,"teamavatars");
   i++;
}
if(isRacer)
{
   _global.chatObj.raceRoomMC.showChallengerNew(false,isBracket);
}
if(_global.chatObj.raceObj.raceInProgress)
{
   var muteSx = new Sound(this);
   muteSx.setVolume(0);
   var i = 1;
   while(i <= 2)
   {
      var j = 1;
      while(j <= 4)
      {
         if(this["team" + i + "Pos" + j].accountID)
         {
            this["team" + i + "Pos" + j].statusBulb.gotoAndStop(2);
            this["team" + i + "Car" + j].fadeUp();
         }
         j++;
      }
      i++;
   }
   play();
}
