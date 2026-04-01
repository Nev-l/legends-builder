stop();
var bet = 0;
fldBet.restrict = "0-9";
if(_global.chatObj.raceObj.mb > 0)
{
   txtInstr = "Set your bet.  The King will take bets up to: $" + _global.chatObj.raceObj.mb;
}
else
{
   txtInstr = "The King is not taking money bets.  This race will only be for the title of King of the Hill.";
   fldBet._visible = false;
   betGroup._visible = false;
}
mvRestrictionsMember._visible = false;
if(!(_global.loginXML.firstChild.firstChild.attributes.mb == 1 && classes.GlobalData.bypassRequirements == true))
{
   if(classes.GlobalData.meetsAccountLengthRequirement == false || _global.loginXML.firstChild.firstChild.attributes.sc < 5000)
   {
      mvRestrictionsMember._visible = true;
      mvRestrictionsMember.btnRemoveRestrictions.onRelease = function()
      {
         _root.openURL(_global.fundsBettingURL);
      };
   }
}
