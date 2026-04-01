if(_global.chatObj.challengeXML.firstChild.attributes.r == 1)
{
   betType.gotoAndStop(4);
   txtBetType = "Ranked Match\r";
   var betAmount = Number(_global.chatObj.challengeXML.firstChild.attributes.b);
   if(betAmount > 0)
   {
      txtBetAmount = "$" + classes.NumFuncs.commaFormat(betAmount);
   }
}
