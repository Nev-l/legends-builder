btnCancel.btnLabel.text = "Step Down";
btnContinue.btnLabel.text = "Continue";
if(_global.chatObj.raceRoomMC.kingObj.bt > 0)
{
   dialInGroup.txtDialIn = _global.chatObj.raceRoomMC.kingObj.bt;
   dialInGroup.fldDialIn.restrict = "0-9.";
}
else
{
   dialInGroup._visible = false;
}
