stop();
avatar.removeMovieClip();
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
btnLeader.onRelease = function()
{
   targetRole = 2;
   gotoAndStop("confirm");
   play();
};
btnDealer.onRelease = function()
{
   targetRole = 3;
   gotoAndStop("confirm");
   play();
};
btnMember.onRelease = function()
{
   targetRole = 4;
   gotoAndStop("confirm");
   play();
};
btnBack.btnLabel.text = "Back";
btnBack.onRelease = function()
{
   gotoAndPlay(1);
};
