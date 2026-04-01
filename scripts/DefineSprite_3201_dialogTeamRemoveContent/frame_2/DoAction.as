var i = 0;
while(i < membersXML.childNodes.length)
{
   tAttr = membersXML.childNodes[i].attributes;
   if(tAttr.i == targetID)
   {
      classes.Drawing.userListItem(this,"avatar",tAttr.i,tAttr.un,270,94);
      break;
   }
   i++;
}
var CB_kick = function(s)
{
   var _loc4_ = _global.teamXML.firstChild.firstChild;
   var _loc5_ = undefined;
   if(s == 1)
   {
      _loc5_ = 0;
      while(_loc5_ < _loc4_.childNodes.length)
      {
         if(_loc4_.childNodes[_loc5_].attributes.i == _global.teamKickID)
         {
            _loc4_.childNodes[_loc5_].removeNode();
            classes.SectionTeamHQ._MC.goPage(2);
            _global.teamKickID = 0;
            break;
         }
         _loc5_ += 1;
      }
   }
   else
   {
      _root.displayAlert("warning","Failed to Remove Team Member","For some reason, your attempt to remove a team member failed.  Please try again later.");
   }
};
btnOK.onRelease = function()
{
   classes.Lookup.addCallback("teamKick",this,CB_kick,"");
   _root.teamKick(targetID);
   _parent.closeMe();
};
