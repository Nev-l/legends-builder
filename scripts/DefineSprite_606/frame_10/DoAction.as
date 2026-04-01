stop();
btnExtend.onRelease = function()
{
   trace("btnExtend pushed.....");
   _root.openURL("http://www.nittolegends.com/1320Shop_default.aspx");
};
var memNum = 17785280 + Number(classes.GlobalData.id);
txtMemNum = memNum;
trace("memNum: " + memNum);
txtExpiry = "EXP: " + (!classes.GlobalData.attr.me ? "-----" : classes.GlobalData.attr.me);
txtUserName = classes.GlobalData.uname;
trace("txtUserName: " + txtUserName);
classes.Drawing.portrait(pic,classes.GlobalData.id,1,0,0,1,false);
