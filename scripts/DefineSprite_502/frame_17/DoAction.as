function cont()
{
   play();
}
stop();
checkLockedMsg();
carMC.clearCarView();
classes.ClipFuncs.removeAllClips(carMC);
classes.Drawing.carView(carMC,carXML,100,"front");
_global.setTimeout(cont,500);
