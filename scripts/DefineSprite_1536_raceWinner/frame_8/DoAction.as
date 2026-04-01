function doNext(p_tks)
{
   if(_global.chatObj.roomType == "KOTH")
   {
      if(_global.loginXML.firstChild.firstChild.attributes.i == _global.chatObj.queueXML.firstChild.childNodes[0].attributes.i)
      {
         if(p_tks > 1)
         {
            _parent.showKingOption();
         }
         else if(p_tks > 0)
         {
            _parent.showKingNew();
         }
      }
      else if(_global.loginXML.firstChild.firstChild.attributes.i == _global.chatObj.queueXML.firstChild.childNodes[1].attributes.i)
      {
         _parent.showChallengerNew();
      }
   }
}
stop();
_global.setTimeout(doNext,6000,tks);
