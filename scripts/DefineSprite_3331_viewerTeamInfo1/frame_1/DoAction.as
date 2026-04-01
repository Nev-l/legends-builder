fldMsg.autoSize = true;
this.attachMovie("userInfo50","leaderInfo",this.getNextHighestDepth(),{_x:2,_y:16,scale:50,uID:leaderID,uName:leaderName,uCred:leaderSC});
if(leaderET)
{
   leaderInfo.fldTitleET.text = "BEST AVG ET:";
   leaderInfo.fldET.text = classes.NumFuncs.zeroFill(leaderET,3);
}
this.attachMovie("viewerTeamInfo2","teamInfo2",this.getNextHighestDepth(),{_y:this._height + 10});
