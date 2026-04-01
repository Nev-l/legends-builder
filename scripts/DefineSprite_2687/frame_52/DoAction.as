clearHelp();
classes.Effects.roBump(btnBetFriendly);
classes.Effects.roBump(btnBetMoney);
classes.Effects.roBump(btnBetPinks);
var moneyErrorMsg = "You must enter a the amount of money you want to wager in order to create a Money Bet.";
fldBet.restrict = "0-9";
btnBetPinks._alpha = 100;
if(!(_global.loginXML.firstChild.firstChild.attributes.mb == 1 && classes.GlobalData.bypassRequirements == true))
{
   if(classes.GlobalData.meetsAccountLengthRequirement == false || _global.loginXML.firstChild.firstChild.attributes.sc < 5000)
   {
      btnBetPinks._alpha = 50;
   }
}
btnBetFriendly.onRelease = function()
{
   betType = 1;
   gotoAndStop("confirm");
   play();
};
btnBetMoney.onRelease = function()
{
   betType = 2;
   if(!betAmount || betAmount < 0)
   {
      _root.displayAlert("warning","No Bet Amount Set",moneyErrorMsg);
   }
   else if(betType == 2 && betAmount > 999 && classes.GlobalData.meetsAccountLengthRequirement == false && (_global.loginXML.firstChild.firstChild.attributes.mb != 1 || classes.GlobalData.bypassRequirements == false))
   {
      _root.displayRestrictionsAlert("warning","Account Age","Maximum bet $999.");
   }
   else if(betType == 2 && betAmount > 999 && _global.loginXML.firstChild.firstChild.attributes.sc < 5000 && (_global.loginXML.firstChild.firstChild.attributes.mb != 1 || classes.GlobalData.bypassRequirements == false))
   {
      _root.displayRestrictionsAlert("warning","More Street Credit","Maximum bet $999.");
   }
   else
   {
      gotoAndStop("confirm");
      play();
   }
};
btnBetPinks.onRelease = function()
{
   if(Number(selCarXML.attributes.td))
   {
      _root.displayAlert("warning","Test Drive Car","Your can\'t race a pink slip race with a test drive car.");
   }
   else if(classes.GlobalData.meetsAccountLengthRequirement == false && (_global.loginXML.firstChild.firstChild.attributes.mb != 1 || classes.GlobalData.bypassRequirements == false))
   {
      _root.displayRestrictionsAlert("warning","Account Age","Account not eligible to race for Pink Slips.");
   }
   else if(_global.loginXML.firstChild.firstChild.attributes.sc < 5000 && (_global.loginXML.firstChild.firstChild.attributes.mb != 1 || classes.GlobalData.bypassRequirements == false))
   {
      _root.displayRestrictionsAlert("warning","More Street Credit","Account not eligible to race for Pink Slips.");
   }
   else
   {
      betType = 3;
      gotoAndStop("confirm");
      play();
   }
};
nav2.onRelease = function()
{
   if(!betType)
   {
      _root.displayAlert("warning","No Bet Set","You must select one of the three bet types.");
   }
   else if(betType == 2 && (!betAmount || betAmount < 0))
   {
      _root.displayAlert("warning","No Bet Amount Set",moneyErrorMsg);
   }
   else if(betType == 3 && Number(selCarXML.attributes.td))
   {
      _root.displayAlert("warning","Test Drive Car","You can\'t race a pink slip race with a test drive car.");
   }
   else if(betType == 2 && betAmount > 999 && classes.GlobalData.meetsAccountLengthRequirement == false && (_global.loginXML.firstChild.firstChild.attributes.mb != 1 || classes.GlobalData.bypassRequirements == false))
   {
      _root.displayRestrictionsAlert("warning","Account Age","Maximum bet $999.");
   }
   else if(betType == 2 && betAmount > 999 && _global.loginXML.firstChild.firstChild.attributes.sc < 5000 && (_global.loginXML.firstChild.firstChild.attributes.mb != 1 || classes.GlobalData.bypassRequirements == false))
   {
      _root.displayRestrictionsAlert("warning","More Street Credit","Maximum bet $999.");
   }
   else
   {
      gotoAndStop("confirm");
      play();
   }
};
nav3.onRelease = function()
{
   gotoAndStop("type");
   play();
};
