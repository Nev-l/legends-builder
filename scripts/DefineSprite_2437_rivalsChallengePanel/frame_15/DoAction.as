stop();
var dialInErrorMsg = "You must specify a dial-in time when choosing a bracket race.  You should set your dial-in time to the number of seconds you think you will run the race without beating.  The difference between your and your opponent\'s dial-in times sets the handicap for this race.  Beating your dial-in time will disqualify you from the race.";
betIcon.gotoAndStop(betType);
if(brt1 > -1)
{
   bracketGroup.brt1 = brt1;
}
else
{
   brt2 = -1;
   bracketGroup._visible = false;
}
classes.Drawing.carView(car1,new XML(selOppCarXML.toString()),35);
classes.Drawing.carView(car2,new XML(selCarXML.toString()),35);
car2._xscale = -100;
if(Number(selOppCarXML.firstChild.attributes.pi) <= 7 || Number(selOppCarXML.attributes.pi) >= 11)
{
   classes.Drawing.plateView(plate1,selOppCarXML.firstChild.attributes.pi,selOppCarXML.firstChild.attributes.pn,29,true);
}
else
{
   classes.Drawing.plateView(plate1,selOppCarXML.firstChild.attributes.pi,selOppCarXML.firstChild.attributes.pn,17,true);
}
if(Number(selCarXML.firstChild.attributes.pi) <= 7 || Number(selCarXML.attributes.pi) >= 11)
{
   classes.Drawing.plateView(plate2,selCarXML.firstChild.attributes.pi,selCarXML.firstChild.attributes.pn,29,true);
}
else
{
   classes.Drawing.plateView(plate1,selCarXML.firstChild.attributes.pi,selCarXML.firstChild.attributes.pn,17,true);
}
userInfo1.attachMovie("userListItemR","userInfo1",1,{userName:oppName});
userInfo2.attachMovie("userListItem","userInfo2",1,{userName:classes.GlobalData.uname});
userInfo1.createEmptyMovieClip("pic",2);
userInfo1.pic._xscale = userInfo1.pic._yscale = 25;
userInfo2.createEmptyMovieClip("pic",2);
userInfo2.pic._x = 100;
userInfo2.pic._xscale = userInfo2.pic._yscale = 25;
classes.Drawing.portrait(userInfo1.pic,oppID,2);
classes.Drawing.portrait(userInfo2.pic,classes.GlobalData.id,2);
mods1 = "K20 motor swap with\r$43,120 in modifications";
mods2 = "K20 motor swap with\r$43,120 in modifications";
nav1.onRelease = function()
{
   car1.clearCarView();
   car2.clearCarView();
   gotoAndStop("reveal");
   play();
};
nav2.onRelease = function()
{
   car1.clearCarView();
   car2.clearCarView();
   classes.RivalsChallengePanel.removeChallenge(oppCar + "_" + selCar);
   _root.chatRIVResponse(0,0,guid);
   gotoAndStop("reveal");
   play();
};
nav3.onRelease = function()
{
   if(brt1 > -1)
   {
      brt2 = Number(bracketGroup.brt2);
      if(brt2)
      {
         _root.chatRIVResponse(1,brt2,guid);
         car1.clearCarView();
         car2.clearCarView();
         gotoAndStop("hide");
         play();
      }
      else
      {
         classes.Control.dialogAlert("Dial-In time Not Set",dialInErrorMsg);
      }
   }
   else
   {
      brt2 = -1;
      _root.chatRIVResponse(1,brt2,guid);
      car1.clearCarView();
      car2.clearCarView();
      gotoAndStop("hide");
      play();
   }
};
