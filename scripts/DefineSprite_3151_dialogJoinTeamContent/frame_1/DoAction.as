stop();
trace("dialog: " + _parent.tid);
var txt = "";
var CB_joinTeam = function(s)
{
   switch(s)
   {
      case 1:
         _root.displayAlert("success","Application Sent","You have successfully applied to this team.  You can check the status of your application in your Home, on the Team Status page.");
         return undefined;
      case 0:
         _root.displayAlert("warning","Failed Attempt","Sorry, there was an error and your application could not be processed.  Please try again.");
         return undefined;
      case -1:
         _root.displayAlert("warning","Team is Closed","Sorry, this team currently is not accepting applications for new members.");
         return undefined;
      case -2:
         _root.displayAlert("warning","Not Qualified","Sorry, you do not fulfill the necessary requirements to apply to this team.");
         return undefined;
      case -3:
         _root.displayAlert("warning","Not Enough Street Credit","Sorry, you do not have enough street credit to apply to this team.");
         return undefined;
      case -4:
         _root.displayAlert("warning","Required Car Not Found","Sorry, you do not own the required car to apply to this team.");
         return undefined;
      case -5:
         _root.displayAlert("success","Application On File","You already have an application sent to this team.  Please go to the Team Status page in your Home to check the status of your application.");
         return undefined;
      case -6:
         _root.displayAlert("success","Already on the Team","You already are a member of the team you apply for.");
         return undefined;
      case -60:
         _root.displayAlert("warning","Please Activate Account","You need to activate your account to join a team.");
         return undefined;
      default:
         _root.displayAlert("warning","Not Enough Street Credit","Sorry, you do not have enough street credit to apply to a team. You have to earn at least " + s + " street credit to join a team.");
         return undefined;
   }
};
btnCancel.btnLabel.text = "Cancel";
btnCancel.onRelease = function()
{
   _parent.closeMe();
};
btnSend.btnLabel.text = "Send";
btnSend.onRelease = function()
{
   classes.Lookup.addCallback("teamAddApp",this,CB_joinTeam,"");
   _root.teamAddApp(this._parent._parent.tid,this._parent.txt);
   _parent.closeMe();
};
