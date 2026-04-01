var typeID = _parent.typeID;
var isPrivate = 0;
var isMember = 0;
var isPro = 0;
var setting;
var newRoomName = "User Room";
fld.restrict = classes.Lookup.alphaNumRestrictChars + " ";
optionsGroup.newPW = "";
btn1.onRelease = function()
{
   pickSetting(1);
};
btn2.onRelease = function()
{
   pickSetting(2);
};
btn3.onRelease = function()
{
   pickSetting(3);
};
pickSetting(1);
btnOK.btnLabel.text = "Create";
btnOK.onRelease = function()
{
   onOK();
};
btnCancel.btnLabel.text = "Cancel";
btnCancel.onRelease = function()
{
   _parent.closeMe();
};
mvBtnPro.gotoAndStop(1);
btnPro.onRelease = function()
{
   trace("onRelease");
   if(mvBtnPro._currentFrame == 1)
   {
      mvBtnPro.gotoAndStop(2);
      isPro = 1;
   }
   else
   {
      mvBtnPro.gotoAndStop(1);
      isPro = 0;
   }
};
