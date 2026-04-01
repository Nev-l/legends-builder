stop();
var i = 0;
while(i < membersXML.childNodes.length)
{
   tAttr = membersXML.childNodes[i].attributes;
   if(tAttr.i == targetID)
   {
      classes.Drawing.userListItem(this,"avatar",tAttr.i,tAttr.un,270,94);
      break;
   }
   i++;
}
txtConfirm = "You have chosen to make this person a ";
switch(targetRole)
{
   case 2:
      txtConfirm += "Co-Leader.";
      dealerPercGroup._visible = false;
      break;
   case 3:
      txtConfirm += "Dealer.  Enter the percentage of the team funds that you want to allow this dealer to bet with (1 - 100):";
      break;
   case 4:
      txtConfirm += "regular Member.";
      dealerPercGroup._visible = false;
      break;
   default:
      txtConfirm = "No role was selected.  Please go back.";
}
btnBack.onRelease = function()
{
   gotoAndStop("pickRole");
   play();
};
btnOK.onRelease = function()
{
   if(dealerPercGroup.perc == "" || Number(dealerPercGroup.perc) == NaN || Number(dealerPercGroup.perc) < 0 || Number(dealerPercGroup.perc) > 100)
   {
      dealerPercGroup.txtErr = "must be 0 - 100";
   }
   else
   {
      _root.teamChangeRole(targetID,targetRole,Number(dealerPercGroup.perc));
      _parent.closeMe();
   }
};
