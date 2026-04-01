function showWinnerInfo()
{
   if(_global.chatObj.queueXML.firstChild.childNodes[0].attributes.i == _global.chatObj.twoRacersCarsXML.firstChild.childNodes[0].attributes.i)
   {
      winnerIdx = 0;
   }
   else
   {
      winnerIdx = 1;
   }
   var _loc3_ = new XML(_global.chatObj.twoRacersCarsXML.firstChild.childNodes[winnerIdx]);
   var _loc4_ = _global.chatObj.queueXML.firstChild.childNodes[0];
   var _loc5_ = {_x:28,_y:199,uID:_loc4_.attributes.i,uName:_loc4_.attributes.un,uCred:_loc4_.attributes.sc};
   this.attachMovie("userInfo","user1Info",1,_loc5_);
   this.createEmptyMovieClip("car1",2);
   classes.Drawing.carView(car1,_loc3_,73);
   car1._x = 376;
   car1._y = 173;
}
