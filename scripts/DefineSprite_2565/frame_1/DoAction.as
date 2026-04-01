var listTypeXML = new XML("<lt><t id=\"tsc\" n=\"Top Teams Based on Street Credit\" /><t id=\"tba\" n=\"Top Teams Based on Net Wealth\" /><t id=\"tft\" n=\"Fastest Teams\" /></lt>");
stop();
var menuXML = new XML();
menuXML.onLoad = function()
{
   topCount = Number(this.firstChild.attributes.tc);
   topTopCount = Number(this.firstChild.attributes.ttc);
   play();
};
menuXML.ignoreWhite = true;
_root.leaderboardGetMenu();
