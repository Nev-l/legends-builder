stop();
classes.Drawing.userListItem(this,"avatar",classes.GlobalData.id,classes.GlobalData.uname,270,94);
teamFundsDisplay.txt = "$" + classes.NumFuncs.commaFormat(_parent.teamFunds);
remainingFundsDisplay.txt = "$" + classes.NumFuncs.commaFormat(_parent.teamFunds);
if(classes.GlobalData.attr.tr == 1)
{
   myTeamFunds = "N/A";
   myPO = "N/A";
}
else
{
   myTeamFunds = "$" + _parent.myTeamFunds;
   myPO = _parent.myPO + "%";
}
fldAmount.restrict = "0-9";
fldAmount.onChanged = function()
{
   remainingFundsDisplay.txt = "$" + classes.NumFuncs.commaFormat(Number(_parent.teamFunds) + Number(amount));
};
var CB_deposit = function(s)
{
   var _loc4_ = undefined;
   var _loc5_ = undefined;
   if(s == 1)
   {
      _loc4_ = Number(_global.loginXML.firstChild.firstChild.attributes.m) - classes.SectionTeamHQ.depositObj.amount;
      classes.GlobalData.updateInfo("m",_loc4_);
      _global.teamXML.firstChild.firstChild.attributes.tf = Number(_global.teamXML.firstChild.firstChild.attributes.tf) + classes.SectionTeamHQ.depositObj.amount;
      classes.SectionTeamHQ._MC.setFundsField(_global.teamXML.firstChild.firstChild.attributes.tf);
      classes.SectionTeamHQ._MC.selfNode.attributes.fu = Number(classes.SectionTeamHQ._MC.selfNode.attributes.fu) + classes.SectionTeamHQ.depositObj.amount;
      classes.SectionTeamHQ._MC.selfNode.attributes.po = Math.round(10000 * classes.SectionTeamHQ._MC.selfNode.attributes.fu / _global.teamXML.firstChild.firstChild.attributes.tf) / 100;
      classes.SectionTeamHQ._MC.goPage(4);
      _loc5_ = "You have successfully deposited $" + classes.SectionTeamHQ.depositObj.amount + " to the team.\r\rYour personal funds balance is now $" + classes.NumFuncs.commaFormat(Number(_loc4_)) + ".";
      if(classes.GlobalData.attr.tr != 1)
      {
         _loc5_ += "\rYour team ownership is now " + classes.SectionTeamHQ._MC.selfNode.attributes.po + "%";
      }
      _root.displayAlert("funds","Deposit Succeeded",_loc5_);
   }
   else
   {
      _root.displayAlert("warning","Deposit Failed","Sorry, for some reason your deposit could not go through. Please try again later.");
   }
   classes.SectionTeamHQ.depositObj.amount = 0;
};
btnOK.btnLabel.text = "OK";
btnOK.onRelease = function()
{
   if(Number(amount))
   {
      classes.Lookup.addCallback("teamDeposit",this,CB_deposit,"");
      _root.teamDeposit(Number(amount));
      _parent.closeMe();
   }
};
btnCancel.btnLabel.text = "Cancel";
btnCancel.onRelease = function()
{
   _parent.closeMe();
};
