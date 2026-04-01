stop();
var deleteApp = function()
{
   var _loc3_ = 0;
   while(_loc3_ < _global.appXML.firstChild.childNodes.length)
   {
      if(_global.appXML.firstChild.childNodes[_loc3_].attributes.ti == _global.deleteAppID)
      {
         _global.appXML.firstChild.childNodes[_loc3_].removeNode();
         _root.teamDeleteApp(_global.deleteAppID);
         classes.HomeProfile._MC.drawTeamStatus();
         break;
      }
      _loc3_ += 1;
   }
   delete _global.deleteAppID;
};
btnCancel.onRelease = function()
{
   _global.deleteAppID = tID;
   classes.Control.dialogAlert("Delete Application?","Are you sure you want to delete your application to this team? Click \'Cancel\' to leave this application alone.",deleteApp);
};
