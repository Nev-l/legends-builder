classes.Control.tourneyMenuMC = this;
var eventListXML;
var detailObj;
if(_global.chatObj.roomType == "CT")
{
   isCompTourney = true;
}
if(isCompTourney)
{
   eventListXML = new XML("<n2><e i=\"1\" it=\"1\" b=\"1\" s=\"2\" d=\"0\" ct=\"f\" c=\"\"><er><![CDATA[Free to enter.  Everyone welcome.  Any car may be used to race.]]></er></e><e i=\"2\" it=\"2\" b=\"1\" s=\"2\" d=\"0\" ct=\"f\" c=\"\"><er><![CDATA[Free to enter.  Everyone welcome.  Any car may be used to race.]]></er></e><e i=\"3\" it=\"3\" b=\"1\" s=\"2\" d=\"0\" ct=\"f\" c=\"\"><er><![CDATA[Free to enter.  Everyone welcome.  Any car may be used to race.]]></er></e></n2>");
}
else
{
   stop();
   _root.htGetTournaments();
}
