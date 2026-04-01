stop();
classes.Drawing.portrait(teamAvatar,classes.GlobalData.attr.ti,2,0,0,2,false,"teamavatars");
classes.Drawing.userListItem(this,"avatar",classes.GlobalData.id,classes.GlobalData.uname,270,94);
var CB_stepDown = function(s)
{
   trace("CB_stepDown");
   if(s == 1)
   {
      classes.GlobalData.updateInfo("tr",3);
      classes.Frame.__MC.goMainSection("teamhq");
   }
};
btnCancel.btnLabel.text = "Cancel";
btnCancel.onRelease = function()
{
   _parent.closeMe();
};
btnOK.onRelease = function()
{
   classes.Lookup.addCallback("teamStepDown",this,CB_stepDown,"");
   _root.teamStepDown();
   _parent.closeMe();
};
