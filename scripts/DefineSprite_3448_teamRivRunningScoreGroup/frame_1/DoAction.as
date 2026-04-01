function cont()
{
   this.onEnterFrame = function()
   {
      if(this._alpha > 0)
      {
         this._alpha -= 20;
      }
      else
      {
         this.removeMovieClip();
         delete this.onEnterFrame;
      }
   };
}
if(td < 0)
{
   teamID = Number(_global.chatObj.challengeXML.firstChild.attributes.ti1);
   name1 = classes.Lookup.getTeamNode(teamID).attributes.n;
   margin1 = "winning by: " + Math.abs(td);
   classes.Drawing.portrait(pic1.holder,teamID,2,0,0,2,false,"teamavatars");
}
else if(td > 0)
{
   teamID = Number(_global.chatObj.challengeXML.firstChild.attributes.ti2);
   name2 = classes.Lookup.getTeamNode(teamID).attributes.n;
   margin2 = "winning by: " + Math.abs(td);
   classes.Drawing.portrait(pic2.holder,teamID,2,0,0,2,false,"teamavatars");
}
_global.setTimeout(this,"cont",4500);
