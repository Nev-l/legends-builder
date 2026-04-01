function validRT(val)
{
   if(val == -1)
   {
      return "--";
   }
   return classes.NumFuncs.zeroFill(val,3);
}
function validET(val)
{
   if(val == -1 || val == classes.GlobalData.teamRivalPenalty || val == classes.GlobalData.teamRivalBracketPenalty)
   {
      return "--";
   }
   return classes.NumFuncs.zeroFill(val,3);
}
function validTS(val)
{
   if(val == -1)
   {
      return "--";
   }
   return classes.NumFuncs.zeroFill(val,2);
}
