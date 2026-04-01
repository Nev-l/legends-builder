winnerBar.clr = new Color(winnerBar);
if(_global.chatObj.challengeXML.firstChild.attributes.r == 1)
{
   if(Number(_global.chatObj.challengeXML.firstChild.attributes.b) > 0)
   {
      txtBetWon = "$" + classes.NumFuncs.commaFormat(Number(_global.chatObj.challengeXML.firstChild.attributes.b));
      winnerBar.clr.setRGB(3182680);
   }
   else
   {
      winnerBar.clr.setRGB(4333131);
      txtBetType = "Ranked Challenge";
   }
}
else
{
   winnerBar.clr.setRGB(2336495);
   txtBetType = "Friendly Challenge";
}
