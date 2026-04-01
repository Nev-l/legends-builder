stop();
btnExtend.onRelease = function()
{
   _root.openURL("http://www.nittolegends.com/1320Shop_default.aspx");
};
var memNum = 17785280 + Number(classes.GlobalData.id);
txtMemNum = memNum;
txtExpiry = "EXPIRES: " + (!classes.GlobalData.attr.me ? "-----" : classes.GlobalData.attr.me);
txtUserInfo = classes.GlobalData.uname;
txtUserInfo += "\r" + classes.Lookup.homeName(classes.GlobalData.attr.lid);
txtUserInfo += "\r\r";
switch(classes.GlobalData.attr.g)
{
   case "m":
   case "M":
      txtUserInfo += "SEX: MALE";
      break;
   case "f":
   case "F":
      txtUserInfo += "SEX: FEMALE";
}
classes.Drawing.portrait(pic,classes.GlobalData.id,1,0,0,1,false);
