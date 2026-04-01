var listType = listTypeXML.firstChild.childNodes[0].attributes.id;
var periodType = "";
var newPeriodType = "";
var headerMatchType = "";
var headerRaceType = "";
var periodNum = 0;
var newPeriodNum = 0;
var xmlNum;
var newXmlNum;
var listNum;
var isNewSection;
var i = 0;
while(i < listTypeXML.firstChild.childNodes.length)
{
   var titem = this["btc_" + listTypeXML.firstChild.childNodes[i].attributes.id];
   titem.listType = listTypeXML.firstChild.childNodes[i].attributes.id;
   titem.hot.onRelease = function()
   {
      headerMatchType = "";
      headerRaceType = "";
      isNewSection = true;
      listType = this._parent.listType;
      removeExtraDropdowns();
      prepLeaderboard();
   };
   i++;
}
