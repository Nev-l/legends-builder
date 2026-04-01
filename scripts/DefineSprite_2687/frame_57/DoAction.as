clearHelp();
betIcon.gotoAndStop(betType);
classes.Drawing.carView(car1,new XML(selCarXML.toString()),35);
classes.Drawing.carView(car2,new XML(selOppCarXML.toString()),35);
car2._xscale = -100;
if(Number(selCarXML.attributes.pi) <= 7 || Number(selCarXML.attributes.pi) >= 11)
{
   classes.Drawing.plateView(plate1,selCarXML.attributes.pi,selCarXML.attributes.pn,29,true);
}
else
{
   classes.Drawing.plateView(plate1,selCarXML.attributes.pi,selCarXML.attributes.pn,17,true);
}
if(Number(selOppCarXML.attributes.pi) <= 7 || Number(selOppCarXML.attributes.pi) >= 11)
{
   classes.Drawing.plateView(plate2,selOppCarXML.attributes.pi,selOppCarXML.attributes.pn,29,true);
}
else
{
   classes.Drawing.plateView(plate2,selOppCarXML.attributes.pi,selOppCarXML.attributes.pn,17,true);
}
userInfo1.attachMovie("userListItemR","userInfo1",1,{userName:_global.loginXML.firstChild.firstChild.attributes.u});
userInfo2.attachMovie("userListItem","userInfo2",1,{userName:oppName});
userInfo1.createEmptyMovieClip("pic",2);
userInfo1.pic._xscale = userInfo1.pic._yscale = 25;
userInfo2.createEmptyMovieClip("pic",2);
userInfo2.pic._x = 100;
userInfo2.pic._xscale = userInfo2.pic._yscale = 25;
classes.Drawing.portrait(userInfo1.pic,classes.GlobalData.id,2);
classes.Drawing.portrait(userInfo2.pic,oppID,2);
nav2.onRelease = function()
{
   car1.clearCarView();
   car2.clearCarView();
   var _loc2_ = 0;
   if(betType == 2)
   {
      _loc2_ = betAmount;
   }
   else if(betType == 3)
   {
      _loc2_ = -1;
   }
   var _loc3_ = dialTime;
   if(!_loc3_)
   {
      _loc3_ = -1;
   }
   _root.chatRIVRequest(selCar,oppID,selOppCar,_loc2_,_loc3_);
   gotoAndStop("hide");
   play();
};
nav3.onRelease = function()
{
   car1.clearCarView();
   car2.clearCarView();
   gotoAndStop("bet");
   play();
};
