stop();
classes.GlobalData.attr.em = email;
classes.GlobalData.updateInfo("act","0");
classes.LimitedAccessFunctions.showLimitedAccessAlert(true,limitedAccessAlert);
if(_global.supportCenterLimitedAccessAlert)
{
   trace("showing support center alert");
   classes.LimitedAccessFunctions.showLimitedAccessAlert(true,_global.supportCenterLimitedAccessAlert);
}
