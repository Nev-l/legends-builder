newKing._visible = false;
reKing._visible = false;
if(r1Obj.bt != "-1" || r2Obj.bt != "-1")
{
   fldWinner._x = fldStats4._x + fldStats4._width + 2;
}
var tks = _parent.kingObj.ks;
if(!tks)
{
   tks = 0;
}
if(tks <= 1)
{
   showKing(newKing);
}
else if(tks > 1)
{
   reKing.mult.txtX = "X" + tks;
   switch(tks)
   {
      case 2:
         reKing.mult.txtName = "RACETACULAR";
         break;
      case 3:
         reKing.mult.txtName = "RACING RIOT";
         break;
      default:
         reKing.mult.txtName = "RACING RAMPAGE";
   }
   showKing(reKing);
}
var isInQueue = false;
var i = 0;
while(i < _global.chatObj.queueXML.firstChild.childNodes.length)
{
   if(_global.loginXML.firstChild.firstChild.attributes.i == _global.chatObj.queueXML.firstChild.childNodes[i].attributes.i)
   {
      isInQueue = true;
      break;
   }
   i++;
}
if(!isInQueue)
{
   _parent.togLineUp.gotoAndStop(1);
   _parent.togLineUp._visible = true;
}
