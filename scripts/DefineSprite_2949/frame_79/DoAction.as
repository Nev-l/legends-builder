stop();
if(spectateFlag)
{
   rankingBoardGroup._visible = true;
   rankTitle._visible = true;
   rankHead._visible = true;
   if(!matchTreeXML)
   {
      _root.htGetTop32();
   }
   else
   {
      this.showContainer("raceTourneyIntro",tourneyType);
   }
}
else
{
   this.showContainer("raceTourneyIntro",tourneyType);
}
loadin.cacheAsBitmap = true;
