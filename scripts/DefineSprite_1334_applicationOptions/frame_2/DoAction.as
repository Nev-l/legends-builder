stop();
btn.onRelease = function()
{
   var _loc3_ = 0;
   while(_loc3_ < _global.appXML.firstChild.childNodes.length)
   {
      if(_global.appXML.firstChild.childNodes[_loc3_].attributes.ti == tID)
      {
         _global.appXML.firstChild.childNodes[_loc3_].removeNode();
         _root.teamDeleteApp(tID);
         classes.HomeProfile._MC.drawTeamStatus();
         break;
      }
      _loc3_ += 1;
   }
};
