var buttonsArray = new Array();
title = _global.specialEvent.title;
description = _global.specialEvent.description;
_global.specialEvent.loadLogo(logo);
btnDecideLater.btnLabel.text = "Decide Later";
btnDecideLater.onRelease = function()
{
   trace("Decide Later");
   enableButtons(false);
   _parent.closeMe();
};
btnDecline.txt = "Decline";
btnDecline.onRelease = function()
{
   trace("Decline");
   _root.joinSpecialEvent(_global.specialEvent.id,0);
   enableButtons(false);
};
var i = 0;
while(i < _global.specialEvent.teams.length)
{
   var xMultiplier = 185;
   var yMultiplier = 43;
   var xPosition = 0;
   var yPosition = 0;
   if(i == 6)
   {
      break;
   }
   if(i == 1 || i == 3 || i == 5)
   {
      xPosition = xMultiplier;
   }
   else
   {
      xPosition = 0;
   }
   if(i > 1)
   {
      if(i > 3)
      {
         yPosition = yMultiplier * 2;
      }
      else
      {
         yPosition = yMultiplier;
      }
   }
   var tmpMV = teamList.attachMovie("SpecialEventTeamDisplay","teamDisplay" + i,teamList.getNextHighestDepth(),{_x:xPosition,_y:yPosition,tid:_global.specialEvent.teams[i].id});
   _global.specialEvent.loadTeamIcon(_global.specialEvent.teams[i].id,tmpMV.icon,28,28);
   tmpMV.txt = _global.specialEvent.teams[i].description;
   tmpMV.onRollOver = function()
   {
      this.field.textColor = 16711680;
      trace(this.tid);
   };
   tmpMV.onRollOut = function()
   {
      this.field.textColor = 0;
   };
   tmpMV.onRelease = function()
   {
      trace("onRelease!");
      trace(this.tid);
      enableButtons(false);
      _root.joinSpecialEvent(_global.specialEvent.id,this.tid);
   };
   buttonsArray.push(tmpMV);
   i++;
}
