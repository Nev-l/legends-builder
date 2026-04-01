front_back.btnFront.onRelease = function()
{
   isBack = false;
   front_back.prevFrame();
   gotoAndStop("frontIn");
   play();
};
front_back.btnBack.onRelease = function()
{
   isBack = true;
   front_back.nextFrame();
   gotoAndStop("backIn");
   play();
};
btnSpareParts.onRelease = navToSpareParts;
leftMenu.btnParts.onRelease = navToCarParts;
leftMenu.btnDiagnosticTool.onRelease = mx.utils.Delegate.create(this,navToDiagnosticTool);
carPicker.setSelectedCar(classes.GlobalData.attr.dc);
if(classes.GlobalData.doesCarHaveDiagnosticToolInstalled() == true)
{
   trace("show it");
   leftMenu.btnDiagnosticTool._visible = true;
   leftMenu.btnDiagnosticsDisplay._visible = true;
}
else
{
   trace("hide it");
   leftMenu.btnDiagnosticTool._visible = false;
   leftMenu.btnDiagnosticsDisplay._visible = false;
}
checkLockedMsg();
gotoAndStop("front");
play();
