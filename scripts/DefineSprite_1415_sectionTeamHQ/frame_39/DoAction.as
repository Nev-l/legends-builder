stop();
var CB_cont = function(d)
{
   if(selSnav == 3)
   {
      _global.appXML = new XML(d);
      drawApplications(_global.appXML.firstChild,_global.teamXML.firstChild.firstChild.attributes.lc);
   }
};
classes.Lookup.addCallback("teamGetAllApps",this,CB_cont,"sectionTeamHQ");
_root.teamGetAllApps(_global.loginXML.firstChild.firstChild.attributes.ti);
