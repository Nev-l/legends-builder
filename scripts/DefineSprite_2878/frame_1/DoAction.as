function loadPlate(pid, seq)
{
   if(pid <= 7 || pid >= 11)
   {
      classes.Drawing.plateView(plate,pid,seq,45,true);
   }
   else
   {
      classes.Drawing.plateView(plate,pid,seq,30,true);
   }
}
