clrOverlay._x = 73;
clrOverlay._width = 697;
trace("team1");
var CB_team = function(d)
{
   classes.Viewer.viewTeamXML = new XML(d);
   drawTeam(classes.Viewer.viewTeamXML);
};
classes.Lookup.addCallback("teamGetInfo",this,CB_team,"");
_root.teamGetInfo(tID);
btnJoin.onRelease = function()
{
   _root.attachMovie("dialogContainer","abc",_root.getNextHighestDepth(),{contentName:"dialogJoinTeamContent",tid:tID});
};
