stop();
btnExit._visible = false;
meterAF._visible = false;
controllerAF._visible = false;
controllerBoost._visible = false;
controllerShift._visible = false;
var selCarXMLPart = classes.GlobalData.getSelectedCarXML();
var i = 0;
while(i < selCarXMLPart.childNodes.length)
{
   if(selCarXMLPart.childNodes[i].attributes.ci == "23")
   {
      controllerBoost._visible = true;
   }
   else if(selCarXMLPart.childNodes[i].attributes.ci == "26")
   {
      controllerAF._visible = true;
      meterAF._visible = false;
   }
   else if(selCarXMLPart.childNodes[i].attributes.ci == "134")
   {
      if(!controllerAF._visible)
      {
         meterAF._visible = true;
      }
   }
   i++;
}
if(classes.GlobalData.doesSelCarHaveSpecialGauge() == true)
{
   controllerShift._visible = true;
   var theRPM = 0;
   trace("theRPM: " + theRPM);
   if(classes.GlobalData.shiftLightGaugeRPM)
   {
      theRPM = classes.GlobalData.shiftLightGaugeRPM;
      trace("theRPM2: " + theRPM);
   }
   trace("calling setRPM");
   controllerShift.rpm = theRPM;
   controllerShift.textMovie.rpmText = theRPM;
}
if(loadOnly)
{
   btnStartDyno._visible = false;
   loadOnly = false;
}
aryDynoCollection = new Array();
arySwatch = new Array();
populateSessionSwatch();
if(scrollerContent == undefined)
{
   this.createEmptyMovieClip("scrollerContent",this.getNextHighestDepth());
   scrollerContent._x = 10;
   scrollerContent._y = 120;
   scrollerObj = new controls.ScrollPane(scrollerContent,203,314);
}
scrollerObj.setScrollToTop();
btnStartDyno.onRelease = function()
{
   this._alpha = 50;
   canDyno = false;
   _root.garageDynoRun(boostSetting,chipSetting);
};
btnExit.onRelease = function()
{
   clearInterval(dynoInterval);
   scrollerContent.removeMovieClip();
   scrollerObj.destroy();
   gotoAndStop("options");
};
btnPlus.onRelease = function()
{
   if(graphScale > 0.15)
   {
      redrawGraph(graphScale - 0.1);
   }
};
btnMinus.onRelease = function()
{
   redrawGraph(graphScale + 0.1);
};
