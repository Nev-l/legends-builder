stop();
tutorialSelector._visible = false;
btnTutorials.onRelease = function()
{
   tutorialSelector._visible = !tutorialSelector._visible;
};
btnReset.onRelease = function()
{
   if(Number(_parent.selCarXML.attributes.td) && Number(_parent.selCarXML.attributes.tdex))
   {
      _root.markTestDriveExpiredAndDisplayWarning();
   }
   else
   {
      _root.practiceCreate(selCarID);
   }
};
if(Number(_parent.selCarXML.attributes.td) && Number(_parent.selCarXML.attributes.tdex))
{
   _root.displayTestDriveExpiredWarning();
}
else
{
   _root.practiceCreate(selCarID);
}
