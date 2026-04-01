var isTeamRivAnnounce = true;
var i = 1;
while(i <= 2)
{
   var j = 1;
   while(j <= 4)
   {
      this["team" + i + "Pos" + j]._visible = false;
      j++;
   }
   i++;
}
