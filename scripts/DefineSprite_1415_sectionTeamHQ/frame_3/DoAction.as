stop();
classes.ClipFuncs.removeAllClips(this);
var CB_cont = function(d)
{
   _global.appXML = new XML(d);
   drawMyApplications(_global.appXML.firstChild);
};
classes.Lookup.addCallback("teamGetMyApps",this,CB_cont,"sectionTeamHQ");
_root.teamGetMyApps();
btnCreate.onRelease = function()
{
   _root.attachMovie("dialogContainer","abc",_root.getNextHighestDepth(),{contentName:"dialogTeamCreateContent"});
};
