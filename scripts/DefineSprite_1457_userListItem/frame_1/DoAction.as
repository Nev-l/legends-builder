flag._visible = tf != 1 ? false : true;
trace("tid");
trace(tid);
if(tid)
{
   if(tid != -1)
   {
      _global.specialEvent.loadTeamIcon(tid,icon,8,8);
   }
}
