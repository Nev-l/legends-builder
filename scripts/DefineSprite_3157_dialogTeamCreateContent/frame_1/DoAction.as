stop();
var txt = "";
fld.restrict = classes.Lookup.alphaNumRestrictChars + " ";
var CB_createTeam = function(s)
{
   switch(s)
   {
      case 1:
         classes.Frame.__MC.goMainSection("teamhq");
         break;
      case 0:
         _root.displayAlert("warning","Failed to Create Team","An offensive word or phrase was found in the team name you entered. Please try again.");
         break;
      case -1:
         _root.displayAlert("warning","Failed to Create Team","You are already on a team. You must quit that team before you can create a new team.");
         break;
      case -2:
         _root.displayAlert("warning","Failed to Create Team","The team name you entered is already being used by another team. Please try another name.");
         break;
      case -4:
         _root.displayMembershipAlert("warning","Failed to Create Team","You need to be a member to create a team.");
         break;
      case -5:
         _root.displayRestrictionsAlert("warning","Failed to Create Team","Account not eligible to create a team.",1);
         break;
      case -6:
         _root.displayRestrictionsAlert("warning","Failed to Create Team","Account not eligible to create a team.",1);
      default:
         return undefined;
   }
};
btnCancel.btnLabel.text = "Cancel";
btnCancel.onRelease = function()
{
   _parent.closeMe();
};
btnCreate.btnLabel.text = "Create Team";
btnCreate.onRelease = function()
{
   if(this._parent.txt.length)
   {
      classes.Lookup.addCallback("teamCreate",this,CB_createTeam,"");
      _root.teamCreate(this._parent.txt);
      _parent.closeMe();
   }
};
