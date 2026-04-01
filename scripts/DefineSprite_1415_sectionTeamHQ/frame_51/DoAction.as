stop();
var userInfo = this.attachMovie("userInfo50","userInfo",this.getNextHighestDepth(),{scale:50,uID:classes.GlobalData.id,uName:classes.GlobalData.uname,uCred:_global.loginXML.firstChild.firstChild.attributes.sc});
userInfo._x = 127;
userInfo._y = 175;
var CB_cont = function(d)
{
   if(selSnav == 4)
   {
      _global.transXML = new XML(d);
      play();
   }
};
classes.Lookup.addCallback("teamTrans",this,CB_cont,"sectionTeamHQ");
_root.teamTrans(_global.loginXML.firstChild.firstChild.attributes.ti);
