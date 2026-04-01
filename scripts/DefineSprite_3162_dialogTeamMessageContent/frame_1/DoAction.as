stop();
fld.restrict = classes.Lookup.keyboardRestrictChars;
classes.Drawing.portrait(teamAvatar,classes.GlobalData.attr.ti,2,0,0,2,false,"teamavatars");
txt = unescape(_global.teamXML.firstChild.firstChild.attributes.lc);
var CB_leaderComments = function(s)
{
   var _loc4_ = _global.teamXML.firstChild.firstChild;
   if(s == 1)
   {
      _global.teamXML.firstChild.firstChild.attributes.lc = _global.newLeaderComments;
      delete _global.newLeaderComments;
      classes.SectionTeamHQ._MC.goPage(3);
   }
   else
   {
      _root.displayAlert("warning","Failed to Update Leader Message","For some reason, your attempt to update the leader message failed.  Please try again later.");
   }
};
btnCancel.btnLabel.text = "Cancel";
btnCancel.onRelease = function()
{
   _parent.closeMe();
};
btnOK.onRelease = function()
{
   classes.Lookup.addCallback("teamUpdateLeaderComments",this,CB_leaderComments,"");
   _root.teamUpdateLeaderComments(escape(txt));
   _parent.closeMe();
};
