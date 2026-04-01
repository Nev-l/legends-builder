fld.autoSize = true;
if(_global.loginXML.firstChild.firstChild.attributes.tr == 1)
{
   this.attachMovie("btnUpdate","btnUpdate",this.getNextHighestDepth());
   btnUpdate._x = 162;
   btnUpdate.onRelease = function()
   {
      _root.attachMovie("dialogContainer","abc",_root.getNextHighestDepth(),{contentName:"dialogTeamMessageContent"});
   };
}
