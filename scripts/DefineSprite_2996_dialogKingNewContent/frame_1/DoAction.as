if(_global.chatObj.raceRoomMC.kingObj.bt > 0)
{
   dialInGroup.txtDialIn = _global.chatObj.raceRoomMC.kingObj.bt;
   dialInGroup.txtDialIn.restrict = "0-9.";
}
else
{
   dialInGroup._visible = false;
}
btnCancel.btnLabel.text = "Step Down";
btnContinue.btnLabel.text = "Continue";
var bet = 0;
fld.restrict = "0-9";
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
