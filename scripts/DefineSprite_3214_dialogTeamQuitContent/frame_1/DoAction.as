classes.Drawing.portrait(teamAvatar,classes.GlobalData.attr.ti,2,0,0,2,false,"teamavatars");
classes.Drawing.userListItem(this,"avatar",classes.GlobalData.id,classes.GlobalData.uname,270,94);
myTeamFunds = "$" + _parent.myTeamFunds;
myPO = _parent.myPO + "%";
var CB_quit = function(s)
{
   if(s == 0)
   {
      _root.displayAlert("warning","Failed to Quit","Sorry, for some reason you can not quit this team. Please try again later.");
   }
   else if(s == -50)
   {
      _root.displayAlert("triangle","Account Locked","Sorry, you left a race that is still in progress. Your account is temporarily locked until the race is finished.  This may take moment.");
   }
   else
   {
      delete _global.teamXML;
      _global.loginXML.firstChild.firstChild.attributes.tr = "";
      _global.loginXML.firstChild.firstChild.attributes.ti = "";
      _root.displayAlert("teamMember","You Have Quit the Team","You have successfully quit the team.  You will no longer be able to view this team\'s details in the Team HQ.");
   }
};
btnOK.btnLabel.text = "OK";
btnOK.onRelease = function()
{
   classes.Lookup.addCallback("teamQuit",this,CB_quit,"");
   _root.teamQuit();
   _parent.closeMe();
};
btnCancel.btnLabel.text = "Cancel";
btnCancel.onRelease = function()
{
   _parent.closeMe();
};
