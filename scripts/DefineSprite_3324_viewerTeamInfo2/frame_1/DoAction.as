btnJoin.onRelease = function()
{
   _root.attachMovie("dialogContainer","abc",_root.getNextHighestDepth(),{contentName:"dialogJoinTeamContent",tid:_parent._parent._parent.tID});
};
