var listTypeXML = new XML("<lt><t id=\"sc\" n=\"Top Racers Based on Street Credit\" /><t id=\"ba\" n=\"Top Ballers Based on Net Wealth\" /><t id=\"ks\" n=\"Top King of the Hill Streaks\" /><t id=\"fc\" n=\"Fastest Cars\" /></lt>");
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
