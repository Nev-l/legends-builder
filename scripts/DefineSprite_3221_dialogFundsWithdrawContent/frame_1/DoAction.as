classes.Drawing.userListItem(this,"avatar",classes.GlobalData.id,classes.GlobalData.uname,270,94);
classes.Drawing.portrait(teamAvatar,classes.GlobalData.attr.ti,2,0,0,2,false,"teamavatars");
teamFundsDisplay.txt = "$" + classes.NumFuncs.commaFormat(_parent.teamFunds);
remainingFundsDisplay.txt = "$" + classes.NumFuncs.commaFormat(_parent.teamFunds);
myTeamFunds = "$" + _parent.myTeamFunds;
myPO = _parent.myPO + "%";
fldAmount.restrict = "0-9";
fldAmount.onChanged = function()
{
   var _loc2_ = Number(_parent.teamFunds) - Number(amount);
   remainingFundsDisplay.txt = "$" + classes.NumFuncs.commaFormat(Math.max(0,_loc2_));
};
btnOK.btnLabel.text = "OK";
btnOK.onRelease = function()
{
   if(Number(amount))
   {
      _root.teamWithdrawal(Number(amount));
      _parent.closeMe();
   }
};
btnCancel.btnLabel.text = "Cancel";
btnCancel.onRelease = function()
{
   _parent.closeMe();
};
