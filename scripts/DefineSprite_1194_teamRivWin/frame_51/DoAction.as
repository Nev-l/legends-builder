if(_global.chatObj.challengeXML.firstChild.attributes.r == 1)
{
   icnBetType.gotoAndStop(4);
}
if(!scWon && scWon !== 0)
{
   scAmount.txt = "";
}
else
{
   scAmount.txt = "+" + scWon;
}
