stop();
var theTeamXML;
if(_global.loginXML.firstChild.firstChild.attributes.ti > 0)
{
   var CB_cont = function(d)
   {
      _global.teamXML = new XML(d);
      gotoAndStop("init");
      play();
   };
   classes.Lookup.addCallback("teamGetInfo",this,CB_cont,"");
   _root.teamGetInfo(_global.loginXML.firstChild.firstChild.attributes.ti);
}
else
{
   gotoAndStop("noTeam");
   play();
}
