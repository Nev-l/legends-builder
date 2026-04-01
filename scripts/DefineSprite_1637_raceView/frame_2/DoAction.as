matchBox.swapDepths(40);
if(matchNum)
{
   matchBox.num = matchNum;
   matchBox.txt = "MATCH " + matchNum;
}
else
{
   matchBox._visible = false;
   matchBox.removeMovieClip();
}
car1 = screenEventShake.raceScreen.carAni1;
car2 = screenEventShake.raceScreen.carAni2;
carHolder1 = car1.carAni_shift.carAni_Nitrous.carAni_speedJitter.carHolder;
carHolder2 = car2.carAni_shift.carAni_Nitrous.carAni_speedJitter.carHolder;
if(_parent.isPeerView)
{
   renderCar(1,12);
   renderCar(2,12);
}
else
{
   renderCar(1,-7);
   renderCar(2,-7);
}
carHolder1._visible = false;
carHolder2._visible = false;
car1._visible = false;
car2._visible = false;
if(carXML1)
{
   classes.Drawing.carView(carHolder1,carXML1,100,"spectate");
}
if(carXML2)
{
   classes.Drawing.carView(carHolder2,carXML2,100,"spectate");
}
var rObj = racer1Obj;
var user1Obj = {_x:10,_y:250,_visible:false,uID:rObj.id,uName:rObj.un,tID:rObj.ti,tName:rObj.tn,uCred:rObj.sc};
var rObj = racer2Obj;
var user2Obj = {_x:400,_y:250,_visible:false,isReversed:true,uID:rObj.id,uName:rObj.un,tID:rObj.ti,tName:rObj.tn,uCred:rObj.sc};
this.attachMovie("userInfo","user1Info",21,user1Obj);
this.attachMovie("userInfoRev","user2Info",22,user2Obj);
if(isSpectator)
{
   user1Info._visible = true;
   user2Info._visible = true;
}
